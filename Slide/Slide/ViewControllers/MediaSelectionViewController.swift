//
//  MediaSelectionViewController.swift
//  Slide
//
//  Created by Valeriy Soltan on 6/24/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit

class MediaSelectionViewController: UIViewController {

    @IBAction func emailCheckbox(_ sender: UIButton) {
        // animates the checkbox button
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }
    
    // retrieves the information from the field and appends it to the structure
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let generationController = segue.destination as! GenerationViewController
        generationController.toBeShared = CurrentUser.getEmail()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
