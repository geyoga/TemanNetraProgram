//
//  DetailViewController.swift
//  TemanNetraProgram
//
//  Created by Linando Saputra on 26/08/19.
//  Copyright © 2019 Georgius Yoga Dewantama. All rights reserved.
//

import UIKit
import AVFoundation

class DetailViewController: UIViewController {

    var detailNote: String?
    
    @IBOutlet weak var detailLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        detailLabel.text = detailNote
        print("INI detail VIEW CONTROLLER")
        synthesizer.stopSpeaking(at: .immediate)
//        let speechUtterance = AVSpeechUtterance(string: detailNote!)
//        speechUtterance.voice = AVSpeechSynthesisVoice(language: "id")
//        synthesizer.speak(speechUtterance)
        detailLabel.textColor = .black
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            synthesizer.stopSpeaking(at: .immediate)
        }
    }

}
