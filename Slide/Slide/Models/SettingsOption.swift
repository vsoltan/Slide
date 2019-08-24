//
//  SettingsOption.swift
//  Slide
//
//  Created by Valeriy Soltan on 8/22/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

enum GeneralOption: Int, CaseIterable, CustomStringConvertible {
    
    case EditProfile
    case About
    
    var description : String {
        switch self {
        case .EditProfile:
            return "Edit Profile"
        case .About:
            return "About"
        }
    }
}

enum ManageOption: Int, CaseIterable, CustomStringConvertible {
    
    case DeleteAccount
    
    var description : String {
        switch self {
        case .DeleteAccount:
            return "Delete Account"
        }
    }
}

enum SettingSection: Int, CustomStringConvertible {
    
    case General
    case Manage
    
    var description : String {
        switch self {
        case .General:
            return "General"
        case .Manage:
            return "Manage"
        }
    }
}
