//
//  Pin.swift
//  PropPHL
//
//  Created by Kelly Innes on 9/19/15.
//  Copyright © 2015 Kelly Innes. All rights reserved.
//

import UIKit
import MapKit

@objc(Pin)
class Pin: NSObject, MKAnnotation {
    
    var latitude: Double
    var longitude: Double
    var streetAddress: String
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    required init(pinDictionary: [String:AnyObject]) {
        self.latitude = pinDictionary["latitude"] as! Double
        self.longitude = pinDictionary["longitude"] as! Double
        self.streetAddress = pinDictionary["streetAddress"] as! String
    }
    
    func removePinAnimation() {
        ///
    }
    
}
