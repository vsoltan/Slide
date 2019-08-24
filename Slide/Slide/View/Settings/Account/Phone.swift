//
//  AddPhoneNumViewController.swift
//  Slide
//
//  Created by Jennifer Kim on 7/5/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class Phone: UIViewController, UITextFieldDelegate {
    
    // textfield for modifying a user's number
    @IBOutlet weak var setPhone: UITextField!
    
    // shows if the user's phone number can be a part of their slide
    @IBOutlet weak var userPermission: UISwitch!
    
    // resets each time the page loads
    var wasModified = false
    
    let currPhone = UserDefaults.standard.getPhoneNumber()
    var newPhone = String()
    
    // prepare doc for modifications
    let db = Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setPhone.delegate = self
        self.hideKeyboardOnGesture()
        setPhone.keyboardType = .phonePad
        
        // display the user's synced number if already associated with the account
        if let phoneNumber = UserDefaults.standard.getPhoneNumber() {
            setPhone.text = phoneNumber
        }
    }
    
    func checkFormat() -> Bool {
        return newPhone.isValidPhoneNumber()
    }
    
    // after editing is finished compares new and old numbers
    @IBAction func phoneModified(_ sender: Any) {
        // checks if there were any changes made
        newPhone = setPhone.text!
        if (newPhone != currPhone) {
            wasModified = true
        }
        
        // if user removes their number automatically turn off sync
        if (newPhone.isEmpty) {
            userPermission.isOn = false
        }
    }
    
    // user is ready to commit changes
    func checkAndUpdatePhone() -> Bool {
        
        // determines if the user can return to linked accounts page
        var canContinue : Bool = true
        
        // if the user authorizes the app to work with their number
        if (userPermission.isOn) {
            if (wasModified) {
                if (checkFormat()) {
                    // modify document for the user
                    db.setData([
                        "Phone": newPhone,
                    ], merge: true) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                    UserDefaults.standard.setPhoneNumber(value: newPhone)
                } else {
                    CustomError.createWith(errorTitle: "Poorly Formated Number", errorMessage: "enter a number like XXX-XXX-XXXX")
                    canContinue = false
                }
            }
        } else {
            setPhone.placeholder = "XXX-XXX-XXXX"
            
            // make modification in background
            UserDefaults.standard.setPhoneNumber(value: nil)
            
            db.updateData([
                "Phone": FieldValue.delete(),
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
        }
        return canContinue
    }
    
    @IBAction func goBack(_ sender: Any) {
        if (checkAndUpdatePhone()) {
            performSegue(withIdentifier: "phoneToLinked", sender: self)
        }
    }
    
    // TODO get the program to auto format the number so user doesn't have to
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func autoFormat() {
        // 10 digit number, 2 parens, and 2 dashes
        while (setPhone.text?.count ?? 0 <= 14) {
            
        }
    }
}
