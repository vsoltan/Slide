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
    
    
    @IBOutlet weak var setPhone: UITextField!
    
    @IBOutlet weak var userPermission: UISwitch!
    
    @IBAction func goBackAndSave(_ sender: Any) {
        // checks that the phone is provided in the proper format
        if ((setPhone.text)?.isValidatePhoneNumber() == false) {
            print("poorly formatted number")
            return
        }
        
        // if the user authorizes us to work with their number
        if (userPermission.isOn) {
            let currPhone = UserDefaults.standard.getPhoneNumber()
            let passedData = setPhone.text!
            let db = Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid)
            
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
        } else {
            // TODO grey out the options so the user cannot interact with them
            print("user has to give permission")
            return
        }
        self.performSegue(withIdentifier: "backToSettings", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}
