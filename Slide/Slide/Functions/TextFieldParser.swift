//
//  TextVerification.swift
//  Slide
//
//  Created by Valeriy Soltan on 6/6/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit
import Foundation

class TextFieldParser {
    static func validEmail(emailField: UITextField) {
        // TODO
    }
    
    static func validate(textFields: Array<(field: UITextField, type: String)>) {
        // change placeholder color to red color for the passed textfields if empty
        for entry in textFields {
            if (entry.field.text!.isEmpty){
                entry.field.attributedPlaceholder = NSAttributedString(string: "please enter your \(entry.type)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            }
            
            if (entry.type.equals(id: "email")) {
                validEmail(emailField: entry.field)
            }
        }
    }
}

extension String {
    func equals(id: String) -> Bool {
        return String(format: self) == id
    }
}
