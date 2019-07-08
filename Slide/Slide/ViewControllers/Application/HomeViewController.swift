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
        
        nameLabel.text = UserDefaults.standard.getName()
        
        // sets nameLabel with side effect of loading user data into UserDefaults for persistance across app
//        User.getUser(userID: Auth.auth().currentUser!.uid) { (error) in
//            if error != nil {
//                print("\(error!)")
//            } else {
//                self.nameLabel.text = UserDefaults.standard.getName()
//            }
//        }
    }
}

