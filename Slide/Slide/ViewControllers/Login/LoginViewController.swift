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
        
        // checks that the user passed information to the application
        if (TextFieldParser.validate(textFields: signInInfo) == true) {
            Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
                if (user != nil) {
                    // retrieves user data to create defaults for the current session
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
    
    @IBAction func facebookLogin(_ sender: Any) {
        let loginManager = LoginManager()
        
        let fbReadPermissions: [String] = ["public_profile", "email"]
        
        loginManager.logIn(permissions: fbReadPermissions, from: self) { (result, error) in
            if (error == nil) {
                self.loginButton(self.facebookButton, didCompleteWith: result, error: error)
            }
        }
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            // something went wrong
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
                                }
                            }
                        }
                    })
                }
                
                // defaults are updated once user is set up and logged in
                User.getUser(userID: userID, completionHandler: { (error) in
                    if let error = error {
                        print("trouble retrieving user data, \(error.localizedDescription)")
                    }
                })
                
                // user is redirected back to the home page
                self.performSegue(withIdentifier: "signInToMain", sender: self)
            }
            
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("finished logout")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // creates facebook login button
        let loginButton = FBLoginButton()
        loginButton.delegate = self
        
        // determines layout and renders the button
//        loginButton.center = view.center
//        view.addSubview(loginButton)
        
        
    }
}

