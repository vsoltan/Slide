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
class CurrentUser {
    
    // the user ID of the currently signed in user
    static var user = Auth.auth().currentUser!.uid
    
    // retrieves the data tree belonging to the current user
    static func getDocument(completionHandler: @escaping ([QueryDocumentSnapshot]?) -> Void) {
        
        // reference to the database
        let db = Firestore.firestore()

        // asynchronous call to the database
        db.collection("users").whereField("ID", isEqualTo: user).getDocuments { (snapshot, error) in
            if error != nil {
                // user was not found
                SlideError.inputError(errorTitle: "Data Retrieval", errorMessage: error!.localizedDescription).show()
                completionHandler(nil)
            } else {
                // upon completion, returns a reference to the document
                completionHandler((snapshot?.documents)!)
            }
        }
    }
    
    // parses through the user's doc tree and finds their name
    static func getName(completion: @escaping (String?) -> Void) {
        // thread deployed to interact with database
        self.getDocument() { (userData) in
            // iterates through the array, as there may be several docs
            for document in userData! {
                if let nameData = document.data()["Name"] as? String {
                    // waits for the thread to complete and returns
                    completion(nameData)
                }
            }
        }
    }
    /*  NOTE: if we put a return statement here, it would execute before most of the
        code after the call to the getDocument method, therefore, nameData wouldn't get
        initialized...which is why we kept getting nil
    */
}
