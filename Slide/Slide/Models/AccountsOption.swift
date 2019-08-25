//
//  AccountsOption.swift
//  Slide
//
//  Created by Valeriy Soltan on 8/24/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

enum AccountsOption: Int, CaseIterable {
    case PhoneNumber
    case Email
    
    var description: String {
        switch self {
        case .PhoneNumber:
            return "Phone Number"
        case .Email:
            return "Email"
        }
    }
}
