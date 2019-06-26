//
//  MediaContainer.swift
//  Slide
//
//  Created by Valeriy Soltan on 6/24/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import Foundation

// container class that stores the media to be turned into a QR code
class EncodedMedia{
    
    // of type codable to allow for easy de/serialization
    struct Media : Codable {
        var name, phoneNumber : String
    }
    
    static func structToJSON(preparedData: [String]?) -> String? {
        // make sure that data is being passed to the function
        if preparedData == nil {
            return nil
        }
        // convert the data to the json format
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: preparedData!, options: .prettyPrinted)
            return String(data: jsonData, encoding: String.Encoding.utf8)
        } catch let error {
            print("error converting to json: \(error)")
            return nil
        }
    }
    
    // decoder function to be used by the QR reader
    static func JSONtoStruct(source: String?) {
        print(source!)
        let src = Data(source!.utf8)
        do {
            let data = try JSONDecoder().decode([Media].self, from: src)
            print(data)
        } catch {
            print(error.localizedDescription)
        }
    }
}
    
    

