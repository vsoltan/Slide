//
//  GenerationViewController.swift
//  Slide
//
//  Created by Valeriy Soltan on 6/21/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit

class Generate: UXView {
    
    // MARK: - PROPERTIES
    
    // structure passed from the media selection VC
    var toBeShared : EncodedMedia.Media?
    
    lazy var QRView: UIImageView = {
        let dims = UIScreen.main.bounds.size
        let view = UIImageView()
        view.frame = CGRect(x: 0, y: 0, width: dims.width * 3 / 4, height: dims.width * 3 / 4)
        return view
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        button.setTitle("Done", for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = UX.defaultColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad(withTitle: "Share")
        configureGenerationController()
    }
    
    func configureGenerationController() {
        
        view.backgroundColor = .white
        
        view.addSubview(QRView)
        QRView.center = view.center
    
        // applies a QR code filter on the text passed through the field
        let img = GenerateQR.generateQRCode(from: EncodedMedia.structToJSON(preparedData: toBeShared))
        QRView.image = img
        
        view.addSubview(doneButton)
        doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        doneButton.centerYAnchor.constraint(equalTo: QRView.bottomAnchor, constant: 60).isActive = true
        
        doneButton.addTarget(self, action: #selector(handleDoneButton), for: .touchUpInside)
    }
    
    // MARK: - HANDLERS
    @objc func handleDoneButton() {
        
        // return to container
        let container = Container()
        present(container, animated: true, completion: nil)
    }
}
