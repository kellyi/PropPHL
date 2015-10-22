//
//  AboutViewController.swift
//  PropPHL
//
//  Created by Kelly Innes on 10/21/15.
//  Copyright © 2015 Kelly Innes. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var aboutVCTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        aboutVCTextView.text = "PropPHL is an iOS client for a City of Philadelphia Office of Property Assessment API.\n\nAPI License and Terms:\nI am not affiliated with the Office of Property Assessment or the City of Philadelphia. The API is used under the license available at http://phlapi.com\n\nPer the API license:\n\"This product uses a City of Philadelphia Data API but is not endorsed or certified by the City of Philadelphia.\""
        aboutVCTextView.font = UIFont.systemFontOfSize(20.0)
    }

    @IBAction func dismissAboutView(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
