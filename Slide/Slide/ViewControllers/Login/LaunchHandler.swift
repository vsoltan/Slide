//
//  LaunchViewController.swift
//  Slide
//
//  Created by Valeriy Soltan on 8/11/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit
import FirebaseAuth

class LaunchHandler: UIViewController {
    
    // MARK: -CUSTOMIZATION DETAILS
    
    let titleLabel : UILabel = {
        let dims = UIScreen.main.bounds.size
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        label.center = CGPoint(x: dims.width / 2, y: dims.height / 2)
        // infinte num of lines
        label.numberOfLines = 2
        label.text = "Slide \na better way to connect"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    
    // MARK: -CONFIGURATION
    
    // default navigation
    var postLaunchScreen = UIStoryboard(name: "LoginRegister", bundle: nil).instantiateInitialViewController()
    
    func configureLaunch() {
        self.view.backgroundColor = .blue
        self.view.addSubview(titleLabel)
        
        let getData = DispatchGroup()
        if let currentID = Auth.auth().currentUser?.uid {
            getData.enter()
            SlideUser.getUser(userID: currentID) { (error) in
                if (error == nil) {
                    print("oi")
                    self.postLaunchScreen = Home()
                    getData.leave()
                } else {
                    CustomError.createWith(errorTitle: "Oops! Something went wrong!", errorMessage: "please try logging in again")
                }
            }
        }
        getData.notify(queue: .main) {
            self.present(self.postLaunchScreen!, animated: true, completion: {
                print("done!")
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLaunch()
    }
}
