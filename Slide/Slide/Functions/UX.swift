//
//  UX.swift
//  Slide
//
//  Created by Valeriy Soltan on 8/6/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import Foundation
import UIKit

class UX {}

// allows the user to dismiss the keyboard once they are done editing
extension UIViewController {
    func hideKeyboardOnGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        
        let scrollUp = UISwipeGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        let scrollDown = UISwipeGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        scrollUp.direction = .up
        scrollDown.direction = .down
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        view.addGestureRecognizer(scrollUp)
        view.addGestureRecognizer(scrollDown)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
