//
//  NoteTableViewController.swift
//  Notes
//
//  Created by Fabian Grochowalski on 09.03.18.
//  Copyright © 2018 Fabian Grochowalski. All rights reserved.
//

import UIKit
import CoreData

class NoteTableViewController: UITableViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var noteOverviewToolbar: UIToolbar!
    @IBOutlet weak var sortAlphabetically: UIButton!
    @IBOutlet weak var sortCategory: UIButton!

    var warningNotesDataset = [NoteDataset]()
    var alertNotesDataset = [NoteDataset]()
    var infoNotesDataset = [NoteDataset]()
    var notesDataset = [NoteDataset]()
    var notesDatasetbyCategory = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "paper"), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.isTranslucent = false
        self.title = NSLocalizedString("noteOverview", comment: "")
        noteOverviewToolbar.setBackgroundImage(UIImage(named: "paper"), forToolbarPosition: .bottom, barMetrics: .default)

        sortCategory.setTitle(NSLocalizedString("sortCategory", comment: ""), for: .normal)
        sortAlphabetically.setTitle(NSLocalizedString("sortTitle", comment: ""), for: .normal)
        
        sortCategory.isSelected = false
        sortAlphabetically.isSelected = false
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 600
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        deleteAllData()
        getNotesDataset()
        if sortCategory.isSelected{
            intoDatasetbyCategory()
        }
        self.tableView.reloadData()
    }
    
    @IBAction func sortByAlphabet(_ sender: AnyObject) {
        if sortAlphabetically.isSelected {
            sortAlphabetically.isSelected = false
            tableView.reloadData()
        } else {
            sortAlphabetically.isSelected = true
            tableView.reloadData()
        }
    }
    
    @IBAction func sortByCategory(_ sender: AnyObject) {
        if sortCategory.isSelected {
            sortCategory.isSelected = false
            deleteAllData()
            getNotesDataset()
            tableView.reloadData()
        } else {
            sortCategory.isSelected = true
            deleteAllData()
            getNotesDataset()
            intoDatasetbyCategory()
            tableView.reloadData()
        }
    }
    
    func getNotesDataset(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        request.returnsObjectsAsFaults = false
        do {
            let context = appDelegate.persistentContainer.viewContext
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let n = NoteDataset()
                n.noteID = data.objectID
                n.title = (data.value(forKey: "title") as! String)
                n.description = (data.value(forKey: "subTitle")as! String)
                n.indicator = (data.value(forKey: "indicator")as! String)
                n.fromOverview = true
                if(sortCategory.isSelected){
                switch (data.value(forKey: "indicator")as! String){
                case "Warning":
                    self.warningNotesDataset.append(n)
                case "Alert":
                    self.alertNotesDataset.append(n)
                case "Info":
                    self.infoNotesDataset.append(n)
                default:
                    print ("Failed")
                    }
                } else{
                    notesDataset.append(n)
                }
            }
        } catch {
            NSLog("Failed loading Data")
        }
    }
    
    func intoDatasetbyCategory(){
        notesDatasetbyCategory = [Category(section:warningNotesDataset.isEmpty == false ? NSLocalizedString("warning", comment: "") : "", items:warningNotesDataset),
                        Category(section:alertNotesDataset.isEmpty == false ?  NSLocalizedString("alert", comment: "") : "", items:alertNotesDataset),
                        Category(section:infoNotesDataset.isEmpty == false ? NSLocalizedString("info", comment: "") : "", items:infoNotesDataset)]
    }
    
    func deleteAllData(){
        warningNotesDataset.removeAll()
        alertNotesDataset.removeAll()
        infoNotesDataset.removeAll()
        notesDatasetbyCategory.removeAll()
        notesDataset.removeAll()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        if sortCategory.isSelected {
            return notesDatasetbyCategory.count
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sortCategory.isSelected {
            let items = self.notesDatasetbyCategory[section].items
            return items.count
        } else {
            return notesDataset.count
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if sortCategory.isSelected {
            return self.notesDatasetbyCategory[section].section
        } else {
            return ""
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! NoteControllerTableViewCell
        if sortCategory.isSelected{
            let noteItems = self.notesDatasetbyCategory[indexPath.section].items
            let noteItem = sortAlphabetically.isSelected ? noteItems.sorted(by: { $0.title < $1.title })[indexPath.row] : noteItems[indexPath.row]
            cell.NoteTitleLabel.text = noteItem.title
            cell.NoteSubTitleLabel?.text = noteItem.description
            cell.NoteIndicatorLabel?.text = NSLocalizedString(noteItem.indicator.lowercased(), comment: "")
            cell.NoteIndicatorImageView.image = UIImage(named: noteItem.indicator)
        } else {
            let noteItem = sortAlphabetically.isSelected ? notesDataset.sorted(by: { $0.title < $1.title })[indexPath.row] : notesDataset[indexPath.row]
            cell.NoteTitleLabel.text = noteItem.title
            cell.NoteSubTitleLabel?.text = noteItem.description
            cell.NoteIndicatorLabel?.text = NSLocalizedString(noteItem.indicator.lowercased(), comment: "")
            cell.NoteIndicatorImageView.image = UIImage(named: noteItem.indicator)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: "Notedetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is NoteDetailViewController
        {
            if let indexPath = tableView.indexPathForSelectedRow{
                let vc = segue.destination as? NoteDetailViewController
                if sortCategory.isSelected{
                    let noteItems = self.notesDatasetbyCategory[indexPath.section].items
                    vc?.note = sortAlphabetically.isSelected ? noteItems.sorted(by: { $0.title < $1.title })[indexPath.row] : noteItems[indexPath.row]
                } else {
                    vc?.note = sortAlphabetically.isSelected ?  notesDataset.sorted(by: { $0.title < $1.title })[indexPath.row] : notesDataset[indexPath.row]
                }
            }
        }
    }
}
