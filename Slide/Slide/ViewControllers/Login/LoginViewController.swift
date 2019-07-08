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
                if (user != nil) {
                    // retrieve the user's information
                    User.getUser(userID: Auth.auth().currentUser!.uid, completionHandler: { (error) in
                        if (error != nil) {
                            print("something went wrong")
                        } else {
                            self.performSegue(withIdentifier: "signInToMain", sender: self)
                        }
                    })
                    
                } else {
                    CustomError.createWith(errorTitle: "Login Error", errorMessage: error!.localizedDescription).show()
                }
            }
        }
    }
    
//    func googleSignIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
//                    withError error: NSError!) {
//        if (error == nil) {
//                // Perform any operations on signed in user here.
//        } else {
//            print("\(error.localizedDescription)")
//        }
//    }

    
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
        let LoginManage = LoginManager()
        
        LoginManage.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
            
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            guard let accessToken = AccessToken.current else {
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                } else {
                    let r = GraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: AccessToken.current?.tokenString, version: nil, httpMethod: HTTPMethod(rawValue: "GET"))

                    
                    r.start(completionHandler: { (test, result, error) in
                        if(error == nil) {
                            let data = result as! NSDictionary
                            
                            // retrieves the data of the user
//                            let email = data["email"] as! String
                            
                            if (AccessToken.isCurrentAccessTokenActive) {
                                Auth.auth().signIn(with: credential, completion: { (result, error) in
                                    // if sign in successful
                                    if (result != nil) {
                                        print("segue complete")
                                        self.performSegue(withIdentifier: "signInToMain", sender: self)
                                    }
                                })
                                
                            } else {
                                Auth.auth().createUser(withEmail: data["email"] as! String, password: "placeholder") { (user, error) in
                                    print("created user")
                                    // successfully creates a new user and signs them into the application
                                    if user != nil {
                                        let userID = Auth.auth().currentUser!.uid
                                        let db = Firestore.firestore()
                                        
                                        print("data", data)
                                        // creates firestore document
                                        db.collection("users").document(userID).setData([
                                            // set specified data entries
                                            "Name": data["name"] as! String,
                                            "ID": userID,
                                            "Email": data["email"] as! String,
                                        ]) { err in
                                            if let err = err {
                                                print("Error writing document: \(err)")
                                            } else {
                                                print("Document successfully written!")
                                            }
                                        }
                                        print("completed")
                                    } else {
                                        print("Error: \(String(describing: error))")
                                    }
                                }
                            }
                        }
                    })
                    
                    self.performSegue(withIdentifier: "signInToMain", sender: self)
                }
            })
        }
    }
    
    // Login Button protocol
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            CustomError.createWith(errorTitle: "Facebook Login Error", errorMessage: error.localizedDescription).show()
            return
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                CustomError.createWith(errorTitle: "Facebook Login Error", errorMessage: error.localizedDescription).show()
                return
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        // Do something when the user logout
        print("Logged out")
    }
}
