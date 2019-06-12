//
//  LoginViewController.swift
//  Slide
//
//  Created by Valeriy Soltan on 6/6/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func LogInActivated(_ sender: Any) {
        // checks if the textfields are empty and prints out an error message
        TextVerification.validate(field: username, type: "username")
        TextVerification.validate(field: password, type: "password")
    }

    // To be implemented later for google signout...
//    @IBAction func didTapSignOut(_ sender: AnyObject) {
//        GIDSignIn.sharedInstance().signOut()
//    }

    
//    func googleSignIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
//                withError error: NSError!) {
//        if (error == nil) {
//            // Perform any operations on signed in user here.
//        } else {
//            print("\(error.localizedDescription)")
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // creates login button from FBSDKLoginKit
        // TODO center the facebook sign in button 
        _ = FBSDKLoginButton()
        
        // creates login button from GoogleSignIn
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // Uncomment to automatically sign the user into google.
        // GIDSignIn.sharedInstance().signInSilently()
        
        // TODO: Configure the sign-in button look/feel
    }

}
