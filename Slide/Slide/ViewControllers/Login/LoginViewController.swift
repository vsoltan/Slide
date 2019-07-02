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
import FacebookCore
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit


class LoginViewController: UIViewController, LoginButtonDelegate, GIDSignInUIDelegate {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var facebookButton: FBLoginButton!
    
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
        
        // creates facebook login button
        let loginButton = FBLoginButton()
        loginButton.delegate = self

        // creates login button from GoogleSignIn
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // automatically signs the user into google.
        GIDSignIn.sharedInstance().signInSilently()
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
                            let r = result as! NSDictionary
                            Auth.auth().createUser(withEmail: r["email"] as! String, password: "placeholder") { (user, error) in
                                    // successfully creates a new user and signs them into the application
                                    if user != nil {
                                        let userID = CurrentUser.userID
                                        let db = Firestore.firestore()
                                        
                                        // creates firestore document
                                        db.collection("users").document(userID).setData([
                                            // set specified data entries
                                            "Name": r["name"] as! String,
                                            "ID": userID,
                                            "Email": r["email"] as! String,
                                        ]) { err in
                                            if let err = err {
                                                print("Error writing document: \(err)")
                                            } else {
                                                print("Document successfully written!")
                                            }
                                        }
                                    }
                                }
                            }
                        })
                    
                    self.performSegue(withIdentifier: "signInToMain", sender: self)
                }

//            Auth.auth().signInAndRetrieveData(with: credential) { (user, error) in
//                if let error = error {
//                    print("Login error: \(error.localizedDescription)")
//                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
//                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                    alertController.addAction(okayAction)
//                    self.present(alertController, animated: true, completion: nil)
//                    return
//                }
//                // self.performSegue(withIdentifier: self.signInSegue, sender: nil)
//            }
            }
        }
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "signInToMain") {
            let dst = segue.destination as! HomeViewController
            CurrentUser.getName { (name) in
                dst.NameLabel.text = name!
                dst.customizationInfo.setObject(name as AnyObject, forKey: "name" as AnyObject)
            }
            
        }
    }
    
    // to be implemented later for google signout...
    //    @IBAction func didTapSignOut(_ sender: AnyObject) {
    //        GIDSignIn.sharedInstance().signOut()
    //    }
    
    //
}
