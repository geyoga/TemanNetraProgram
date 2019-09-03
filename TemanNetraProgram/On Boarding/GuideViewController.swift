//
//  GuideViewController.swift
//  TemanNetraProgram
//
//  Created by Georgius Yoga Dewantama on 03/09/19.
//  Copyright © 2019 Georgius Yoga Dewantama. All rights reserved.
//

import UIKit

class GuideViewController: UIViewController {

    @IBOutlet weak var labelView: UIView!
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    @IBOutlet weak var labelThree: UILabel!
    @IBOutlet weak var labelFour: UILabel!
    @IBOutlet weak var labelFive: UILabel!
    @IBOutlet weak var labelSix: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelView.accessibilityLabel = "\(labelOne.text!), \(labelTwo.text!), \(labelThree.text!), \(labelFour.text!), \(labelFive.text!), \(labelSix.text!), geser ke kanan untuk melanjutkan"
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
