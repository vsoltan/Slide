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
        
        if (TextFieldParser.validate(textFields: registerInfo)) {
            auth.createUser(withEmail: (usrEmail.text!).trim(), password: usrPassword.text!) { (user, error) in
                // successfully creates a new user and signs them into the application
                if user != nil {
                    // has to be Auth.auth
                    let userID = auth.currentUser!.uid
                    let db = Firestore.firestore()
                    
                    // creates firestore document
                    db.collection("users").document(userID).setData([
                        // set specified data entries
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
                    // possible optimization: pass the registration data to defaults as it's being added to the database
                    User.getUser(userID: Auth.auth().currentUser!.uid, completionHandler: { (error) in
                        if (error != nil) {
                            print("something went wrong")
                        } else {
                            self.performSegue(withIdentifier: "registerToHome", sender: self)
                        }
                    })
                // something went wrong iwth user initialization
                } else {
                    CustomError.createWith(errorTitle: "Account Creation", errorMessage: error!.localizedDescription).show()
                }
            }
        }
    }
}

