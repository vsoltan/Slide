//
//  UX.swift
//  Slide
//
//  Created by Valeriy Soltan on 8/6/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import Foundation
import UIKit

class UX {
    
    // MARK: - COLORS
    
    static let defaultColor = UIColor(red: 255, green: 123, blue: 73)
    static let facebookColor = UIColor(red: 59, green: 89, blue: 152)
    
}

// int inputs are converted to CGFloat
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red) / 255
        let newGreen = CGFloat(green) / 255
        let newBlue = CGFloat(blue) / 255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}

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
