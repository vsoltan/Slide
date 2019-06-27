//
//  MediaSelectionViewController.swift
//  Slide
//
//  Created by Valeriy Soltan on 6/24/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit

class MediaSelectionViewController: UIViewController {
    
    var selectedMedia = EncodedMedia.Media.init(name: nil, phoneNumber: nil, email: nil)
    
    @IBOutlet weak var emailButton: UIButton!
    
    @IBAction func emailCheckbox(_ sender: UIButton) {
        // radio button (is selected if not already)
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }
    
    // stages the media properties to be added to the encoding structure
    @IBAction func selectionComplete(_ sender: Any) {
        if (emailButton.isSelected) {
            self.selectedMedia.email = CurrentUser.getEmail()
        }
        performSegue(withIdentifier: "toQRCodeView", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // passes data generated in this view controller to the GenerationVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toQRCodeView") {
            let generationController = segue.destination as! GenerationViewController
            generationController.toBeShared = selectedMedia
        }
    }
}
