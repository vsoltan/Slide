//
//  MediaSelectionViewController.swift
//  Slide
//
//  Created by Valeriy Soltan on 6/24/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit

class MediaSelectionViewController: UIViewController {
    
    var selectedMedia = EncodedMedia.Media.init(name: "name", phone: "5089047060", email: "v@gmail.com")

    @IBAction func emailCheckbox(_ sender: UIButton) {
        // animates the checkbox button and stages the email to be encoded
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }
    
    // retrieves the information from the field and appends it to the structure
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let generationController = segue.destination as! GenerationViewController
        generationController.toBeShared = selectedMedia
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
