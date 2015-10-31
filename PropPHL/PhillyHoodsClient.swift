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
    
    // MARK: - Make Singleton
    
    static let sharedInstance = PhillyHoodsClient()
    
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
                completionHandler(success: false, errorString: "Couldn't connect to the APIs.")
            } else {
                do {
                    let result = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                    if let results = result["results"] as! NSDictionary! {
                        let features = results["features"] as! NSArray
                        let featZero = features[0] as! NSDictionary
                        let prop = featZero["properties"] as! NSDictionary
                        let neighborhood = prop["name"] as! NSString
                        self.currentNeighborhoodName = neighborhood as String
                    }
                } catch {
                    completionHandler(success: false, errorString: "Error parsing API data.")
                }
            }
            completionHandler(success: true, errorString: nil)
        }
        task.resume()
    }
    
}
