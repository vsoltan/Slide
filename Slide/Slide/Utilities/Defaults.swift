//
//  Defaults.swift
//  Slide
//
//  Created by Valeriy Soltan on 8/13/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import Foundation
import Firebase

// setter and getter functions for local data
extension UserDefaults {
    
    func setEmail(value: String) {
        set(value, forKey: UserDefaultsKeys.email.rawValue)
    }
    func getEmail() -> String {
        return string(forKey: UserDefaultsKeys.email.rawValue)!
    }
    
    func setID(value: String){
        set(value, forKey: UserDefaultsKeys.id.rawValue)
    }
    func getID() -> String {
        return string(forKey: UserDefaultsKeys.id.rawValue)!
    }
    
    func setGroup(value: String){
        set(value, forKey: UserDefaultsKeys.name.rawValue)
    }
    
    func getGroup() -> String {
        return string(forKey: UserDefaultsKeys.name.rawValue)!
    }
    
    func setName(value: String){
        set(value, forKey: UserDefaultsKeys.name.rawValue)
    }
    func getName() -> String {
        return string(forKey: UserDefaultsKeys.name.rawValue)!
    }
    
    func setPhoneNumber(value: String?){
        set(value, forKey: UserDefaultsKeys.phone.rawValue)
    }
    func getPhoneNumber() -> String? {
        return string(forKey: UserDefaultsKeys.phone.rawValue)
    }
    
    // TOOD store in a URL
    func setFacebookID(value: String) {
        set(value, forKey: UserDefaultsKeys.fbid.rawValue)
    }
    
    func getFacebookID() -> String? {
        return string(forKey: UserDefaultsKeys.fbid.rawValue)
    }
    
    func setAllDefaults(source: QueryDocumentSnapshot) {
        
        let defaults = UserDefaults.standard
        
        if let nameData = source.data()["Name"] as? String {
            defaults.setName(value: nameData)
        }
        
        if let emailData = source.data()["Email"] as? String {
            defaults.setEmail(value: emailData)
        }
        
        if let idData = source.data() ["ID"] as? String {
            defaults.setID(value: idData)
        }
        
        if let phoneData = source.data() ["Phone"] as? String {
            defaults.setPhoneNumber(value: phoneData)
        }
        
        if let fbdata = source.data()["Facebook"] as? String {
            defaults.setFacebookID(value: fbdata)
        }
    }
}
