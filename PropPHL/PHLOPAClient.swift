//
//  PHLOPAClient.swift
//  PropPHL
//
//  Created by Kelly Innes on 9/8/15.
//  Copyright (c) 2015 Kelly Innes. All rights reserved.
//

import Foundation

class PHLOPAClient: NSObject {
   
    // API documentation: http://phlapi.com/opaapi.html
   
    var savedBlocks = [Block]()
    var savedProperties = [Property]()
    var total = 0
    
    // MARK: - Constants and Variables
    let addressLink = "https://api.phila.gov/opa/v1.1/"
    let formatParameter = "?format=json?skip="
    var session: NSURLSession
    var completionHandler: ((success: Bool, errorString: String?) -> Void)? = nil
    
    // MARK: - Initializer
    
    override init() {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: config)
        super.init()
    }
    
    // MARK: - Make API Call
    
    func getPropertyJSONByBlockUsingCompletionHandler(block: String, skip: Int, completionHandler: (success: Bool, errorString: String?) -> Void) {
        if skip == 0 { savedProperties = [] }
        let escapedBlock = escapeURLSpaces(block)
        let fullURLString = "\(addressLink)block/\(escapedBlock)/\(formatParameter)\(skip)"
        let apiURL = NSURL(string: fullURLString)
        let request = NSMutableURLRequest(URL: apiURL!)
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(success: false, errorString: "\(error)")
            } else {
                let result = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                self.total = result["total"] as! Int
                let newResult = result["data"] as! NSDictionary
                let properties = newResult["properties"] as! NSArray
                for p in properties {
                    let dict = p as! NSDictionary
                    let property = self.propertyFromDictionary(dict)
                    self.savedProperties.append(property!)
                }
                if self.savedProperties.count < self.total {
                    self.getPropertyJSONByBlockUsingCompletionHandler(block, skip: skip+30, completionHandler: completionHandler)
                } else {
                    let blockToAppend = self.blockFromData(self.savedProperties, streetAddress: block)
                    self.savedBlocks.append(blockToAppend!)
                    self.savedProperties = []
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
        var initializerDictionary = [
            "timeWhenAdded": timeWhenAdded as NSDate,
            "properties": properties as [Property],
            "streetAddress": streetAddress as String,
        ] as [String:AnyObject]
        if (initializerDictionary["properties"] as! [Property]).count > 0 {
            let pin = properties[0].pin as Pin
            initializerDictionary["pin"] = pin
        }
        return Block(blockDictionary: initializerDictionary)
    }
    
    func pinFromDictionary(pinDictionary: NSDictionary) -> Pin? {
        let latitude = pinDictionary["latitude"] as! Double
        print("latitude reached")
        let longitude = pinDictionary["longitude"] as! Double
        print("longitude reached")
        let streetAddress = pinDictionary["streetAddress"] as! String
        print("streetAddress reached")
        let initializerDictionary = [
            "latitude": latitude,
            "longitude": longitude,
            "streetAddress": streetAddress
        ] as [String:AnyObject]
        print("set pin initializer dictionary")
        return Pin(pinDictionary: initializerDictionary)
    }
    
    // create a Property object from a dictionary
    func propertyFromDictionary(propertyDictionary: NSDictionary) -> Property? {
        let coordinates = propertyDictionary["geometry"] as! NSDictionary
        let latitude = coordinates["x"] as! Double
        let longitude = coordinates["y"] as! Double
        let salesInfo = propertyDictionary["sales_information"] as! NSDictionary
        let characteristics = propertyDictionary["characteristics"] as! NSDictionary
        let valDictionary = propertyDictionary["valuation_history"] as! NSArray
        let valHistory = valDictionary[0] as! NSDictionary
        let pinDictionary = [
            "latitude": latitude,
            "longitude": longitude,
            "streetAddress": propertyDictionary["full_address"] as! String
        ] as [String:AnyObject]
        let pin = Pin(pinDictionary: pinDictionary)
        let initializerDictionary = [
            "property_id": propertyDictionary["property_id"] as! String,
            "full_address": propertyDictionary["full_address"] as! String,
            "pin": pin as Pin,
            "description": characteristics["description"] as! String,
            "sales_date": stringToDate(salesInfo["sales_date"] as! String) as NSDate,
            "sales_price": salesInfo["sales_price"] as! NSNumber,
            "assessment": valHistory["market_value"] as! NSNumber,
            "taxes": valHistory["taxes"] as! NSNumber
        ]
        return Property(propDictionary: initializerDictionary)
    }
    
    // parse the Date(...) string returned in JSON
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
