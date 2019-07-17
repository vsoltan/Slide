//
//  CurrentUser.swift
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
                    
                    if let phoneData = document.data() ["Phone"] as? String {
                        UserDefaults.standard.setPhoneNumber(value: phoneData)
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
    
    // clear UserDefaults
    static func clearLocalData() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    // delete user
    static func deleteUser(caller: UIViewController) {
        
        if let user = Auth.auth().currentUser {
            let id = user.uid
            // attempt to delete
            user.delete(completion: { (error) in
                // reauthenticate if user hasn't authenticated in a hot second
                if (error != nil) {
                    self.getProvider(clientVC: caller)
                }
                // clear user's database data
                self.deleteData(userID: id)
                
                // segue into LoginViewController
                let mySB = UIStoryboard(name: "LoginRegister", bundle: nil)
                let next = mySB.instantiateViewController(withIdentifier: "LoginViewController")
                caller.present(next, animated: true, completion: nil)
            })
        }
    }
    
    // TODO: replace error messages with CustomError
    // finds which authentication method was used
    static func getProvider(clientVC: UIViewController){
    
        if let providerData = Auth.auth().currentUser?.providerData {
            // reauthenticate for every auth. method linked to user account
            for userInfo in providerData {
                switch userInfo.providerID {
                case "facebook.com":
                    if let credential = facebookCredential(){
                        self.reauthenticate(credential: credential)
                    }
                case "google.com":
                    if let credential = googleCredential(){
                        self.reauthenticate(credential: credential)
                    }
                    print("user is signed in with google")
                case "password":
                    // prompt user to reenter login information
                    let alert = UIAlertController(title: "Sign In", message: "Please sign in again to confirm you want to delete all your account data", preferredStyle: .alert)
                    alert.addTextField { (textField: UITextField) in
                        textField.placeholder = "Email"
                    }
                    alert.addTextField { (textField: UITextField) in
                        textField.placeholder = "Password"
                        textField.isSecureTextEntry = true
                    }
                    // button for user to cancel
                    let noAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    
                    // button for user to confirm
                    let yesAction = UIAlertAction(title: "OK", style: .destructive, handler: { (action:UIAlertAction) in
                        let emailTextField = alert.textFields![0]
                        let passwordTextField = alert.textFields![1]
                        
                        //TODO: this is generic code. Match up with our login method
                        // check if user login makes sense
                        if let credential = self.emailCredential(email: emailTextField.text!, password: passwordTextField.text!){
                            self.reauthenticate(credential: credential)
                        } else {
                            print("error")
                        }
                    })
                    // create the buttons on the prompt
                    alert.addAction(yesAction)
                    alert.addAction(noAction)
                    
                    // create the prompt
                    clientVC.present(alert, animated: true, completion: nil)
                
                // couldn't find auth method
                default:
                    print("unknown auth provider")
                    
                }
            }
        }
    }
    
    // reauthenticate user using provided credential
    static func reauthenticate(credential: AuthCredential){
        
        Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (user, error) in
            if let error = error {
                print("reauth error \(error.localizedDescription)")
            } else {
                print("no reauth error")
                // reattempt deletion
                Auth.auth().currentUser?.delete { error in
                    if let error = error {
                        CustomError.createWith(errorTitle: "Reauthenticate User Error", errorMessage: error.localizedDescription).show()
                    } else {
                        print("Successfully reauthenticated user")
                    }
                }
            }
        })
    }
    
    // get facebook credential
    static func facebookCredential() -> AuthCredential? {
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        return credential
    }
    
    // get email-password credendial
    static func emailCredential(email:String,password:String) -> AuthCredential? {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        return credential
    }
    
    // get google credential
    static func googleCredential() -> AuthCredential? {
        guard let user = GIDSignIn.sharedInstance().currentUser else {return nil}
        guard let authentication = user.authentication else {return nil}
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        return credential
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
        User.clearLocalData()
    }
    
    // explicit return type because every user has to have an email
    static func getEmail() -> String {
        return (Auth.auth().currentUser?.email)!
    }
    
}

// contains "fields" for UserDefaults
enum UserDefaultsKeys : String {
    case localEmail
    case localID
    case localName
    case localPhone
    case localGroups
}

// functions to set and get data from UserDefaults
extension UserDefaults {
    
    // set and retrieve localEmail
    func setEmail(value: String) {
        set(value, forKey: UserDefaultsKeys.localEmail.rawValue)
    }
    func getEmail() -> String {
        return string(forKey: UserDefaultsKeys.localEmail.rawValue)!
    }
    
    // set and retrieve localID
    func setID(value: String){
        set(value, forKey: UserDefaultsKeys.localID.rawValue)
    }
    func getID() -> String{
        return string(forKey: UserDefaultsKeys.localID.rawValue)!
    }
    
    // set and retrieve localName
    func setGroup(value: String){
        set(value, forKey: UserDefaultsKeys.localName.rawValue)
    }
    func getGroup() -> String {
        return string(forKey: UserDefaultsKeys.localName.rawValue)!
    }
    
    // set and retrieve localGroups
    func setName(value: String){
        set(value, forKey: UserDefaultsKeys.localName.rawValue)
    }
    func getName() -> String {
        return string(forKey: UserDefaultsKeys.localName.rawValue)!
    }
    
    // set and retrieve localPhone
    func setPhoneNumber(value: String){
        set(value, forKey: UserDefaultsKeys.localPhone.rawValue)
    }
    func getPhoneNumber() -> String? {
        return string(forKey: UserDefaultsKeys.localPhone.rawValue)
    }
}
