//
//  SlideUser.swift
//  Slide
//
//  Created by Valeriy Soltan on 6/12/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import Foundation
import Firebase
import FBSDKCoreKit
import GoogleSignIn

// an interface between the database and the user
class SlideUser {
    
/* METHODS that directy interact with backend and local storage */
 
    // retrieves the data tree belonging to the current user
    private static func getDocument(currentUserID: String, completionHandler: @escaping ([QueryDocumentSnapshot]?, Error?) -> Void) {
        
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
    
    // downloads user data to local storage
    static func getUser(userID: String, completionHandler: @escaping (Error?) -> Void) {
        // thread deployed to interact with database
        getDocument(currentUserID: userID) { (userData, error) in
            if (error == nil && userData != nil) {
                // iterates through the array, as there may be several docs
                for document in userData! {
                    // retrieves user data from Firebase into UserDefaults
                    UserDefaults.standard.getAll(source: document)
                }
                // no error
                completionHandler(nil)
            } else {
                print("\(error!)")
                // Notify that there was indeed an error
                completionHandler(error)
            }
        }
    }
    
    // wipe defaults
    static func clearLocalData() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    // retrieve key value pairs in defaults for processing
    static func generateKeyDictionary() -> NSDictionary {
        let defaults = UserDefaults.standard
        
        let dictionary : NSDictionary = [
            "name"   : defaults.getName(),
            "email"  : defaults.getEmail(),
            "mobile" : defaults.getPhoneNumber() ?? NSNull(),
        ]
        return dictionary
    }
    
/* METHODS implementing account deletion functionality */
    
    static func deleteUser(caller: UIViewController) {
        
        // reauthenticate for auth method linked to user account
        if let user = Auth.auth().currentUser {
            
            switch user.providerID {
                
            case "facebook.com":
                if let credential = facebookCredential(){
                    self.reauthenticateAndDelete(credential: credential, currUser: user, caller: caller)
                }
                
            case "google.com":
                if let credential = googleCredential(){
                    self.reauthenticateAndDelete(credential: credential, currUser: user, caller: caller)
                }
                
            case "Firebase":
                reauthenticateAlert(usr: user, caller: caller)
                
            // couldn't find auth method
            default:
                print(user.providerID)
                print("unknown auth provider")
            }
        }
    }
    
    // reauthenticate user using provided credential
    static func reauthenticateAndDelete(credential: AuthCredential, currUser: User, caller: UIViewController){
        
        Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (user, error) in
            if let error = error {
                print("reauth error \(error.localizedDescription)")
            } else {
                print("no reauth error")
                // attempt to delete
                currUser.delete(completion: { (error) in
                    if (error == nil) {
                        // clear user's database data
                        self.deleteData(userID: currUser.uid)
                        
                        // segue into LoginViewController
                        let mySB = UIStoryboard(name: "LoginRegister", bundle: nil)
                        let next = mySB.instantiateViewController(withIdentifier: "LoginViewController")
                        caller.present(next, animated: true, completion: nil)
                        print("completed")
                    }
                })
            }
        })
    }
    
    // prompts the user to reenter login information before account deletion
    static func reauthenticateAlert(usr: User, caller: UIViewController) {

        let alert = UIAlertController(title: "Sign In", message: "Sign in to confirm deletion of all account data", preferredStyle: .alert)
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Email"}
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let confirm = UIAlertAction(title: "OK", style: .destructive, handler: { (action: UIAlertAction) in
            let email = alert.textFields![0]
            let password = alert.textFields![1]
            
            let signInInfo: Array<(field: UITextField, type: String)>
                = [(email, "username"), (password, "password")]
            
            if (TextFieldParser.validate(textFields: signInInfo)) {
                if let credential = self.emailCredential(email: email.text!, password: password.text!) {
                    self.reauthenticateAndDelete(credential: credential, currUser: usr, caller: caller)
                } else {
                    print("error")
                }
            }
        })
        
        // create the buttons on the prompt
        alert.addAction(confirm)
        alert.addAction(cancel)
        
        // create the prompt
        caller.present(alert, animated: true, completion: nil)
    }
    
    // deletes all other data in user's documents and local storage
    static func deleteData(userID : String){
        
        let db = Firestore.firestore()
        
        db.collection("users").document(userID).delete() { error in
            if let error = error {
                CustomError.createWith(errorTitle: "Document Removal Error", errorMessage: error.localizedDescription).show()
            } else {
                print("Document successfully removed")
            }
        }
        SlideUser.clearLocalData()
    }
    
    
/* API METHODS */
    
    // get facebook credential
    static func facebookCredential() -> AuthCredential? {
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        return credential
    }
    
    // get email-password credendtial
    static func emailCredential(email:String,password:String) -> AuthCredential? {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        return credential
    }
    
    // get google credential
    static func googleCredential() -> AuthCredential? {
        guard let user = GIDSignIn.sharedInstance().currentUser else { return nil }
        guard let authentication = user.authentication else { return nil }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        return credential
    }
}

/* USER DEFAULTS */

// implemented properties for UserDefaults
enum UserDefaultsKeys : String {
    case localEmail
    case localID
    case localName
    case localPhone
    case localGroups
}

// TODO implement settings so phone number switch can be saved

// setter and getter functions for local data
extension UserDefaults {
    
    func setEmail(value: String) {
        set(value, forKey: UserDefaultsKeys.localEmail.rawValue)
    }
    func getEmail() -> String {
        return string(forKey: UserDefaultsKeys.localEmail.rawValue)!
    }
    
    func setID(value: String){
        set(value, forKey: UserDefaultsKeys.localID.rawValue)
    }
    func getID() -> String{
        return string(forKey: UserDefaultsKeys.localID.rawValue)!
    }
    
    func setGroup(value: String){
        set(value, forKey: UserDefaultsKeys.localName.rawValue)
    }
    
    func getGroup() -> String {
        return string(forKey: UserDefaultsKeys.localName.rawValue)!
    }
    
    func setName(value: String){
        set(value, forKey: UserDefaultsKeys.localName.rawValue)
    }
    func getName() -> String {
        return string(forKey: UserDefaultsKeys.localName.rawValue)!
    }
    
    func setPhoneNumber(value: String?){
        set(value, forKey: UserDefaultsKeys.localPhone.rawValue)
    }
    func getPhoneNumber() -> String? {
        return string(forKey: UserDefaultsKeys.localPhone.rawValue)
    }
    
    func getAll(source: QueryDocumentSnapshot) {
        
        if let nameData = source.data()["Name"] as? String {
            UserDefaults.standard.setName(value: nameData)
        }
        
        if let emailData = source.data()["Email"] as? String {
            UserDefaults.standard.setEmail(value: emailData)
        }
        
        if let idData = source.data() ["ID"] as? String {
            UserDefaults.standard.setID(value: idData)
        }
        
        if let phoneData = source.data() ["Phone"] as? String {
            UserDefaults.standard.setPhoneNumber(value: phoneData)
        }
    }
}
