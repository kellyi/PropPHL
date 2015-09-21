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
    
    func getBlockJSONUsingCompletionHandler(blockAddress: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        let escapedBlock = escapeURLSpaces(blockAddress)
        let fullURLString = "\(addressLink)block/\(escapedBlock)/\(formatParameter)0"
        let apiURL = NSURL(string: fullURLString)
        let request = NSMutableURLRequest(URL: apiURL!)
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(success: false, errorString: "\(error)")
            } else {
                let result = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                let total = result["total"] as! Int
                let blockDictionary = [
                    "timeWhenAdded": NSDate(),
                    "streetAddress": blockAddress
                ]
                let block = Block(blockDictionary: blockDictionary, context: self.sharedContext)
                self.getPropertyJSONByBlockUsingCompletionHandler(block, total: total, skip: 0, completionHandler: completionHandler)
            }
            completionHandler(success: true, errorString: nil)
        }
        task.resume()
    }
    
    func getPropertyJSONByBlockUsingCompletionHandler(block: Block, total: Int, skip: Int, completionHandler: (success: Bool, errorString: String?) -> Void) {
        let escapedBlock = escapeURLSpaces(block.streetAddress)
        let fullURLString = "\(addressLink)block/\(escapedBlock)/\(formatParameter)\(skip)"
        let apiURL = NSURL(string: fullURLString)
        let request = NSMutableURLRequest(URL: apiURL!)
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(success: false, errorString: "\(error)")
            } else {
                let result = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                let newResult = result["data"] as! NSDictionary
                let properties = newResult["properties"] as! NSArray
                for p in properties {
                    let dict = p as! NSDictionary
                    let property = self.propertyFromDictionary(dict)
                    property!.block = block
                    print("\(property!.fullAddress)")
                    let propertyCoordinates = dict["geometry"] as! NSDictionary
                    let propertyLatitude = propertyCoordinates["y"] as! Double
                    let propertyLongitude = propertyCoordinates["x"] as! Double
                    let pinDictionary = ["latitude": propertyLatitude, "longitude": propertyLongitude]
                    let pin = self.pinFromDictionary(pinDictionary)
                    pin!.property = property!
                }
                if skip < total {
                    self.getPropertyJSONByBlockUsingCompletionHandler(block, total: total, skip: skip+30, completionHandler: completionHandler)
                }
            }
            completionHandler(success: true, errorString: nil)
        }
        task.resume()
    }
    
    // MARK: - Convenience Methods
    
    func escapeURLSpaces(toEscape: String) -> String {
        return toEscape.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: [], range: nil)
    }
    
    func blockFromData(properties: [Property], streetAddress: String) -> Block? {
        let timeWhenAdded = NSDate()
        let initializerDictionary = [
            "timeWhenAdded": timeWhenAdded as NSDate,
            "properties": properties as [Property],
            "streetAddress": streetAddress as String,
        ] as [String:AnyObject]
        return Block(blockDictionary: initializerDictionary, context: sharedContext)
    }
    
    func pinFromDictionary(pinDictionary: NSDictionary) -> Pin? {
        let latitude = pinDictionary["latitude"] as! Double
        let longitude = pinDictionary["longitude"] as! Double
        let initializerDictionary = [
            "latitude": latitude,
            "longitude": longitude,
        ] as [String:AnyObject]
        return Pin(pinDictionary: initializerDictionary, context: sharedContext)
    }
    
    // create a Property object from a dictionary
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
    
    // parse the Date(...) string returned in JSON from API
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
