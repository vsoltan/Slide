//
//  MenuOption.swift
//  Slide
//
//  Created by Valeriy Soltan on 8/19/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit

enum MenuOption: Int, CustomStringConvertible {
    case Profile
    case Accounts
    case Settings
    case Logout
    
    var description: String {
        switch self {
            case .Profile:
                return "Profile"
            case .Accounts:
                return "Accounts"
            case .Settings:
                return "Settings"
            case .Logout:
                return "Logout"
        }
    }
    
    var image: UIImage {
        switch self {
        case .Profile:
            return #imageLiteral(resourceName: "streamline-icon-single-neutral-profile-picture@24x24")
        case .Accounts:
            return #imageLiteral(resourceName: "streamline-icon-common-file-bookmark@24x24")
        case .Settings:
            return #imageLiteral(resourceName: "streamline-icon-tools-box@24x24")
        case .Logout:
            return #imageLiteral(resourceName: "streamline-icon-login-2@24x24")
        }
    }
}
