//
//  RegisterViewController.swift
//  Slide
//
//  Created by Valeriy Soltan on 6/5/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit
import Firebase

class Register: UIViewController {
    
    // MARK: - PROPERTIES
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Register"
        label.font = UIFont.systemFont(ofSize: 30)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sign up to connect with your network"
        label.font = UIFont.systemFont(ofSize: 16)
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
    
    let nameField: UITextField = {
        let field = UITextField()
        field.frame = CGRect(x: 0, y: 0, width: 334, height: 40)
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Full Name"
        field.textAlignment = .left
        field.borderStyle = .roundedRect
        field.autocapitalizationType = .none
        return field
    }()
    
    let usernameField: UITextField = {
        let field = UITextField()
        field.frame = CGRect(x: 0, y: 0, width: 334, height: 40)
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Username"
        field.textAlignment = .left
        field.borderStyle = .roundedRect
        field.isSecureTextEntry = true
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
    
    let registerButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UX.defaultColor
        button.setTitle("Sign Up", for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    let disclaimer: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.text = "By signing up, you agree to our Terms,\n Data Policy and Cookies Policy"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    let existingAccount: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Have an account?"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        return label 
    }()
    
    let backToLoginButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UX.defaultColor, for: .normal)
        button.setTitle("Login", for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    // MARK: - CONFIGURATION
    func configureRegister() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        
        view.addSubview(descriptionLabel)
        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 50).isActive = true
        
        view.addSubview(emailField)
        emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailField.topAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: 50).isActive = true
        
        view.addSubview(nameField)
        nameField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameField.topAnchor.constraint(equalTo: emailField.topAnchor, constant: 50).isActive = true
        
        view.addSubview(usernameField)
        usernameField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        usernameField.topAnchor.constraint(equalTo: nameField.topAnchor, constant: 50).isActive = true
        
        view.addSubview(passwordField)
        passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordField.topAnchor.constraint(equalTo: usernameField.topAnchor, constant: 50).isActive = true
        
        view.addSubview(registerButton)
        registerButton.addTarget(self, action: #selector(handleRegisterButton), for: .touchUpInside)
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerButton.topAnchor.constraint(equalTo: passwordField.topAnchor, constant: 50).isActive = true
        
        view.addSubview(disclaimer)
        disclaimer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        disclaimer.topAnchor.constraint(equalTo: registerButton.topAnchor, constant: 50).isActive = true
        
        view.addSubview(existingAccount)
        existingAccount.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        existingAccount.topAnchor.constraint(equalTo: disclaimer.topAnchor, constant: 50).isActive = true
        
        view.addSubview(backToLoginButton)
        backToLoginButton.addTarget(self, action: #selector(handleBackToLogin), for: .touchUpInside)
        backToLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backToLoginButton.topAnchor.constraint(equalTo: existingAccount.topAnchor, constant: 50).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRegister()
        
        self.hideKeyboardOnGesture() 
    }
    
    // MARK: - HANDLERS
    
    @objc func handleRegisterButton() {
        let registerInfo: Array<(field: UITextField, type: String)>
            = [(emailField, "email"), (nameField, "name"), (usernameField, "username"), (passwordField, "password")]
        
        // verifies that textfields are properly formatted and creates a user
        let auth = Auth.auth()
        
        if (TextParser.validate(textFields: registerInfo)) {
            
            // formats the user's input
            for input in registerInfo {
                let data = input.field.text
                // can use whitespace in passwords
                if (input.type != "password") {
                    input.field.text = data?.trim()
                }
            }
            
            let register = (name: nameField.text!, email: emailField.text!,
                            password: passwordField.text!)
            
            // creates a new user
            auth.createUser(withEmail: register.email, password: register.password) { (user, error) in
                // successful user creation and sign in
                if user != nil {
                    let userID = auth.currentUser!.uid
                    let db = Firestore.firestore()
                    
                    // creates firestore document
                    db.collection("users").document(userID).setData([
                        // set specified data entries
                        "Name": register.name,
                        "ID": userID,
                        "Email": register.email,
                    ]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                    
                    // sets default without having to ping database
                    let defaults = UserDefaults.standard
                    defaults.setName(value: register.name)
                    defaults.setEmail(value: register.email)
                    defaults.setID(value: userID)
                    
                    // continues with main thread execution on home page
                    
                    // create a container view to run the application
                    let container = Container()
                    self.present(container, animated: true, completion: nil)
                    
                } else {
                    CustomError.createWith(errorTitle: "Account Creation", errorMessage: error!.localizedDescription)
                }
            }
        }
    }
    
    @objc func handleBackToLogin() {
        let login = Login()
        present(login, animated: true, completion: nil)
    }
    
    // navigates back to sign in view
    @IBAction func chooseLogIn(_ sender: Any) {
        performSegue(withIdentifier: "toLogin", sender: self)
    }
}

