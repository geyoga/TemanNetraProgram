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
    
    @IBAction func selesaiButtonAction(_ sender: UIButton) {
        
      self.view.endEditing(true)
                self.selesaiButtonOutlet.tintColor = UIColor.gray
        
        updateData()
        
        endButton()
        
        
        
    }
    
    func endButton() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: {
          
        })
        
        selesaiButtonOutlet.isEnabled = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //text view//
        
        self.detailTextField.delegate = self
        self.detailJudulTextField.delegate = self
        detailTextField.text = note.isiNotes
        print("INI detail VIEW CONTROLLER")
        synthesizer.stopSpeaking(at: .immediate)
//        let speechUtterance = AVSpeechUtterance(string: detailNote!)
//        speechUtterance.voice = AVSpeechSynthesisVoice(language: "id")
//        synthesizer.speak(speechUtterance)
        
//        fetchDataLabel()
        
        
        
        self.detailJudulTextField.text = note.judulNotes
        
        
        //moving view//
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification)
    {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            detailTextField.contentInset = UIEdgeInsets.zero
        } else {
            detailTextField.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        detailTextField.scrollIndicatorInsets = detailTextField.contentInset
        
        let selectedRange = detailTextField.selectedRange
        detailTextField.scrollRangeToVisible(selectedRange)
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.selesaiButtonOutlet.isEnabled = true
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        self.selesaiButtonOutlet.tintColor = UIColor(red: 0, green: 122.0/255.0, blue: 1, alpha: 1)
        self.selesaiButtonOutlet.isEnabled = true
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
        deleteData()
//        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
//        fetchRequest.predicate = NSPredicate.init(format: "NoteID==\(ID)")
    
    }
    
    @IBAction func shareButton(_ sender: Any) {
        
        let activityVC = UIActivityViewController(activityItems: [self.detailTextField.text], applicationActivities: nil)
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


