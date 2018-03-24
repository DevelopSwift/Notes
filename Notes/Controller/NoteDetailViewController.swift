//
//  NoteDetailViewController.swift
//  Notes
//
//  Created by Fabian Grochowalski on 10.03.18.
//  Copyright © 2018 Fabian Grochowalski. All rights reserved.
//

import UIKit
import CoreData
import DropDown
import IHKeyboardAvoiding

class NoteDetailViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var Notedetail: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var noteDeatailToolbar: UIToolbar!
    @IBOutlet weak var indicatorDropDownButton: UIButton!
    @IBOutlet weak var indicatorImageView: UIImageView!
    let indicatorDopDown = DropDown()
    print ("testhttps://github.com/DevelopSwift/Households.git")
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var note = NoteDataset()
    var titledidchange : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        KeyboardAvoiding.avoidingView = self.noteDeatailToolbar
        view.addBackground()
        setupIndicatorDropDown()
        noteDeatailToolbar.setBackgroundImage(UIImage(named: "paper"), forToolbarPosition: .bottom, barMetrics: .default)
            if note.title.isEmpty{
                editTitle(self)
                indicatorDropDownButton.setTitle(IndicatorDropDownDataset().indicator.first!, for: .normal)
                indicatorImageView.image = UIImage(named: IndicatorDropDownDataset().indicator.first!)
                note.indicator = IndicatorDropDownDataset().indicator.first!
            } else{
                titledidchange = false
                title = note.title
                detailTextView.text = note.description
                indicatorDropDownButton.setTitle(note.indicator, for: .normal)
                indicatorImageView.image = UIImage(named: note.indicator)
            }
        }
    
    lazy var dropDowns: DropDown = {
        return
            self.indicatorDopDown
    }()
    
    @IBAction func changeIndicator(_ sender: Any) {
        indicatorDopDown.show()
    }
    
    func setupIndicatorDropDown() {
        indicatorDopDown.anchorView = indicatorDropDownButton
        indicatorDopDown.bottomOffset = CGPoint(x: 0, y: indicatorDropDownButton.bounds.height)
        indicatorDopDown.dataSource = IndicatorDropDownDataset().indicator
        indicatorDopDown.selectionAction = { [weak self] (index, item) in
            self?.indicatorDropDownButton.setTitle(item, for: .normal)
            self?.note.indicator = item
            self?.indicatorImageView.image = UIImage(named: item)
        }}
    
    @IBAction func editTitle(_ sender: Any) {
        let alert = UIAlertController(title: NSLocalizedString("title", comment: ""), message: NSLocalizedString("setTitle", comment: ""), preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = self.note.title
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            self.title = textField?.text
            self.note.title = (textField?.text)!
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonOnClick(_ sender: Any) {
       note.description = detailTextView.text
        if note.fromOverview == false{
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Note", in: context)
            let newNote = NSManagedObject(entity: entity!, insertInto: context)
            
            newNote.setValue(note.title, forKey: "title")
            newNote.setValue(detailTextView.text, forKey: "subTitle")
            newNote.setValue(note.indicator, forKey: "indicator")
            saveContent()
        } else{

            let titleKeyPredicate = NSPredicate(format: "self == %@", (note.noteID))
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            request.predicate = titleKeyPredicate
            request.returnsObjectsAsFaults = false
            let context = appDelegate.persistentContainer.viewContext
            do {
                let fetchedEntities = try context.fetch(request) as! [Note]
                fetchedEntities.first?.title = note.title
                fetchedEntities.first?.subTitle = note.description
                fetchedEntities.first?.indicator = note.indicator
            } catch {
                print("Error")
            }
            saveContent()
        }
    }
    
    @IBAction func deleteButtonOnClick(_ sender: Any) {
        let predicate = NSPredicate(format: "self == %@", (note.noteID))
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
        let context = appDelegate.persistentContainer.viewContext
        do {
            let fetchedEntities = try context.fetch(request) as! [Note]
            if let entityToDelete = fetchedEntities.first {
                context.delete(entityToDelete)
            }
        } catch {
            print("Error")
        }
        
        do {
            try context.save()
            performSegue(withIdentifier: "overview", sender: self)
        } catch {
            print("Error")
        }
    }

    func saveContent() {
        let context = appDelegate.persistentContainer.viewContext
        if note.title.isEmpty {
            let alert = UIAlertController(title: NSLocalizedString("title", comment: ""), message: NSLocalizedString("emptyTitle", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [] (_) in
                self.editTitle(self)
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else{
            do {
                try context.save()
                performSegue(withIdentifier: "overview", sender: self)
            } catch {
                print("Failed saving")
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
}

