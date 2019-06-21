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
import FirebaseDatabase

// an interface between the database and the user
class User {
    // reference to the cloud database
    let db = Firestore.firestore()
    
    // global structure for easy access to user details
    struct profile {
        static var name, ID, email : String?
    }
    
    init(UID : String) {
        let db = Firestore.firestore()
        db.collection("users").whereField("ID", isEqualTo: UID).getDocuments { (snapshot, error) in
            if error != nil {
                SlideError.inputError(errorTitle: "Data Retrieval", errorMessage: error!.localizedDescription).show()
            } else {
                for document in (snapshot?.documents)! {
                    profile.name = document.data()["Name"] as? String
                    print(profile.name!)
                }
            }
        }
        
    }
}
