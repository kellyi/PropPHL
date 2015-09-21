//
//  PhillyHoodsClient.swift
//  PropPHL
//
//  Created by Kelly Innes on 9/20/15.
//  Copyright © 2015 Kelly Innes. All rights reserved.
//

import Foundation
import CoreData

class PhillyHoodsClient: NSObject {

    // api reference: http://phillyhoods.net/
    
    let baseURL = "http://api.phillyhoods.net/v1/locations/"
    var session: NSURLSession
    var completionHandler: ((success: Bool, errorString: String?) -> Void)? = nil
    
    // NSMangedObjectContext singleton
    lazy var sharedContext: NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    override init() {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: config)
        super.init()
    }
    
    func getNeighborhoodNameUsingCompletionHandler(latitude: Double, longitude: Double, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        let fullURLString = "\(baseURL)/\(longitude)/\(latitude)"
        
    }
    
    // MARK: - Make Singleton
    
    class func sharedInstance() -> PhillyHoodsClient {
        struct Singleton {
            static var sharedInstance = PhillyHoodsClient()
        }
        return Singleton.sharedInstance
    }
}
