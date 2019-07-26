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
        
        let userid = "tyler.clift.140"
        let url = URL(string: "https://www.facebook.com/addfriend.php?id=\(userid)")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
