//
//  MenuOption.swift
//  Slide
//
//  Created by Valeriy Soltan on 8/19/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    
    // MARK: - PROPERTIES
    let iconImage : UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    
    let optionText : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "sample"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .darkGray
        
        addSubview(iconImage)
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        iconImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        iconImage.widthAnchor.constraint(equalToConstant: 24).isActive = true
        iconImage.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        addSubview(optionText)
        optionText.translatesAutoresizingMaskIntoConstraints = false
        optionText.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        optionText.leftAnchor.constraint(equalTo: iconImage.rightAnchor, constant: 12).isActive = true
    
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    } 
}
