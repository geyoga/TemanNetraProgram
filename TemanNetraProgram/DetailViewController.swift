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

    var detailNote: String?
    
    @IBOutlet weak var detailJudulTextField: UITextView!
    
    @IBOutlet weak var detailTextField: UITextView!
    
    
    @IBOutlet weak var selesaiButtonOutlet: UIBarButtonItem!
    
    @IBAction func selesaiButtonAction(_ sender: Any) {
        
        self.detailTextField.resignFirstResponder()
               self.selesaiButtonOutlet.tintColor = UIColor.gray
    }
    
    var titleNote = ""
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
       self.detailTextField.becomeFirstResponder()
        self.detailTextField.delegate = self
        detailTextField.text = detailNote
        print("INI detail VIEW CONTROLLER")
        synthesizer.stopSpeaking(at: .immediate)
//        let speechUtterance = AVSpeechUtterance(string: detailNote!)
//        speechUtterance.voice = AVSpeechSynthesisVoice(language: "id")
//        synthesizer.speak(speechUtterance)
        
//        fetchDataLabel()
        self.detailJudulTextField.text = self.titleNote
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

    @IBAction func shareButton(_ sender: Any) {
        
        let activityVC = UIActivityViewController(activityItems: [self.detailTextField.text], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
        
    }
    
    func fetchDataLabel()
    {
        let appDelegateLabel = UIApplication.shared.delegate as? AppDelegate
        guard let managedContext = appDelegateLabel?.persistentContainer.viewContext else { return  }
        
        var catatancatatanku = [Note]()
        
        do {
            catatancatatanku = try managedContext.fetch(Note.fetchRequest())
            
            for catatan in catatancatatanku
            {
                //                judulNotes[tableRowCounter] = note.judulNotes!
                //                isiNotes[tableRowCounter] = note.isiNotes!
                //                timestampNotes[tableRowCounter] = Int(note.timestampNotes)
                //                tempDictionary.updateValue(note.isiNotes!, forKey: Int(note.timestampNotes))
                //                searchDictionary.updateValue(tempDictionary, forKey: note.judulNotes!)
//                self.detailJudulTextField.text = catatan.judulNotes ?? ""
            }
        } catch  {
            print("Gagal memanggil")
        }
        
    }
    
    func updateData()
    {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return  }
        
        var notes = [Note]()
        
        do {
            notes = try managedContext.fetch(Note.fetchRequest())
            
            for note in notes
            {
                //                judulNotes[tableRowCounter] = note.judulNotes!
                //                isiNotes[tableRowCounter] = note.isiNotes!
                //                timestampNotes[tableRowCounter] = Int(note.timestampNotes)
                //                tempDictionary.updateValue(note.isiNotes!, forKey: Int(note.timestampNotes))
                //                searchDictionary.updateValue(tempDictionary, forKey: note.judulNotes!)
                
            }
        } catch  {
            print("Gagal memanggil")
        }
        
    }
    
    
}
