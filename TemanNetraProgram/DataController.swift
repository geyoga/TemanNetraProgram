//
//  DataController.swift
//  TemanNetraProgram
//
//  Created by Georgius Yoga Dewantama on 23/08/19.
//  Copyright © 2019 Georgius Yoga Dewantama. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    static var noteCounter : Int = 0
    
    static func addNote(judul: String, isi: String){
        
        noteCounter += 1
        
        let note = Note(context: CoreDataHelper.managedContext)
        note.judulNotes = judul
        note.isiNotes = isi
        note.timeStampNotes = Date()
        
        CoreDataHelper.save()
    }
}
