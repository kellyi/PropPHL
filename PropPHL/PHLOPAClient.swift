//
//  PHLOPAClient.swift
//  PropPHL
//
//  Created by Kelly Innes on 9/8/15.
//  Copyright (c) 2015 Kelly Innes. All rights reserved.
//

import Foundation
import CoreData

class PHLOPAClient: NSObject {
   
    // API documentation: http://phlapi.com/opaapi.html
    
    // MARK: - Constants and Variables
    let addressLink = "https://api.phila.gov/opa/v1.1/"
    let formatParameter = "?format=json?skip="
    var session: NSURLSession
    var completionHandler: ((success: Bool, errorString: String?) -> Void)? = nil
    
    // NSMangedObjectContext singleton
    lazy var sharedContext: NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    // MARK: - Initializer
    
    override init() {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: config)
        super.init()
    }
    
    // MARK: - Make API Call
    
    // API call to create Block object
    func getBlockJSONUsingCompletionHandler(blockAddress: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        let escapedBlock = escapeURLSpaces(blockAddress)
        let fullURLString = "\(addressLink)block/\(escapedBlock)/\(formatParameter)0"
        let apiURL = NSURL(string: fullURLString)
        let request = NSMutableURLRequest(URL: apiURL!)
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(success: false, errorString: "Can't connect to the API.")
            } else {
                let result = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                let total = result["total"] as! Int
                if total == 0 {
                    completionHandler(success: false, errorString: "No properties found for \(blockAddress)!")
                } else {
                    let blockDictionary = [
                        "timeWhenAdded": NSDate(),
                        "streetAddress": blockAddress
                    ]
                    let block = Block(blockDictionary: blockDictionary, context: self.sharedContext)
                    self.getPropertyJSONByBlockUsingCompletionHandler(block, total: total, skip: 0) { (success, errorString) in
                        if success {
                            completionHandler(success: true, errorString: nil)
                        } else {
                            completionHandler(success: false, errorString: errorString)
                        }
                    }
                }
            }
            
        }
        task.resume()
    }
    
    // API call to create Property objects
    // called from block API call & recursively calls itself until it
    // has gone through every page of property data for the specific block
    func getPropertyJSONByBlockUsingCompletionHandler(block: Block, total: Int, skip: Int, completionHandler: (success: Bool, errorString: String?) -> Void) {
        let escapedBlock = escapeURLSpaces(block.streetAddress)
        let fullURLString = "\(addressLink)block/\(escapedBlock)/\(formatParameter)\(skip)"
        let apiURL = NSURL(string: fullURLString)
        let request = NSMutableURLRequest(URL: apiURL!)
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(success: false, errorString: "Couldn't connect to the APIs.")
            } else {
                let result = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                let newResult = result["data"] as! NSDictionary
                let properties = newResult["properties"] as! NSArray
                var counter = 0
                for p in properties {
                    let dict = p as! NSDictionary
                    let property = self.propertyFromDictionary(dict)
                    property!.block = block
                    let propertyCoordinates = dict["geometry"] as! NSDictionary
                    var propertyLatitude = 0.0
                    var propertyLongitude = 0.0
                    if let lat = propertyCoordinates["y"] as? Double {
                        propertyLatitude = lat
                    }
                    if let lon = propertyCoordinates["x"] as? Double {
                        propertyLongitude = lon
                    }
                    let pinDictionary = ["latitude": propertyLatitude, "longitude": propertyLongitude]
                    let pin = self.pinFromDictionary(pinDictionary)
                    pin!.property = property!
                    if counter == 0 && skip == 0 { pin!.block = block }
                    counter++
                }
                if skip < total {
                    self.getPropertyJSONByBlockUsingCompletionHandler(block, total: total, skip: skip+30, completionHandler: completionHandler)
                } else {
                    PhillyHoodsClient.sharedInstance().getNeighborhoodNameUsingCompletionHandler(block.pin.coordinate.latitude, longitude: block.pin.coordinate.longitude) { (success, errorString) in
                        if let neighborhood = PhillyHoodsClient.sharedInstance().currentNeighborhoodName {
                            block.neighborhood = neighborhood
                            try! self.sharedContext.save()
                        }
                    }
                    completionHandler(success: true, errorString: nil)
                }
            }
        }
        task.resume()
    }
    
    // MARK: - Convenience Methods
    
    // Replace spaces for URL
    func escapeURLSpaces(toEscape: String) -> String {
        return toEscape.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: [], range: nil)
    }
    
    // Create a Block object from a dictionary of Properties and a street address
    func blockFromData(properties: [Property], streetAddress: String) -> Block? {
        let timeWhenAdded = NSDate()
        let initializerDictionary = [
            "timeWhenAdded": timeWhenAdded as NSDate,
            "properties": properties as [Property],
            "streetAddress": streetAddress as String,
        ] as [String:AnyObject]
        return Block(blockDictionary: initializerDictionary, context: sharedContext)
    }
    
    // Create a Pin object from a dictionary
    func pinFromDictionary(pinDictionary: NSDictionary) -> Pin? {
        let latitude = pinDictionary["latitude"] as! Double
        let longitude = pinDictionary["longitude"] as! Double
        let initializerDictionary = [
            "latitude": latitude,
            "longitude": longitude,
        ] as [String:AnyObject]
        return Pin(pinDictionary: initializerDictionary, context: sharedContext)
    }
    
    // Create a Property object from a dictionary
    func propertyFromDictionary(propertyDictionary: NSDictionary) -> Property? {
        let salesInfo = propertyDictionary["sales_information"] as! NSDictionary
        let characteristics = propertyDictionary["characteristics"] as! NSDictionary
        let valDictionary = propertyDictionary["valuation_history"] as! NSArray
        let valHistory = valDictionary[0] as! NSDictionary
        let initializerDictionary = [
            "property_id": propertyDictionary["property_id"] as! String,
            "full_address": propertyDictionary["full_address"] as! String,
            "description": characteristics["description"] as! String,
            "sales_date": stringToDate(salesInfo["sales_date"] as! String) as NSDate,
            "sales_price": salesInfo["sales_price"] as! NSNumber,
            "assessment": valHistory["market_value"] as! NSNumber,
            "taxes": valHistory["taxes"] as! NSNumber
        ]
        return Property(propDictionary: initializerDictionary, context: sharedContext)
    }
    
    // Parse the Date(...) string returned in JSON from PHL OPA API
    func stringToDate(s: String) -> NSDate {
        let d = Double(s.componentsSeparatedByString("000-")[0].componentsSeparatedByString("(")[1])!
        return NSDate(timeIntervalSince1970: d)
    }
    
    // MARK: - Make Singleton
    
    class func sharedInstance() -> PHLOPAClient {
        struct Singleton {
            static var sharedInstance = PHLOPAClient()
        }
        return Singleton.sharedInstance
    }
}
