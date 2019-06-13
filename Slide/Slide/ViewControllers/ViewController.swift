//
//  ViewController.swift
//  Slide
//
//  Created by mac on 6/5/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var linkField: UITextField!
    @IBOutlet weak var QRView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func generate(_ sender: Any) {
    let img = QR.generateQRCode(from: linkField.text!)
        QRView.image = img
    }
}

