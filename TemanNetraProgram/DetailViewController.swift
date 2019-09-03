//
//  DetailViewController.swift
//  TemanNetraProgram
//
//  Created by Linando Saputra on 26/08/19.
//  Copyright © 2019 Georgius Yoga Dewantama. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class DetailViewController: UIViewController, UITextViewDelegate {

    var note:Note!
    
    @IBOutlet weak var detailJudulTextField: UITextView!
    
    @IBOutlet weak var detailTextField: UITextView!
    
    
    @IBOutlet weak var selesaiButtonOutlet: UIBarButtonItem!
    
    @IBAction func selesaiButtonAction(_ sender: Any) {
        
        self.detailTextField.resignFirstResponder()
               self.selesaiButtonOutlet.tintColor = UIColor.gray
        updateData()
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
       self.detailTextField.becomeFirstResponder()
        self.detailTextField.delegate = self
        detailTextField.text = note.isiNotes
        print("INI detail VIEW CONTROLLER")
        synthesizer.stopSpeaking(at: .immediate)
//        let speechUtterance = AVSpeechUtterance(string: detailNote!)
//        speechUtterance.voice = AVSpeechSynthesisVoice(language: "id")
//        synthesizer.speak(speechUtterance)
        
//        fetchDataLabel()
        self.detailJudulTextField.text = note.judulNotes
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        self.selesaiButtonOutlet.tintColor = UIColor(red: 0, green: 122.0/255.0, blue: 1, alpha: 1)
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            synthesizer.stopSpeaking(at: .immediate)
        }
    }
    
    
    @IBAction func deleteButton(_ sender: Any) {
        
        let alert = UIAlertController(title: "Hapus Arsip ?", message: "anda tidak dapat mengembalikan arsip yang sudah di hapus", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Batal", style: .cancel, handler: nil)
        let delete = UIAlertAction(title: "Hapus", style: .default) { (_: UIAlertAction!) in
            self.deleteData()
            
        }
        alert.addAction(cancel)
        alert.addAction(delete)
        
        self.present(alert, animated: true, completion: nil)
//        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
//        fetchRequest.predicate = NSPredicate.init(format: "NoteID==\(ID)")
    
    }
    
    @IBAction func shareButton(_ sender: Any) {
        
        let activityVC = UIActivityViewController(activityItems: ["Judul :",self.detailJudulTextField.text,"Isi :",self.detailTextField.text], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
        
    }
    
    func updateData()
    {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return  }
     
        do{
            note.judulNotes = detailJudulTextField.text
            note.isiNotes = detailTextField.text
            try? managedContext.save()
        }
        
        
    }
    
    
    func deleteData() {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(note)
        navigationController?.popViewController(animated: true)
    }
    
    
}
