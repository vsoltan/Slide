//
//  PasswordViewController.swift
//  Slide
//
//  Created by Sam Lee on 6/21/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class PasswordViewController: UIViewController {
    
    
    @IBOutlet weak var userEmail: UITextField!
    
    @IBOutlet weak var curPassword: UITextField!
    
    @IBOutlet weak var newPassword: UITextField!
    
    @IBOutlet weak var confirmNew: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // save button clicked
    @IBAction func passwordSaved(_ sender: Any) {
        let passwordInfo: Array<(field: UITextField, type: String)>
            = [(userEmail, "email"), (curPassword, "cur"), (newPassword, "new"), (confirmNew, "confirm")]
        
        let usr = Auth.auth().currentUser
        let credential = EmailAuthProvider.credential(withEmail: userEmail.text!, password: curPassword.text!)
        // let dataResult = {[weak self] (error) in}
        
        if (TextFieldParser.validate(textFields: passwordInfo) && newPassword.text == confirmNew.text) {
            usr?.reauthenticate(with: credential) { (user, error) in
                if let error = error {
                    SlideError.inputError(errorTitle: "Error", errorMessage: error.localizedDescription).show()
                } else {
                    usr?.updatePassword(to: self.newPassword.text!)
                }
            }
        } else {
            SlideError.inputError(errorTitle: "Error", errorMessage: "you didn't follow instructions bitch").show()
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
