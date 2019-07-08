//
//  LoginViewController.swift
//  Slide
//
//  Created by Valeriy Soltan on 6/6/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit


class LoginViewController: UIViewController, LoginButtonDelegate, GIDSignInUIDelegate {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var facebookButton: FBLoginButton!
    @IBOutlet weak var googleButton: GIDSignInButton!
    
    @IBAction func LogInActivated(_ sender: Any) {
        let signInInfo: Array<(field: UITextField, type: String)>
            = [(email, "username"), (password, "password")]
        
        // TODO fix empty textfields working
        // checks that the user passed information to the application
        
        if (TextFieldParser.validate(textFields: signInInfo) == true) {
            Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
                if user != nil {
                    self.performSegue(withIdentifier: "signInToMain", sender: self)
                } else {
                    CustomError.createWith(errorTitle: "Login Error", errorMessage: error!.localizedDescription).show()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // creates facebook login button
        let loginButton = FBLoginButton()
        loginButton.delegate = self

        // creates login button from GoogleSignIn
        //GIDSignIn.sharedInstance().uiDelegate = self
        
        // automatically signs the user into google.
        //GIDSignIn.sharedInstance().signIn()
        
        // TODO: Configure the sign-in button look/feel
    }

    @IBAction func facebookLogin(sender: AnyObject) {
        let loginManager = LoginManager()
        
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (loginResult, error) in
            self.loginButton(self.facebookButton, didCompleteWith: loginResult, error: error)
        }
    }
    
    // Login Button protocol
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            CustomError.createWith(errorTitle: "Facebook Login Error", errorMessage: error.localizedDescription).show()
            return
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        
        // creates a new account and signs in the user
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                CustomError.createWith(errorTitle: "Facebook Login Error", errorMessage: error.localizedDescription).show()
                return
            } else {
                // checks if a document exists under this user's alias
                if ((authResult?.additionalUserInfo!.isNewUser)!) {
                    
                    let userID = Auth.auth().currentUser!.uid
                    let db = Firestore.firestore()
                    
                    db.collection("users").document(userID).setData([
                        // set specified data entries
                        "Name": "test",
                        "ID": userID,
                        "Email": "test@gmail.com",
                    ]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                }
                print("successfully logged in")
                self.performSegue(withIdentifier: "signInToMain", sender: self)
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        // Do something when the user logout
        print("Logged out")
    }
    
    // GOOGLE STUFF
    
    // to be implemented later for google signout...
    //    @IBAction func didTapSignOut(_ sender: AnyObject) {
    //        GIDSignIn.sharedInstance().signOut()
    //    }
    
    //
    
    //    func googleSignIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
    //                    withError error: NSError!) {
    //        if (error == nil) {
    //                // Perform any operations on signed in user here.
    //        } else {
    //            print("\(error.localizedDescription)")
    //        }
    //    }

}
