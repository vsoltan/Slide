//
//  QR.swift
//  Slide
//
//  Created by Valeriy Soltan on 6/13/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit
import Foundation

class QR {
    static func generateQRCode(from string : String) -> UIImage? {
        // retrieves data from string and encodes it into ascii
        let data = string.data(using: String.Encoding.ascii)
        
        // create a QR code filter using Core Image library
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            // pass text data to filter for processing
            filter.setValue(data, forKey: "inputMessage")
            // scaling transformation to fit any screen
            let transform = CGAffineTransform(scaleX: 4, y: 4)
            // image is rendered after transformation is applied
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        // if any of the steps fail, nothing is returned
        return nil
    }
}
