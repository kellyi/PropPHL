//
//  Block.swift
//  PropPHL
//
//  Created by Kelly Innes on 9/14/15.
//  Copyright © 2015 Kelly Innes. All rights reserved.
//

import Foundation

class Block {
    
    var timeWhenAdded: NSDate
    var streetAddress: String
    var properties: [Property]
    //var pin: Pin
    
    var count: Int {
        return self.properties.count
    }
    
    init(blockDictionary: [String:AnyObject]) {
        self.timeWhenAdded = blockDictionary["timeWhenAdded"] as! NSDate
        self.streetAddress = blockDictionary["streetAddress"] as! String
        self.properties = blockDictionary["properties"] as! [Property]
        //self.pin = blockDictionary["pin"] as! Pin
    }
    
}