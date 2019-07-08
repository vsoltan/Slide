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
    
    //var customizationInfo = NSCache<AnyObject, AnyObject>()
    
    var nameString = String()
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets nameLabel with side effect of loading user data into UserDefaults for persistance across app
        User.getUser(userID: Auth.auth().currentUser!.uid) { (error) in
            if error != nil {
                print("\(error!)")
            } else {
                self.nameLabel.text = UserDefaults.standard.getName()
            }
            
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

