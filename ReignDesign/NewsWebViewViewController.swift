//
//  NewsWebViewViewController.swift
//  ReignDesign
//
//  Created by Delapille on 01/09/2017.
//  Copyright © 2017 Delapille. All rights reserved.
//

import Foundation
import UIKit

class NewsWebViewViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!
    var queryString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        webView.delegate = self
        guard let queryString = self.queryString else { return }
        
        if let url = URL(string: queryString) {
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        }
    }
}
