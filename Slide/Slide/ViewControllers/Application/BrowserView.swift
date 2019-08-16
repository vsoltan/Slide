//
//  BrowserViewController.swift
//  Slide
//
//  Created by Tyler Clift on 7/26/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit
import WebKit

class BrowserView: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO get the right id? 
        if let userid = UserDefaults.standard.getFacebookID() {
            let url = URL(string: "https://graph.facebook.com/\(userid)")!
//            let url = URL(string: "https://www.facebook.com/addfriend.php?id=\(userid)")!
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
        } else {
            print("no facebook information available")
            // TODO: this case should be handled before BrowserVC is called
            CustomError.createWith(errorTitle: "Error", errorMessage: "Facebook not setup for this account")
            self.performSegue(withIdentifier: "ReturnToContacts", sender: self)
        }
    }
}
