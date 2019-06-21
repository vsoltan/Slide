//
//  profile.swift
//  Slide
//
//  Created by Valeriy Soltan on 6/12/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

// an interface between the database and the user
class CurrentUser {
    
    private static var name : String?
    
    static var user = Auth.auth().currentUser!.uid
    
    // retrieves the data tree belonging to the current user
    static func getDocument(completion: @escaping ([QueryDocumentSnapshot]?) -> Void) {
        // reference to the cloud database
        let db = Firestore.firestore()
        
        db.collection("users").whereField("ID", isEqualTo: user).getDocuments { (snapshot, error) in
            if error != nil {
                // user was not found
                SlideError.inputError(errorTitle: "Data Retrieval", errorMessage: error!.localizedDescription).show()
                completion(nil)
            } else {
                // returns data
                completion((snapshot?.documents))
            }
        }
    }
    
    // sets private field to the name stored in the database
    static func retrieveName() -> Void {
        // no error checking because getDocument will throw user-not-found error
        getDocument() { (userData) in
            for doc in userData! {
                if let nameField = doc.data()["Name"] as? String {
                    name = nameField
                }
            }
        }
    }
    
    // returns the explicit value of the name
    static func getName() -> String {
        return self.name!
    }
}
