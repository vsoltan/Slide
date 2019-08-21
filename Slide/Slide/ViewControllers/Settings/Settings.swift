//
//  SettingsViewController.swift
//  Slide
//
//  Created by Sam Lee on 6/5/19.
//          and Jennifer Kim :D
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GoogleSignIn

class Settings: UIViewController {// UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - PROPERTIES

    let settingsMenu : UITableView = {
        let table = UITableView()
        return table
    }()
    
    // initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSettingsMenu()
        configureNavigationController()
        
        //settingsMenu.dataSource = self
        //settingsMenu.delegate = self
    }
    
    func configureSettingsMenu() {
        // setup the tableview
        view.backgroundColor = .white
        view.addSubview(settingsMenu)
    }
    
    func configureNavigationController() {
        navigationController?.navigationBar.barTintColor = UX.defaultColor
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = "Settings"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "streamline-icon-navigation-left-2@24x24").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBackButton))
    }
    
//    // cell activation handler
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        // if a row is clicked, unclick and give it a fade out animation
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        // log out
//        if (indexPath.section == 2 && indexPath.row == 3 ) {
//            let firebaseAuth = Auth.auth()
//
//            // check the provider
//            if let providerData = firebaseAuth.currentUser?.providerData {
//                for userInfo in providerData {
//                    switch userInfo.providerID {
//                        // the user logged in using Facebook
//                        case "facebook.com":
//                            let loginManager = LoginManager()
//                            loginManager.logOut()
//
//                        // the user logged in using Google
//                        case "google.com":
//                            GIDSignIn.sharedInstance()?.signOut()
//                        default:
//                            print("provider is \(userInfo.providerID)")
//                    }
//                }
//            }
//
//            // end the user session in firebase
//            do {
//                try firebaseAuth.signOut()
//                if (firebaseAuth.currentUser == nil) {
//                    print ("Successfully signed out!")
//                }
//                // checks if the user logged in using facebook
//                if AccessToken.current != nil {
//                    let loginManager = LoginManager()
//                    loginManager.logOut()
//                }
//                // removes user data from local storage
//                SlideUser.clearLocalData()
//
//            } catch let signOutError as NSError {
//                print ("Error signing out: %@", signOutError)
//            }
//        }
    
    // MARK: - HANDLERS
    
    @objc func handleBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
}
