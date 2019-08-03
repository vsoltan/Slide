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

class PhoneNumViewController: UIViewController {
    
    // textfield for modifying a user's number
    @IBOutlet weak var setPhone: UITextField!
    
    // if on the app can use the user's phone number as part of their slide
    @IBOutlet weak var userPermission: UISwitch!
    
    // prepare doc for modifications
    let db = Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid)
    
    @IBAction func phoneModified(_ sender: Any) {
        // checks that the phone is provided in the proper format
        if (checkFormat()) {
            // if the user authorizes the app to work with their number
            if (userPermission.isOn) {
                let currPhone = UserDefaults.standard.getPhoneNumber()
                let passedData = setPhone.text!
                
                // phoneNumber hasn't been set yet
                if (currPhone == nil) {
                    // create a new document for the user
                    db.setData([
                        // set specified data entries
                        "Phone": passedData,
                    ], merge: true) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                }
                if (setPhone.text != currPhone) {
                    UserDefaults.standard.setPhoneNumber(value: setPhone.text!)
                    db.updateData([
                        "Phone": passedData,
                    ])
                }
            }
        }
        return
    }
    
    @IBAction func goBack(_ sender: Any) {
        // make modification in background
        if (userPermission.isOn == false) {
            print("this is happening")
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
    }

    func checkFormat() -> Bool {
        let result = (setPhone.text)?.isValidPhoneNumber()
        if (result! == false) {
            CustomError.createWith(errorTitle: "Poorly Formated Number", errorMessage: "enter a number like XXX-XXX-XXXX").show()
        }
        return result!
    }
    
    // TODO
    // create an action for the switch that grays out the options for phone input
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // display the user's synced number if already associated with the account
        if let phoneNumber = UserDefaults.standard.getPhoneNumber() {
            setPhone.placeholder = phoneNumber
        }
    }
}
