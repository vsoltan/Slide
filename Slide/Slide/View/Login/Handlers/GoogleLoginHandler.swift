//
//  GoogleLogin.swift
//  Slide
//
//  Created by Valeriy Soltan on 9/2/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import Firebase
import GoogleSignIn

class GoogleLoginHandler: GIDSignIn {
    
    // MARK: - HANDLERS
    
    func handleGoogleSignIn(for GIDCredential: AuthCredential, completion: @escaping (Bool) -> Void) {
        
        let auth = Auth.auth()
        
        auth.signIn(with: GIDCredential) { (authResult, signInError) in
            
            if (signInError == nil) {
                if let user = authResult?.additionalUserInfo {
                    
                    let userID = auth.currentUser!.uid
                    
                    if (user.isNewUser) {
                        
                        let db = Firestore.firestore()
                        
                        db.collection("users").document(userID).setData([
                            "Name": authResult?.user.displayName as Any,
                            "ID": userID,
                            "Email": authResult?.user.email as Any
                        ]) { setDataError in
                            if let error = setDataError {
                                print("Error writing document: \(error)")
                                completion(false)
                            } else {
                                print("Document successfully written!")
                            }
                        }
                    }
                    
                    // load account details for every user
                    AppUser.setLocalData(for: userID, completionHandler: { (cachingError) in
                        (cachingError == nil) ? completion(true) : completion(false)
                    })
                }
            } else {
               print("something went wrong with firebase login")
                completion(false)
            }
        }
    }
    
    // MARK: - TRANSITIONS
    
    func presentApplication(from currentView: AppDelegate) {

        let container = Container()
        
        guard let current = currentView.window?.rootViewController else { return }
        
        UIView.transition(from: current.view, to: container.view, duration: 0.4, options:
            .transitionCrossDissolve, completion: { (_) in
                currentView.window?.rootViewController = container
                currentView.window?.makeKeyAndVisible()
        })
    }
}

