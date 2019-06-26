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

    // text fields
    @IBOutlet weak var usrEmail: UITextField!
    @IBOutlet weak var usrName: UITextField!
    @IBOutlet weak var usrUsername: UITextField!
    @IBOutlet weak var usrPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        if (TextFieldParser.validate(textFields: registerInfo)) {
            Auth.auth().createUser(withEmail: usrEmail.text!, password: usrPassword.text!) { (user, error) in
                // successfully creates a new user and signs them into the application
                if user != nil {
                    
                    let userID = (Auth.auth().currentUser)!.uid
                    let db = Firestore.firestore()
                    
                    // creates firestore document
                    db.collection("users").document(userID).setData([
                        // Set specified data entries
                        "Name": self.usrName.text!,
                        "ID": userID,
                        "Email": (self.usrEmail.text!).trim(),
                    ]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                    self.performSegue(withIdentifier: "registerToHome", sender: self)
                    
                // something went wrong
                } else {
                    CustomError.createWith(errorTitle: "Account Creation", errorMessage: error!.localizedDescription).show()
                }
            }
        }
        return
    }
}

