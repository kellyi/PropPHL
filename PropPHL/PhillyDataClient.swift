//
//  PhillyDataClient.swift
//  ValPHL
//
//  Created by Kelly Innes on 11/3/15.
//  Copyright © 2015 Kelly Innes. All rights reserved.
//

import Foundation
import CoreData

class PhillyDataClient: NSObject {
    
    // MARK: - Make Singleton
    static let sharedInstance = PhillyDataClient()
    
    // MARK: - Constants and Variables
    let baseURL = "https://data.phila.gov/resource/tqtk-pmbv.json?location="
    let apiToken = PhillyDataClient.Constants.apiToken
    var session: NSURLSession
    var completionHandler: ((success: Bool, errorString: String?) -> Void)? = nil
    
    // NSMangedObjectContext
    lazy var sharedContext: NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance.managedObjectContext
    }()
    
    override init() {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: config)
        super.init()
    }
    
    // MARK: - Make API Call
    
    func getPropertyJSONUSingCompletionHandler(propertyAddress: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        let escapedAddress = escapeURLSpaces(propertyAddress)
        let fullURLString = "\(baseURL)\(escapedAddress)"
        let apiURL = NSURL(string: fullURLString)
        let request = NSMutableURLRequest(URL: apiURL!)
        request.addValue(apiToken, forHTTPHeaderField: "X-App-Token")
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(success: false, errorString: "Couldn't connect to the API")
            } else {
                do {
                    let result = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                    print(result)
                    completionHandler(success: true, errorString: nil)
                } catch {
                    print("an error occurred")
                    completionHandler(success: false, errorString: "an error occured")
                }
            }
        }
        task.resume()
    }
    
    // MARK: - Convenience Methods
    
    // Replace URL spaces
    
    func escapeURLSpaces(stringToEscape: String) -> String {
        return stringToEscape.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: [], range: nil)
    }
}
