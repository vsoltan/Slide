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
    var viewToAnimate: UIViewController!
    var homeView: Home!
    var sideMenu: Menu!
    var isHidden = true
    
    // MARK: - INITIALIZATIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomeController()
    }
    
    // MARK: - CONFIGURATIONS
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    override var prefersStatusBarHidden: Bool {
        // disappears when menu is activated
        return !isHidden
    }
    
    func configureHomeController() {
        homeView = Home()
        homeView.delegate = self
        
        // embed the home view in a navigation controller
        viewToAnimate = UINavigationController(rootViewController: homeView)
        
        view.addSubview(viewToAnimate.view)
        addChild(viewToAnimate)
        viewToAnimate.didMove(toParent: self)
    }
    
    func configureMenuController() {
        // only creates the menu on startup
        if (sideMenu == nil) {
            sideMenu = Menu()
            sideMenu.delegate = self
            view.insertSubview(sideMenu.view, at: 0)
            addChild(sideMenu)
            sideMenu.didMove(toParent: self)
        }
    }
    
    func animateStatusBar() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
    
    func animateMenu(hidden: Bool, menuOption: MenuOption?) {
        if !(hidden) {
            // show menu
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.viewToAnimate.view.frame.origin.x = self.viewToAnimate.view.frame.width - 100
                self.homeView.welcomeLabel.frame.origin.y = 0
            }, completion: nil)
        } else {
            // hide menu
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.viewToAnimate.view.frame.origin.x = 0
                self.homeView.welcomeLabel.frame.origin.y = 100
            }) { (_) in
                // only navigates to other pages if option selected
                guard let menuOption = menuOption else { return }
                self.didSelectMenuOtion(withIdentifier: menuOption)
            }
        }
        
        animateStatusBar()
    }
    
    func didSelectMenuOtion(withIdentifier identifier: MenuOption) {
        switch identifier {
        case .Profile:
            print("go to profile")
        case .Accounts:
            let accounts = Account()
            self.present(UINavigationController(rootViewController: accounts), animated: true, completion: nil)
        case .Settings:
            let settings = Settings()
            self.present(UINavigationController(rootViewController: settings), animated: true, completion: nil)
        case .Logout:
            AppUser.logout()
            let login = Login()
            self.present(login, animated: true, completion: nil)
        }
    }
}

extension Container: HomeControllerDelegate {
    func handleMenuToggle(forMenuOption menuOption: MenuOption?) {
        if isHidden {
            configureMenuController()
        }
        isHidden.toggle()
        animateMenu(hidden: isHidden, menuOption: menuOption)
    }
}
