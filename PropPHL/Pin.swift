//
//  Pin.swift
//  PropPHL
//
//  Created by Kelly Innes on 9/19/15.
//  Copyright © 2015 Kelly Innes. All rights reserved.
//

import UIKit
import MapKit
import CoreData

@objc(Pin)
class Pin: NSManagedObject, MKAnnotation {
    
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var property: Property
    @NSManaged var block: Block
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: Double(latitude), longitude: Double(longitude))
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(pinDictionary: [String:AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Pin", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        latitude = pinDictionary["latitude"] as! Double
        longitude = pinDictionary["longitude"] as! Double
    }
    
}
