//
//  TextVerification.swift
//  Slide
//
//  Created by Valeriy Soltan on 6/6/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit
import Foundation

class TextVerification {
    // TODO parse email to determine if it's valid
    static func validate(field: UITextField, type: String) { // -> Bool
        // var valid: Bool = true
        // change placeholder color to red color for the passed textfields if empty
        if (field.text!.isEmpty){
            field.attributedPlaceholder = NSAttributedString(string: "please enter your \(type)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            // valid = false
        }
        // return valid (will use this later when database is implemented
    }
}
