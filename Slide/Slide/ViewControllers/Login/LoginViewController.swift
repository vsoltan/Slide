//
//  LoginViewController.swift
//  Slide
//
//  Created by Valeriy Soltan on 6/6/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
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
            Auth.auth().signIn(withEmail: email.text!.trim(), password: password.text!) { (user, error) in
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
                    CustomError.createWith(errorTitle: "Login Error", errorMessage: error!.localizedDescription)
                }
            }
        }
    }
    
    // custom button that fulfills facebook login function
    @IBAction func facebookLogin(_ sender: Any) {
        
        let loginManager = LoginManager()
        
        let fbReadPermissions: [String] = ["public_profile", "email"]
        
        loginManager.logIn(permissions: fbReadPermissions, from: self) { (result, error) in
            if error != nil {
                print("custom facebook button failed")
            } else {
                self.loginButton(self.facebookButton, didCompleteWith: result, error: error)
            }
        }
    }
    
    // facebook delegate that outlines the logistics of the login sequence
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        if (result!.isCancelled) { return }
        
        // creates a unique firebase login token
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        
        // TOOD implement temp overlay for api logins
        //self.performSegue(withIdentifier: "", sender: self)
        
        // safeguard against async tasks completing after the main thread needs data
        let myGroup = DispatchGroup()
        
        // firebase uses the facebook token to log in
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                CustomError.createWith(errorTitle: "Login Failed", errorMessage: error.localizedDescription)
                return
            } else {
                // reference to the database
                let db = Firestore.firestore()
                let userID = Auth.auth().currentUser!.uid
                
                // checks the time of user creation
                if ((authResult?.additionalUserInfo!.isNewUser)!) {
                    
                    // data retrieved from profile if user was just created
                    let userData = GraphRequest(graphPath: "me", parameters: ["fields":"name, email, id"], tokenString: AccessToken.current?.tokenString, version: nil, httpMethod: HTTPMethod(rawValue: "GET"))
                    
                
                        //guard let userInfo = result as? [String : Any] else { return }
                        
                        //The url is nested 3 layers deep into the result so it's pretty messy
                        //if let imageURL = ((userInfo["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                            //Download image from imageURL
                        //}
                    
                    // blocks off main thread from continuing execution before doc is created
                    myGroup.enter()
                    userData.start(completionHandler: { (connection, result, error) in
                        if (error != nil) {
                            print("something went wrong")
                        } else {
                            // data consolidated into a readable array
                            let data = result as! NSDictionary
                            
                            print(data)
                            
                            // new document is created for the user
                            db.collection("users").document(userID).setData([
                                // set specified data entries
                                "Name"     : data["name"] as! String,
                                "ID"       : userID,
                                "Email"    : data["email"] as! String,
                                "Facebook" : data["id"] as! String,
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
                
                // wait till defaults are updated before proceeding to main page
                SlideUser.getUser(userID: userID, completionHandler: { (error) in
                    if (error != nil) {
                        print("trouble retrieving user data, \(error!.localizedDescription)")
                    } else {
                        // user is redirected back to the home page
                        self.performSegue(withIdentifier: "signInToMain", sender: self)
                    }
                })
            }
        }
    }
    
    // facebook delegate function (not used)
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("finished facebook logout")
    }
}

