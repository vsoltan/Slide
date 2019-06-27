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
        QRView.image = img
    }
    
}
