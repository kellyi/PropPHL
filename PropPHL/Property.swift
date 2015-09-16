//
//  Property.swift
//  PropPHL
//
//  Created by Kelly Innes on 9/8/15.
//  Copyright (c) 2015 Kelly Innes. All rights reserved.
//

import Foundation

class Property {
    
    // MARK: - Variables
    
    var id: String
    var fullAddress: String
    var latitude: Double
    var longitude: Double
    var description: String
    var salesDate: NSDate
    var salesPrice: NSNumber
    var marketValue: NSNumber
    var taxes: NSNumber
    
    // MARK: - Initializer
    
    init(propDictionary: [String:AnyObject]) {
        self.id = propDictionary["property_id"] as! String
        self.fullAddress = propDictionary["full_address"] as! String
        self.latitude = propDictionary["x"] as! Double
        self.longitude = propDictionary["y"] as! Double
        self.description = propDictionary["description"] as! String
        self.salesDate = propDictionary["sales_date"] as! NSDate
        self.salesPrice = propDictionary["sales_price"] as! NSNumber
        self.marketValue = propDictionary["market_value"] as! NSNumber
        self.taxes = propDictionary["taxes"] as! NSNumber
    }
}