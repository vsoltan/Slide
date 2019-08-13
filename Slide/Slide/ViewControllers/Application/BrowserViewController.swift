//
//  BrowserViewController.swift
//  Slide
//
//  Created by Tyler Clift on 7/26/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit
import WebKit

class BrowserViewController: UIViewController, WKNavigationDelegate {
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
            let url = URL(string: "https://www.facebook.com/addfriend.php?id=\(userid)")!
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
        } else {
            print("no facebook information available")
        }
    }
}
