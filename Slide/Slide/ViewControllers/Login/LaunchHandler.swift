//
//  LaunchViewController.swift
//  Slide
//
//  Created by Valeriy Soltan on 8/11/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit
import FirebaseAuth

class LaunchHandler: UIViewController {
    
    var currentUserID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLaunch()
    }
    
    // MARK: -CONFIGURATION
    
    // if there is an active user app has to update defaults
    func configureLaunch() {
        
        // color scheme matches launch screen
        self.view.backgroundColor = UIColor(red: 255, green: 123, blue: 73, alpha: 0)
        
        SlideUser.getUser(userID: currentUserID) { (error) in
            if (error == nil) {
                self.present(Home(), animated: true, completion: {
                })
            } else {
                CustomError.createWith(errorTitle: "Oops! Something went wrong!", errorMessage: "please try logging in again")
            }
        }
    }
}
