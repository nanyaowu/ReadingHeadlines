//
//  WebViewController.swift
//  ReadingHeadlines
//
//  Created by freakytune on 2018/12/4.
//  Copyright © 2018 freakytune. All rights reserved.
//

import UIKit
import WebKit


class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    var rssLink: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("WebViewController loaded its view.")
        
        if let okLink = rssLink, let okURL = URL(string: okLink) {
            let request = URLRequest(url: okURL)
            webView.load(request)
        }
    }
}
