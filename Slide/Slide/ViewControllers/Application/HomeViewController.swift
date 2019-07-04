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
    
    var customizationInfo = NSCache<AnyObject, AnyObject>()
    
    var nameString = String()
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CurrentUser.getName { (name) in
            self.nameLabel.text = name!
        }
        
        // user defaults
        // nameLabel.text = nameString
    }
    
    
//        if customizationInfo.object(forKey: "name" as AnyObject) != nil {
//
//        } else {
//            CurrentUser.getName { (name) in
//                self.NameLabel.text = name!
////                self.customizationInfo.setObject(name as AnyObject, forKey: "name" as AnyObject)
//            }
//        }
//        // sets the namefield to the retrieved information
//        NameLabel.text = nameString
}

