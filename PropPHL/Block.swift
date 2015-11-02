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
    
    // MARK: - Variables
    @NSManaged var timeWhenAdded: NSDate
    @NSManaged var streetAddress: String
    @NSManaged var properties: [Property]
    @NSManaged var pin: Pin
    
    // Compute property count
    var count: Int {
        return self.properties.count
    }
    
    // Compute the median assessment value of all properties on a block
    var medianAsssessmentValue: Int {
        if let propertyValues = self.propertyValuesArray {
            let medianIndex = (propertyValues.count / 2)
            return propertyValues[medianIndex]
        } else {
            return 0
        }
    }
    
    var lowestAssessmentValue: Int {
        if let propertyValues = self.propertyValuesArray {
            return propertyValues.first!
        } else {
            return 0
        }
    }
    
    var highestAssessmentValue: Int {
        if let propertyValues = self.propertyValuesArray {
            return propertyValues.last!
        } else {
            return 0
        }
    }
    
    private var propertyValuesArray: [Int]? {
        let prop = Array(self.properties as NSArray) as! [Property]
        var arrayForAssessmentValues = [Int]()
        for p in prop {
            arrayForAssessmentValues.append(Int(p.assessment))
        }
        if arrayForAssessmentValues.count == 0 {
            return nil
        } else {
            return arrayForAssessmentValues.sort() { $0 < $1 }
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