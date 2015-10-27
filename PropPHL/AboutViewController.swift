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
        let lineOne = "PropPHL is an iOS client for a City of Philadelphia Office of Property Assessment API."
        let lineTwo = "API License and Terms:\n\nI am not affiliated with the Office of Property Assessment or the City of Philadelphia. The API is used under the license available at http://phlapi.com"         //let phlOPAurl = makeHyperLinkFromString("http://phlapi.com", url: "http://phlapi.com")
        let lineThree = "Per the API license:\n\n\"This product uses a City of Philadelphia Data API but is not endorsed or certified by the City of Philadelphia.\""
        let lineFour = "PropPHL uses two MIT license open-source controls:\n\nDGRunKeeperSwitch (https://github.com/gontovnik/DGRunkeeperSwitch) & DOAlertController (https://github.com/okmr-d/DOAlertController)"
        let lines = [lineOne,lineTwo,lineThree,lineFour]
        aboutVCTextView.text = lines.reduce("") { $0 + "\n\n" + $1 }
        aboutVCTextView.font = UIFont.systemFontOfSize(18.0)
    }

    @IBAction func dismissAboutView(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func makeHyperLinkFromString(string: String, url: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        let range = NSMakeRange(0, attributedString.length)
        attributedString.addAttribute(NSLinkAttributeName, value: url, range: range)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.oceanColor(), range: range)
        return attributedString
    }

}
