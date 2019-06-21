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
public class User {
    private var name, email, ID : String?
    
    let db = Firestore.firestore()
    
    // creates a new user
    init(UID : String) {
        let profile = db.collection("users").document(UID)
        ID = UID
        profile.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }
    }
}
