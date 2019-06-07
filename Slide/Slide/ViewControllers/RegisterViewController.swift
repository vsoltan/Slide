//
//  RegisterViewController.swift
//  Slide
//
//  Created by Valeriy Soltan on 6/5/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    // text fields
    @IBOutlet weak var usrEmail: UITextField!
    @IBOutlet weak var usrName: UITextField!
    @IBOutlet weak var usrUsername: UITextField!
    @IBOutlet weak var usrPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // sign up button clicked
    @IBAction func accountActivated(_ sender: Any) {
        if (validated()) {
            // add to database and process sign up request
            return
        }
    }
    
    func validated() -> Bool {
        let email = usrEmail.text
        let name = usrName.text
        let usr = usrUsername.text
        let pswd = usrPassword.text
        
        var valid: Bool = true
        // change placeholder color to red color for empty textfields
        if (email!.isEmpty){
            usrEmail.attributedPlaceholder = NSAttributedString(string: "please enter your email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            valid = false
        }
        
        if (name!.isEmpty){
            usrName.attributedPlaceholder = NSAttributedString(string: "please enter your name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            valid = false
        }
        
        if (usr!.isEmpty){
            usrUsername.attributedPlaceholder = NSAttributedString(string: "please enter your username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            valid = false
        }
        
        if (pswd!.isEmpty){
            usrPassword.attributedPlaceholder = NSAttributedString(string: "please enter your username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            valid = false
        }
        
        return valid
    }
}

