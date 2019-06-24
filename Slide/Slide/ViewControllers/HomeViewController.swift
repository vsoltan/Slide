//
//  ViewController.swift
//  Slide
//
//  Created by Sam Lee on 6/5/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var NameLabel: UILabel!
    
    override func viewDidLoad() {
        
        // sets the label to the current user's name
        CurrentUser.getName { (name) in
            self.NameLabel.text = name
        }
        
        // TODO: look into the delay with the name pop-in
        super.viewDidLoad()
        
        
    }
}

