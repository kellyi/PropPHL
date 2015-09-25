//
//  InfoViewController.swift
//  PropPHL
//
//  Created by Kelly Innes on 9/21/15.
//  Copyright © 2015 Kelly Innes. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        let url = NSURL(string: "https://github.com/kellyi/PropPHL/blob/master/README.md")
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
    }
    
    @IBAction func dismissButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
