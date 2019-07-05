//
//  CurrentUser.swift
//  Slide
//
//  Created by Valeriy Soltan on 6/12/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import Foundation
import Firebase

// an interface between the database and the user
class User {
    
    // retrieves the data tree belonging to the current user
    static func getDocument(currentUserID: String, completionHandler: @escaping ([QueryDocumentSnapshot]?, Error?) -> Void) {
        
        // reference to the database
        let db = Firestore.firestore()

        // asynchronous call to the database
        db.collection("users").whereField("ID", isEqualTo: currentUserID).getDocuments { (snapshot, error) in
            if error != nil {
                // user was not found
                CustomError.createWith(errorTitle: "Data Retrieval", errorMessage: error!.localizedDescription).show()
                completionHandler(nil, error)
            } else {
                // upon completion, returns a reference to the document
                completionHandler((snapshot?.documents)!, nil)
            }
        }
    }
    
    // parses through the user's doc tree and finds their name
    static func getName(userID: String, completion: @escaping (String?) -> Void) {
        // thread deployed to interact with database
        self.getDocument(currentUserID: userID) { (userData, error) in
            if (userData != nil) {
                // iterates through the array, as there may be several docs
                for document in userData! {
                    if let nameData = document.data()["Name"] as? String {
                        // waits for the thread to complete and returns
                        completion(nameData)
                    }
                }
            } else {
                print("\(error!)")
            }
        }
    }

    /*  NOTE: if we put a return statement here, it would execute before most of the
        code after the call to the getDocument method, therefore, nameData wouldn't get
        initialized...which is why we kept getting nil
    */
    
    // explicit return type because every user has to have an email
    static func getEmail() -> String {
        return (Auth.auth().currentUser?.email)!
    }
}
