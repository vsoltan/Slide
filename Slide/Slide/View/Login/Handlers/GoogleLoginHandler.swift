//
//  GoogleLogin.swift
//  Slide
//
//  Created by Valeriy Soltan on 9/2/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import Firebase
import GoogleSignIn
import FacebookLogin

class GoogleLoginHandler: GIDSignIn {
    
    // MARK: - HANDLERS
    
    func handleGoogleSignIn(GIDCredential: AuthCredential, completion: @escaping (Bool) -> Void) {
        
        let auth = Auth.auth()
        
        auth.signIn(with: GIDCredential) { (authResult, error) in
            
            if (error == nil) {
                if let user = authResult?.additionalUserInfo {
                    if (user.isNewUser) {
                        let db = Firestore.firestore()
                        let userID = auth.currentUser!.uid
                        
                        db.collection("users").document(userID).setData([
                            "Name": authResult?.user.displayName as Any,
                            "ID": userID,
                            "Email": authResult?.user.email as Any
                        ]) { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                                completion(false)
                            } else {
                                print("Document successfully written!")
                                AppUser.setLocalData(for: userID, completionHandler: { (error) in
                                    if (error == nil) {
                                        completion(true)
                                    }
                                    completion(false)
                                })
                            }
                        }
                    }
                }
            } else {
               print("something went wrong with firebase login")
            }
        }
    }
    
    func fromGoogleLoginToApplication(currentWindow: UIWindow) {
        
    }
    
    
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

