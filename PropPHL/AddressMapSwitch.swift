//
//  AddressMapSwitch.swift
//  PropPHL
//
//  Created by Kelly Innes on 9/17/15.
//  Copyright © 2015 Kelly Innes. All rights reserved.
//

// This is a custom wrapper for the DGRunKeeperSwitch custom UIControl.
// I added it so I can set up the switch appearance without modifying the original class file.

import UIKit

class AddressMapSwitch: DGRunkeeperSwitch {
    
    // MARK: - Initializer
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.leftTitle = "Map"
        self.rightTitle = "Address"
        self.backgroundColor = .oceanColor()
        self.selectedTitleColor = .oceanColor()
        self.selectedBackgroundColor = .silverColor()
    }
    
}