//
//  PhillyHoodsClient.swift
//  PropPHL
//
//  Created by Kelly Innes on 9/20/15.
//  Copyright © 2015 Kelly Innes. All rights reserved.
//

import Foundation

class PhillyHoodsClient: NSObject {

    // api reference: http://phillyhoods.net/
    
    // MARK: - Constants and Variables
    
    let baseURL = "http://api.phillyhoods.net/v1/locations/"
    var session: NSURLSession
    var currentNeighborhoodName: String?
    
    // MARK: - Initialize Session
    
    override init() {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: config)
        super.init()
    }
    
    // MARK: - Make API Call
    
    func getNeighborhoodNameUsingCompletionHandler(latitude: Double, longitude: Double, completionHandler: (success: Bool, errorString: String?) -> Void) {
        let fullURLString = "\(baseURL)\(latitude),\(longitude)"
        let apiURL = NSURL(string: fullURLString)
        let request = NSMutableURLRequest(URL: apiURL!)
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                
            } else {
                let result = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                if let results = result["results"] {
                    let features = results["features"] as! NSArray
                    let featZero = features[0] as! NSDictionary
                    let prop = featZero["properties"] as! NSDictionary
                    let neighborhood = prop["name"] as! NSString
                    self.currentNeighborhoodName = neighborhood as String
                }
            }
            completionHandler(success: true, errorString: nil)
        }
        task.resume()
    }
    
    // MARK: - Make Singleton
    
    class func sharedInstance() -> PhillyHoodsClient {
        struct Singleton {
            static var sharedInstance = PhillyHoodsClient()
        }
        return Singleton.sharedInstance
    }
}
