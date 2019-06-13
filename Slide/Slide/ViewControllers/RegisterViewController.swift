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
        let registerInfo: Array<(field: UITextField, type: String)>
            = [(usrEmail, "email"), (usrName, "name"), (usrUsername, "username"), (usrPassword, "password")]
        
        TextFieldParser.validate(textFields: registerInfo)
        return
    }
}

