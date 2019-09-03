//
//  MediaSelectionViewController.swift
//  Slide
//
//  Created by Valeriy Soltan on 6/24/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit

class SelectMedia: BaseView {
    
    // MARK: - PROPERTIES
    
    lazy var createButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        button.backgroundColor = UX.defaultColor
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Create", for: .normal)
        return button
    }()
    
    // encoding structure
    var selectedMedia = EncodedMedia.Media.init()

    // stores the buttons and corresponding data
    var selections = [(button: UIButton, data: (key: Any, value: Any))]()
    
    // stores the user's information
    let supportedMedia = AppUser.generateKeyDictionary()
    
    // visual assets
    let unchecked = UIImage(named: "UnCheckbox")!
    let checked = UIImage(named: "Checkbox")!
    
    // MARK: - INITIALIZATIONS
    
    override func viewDidLoad() {
        print("\(isViewLoaded)")
        super.viewDidLoad(withTitle: "Select Media")
        configureSelectMediaController()
        generateMediaChoices()
    }
    
    // MARK: - CONFIGURATIONS
    
    func configureSelectMediaController() {
        view.backgroundColor = .white
        
        view.addSubview(createButton)
        createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        createButton.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -80).isActive = true
        
        createButton.addTarget(self, action: #selector(handleCreateButton), for: .touchUpInside)
    }
    
    func generateMediaChoices() {
        
        // generates choices for sharing based on what is synced to the account
        let navBarHeight = UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
        
        var verticalOffset: CGFloat = 20 + navBarHeight
        
        for media in supportedMedia {
            print(media.key as! String)
            
            // don't create a button if media is not synced
            if (media.value is NSNull) {} else {
                
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
            
                verticalOffset = verticalOffset + 50
                
                mediaButton.addTarget(self, action: #selector(mediaSelected), for: .touchUpInside)
                
                selections.append((mediaButton, media))
                
                self.view.addSubview(mediaButton)
                self.view.addSubview(mediaButtonlabel)
            }
        }
    }
    
    // radio button functionality
    @objc func mediaSelected(sender: UIButton!) {
        sender.isSelected.toggle()
        sender.setImage(sender.isSelected  // isSelect refers to new state now
                            ? checked
                            : unchecked,
                        for: UIControl.State.normal)
    }
    
    // passes data accumuated in this view controller to the GenerationVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toQRCodeView") {
            let generationController = segue.destination as! Generate
            generationController.toBeShared = selectedMedia
        }
    }
    
    // MARK: - HANDLERS
    
    @objc func handleCreateButton() {
        
        // keeps track of the number of fields selected
        var numChecked = 0
        
        for selection in selections {
            if (selection.button.isSelected) {
                numChecked += 1
                
                let type = selection.data.key as! String
                let data = selection.data.value as! String
                
                switch type {
                case "name":
                    self.selectedMedia.name = data
                case "email":
                    self.selectedMedia.email = data
                case "mobile":
                    // TODO Check if this is still how i am doing it "none" vs NSNUll
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
        let generate = Generate()
        generate.toBeShared = selectedMedia
//        self.navigationController?.addChild(generate)
        self.present(UINavigationController(rootViewController: generate), animated: true, completion: nil)
    }
}
