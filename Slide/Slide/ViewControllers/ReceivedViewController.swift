//
//  ReceivedViewController.swift
//  Slide
//
//  Created by Valeriy Soltan on 6/27/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit

class ReceivedViewController: UIViewController {
    
    var receivedInfo : EncodedMedia.Media?

    @IBOutlet weak var receivedInfoLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        receivedInfoLabel.text = receivedInfo?.email!
        nameLabel.text = receivedInfo?.name!
    }
}
