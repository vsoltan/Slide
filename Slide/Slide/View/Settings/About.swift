//
//  About.swift
//  Slide
//
//  Created by Valeriy Soltan on 8/24/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit

class About: BaseView {
    
    // MARK: - PROPERTIES
    
    let creators = "Valeriy Soltan, Sam Lee, Tyler Clift, Jennifer Kim"
    
    lazy var aboutLabel: UILabel = {
        let dims = UIScreen.main.bounds.size
        
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: dims.width * 5 / 6, height: dims.height)
        label.center = view.center
        
        // unlimited number of lines accommodates for different screen sizes
        label.numberOfLines = 0
        label.text = "Summer Project 2019\n Created By:\n \(creators)"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    // MARK: - INITIALIZATIONS
    
    override func viewDidLoad() {
        super.viewDidLoad(withTitle: "About")
        
        print(creators.description)
        configureAbout()
    }
    
    // MARK: - CONFIGURATIONS
    
    func configureAbout() {
        view.backgroundColor = .white
        view.addSubview(aboutLabel)
    }
}
