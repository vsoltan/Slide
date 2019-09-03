//
//  LoginProtocol.swift
//  Slide
//
//  Created by Valeriy Soltan on 8/31/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import Firebase
import GoogleSignIn
import FacebookLogin

class GoogleLoginHandler: GIDSignIn {

    // MARK: - HANDLERS
    
    func handleGoogleSignIn(GIDCredential: AuthCredential) -> Bool {
        
        let auth = Auth.auth()
        
        auth.signIn(with: GIDCredential) { (authResult, error) in
            
            if (error == nil) {
                if let user = authResult?.additionalUserInfo {
                    if (user.isNewUser) {
                        let db = Firestore.firestore()
                        let userID = auth.currentUser!.uid
                        
                        db.collection("users").document(userID).setData([
                            // set specified data entries
                            "Name": authResult?.user.displayName as Any,
                            "ID": userID as Any,
                            "Email": authResult?.user.email as Any,
                        ]) { err in
                            return (err === nil)
                        }
                    }
                }
            }
        }
    }
    
                
//                // store google user's data locally
//                AppUser.getUser(userID: Auth.auth().currentUser!.uid, completionHandler: { (error) in
//                    if (error != nil) {
//                        print("something went wrong")
//                    } else {
//                        print("success!")
////                        // initializes the container for the view controller
////                        self.window = UIWindow(frame: UIScreen.main.bounds)
////
////                        // specifies the destination and creates an instance of that view controller
////                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
////                        let initialViewController = storyboard.instantiateViewController(withIdentifier: "Home")
////
////                        // sets the root view controller to the desination and renders it
////                        self.window?.rootViewController = initialViewController
////                        self.window?.makeKeyAndVisible()
//                    }
//                })
//            }
//                // failed
//            else {
//                print(error?.localizedDescription as Any)
//                CustomError.createWith(errorTitle: "Google Authentication Error", errorMessage: error!.localizedDescription)
//            }
//        }
//    }
}
