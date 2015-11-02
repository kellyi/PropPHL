//
//  InfoViewController.swift
//  PropPHL
//
//  Created by Kelly Innes on 9/21/15.
//  Copyright © 2015 Kelly Innes. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController, UIWebViewDelegate {
    
    // MARK: - Variables
    
    @IBOutlet weak var webView: UIWebView!
    
    // MARK: - View Setup
    
    override func viewDidLoad() {
        webView.delegate = self
        let htmlFile = NSBundle.mainBundle().pathForResource("about", ofType: "html")
        do {
            let htmlString = try NSString(contentsOfFile: htmlFile!, encoding: NSUTF8StringEncoding) as String
            webView.loadHTMLString(htmlString, baseURL: nil)
        } catch {
            let alert = UIAlertController(title: "An error occurred.", message: nil, preferredStyle: .Alert)
            presentViewController(alert, animated: true, completion: nil)
        }
        
        /*
        let url = NSURL(string: "https://github.com/kellyi/PropPHL/blob/master/README.md")
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
        */
    }
    
    // MARK: - IBActions
    
    @IBAction func dismissButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let url = request.URL where navigationType == UIWebViewNavigationType.LinkClicked {
            UIApplication.sharedApplication().openURL(url)
            return false
        }
        return true
    }

}
