//
//  UXView.swift
//  Slide
//
//  Created by Valeriy Soltan on 8/24/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit

class UXView: UIViewController {
    
    var viewTitle: String?
    
    func viewDidLoad(withTitle title: String) {
        super.viewDidLoad()
        
        viewTitle = title
        configureNavigationController()
    }
    
    func configureNavigationController() {
        navigationController?.navigationBar.barTintColor = UX.defaultColor
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = viewTitle
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "streamline-icon-navigation-left-2@24x24").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBackButton))
    }
    
    // MARK: - HANDLERS
    
    @objc func handleBackButton() {
        dismiss(animated: true, completion: nil)
    }
}
