//
//  MediaSelectionViewController.swift
//  Slide
//
//  Created by Valeriy Soltan on 6/24/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit
//import Firebase

class MediaSelectionViewController: UIViewController {
    
    var selectedMedia = EncodedMedia.Media.init(name: nil, phoneNumber: nil, email: nil)
    
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var nameButton: UIButton!
    
    lazy var allButtons : Array<UIButton> = [emailButton, nameButton]
    
    // radio button (is selected if not already)
    fileprivate func checkbox(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }
    
    @IBAction func emailCheckbox(_ sender: UIButton) {checkbox(emailButton)}
    @IBAction func nameCheckbox(_ sender: UIButton)  {checkbox(nameButton)}
    
    // stages the media properties to be added to the encoding structure
    @IBAction func selectionComplete(_ sender: Any) {
        // keeps track of the number of fields selected
        var numChecked = 0
        
        if (emailButton.isSelected) {
            numChecked += 1
            self.selectedMedia.email = User.getEmail()
        }
        
        if (nameButton.isSelected) {
            numChecked += 1
            if (nameButton.isSelected) {
                self.selectedMedia.name = UserDefaults.standard.getName()
            }
        }
        
        // no fields selected
        if (numChecked <= 0) {
            CustomError.createWith(errorTitle: "No Media Selected", errorMessage: "Please choose at least one option to share").show()
            return
        }
        
        // performs the segue once all the info was solicited
        self.performSegue(withIdentifier: "toQRCodeView", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // passes data accumuated in this view controller to the GenerationVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toQRCodeView") {
            let generationController = segue.destination as! GenerationViewController
            generationController.toBeShared = selectedMedia
        }
    }
}
