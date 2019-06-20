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

    // sets the placeholder text to red and displays an appropriate error message
    static func emptyError(field: UITextField, error: String) {
        field.attributedPlaceholder = NSAttributedString(string: error, attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
    }
    
    // verifies the format and completion of a text field entry
    static func validate(textFields: Array<(field: UITextField, type: String)>) -> Bool {
        
        var completeForm : Bool = true
        
        // iterates through each textfield and checks if its empty
        for entry in textFields {
            if (entry.field.text!.isEmpty){
                emptyError(field: entry.field, error: "please enter your \(entry.type)")
                completeForm = false
            }
            
            // regex email matching
            if (entry.type.equals(id: "email") && !(entry.field.text!.isValidEmail())) {
                SlideError.inputError(errorTitle: "Invalid Email", errorMessage: "Please enter a valid email address").show()
                completeForm = false
            }
        }
        return completeForm
    }
}

// string equality method for readability
extension String {
    func equals(id: String) -> Bool {
        return String(format: self) == id
    }
}

// establishes the format for accepted emails
extension String {
    func isValidEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}


