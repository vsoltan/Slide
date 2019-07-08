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
    private static func getDocument(currentUserID: String, completionHandler: @escaping ([QueryDocumentSnapshot]?, Error?) -> Void) {
        
        // reference to the database
        let db = Firestore.firestore()

        // asynchronous call to the database
        db.collection("users").whereField("ID", isEqualTo: currentUserID).getDocuments { (snapshot, error) in
            if error != nil {
                // user was not found
                CustomError.createWith(errorTitle: "Data Retrieval", errorMessage: error!.localizedDescription).show()
                print("Hello 6")
                completionHandler(nil, error)
            } else {
                // upon completion, returns a reference to the document
               print("Hello 7")
                completionHandler((snapshot?.documents)!, nil)
            }
        }
    }
    
    // parses through the user's doc tree and finds their name
    static func getUser(userID: String, completionHandler: @escaping (Error?) -> Void) {
        // thread deployed to interact with database
        self.getDocument(currentUserID: userID) { (userData, error) in
            if (userData != nil) {
                // iterates through the array, as there may be several docs
                for document in userData! {
                    // Retrieves user data from Firebase into UserDefaults
                    if let nameData = document.data()["Name"] as? String {
                        UserDefaults.standard.setName(value: nameData)
                    }
                    
                    if let emailData = document.data() ["Email"] as? String {
                        UserDefaults.standard.setEmail(value: emailData)
                    }
                    
                    if let idData = document.data() ["ID"] as? String {
                        UserDefaults.standard.setID(value: idData)
                    }
                    
                }
                // No error
                completionHandler(nil)
            } else {
                print("\(error!)")
                // Notify that there was indeed an error
                completionHandler(error)
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

// Contains "fields" for UserDefaults
enum UserDefaultsKeys : String {
    
    case localEmail
    case localID
    case localName
    case localGroups
}

// Functions to set and get data from UserDefaults
extension UserDefaults {
    
    // Set and retrieve localEmail
    func setEmail(value: String) {
        set(value, forKey: UserDefaultsKeys.localEmail.rawValue)
    }
    func getEmail() -> String {
        return string(forKey: UserDefaultsKeys.localEmail.rawValue)!
    }
    
    // Set and retrieve localID
    func setID(value: String){
        set(value, forKey: UserDefaultsKeys.localID.rawValue)
    }
    func getID() -> String{
        return string(forKey: UserDefaultsKeys.localID.rawValue)!
    }
    
    // Set and retrieve localName
    func setName(value: String){
        set(value, forKey: UserDefaultsKeys.localName.rawValue)
    }
    func getName() -> String {
        return string(forKey: UserDefaultsKeys.localName.rawValue)!
    }
    
    // Set and retrieve localGroups
    func setName(value: String){
        set(value, forKey: UserDefaultsKeys.localName.rawValue)
    }
    func getName() -> String {
        return string(forKey: UserDefaultsKeys.localName.rawValue)!
    }
}
