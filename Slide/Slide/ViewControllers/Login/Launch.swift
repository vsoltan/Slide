//
//  LaunchViewController.swift
//  Slide
//
//  Created by Valeriy Soltan on 8/11/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit

class Launch: UIViewController {
    
    var currentID = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // bypasses login and goes to home page if logged in
        SlideUser.getUser(userID: currentID) { (error) in
            
            if (error == nil) {
                self.performSegue(withIdentifier: "existingUserToHome", sender: self)
            } else {
                CustomError.createWith(errorTitle: "Oops! Something went wrong!", errorMessage: "please try logging in again")
                self.performSegue(withIdentifier: "errorBackToLogin", sender: self)
            }
    }
        
    }
}
