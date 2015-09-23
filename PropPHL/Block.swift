//
//  Block.swift
//  PropPHL
//
//  Created by Kelly Innes on 9/14/15.
//  Copyright © 2015 Kelly Innes. All rights reserved.
//

import Foundation
import CoreData

@objc(Block)
class Block: NSManagedObject {
    
    @NSManaged var timeWhenAdded: NSDate
    @NSManaged var streetAddress: String
    @NSManaged var properties: [Property]
    @NSManaged var pin: Pin
    
    var count: Int {
        return self.properties.count
    }
    
    var medianAsssessmentValue: Int {
        var arrayForMedian = [Int]()
        for p in self.properties {
            if Int(p.assessment) > 10 {
                arrayForMedian.append(Int(p.assessment))
            }
        }
        if arrayForMedian.count == 0 {
            return 0
        } else {
            let medianIndex = (arrayForMedian.count / 2)
            return arrayForMedian.sort() { $0 < $1 }[medianIndex]
        }
    }
    
    // MARK: - Initializers
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(blockDictionary: [String:AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Block", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        timeWhenAdded = blockDictionary["timeWhenAdded"] as! NSDate
        streetAddress = blockDictionary["streetAddress"] as! String
        streetAddress = self.streetAddress.capitalizeStreetName()
    }
    
}