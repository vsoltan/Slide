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
    
    // native login
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    // additional methods
    @IBOutlet weak var facebookButton: FBLoginButton!
    @IBOutlet weak var googleButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardOnGesture()
        
        // creates facebook login button
        let loginButton = FBLoginButton()
        loginButton.delegate = self
        
        // google delegate setup
        GIDSignIn.sharedInstance()?.uiDelegate = self
    }
    
    // supporting action for when user signs in with email and password
    @IBAction func LogInActivated(_ sender: Any) {
        // consolidate provided data
        let signInInfo: Array<(field: UITextField, type: String)>
            = [(email, "username"), (password, "password")]
        
        // checks that the user passed information to the application
        if (TextParser.validate(textFields: signInInfo) == true) {
            Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
                if (user != nil) {
                    // retrieves user data to create defaults for the current session
                    SlideUser.getUser(userID: Auth.auth().currentUser!.uid, completionHandler: { (error) in
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
    
    // custom button that fulfills facebook login function
    @IBAction func facebookLogin(_ sender: Any) {
        let loginManager = LoginManager()
        
        let fbReadPermissions: [String] = ["public_profile", "email"]
        
        loginManager.logIn(permissions: fbReadPermissions, from: self) { (result, error) in
            if (error == nil) {
                self.loginButton(self.facebookButton, didCompleteWith: result, error: error)
            } else {
                print("custom facebook button failed")
            }
        }
    }
    
    // facebook delegate that outlines the logistics of the login sequence
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        // creates a unique firebase login token
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        
        // safeguard against async tasks completing after the main thread needs data
        let myGroup = DispatchGroup()
        
        // firebase uses the facebook token to log in
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                CustomError.createWith(errorTitle: "Login Failed", errorMessage: error.localizedDescription).show()
                return
            } else {
                // establishes reference to the database
                let db = Firestore.firestore()
                let userID = Auth.auth().currentUser!.uid
                
                // checks the time of user creation
                if ((authResult?.additionalUserInfo!.isNewUser)!) {
                    
                    // data retrieved from profile if user was just created
                    let userData = GraphRequest(graphPath: "me", parameters: ["fields":"name, email"], tokenString: AccessToken.current?.tokenString, version: nil, httpMethod: HTTPMethod(rawValue: "GET"))
                    
                    // blocks off main thread from continuing execution before doc is created
                    myGroup.enter()
                    userData.start(completionHandler: { (test, result, error) in
                        if (error != nil) {
                            print("something went wrong")
                        } else {
                            // data consolidated into a readable array
                            let data = result as! NSDictionary
                            
                            // new document is created for the user
                            db.collection("users").document(userID).setData([
                                // set specified data entries
                                "Name": data["name"] as! String,
                                "ID": userID,
                                "Email": data["email"] as! String,
                            ]) { error in
                                if let error = error {
                                    print("Error writing document: \(error.localizedDescription)")
                                } else {
                                    print("Document successfully written!")
                                    myGroup.leave()
                                }
                            }
                        }
                    })
                }
                
                // suspends program execution until defaults are updated
                myGroup.enter()
                SlideUser.getUser(userID: userID, completionHandler: { (error) in
                    if let error = error {
                        print("trouble retrieving user data, \(error.localizedDescription)")
                    } else {
                        myGroup.leave()
                    }
                })
                
                // sends a signal to the main thread that it can continue
                myGroup.notify(queue: .main) {
                    // user is redirected back to the home page
                    self.performSegue(withIdentifier: "signInToMain", sender: self)
                }
            }
        }
    }
    
    // facebook delegate function (not used)
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("finished facebook logout")
    }
}

