//
//  RegisterViewController.swift
//  Slide
//
//  Created by Valeriy Soltan on 6/5/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    // input text fields
    @IBOutlet weak var usrEmail: UITextField!
    @IBOutlet weak var usrName: UITextField!
    @IBOutlet weak var usrUsername: UITextField!
    @IBOutlet weak var usrPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardOnGesture() 
    }
    
    // navigates back to sign in view
    @IBAction func chooseLogIn(_ sender: Any) {
        performSegue(withIdentifier: "toLogin", sender: self)
    }
    
    // sign up button clicked
    @IBAction func accountActivated(_ sender: Any) {
        let registerInfo: Array<(field: UITextField, type: String)>
            = [(usrEmail, "email"), (usrName, "name"), (usrUsername, "username"), (usrPassword, "password")]
        
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
            
            let register = (name : usrName.text!, email : usrEmail.text!,
                            password : usrPassword.text!)
            
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
                self.performSegue(withIdentifier: "registerToHome", sender: self)
                    
                } else {
                    CustomError.createWith(errorTitle: "Account Creation", errorMessage: error!.localizedDescription)
                }
            }
        }
    }
}

