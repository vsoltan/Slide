//
//  FirebaseLoginHandler.swift
//  Slide
//
//  Created by Valeriy Soltan on 9/4/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import Firebase

class FirebaseLoginHandler {
    
    func handleFirebaseLogin(for loginDetails: LoginDetails, completion: @escaping (Bool) -> Void) {
        
        let auth = Auth.auth()
        
        let credentials = loginDetails.data
        
        if (TextParser.validate(textFields: credentials)) {
            
            let email = loginDetails.getEmailText()
            let password = loginDetails.getPasswordText()
            
            auth.signIn(withEmail: email.trim(), password: password) { (user, error) in
                if (user != nil) {
                    // retrieves user data to create defaults for the current session
                    AppUser.setLocalData(for: auth.currentUser!.uid, completionHandler: { (error) in
                        (error == nil) ? completion(true) : completion(false)
                    })
                } else {
                    CustomError.createWith(errorTitle: "Login Error", errorMessage: error!.localizedDescription)
                }
            }
        }
    }
    
    func presentApplication(from: UIViewController) {
        let container = Container()
        from.present(container, animated: true, completion: nil)
    }
}


