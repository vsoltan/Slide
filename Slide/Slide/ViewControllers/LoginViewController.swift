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
import FirebaseAuth

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func LogInActivated(_ sender: Any) {
        let signInInfo: Array<(field: UITextField, type: String)>
            = [(email, "username"), (password, "password")]
        
        // checks that the user passed information to the application
        if (TextFieldParser.validate(textFields: signInInfo)) {
            Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
                if user != nil {
                    self.performSegue(withIdentifier: "signInToMain", sender: self)
                } else {
                    // error checking
                }
            }
        }
        
        
        
        
    }

    // to be implemented later for google signout...
    //    @IBAction func didTapSignOut(_ sender: AnyObject) {
    //        GIDSignIn.sharedInstance().signOut()
    //    }

    // 
    func googleSignIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                    withError error: NSError!) {
        if (error == nil) {
                // Perform any operations on signed in user here.
        } else {
            print("\(error.localizedDescription)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // creates login button from FBSDKLoginKit
        _ = FBSDKLoginButton()
        
        // creates login button from GoogleSignIn
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // automatically signs the user into google.
         GIDSignIn.sharedInstance().signInSilently()
        
        // TODO: Configure the sign-in button look/feel
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        let handle = Auth.auth().addStateDidChangeListener { (auth, user) in}
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        Auth.auth().removeStateDidChangeListener(handle!)
//    }

}
