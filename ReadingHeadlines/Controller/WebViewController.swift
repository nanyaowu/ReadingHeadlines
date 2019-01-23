//
//  WebViewController.swift
//  ReadingHeadlines
//
//  Created by freakytune on 2018/12/4.
//  Copyright © 2018 freakytune. All rights reserved.
//

import UIKit
import WebKit


class WebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    var rssLink: String?
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        print("WebViewController loaded its view.")
        
        if let okLink = rssLink, let okURL = URL(string: okLink) {
            let request = URLRequest(url: okURL)
            webView.load(request)
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        spinner.startAnimating()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        spinner.stopAnimating()
    }
    
    // 分享按鈕
    
}
