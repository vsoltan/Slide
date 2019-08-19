//
//  Container.swift
//  Slide
//
//  Created by Valeriy Soltan on 8/19/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit

class Container: UIViewController {
    
    // MARK: - PROPERTIES
    var viewToAnimate : UIViewController!
    var sideMenu : UIViewController!
//    var menuHidden = true
    var shouldExpand = false
    
    // MARK: - INITIALIZATIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomeController()
    }
    
    // MARK: - HANDLERS
    
    // MARK: - CONFIGURATIONS
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func configureHomeController() {
        let home = Home()
        home.delegate = self
        
        // embed the home view in a navigation controller
        viewToAnimate = UINavigationController(rootViewController: home)
        
        view.addSubview(viewToAnimate.view)
        addChild(viewToAnimate)
        viewToAnimate.didMove(toParent: self)
    }
    
    func configureMenuController() {
        // only creates the menu on startup
        if sideMenu == nil {
            sideMenu = Menu()
            view.insertSubview(sideMenu.view, at: 0)
            addChild(sideMenu)
            sideMenu.didMove(toParent: self)
        }
    }
    
    func showMenu(hidden: Bool) {
        if (hidden) {
            // show menu
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.viewToAnimate.view.frame.origin.x = self.viewToAnimate.view.frame.width - 80
            }, completion: nil)
        } else {
            // hide menu
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.viewToAnimate.view.frame.origin.x = 0
            }, completion: nil)
        }
    }
}

extension Container : HomeControllerDelegate {
    func handleMenuToggle() {
        if !shouldExpand {
            configureMenuController()
        }
        
        shouldExpand.toggle()
        showMenu(hidden: shouldExpand)
    }
}
