//
//  RegisterViewController.swift
//  Slide
//
//  Created by Valeriy Soltan on 6/5/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    // text fields
    @IBOutlet weak var usrEmail: UITextField!
    @IBOutlet weak var usrName: UITextField!
    @IBOutlet weak var usrUsername: UITextField!
    @IBOutlet weak var usrPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // go back to sign in view
    @IBAction func chooseLogIn(_ sender: Any) {
        performSegue(withIdentifier: "toLogin", sender: self)
    }
    
    // sign up button clicked
    @IBAction func accountActivated(_ sender: Any) {
        let registerInfo: Array<(field: UITextField, type: String)>
            = [(usrEmail, "email"), (usrName, "name"), (usrUsername, "username"), (usrPassword, "password")]
        
        if (TextFieldParser.validate(textFields: registerInfo)) {
            Auth.auth().createUser(withEmail: usrEmail.text!, password: usrPassword.text!) { (user, error) in
                // successfully creates a new user and signs them into the application
                if user != nil {
                    self.performSegue(withIdentifier: "registerToHome", sender: self)
                // error checking
                } else {
                    // TODO make intuitive error alerts
                    print("\(error!)")
                }
            }
        }
        return
    }
}

