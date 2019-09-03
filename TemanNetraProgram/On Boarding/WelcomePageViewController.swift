//
//  WelcomePageViewController.swift
//  TemanNetraProgram
//
//  Created by Georgius Yoga Dewantama on 03/09/19.
//  Copyright © 2019 Georgius Yoga Dewantama. All rights reserved.
//

import UIKit

class WelcomePageViewController: UIViewController {
    @IBOutlet weak var judulSatuLabel: UILabel!
    @IBOutlet weak var isiSatuLabel: UILabel!
    @IBOutlet weak var judulDuaLabel: UILabel!
    @IBOutlet weak var isiDuaLabel: UILabel!
    @IBOutlet weak var judulTigaLabel: UILabel!
    @IBOutlet weak var isiTigaLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        judulSatuLabel.accessibilityLabel = "\(judulSatuLabel.text!), \(isiSatuLabel.text!), geser ke kanan untuk melanjutkan"
        
        judulDuaLabel.accessibilityLabel = "\(judulDuaLabel.text!), \(isiDuaLabel.text!), geser ke kanan untuk melanjutkan"
        
        judulTigaLabel.accessibilityLabel = "\(judulTigaLabel.text!), \(isiTigaLabel.text!), geser ke kanan untuk melanjutkan"
        //judulSatuLabel.accessibilityLabel = result
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
