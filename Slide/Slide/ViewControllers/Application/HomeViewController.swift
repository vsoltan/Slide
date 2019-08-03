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
        
        if let providerData = Auth.auth().currentUser?.providerData {
            for userInfo in providerData {
                switch userInfo.providerID {
                case "facebook.com":
                    print("user is signed in with facebook")
                case "google.com":
                    print("user is signed in with google")
                default:
                    print("user is signed in with \(userInfo.providerID)")
                }
            }
        }

    }
}

