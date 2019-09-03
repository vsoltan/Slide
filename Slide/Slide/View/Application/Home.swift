//
//  ViewController.swift
//  Slide
//
//  Created by Sam Lee on 6/5/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit

class Home: BaseView {
    
    // MARK: - PROPERTIES
    
    // delegate is set to the container class
    var delegate: HomeControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationController()
        customizeHome()
    }
    
    // MARK: - CUSTOMIZATION

    let welcomeLabel: UILabel = {
        let dims = UIScreen.main.bounds.size
        let label  = UILabel(frame: CGRect(x: 20, y: 100, width: 200, height: 60))
        label.textAlignment = .left
        label.numberOfLines = 2
        label.textColor = .black
        label.text = "Welcome,\n"
        return label
    }()
    
    let createSlideButton: UIButton = {
        let dims = UIScreen.main.bounds.size
        let button = UIButton()
        
        // edit this to place it at the bottom of the screen
        button.frame = CGRect(x: dims.width / 2, y: dims.height * 7/8, width: 30, height: 30)
        button.setImage(#imageLiteral(resourceName: "streamline-icon-add-square@24x24"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(handleAddButton), for: .touchUpInside)
        return button
    }()
    
    lazy var swipeToScan: UISwipeGestureRecognizer = {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeToScan))
        swipe.direction = .left
        return swipe
    }()
    
    func customizeHome() {
        // welcome page displays the user's name
        if let name = welcomeLabel.text {
            welcomeLabel.text = name + UserDefaults.standard.getName()
        }
        view.backgroundColor = .white
        view.addSubview(welcomeLabel)
        
        // TODO remove when including constraints
        createSlideButton.center = self.view.center
        view.addSubview(createSlideButton)
        
        // navigate to the QR scanner view controller
        view.addGestureRecognizer(swipeToScan)
    }
    
    
    override func configureNavigationController() {
        navigationController?.navigationBar.barTintColor = UX.defaultColor
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)]
        navigationItem.title = "Slide"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white_3x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleSideMenuToggle))
    }

    // MARK: - HANDLERS
    
    @objc func handleSideMenuToggle() {
        delegate?.handleMenuToggle(forMenuOption: nil)
    }
    
    @objc func handleAddButton() {
        let createSlide = SelectMedia()
        self.present(UINavigationController(rootViewController: createSlide), animated: true, completion: nil)
    }
    
    @objc func handleSwipeToScan() {
        // TODO swipe animation 
        let scanner = QRScanner()
        scanner.modalTransitionStyle = .partialCurl
        self.present(UINavigationController(rootViewController: scanner), animated: true, completion: nil)
    }
}

