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
                completion((snapshot?.documents)!)
            }
        }
    }
    
    static func getName() -> String {
        // explicit String return type because error will be thrown in getDocument method
        self.getDocument() { (userData) in
            for doc in userData! {
//                TODO name = doc.data()["Name"] as? String
            }
        }
        return "placeholderString"
    }

}
