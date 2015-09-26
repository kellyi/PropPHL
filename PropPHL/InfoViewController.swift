//
//  InfoViewController.swift
//  PropPHL
//
//  Created by Kelly Innes on 9/21/15.
//  Copyright © 2015 Kelly Innes. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    // MARK: - Variables
    
    @IBOutlet weak var webView: UIWebView!
    
    // MARK: - View Setup
    
    override func viewDidLoad() {
        let url = NSURL(string: "https://github.com/kellyi/PropPHL/blob/master/README.md")
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
    }
    
    // MARK: - IBActions
    
    @IBAction func dismissButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
