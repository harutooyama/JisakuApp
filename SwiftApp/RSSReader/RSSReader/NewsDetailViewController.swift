//
//  NewsDetailViewController.swift
//  RSSReader
//
//  Created by Owner on 2020/06/09.
//  Copyright © 2020 asOne. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var detailWebView: UIWebView!
    
    var urlToRSSReaderView = NSURL()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailWebView.delegate = self
        makeRequest()
    }
    
    func makeRequest() {
        let urlReq = NSURLRequest(url: urlToRSSReaderView as URL)
        detailWebView.loadRequest(urlReq as URLRequest)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        print("Webロードが正常に行われました")
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        print("Web Viewロード中にエラーが生じました")
    }

}
