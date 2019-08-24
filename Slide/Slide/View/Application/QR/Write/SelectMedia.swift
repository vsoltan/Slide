//
//  MediaSelectionViewController.swift
//  Slide
//
//  Created by Valeriy Soltan on 6/24/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit

class SelectMedia: UIViewController {
    
    // MARK: - PROPERTIES
    
    // encoding structure
    var selectedMedia = EncodedMedia.Media.init()

    // stores the buttons and corresponding data
    var selections = [(button: UIButton, data: (key: Any, value: Any))]()
    
    // stores the user's information
    let supportedMedia = AppUser.generateKeyDictionary()
    
    // visual assets
    let unchecked = UIImage(named: "UnCheckbox")!
    let checked = UIImage(named: "Checkbox")!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSelectMediaController()
    }
    
    func configureSelectMediaController() {
        view.backgroundColor = .white
        configureNavigationController()
        generateMediaChoices()
        
    }
    
    func generateMediaChoices() {
        
        // generates choices for sharing based on what is synced to the account
        let navBarHeight = UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
        
        var verticalOffset: CGFloat = 20 + navBarHeight
        
        for media in supportedMedia {
            print(media.key as! String)
            
            // don't create a button if media is not synced
            if !(media.value is NSNull) {} else {
                
                let mediaType = media.key as! String
                
                // descriptions of media being selected
                let mediaButtonlabel = UILabel()
                mediaButtonlabel.text = mediaType
                mediaButtonlabel.frame = CGRect(x: 100, y: verticalOffset, width: 100.0, height: 30.0)
                
                let mediaButton = UIButton(frame: CGRect(x: 50, y: verticalOffset, width: 30, height: 30))
                
                // customization
                mediaButton.setImage(unchecked, for: UIControl.State.normal)
                mediaButton.setTitle(mediaType, for: UIControl.State.normal)
                mediaButton.isSelected = false
                
                // spacing between generated buttons
                verticalOffset = verticalOffset + 50
                
                // add action to button
                mediaButton.addTarget(self, action: #selector(mediaSelected), for: .touchUpInside)
                
                selections.append((mediaButton, media))
                
                // render
                self.view.addSubview(mediaButton)
                self.view.addSubview(mediaButtonlabel)
            }
        }
    }
    
    func configureNavigationController() {
        navigationController?.navigationBar.barTintColor = UX.defaultColor
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = "Choose Media"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "streamline-icon-navigation-left-2@24x24").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBackButton))
    }
    
    // radio button functionality
    @objc func mediaSelected(sender: UIButton!) {
        if sender.isSelected {
            sender.isSelected = false
            sender.setImage(unchecked, for: UIControl.State.normal)
        } else {
            sender.isSelected = true
            sender.setImage(checked, for: UIControl.State.normal)
        }
    }
    
    // stages the media properties to be added to the encoding structure
    @IBAction func selectionComplete(_ sender: Any) {
        // keeps track of the number of fields selected
        var numChecked = 0
        
        for selection in selections {
            if (selection.button.isSelected) {
                numChecked += 1
                
                let type = selection.data.key as! String
                let data = selection.data.value as! String
                
                switch(type) {
                
                case "name":
                    self.selectedMedia.name = data
                case "email":
                    self.selectedMedia.email = data
                case "mobile":
                    if (data != "none") {
                        self.selectedMedia.phoneNumber = data
                    }
                default:
                    continue
                }
            }
        }
        
        // no fields selected
        if (numChecked <= 0) {
            CustomError.createWith(errorTitle: "No Media Selected", errorMessage: "Please choose at least one option to share")
            return
        }
        
        // performs the segue once all the info was solicited
        self.performSegue(withIdentifier: "toQRCodeView", sender: self)
    }
    
    // passes data accumuated in this view controller to the GenerationVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toQRCodeView") {
            let generationController = segue.destination as! Generate
            generationController.toBeShared = selectedMedia
        }
    }
    
    // MARK: - HANDLERS
    @objc func handleBackButton() {
        dismiss(animated: true, completion: nil)
    }
}
