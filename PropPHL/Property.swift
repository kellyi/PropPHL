//
//  Property.swift
//  PropPHL
//
//  Created by Kelly Innes on 9/8/15.
//  Copyright (c) 2015 Kelly Innes. All rights reserved.
//

import Foundation
import CoreData

@objc(Property)
class Property: NSManagedObject {
    
    // MARK: - Variables
    
    @NSManaged var id: String
    @NSManaged var fullAddress: String
    @NSManaged var opaDescription: String
    @NSManaged var salesDate: NSDate
    @NSManaged var salesPrice: NSNumber
    @NSManaged var assessment: NSNumber
    @NSManaged var taxes: NSNumber
    @NSManaged var pin: Pin
    
    // MARK: - Initializer
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(propDictionary: [String:AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Property", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        id = propDictionary["property_id"] as! String
        fullAddress = propDictionary["full_address"] as! String
        opaDescription = propDictionary["description"] as! String
        salesDate = propDictionary["sales_date"] as! NSDate
        salesPrice = propDictionary["sales_price"] as! NSNumber
        assessment = propDictionary["assessment"] as! NSNumber
        taxes = propDictionary["taxes"] as! NSNumber
        pin = propDictionary["pin"] as! Pin
        fullAddress = self.fullAddress.capitalizeStreetName()
    }
}