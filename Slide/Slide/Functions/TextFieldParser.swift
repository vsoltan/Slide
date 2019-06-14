//
//  TextVerification.swift
//  Slide
//
//  Created by Valeriy Soltan on 6/6/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit
import Foundation

class TextFieldParser: UIAlertController {

    // sets the placeholder text to red and displays an appropriate error message
    static func emptyError(field: UITextField, error: String) {
        field.attributedPlaceholder = NSAttributedString(string: error, attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
    }
    
    // creates a UIAlertController with prompts for the user
    static func emailError() -> UIAlertController {
        // customization
        let invalidEmail = UIAlertController(title: "Invalid Email", message: "Please enter a valid email address", preferredStyle: .actionSheet)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        invalidEmail.addAction(defaultAction)
        return invalidEmail
    }
    
    static func validate(textFields: Array<(field: UITextField, type: String)>) {
        // iterates through each textfield and checks if its empty
        for entry in textFields {
            if (entry.field.text!.isEmpty){
                emptyError(field: entry.field, error: "please enter your \(entry.type)")
            }
            // if the entry is an email, checks if its of a valid format
            if (entry.type.equals(id: "email") && !(entry.field.text!.isValidEmail())) {
                emailError().show()
            }
        }
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

// overrides the view heirarchy to present an alert
public extension UIAlertController {
    func show() {
        let win = UIWindow(frame: UIScreen.main.bounds)
        let vc = UIViewController()
        vc.view.backgroundColor = .clear
        win.rootViewController = vc
        win.windowLevel = UIWindow.Level.alert + 1
        win.makeKeyAndVisible()
        vc.present(self, animated: true, completion: nil)
    }
}
