//
//  DetailViewController.swift
//  TemanNetraProgram
//
//  Created by Linando Saputra on 26/08/19.
//  Copyright © 2019 Georgius Yoga Dewantama. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var detailNote: String?
    
    @IBOutlet weak var detailLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        detailLabel.text = detailNote
    }
    


}
