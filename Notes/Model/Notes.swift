//
//  Note.swift
//  Notes
//
//  Created by Fabian Grochowalski on 09.03.18.
//  Copyright © 2018 Fabian Grochowalski. All rights reserved.
//
import Foundation
import CoreData
class NoteDataset
{
    private var _noteObjectID : NSManagedObjectID?
    private var _title = ""
    private var _description = ""
    private var _indicator = ""
    private var _fromOverview = false
  
    var noteID: NSManagedObjectID {
        set {
            _noteObjectID = newValue
        }
        get {
            return _noteObjectID!
        }
    }
    
    var title: String {
        set {
            _title = newValue
        }
        get {
            return _title
        }
    }
    
    var description: String {
        set {
            _description = newValue
        }
        get {
            return _description
        }
    }
   
    var indicator: String {
        set {
            _indicator = newValue
        }
        get {
            return _indicator
        }
    }
    
    var fromOverview: Bool {
        set {
            _fromOverview = newValue
        }
        get {
            return _fromOverview
        }
    }
}



