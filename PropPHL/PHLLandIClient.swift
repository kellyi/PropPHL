//
//  PHLLandIClient.swift
//  PropPHL
//
//  Created by Kelly Innes on 9/15/15.
//  Copyright © 2015 Kelly Innes. All rights reserved.
//

import Foundation

class PHLLandIClient: NSObject {
    
    // API Documentation: http://phlapi.com/licenseapi.html
    
    // MARK: - Make Singleton
    
    class func sharedInstance() -> PHLLandIClient {
        
        struct Singleton {
            static var sharedInstance = PHLLandIClient()
        }
        
        return Singleton.sharedInstance
    
    }
}
