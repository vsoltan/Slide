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

class Login: UIViewController, LoginButtonDelegate, GIDSignInUIDelegate {
    
    // MARK: - PROPERTIES
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Slide"
        label.font = UIFont.systemFont(ofSize: 30)
        return label
    }()
    
    let emailField: UITextField = {
        let field = UITextField()
        field.frame = CGRect(x: 0, y: 0, width: 334, height: 40)
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Email"
        field.textAlignment = .left
        field.borderStyle = .roundedRect
        field.autocapitalizationType = .none
        return field
    }()
    
    let passwordField: UITextField = {
        let field = UITextField()
        field.frame = CGRect(x: 0, y: 0, width: 334, height: 40)
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Password"
        field.textAlignment = .left
        field.borderStyle = .roundedRect
        field.isSecureTextEntry = true
        return field
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UX.defaultColor
        button.setTitle("Login", for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    let createAccountLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Don't have an account?"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let toRegisterButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UX.defaultColor, for: .normal)
        button.setTitle("Register", for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    // custom button
    let facebookLoginButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UX.facebookColor, for: .normal)
        button.setTitle("Continue with Facebook", for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    let googleLoginButton: GIDSignInButton = {
        let button = GIDSignInButton()
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // reference to underlying facebook button
    var fbLoginButton: FBLoginButton!
    
    // MARK: - CONFIGURATION
    
    func configureLogin() {
        
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        
        view.addSubview(emailField)
        emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        
        // TODO: get leading anchors
        // email.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true

        view.addSubview(passwordField)
        passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20).isActive = true
        
        view.addSubview(loginButton)
        loginButton.addTarget(self, action: #selector(handleLoginButton), for: .touchUpInside)
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 20).isActive = true
        
        view.addSubview(createAccountLabel)
        createAccountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        createAccountLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20).isActive = true
        
        view.addSubview(toRegisterButton)
        toRegisterButton.addTarget(self, action: #selector(handleToRegisterButton), for: .touchUpInside)
        toRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        toRegisterButton.topAnchor.constraint(equalTo: createAccountLabel.bottomAnchor, constant: 20).isActive = true
        
        view.addSubview(facebookLoginButton)
        facebookLoginButton.addTarget(self, action: #selector(handleFacebookLoginButton), for: .touchUpInside)
        facebookLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        facebookLoginButton.topAnchor.constraint(equalTo: toRegisterButton.bottomAnchor, constant: 20).isActive = true
        
        view.addSubview(googleLoginButton)
        googleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        googleLoginButton.topAnchor.constraint(equalTo: facebookLoginButton.bottomAnchor, constant: 20).isActive = true
        
    }
    
    // MARK: - INITIALIZATIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLogin()
        
        self.hideKeyboardOnGesture()
        
        // creates facebook login button
        fbLoginButton = FBLoginButton()
        fbLoginButton.delegate = self
        
        // google delegate setup
        GIDSignIn.sharedInstance()?.uiDelegate = self
    }
    
    // MARK: - HANDLERS
    
    @objc func handleLoginButton() {
        // consolidate provided data
        let signInInfo: Array<(field: UITextField, type: String)>
            = [(emailField, "username"), (passwordField, "password")]
        
        let auth = Auth.auth()
        
        // checks that the user passed information to the application
        if (TextParser.validate(textFields: signInInfo) == true) {
            Auth.auth().signIn(withEmail: emailField.text!.trim(), password: passwordField.text!) { (user, error) in
                if (user != nil) {
                    // retrieves user data to create defaults for the current session
                    AppUser.setLocalData(for: auth.currentUser!.uid, completionHandler: { (error) in
                        if (error != nil) {
                            print("something went wrong")
                        } else {
                            // create a container view to run the application
                            let container = Container()
                            self.present(container, animated: true, completion: nil)
                        }
                    })
                } else {
                    CustomError.createWith(errorTitle: "Login Error", errorMessage: error!.localizedDescription)
                }
            }
        }
    }
    
    @objc func handleToRegisterButton() {
        let register = Register()
        present(register, animated: true, completion: nil)
    }
    
    @objc func handleFacebookLoginButton() {
        let loginManager = LoginManager()
        
        let fbReadPermissions: [String] = ["public_profile", "email"]
        
        loginManager.logIn(permissions: fbReadPermissions, from: self) { (result, error) in
            if error != nil {
                print("custom facebook button failed")
            } else if (result?.isCancelled)!{
                print("login was cancelled")
            } else {
                self.loginButton(self.fbLoginButton, didCompleteWith: result, error: error)
            }
        }
    }
    
    // MARK: - API
    
    // facebook delegate that outlines the logistics of the login sequence
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
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
                    
                    // blocks off main thread from continuing execution before doc is created
                    myGroup.enter()
                    userData.start(completionHandler: { (connection, result, error) in
                        if (error != nil) {
                            print("something went wrong")
                        } else {
                            // data consolidated into a readable array
                            let data = result as! NSDictionary
                            
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
                AppUser.setLocalData(for: userID, completionHandler: { (error) in
                    if (error != nil) {
                        print("trouble retrieving user data, \(error!.localizedDescription)")
                    } else {
                        // create a container view to run the application
                        let container = Container()
                        self.present(container, animated: true, completion: nil)
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

