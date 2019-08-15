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
    
    // TODO
    // work on prelim UI so this looks kinda nice
    // implemenet hamburger settings menu
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // welcome page displays the user's name
        if let name = nameLabel.text {
            nameLabel.text = name + UserDefaults.standard.getName()
        }
    }
}

