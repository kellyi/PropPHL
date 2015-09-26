//
//  FindBlockButton.swift
//  PropPHL
//
//  Created by Kelly Innes on 9/16/15.
//  Copyright © 2015 Kelly Innes. All rights reserved.
//

import UIKit

class FindBlockButton: UIButton {
    
    // MARK: - Initializer
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.layer.cornerRadius = 20.0
        self.backgroundColor = .oceanColor()
        self.setTitleColor(.oceanColor(), forState: UIControlState.Disabled)
        self.setTitleColor(.whiteColor(), forState: UIControlState.Normal)
    }
    
}
