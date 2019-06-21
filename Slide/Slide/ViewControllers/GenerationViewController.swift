//
//  GenerationViewController.swift
//  Slide
//
//  Created by Valeriy Soltan on 6/21/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit

class GenerationViewController: UIViewController {
    
    @IBOutlet weak var linkField: UITextField!
    @IBOutlet weak var QRView: UIImageView!
    
    @IBAction func generateQRCode(_ sender: Any) {
        let img = GenerateQR.generateQRCode(from: linkField.text!)
        QRView.image = img
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//    // creates a qr code based on the passed String to the linkField
//
//
//    }
    
}
