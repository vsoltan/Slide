//
//  GenerationViewController.swift
//  Slide
//
//  Created by Valeriy Soltan on 6/21/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit

class GenerationViewController: UIViewController {
    
    @IBOutlet weak var QRView: UIImageView!
    
    // structure passed from the media selection VC
    var toBeShared : EncodedMedia.Media?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // applies a QR code filter on the text passed through the field
        let img = GenerateQR.generateQRCode(from: EncodedMedia.structToJSON(preparedData: toBeShared))
        
        //        // below is the format for implementing "vcard", the standard for sharing entire contacts
        //        let img = GenerateQR.generateQRCode(from: "BEGIN:VCARD \n" +
        //            "VERSION:4.0 \n" +
        //            "FN:Juanes \n" +
        //            "TEL;CELL:+1 234 567 8901 \n" +
        //            "EMAIL:\(CurrentUser.getEmail()) \n" +
        //            "URL:www.facebook.com \n" +
        //            "ADR;WORK:;;Placeholder Address St;Charlottesville;VA;22905;USA \n" +
        //            "END:VCARD")
        
        QRView.image = img
    }
    
}
