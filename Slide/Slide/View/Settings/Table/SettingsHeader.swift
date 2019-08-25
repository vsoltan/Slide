//
//  SettingsHeader.swift
//  Slide
//
//  Created by Valeriy Soltan on 8/22/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit

class SettingsHeader: UIView {
    
    // MARK: - PROPERTIES
    
    let user = AppUser()
    
    let profilePicture: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "val2")
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = user.getName()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = user.getEmail()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - INITIALIZATIONS
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let profileImageDimension: CGFloat = 60
        
        addSubview(profilePicture)
        profilePicture.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profilePicture.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        profilePicture.widthAnchor.constraint(equalToConstant: profileImageDimension).isActive = true
        profilePicture.heightAnchor.constraint(equalToConstant: profileImageDimension).isActive = true
        profilePicture.layer.cornerRadius = profileImageDimension / 2
        
        addSubview(nameLabel)
        nameLabel.centerYAnchor.constraint(equalTo: profilePicture.centerYAnchor, constant: -10).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: profilePicture.rightAnchor, constant: 12).isActive = true
        
        addSubview(emailLabel)
        emailLabel.centerYAnchor.constraint(equalTo: profilePicture.centerYAnchor, constant: 10).isActive = true
        emailLabel.leftAnchor.constraint(equalTo: profilePicture.rightAnchor, constant: 12).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
