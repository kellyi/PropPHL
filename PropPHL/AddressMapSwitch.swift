//
//  AddressMapSwitch.swift
//  PropPHL
//
//  Created by Kelly Innes on 9/17/15.
//  Copyright © 2015 Kelly Innes. All rights reserved.
//

import UIKit

class AddressMapSwitch: DGRunkeeperSwitch {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        self.leftTitle = "Map"
        self.rightTitle = "Address"
        self.backgroundColor = .oceanColor()
        self.selectedTitleColor = .oceanColor()
        self.selectedBackgroundColor = .silverColor()
    }
    
}