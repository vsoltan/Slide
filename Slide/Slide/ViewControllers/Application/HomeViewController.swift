//
//  ViewController.swift
//  Slide
//
//  Created by Sam Lee on 6/5/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    var nameString = String()
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // welcome page displays the user's name
        nameLabel.text = UserDefaults.standard.getName()
        TextParser.splitName(fullName: "Valeriy Soltan")
    }
}

