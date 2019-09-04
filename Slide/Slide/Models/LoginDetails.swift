//
//  LoginDetails.swift
//  Slide
//
//  Created by Valeriy Soltan on 9/4/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit

class LoginDetails {
    
    public var data = Array<(field: UITextField, type: String)>()
    
    init(email: UITextField, password: UITextField) {
        data.append((email, "email"))
        data.append((password, "password"))
    }
    
    // MARK: - GETTERS
    
    func getEmailText() -> String {
        return data[0].field.text!
    }
    
    func getPasswordText() -> String {
        return data[1].field.text!
    }
}
