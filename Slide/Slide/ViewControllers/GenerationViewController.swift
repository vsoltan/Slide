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
    
    // applies a QR code filter on the text passed through the field
    @IBAction func generateQRCode(_ sender: Any) {
        let img = GenerateQR.generateQRCode(from: linkField.text!)
        QRView.image = img
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
