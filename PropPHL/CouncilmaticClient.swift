//
//  CouncilmaticClient.swift
//  PropPHL
//
//  Created by Kelly Innes on 9/15/15.
//  Copyright © 2015 Kelly Innes. All rights reserved.
//

import Foundation

class CouncilmaticClient: NSObject {
    
    // API Documentation: http://philly.councilmatic.org/api/
    
    // MARK: - Make Singleton
    
    class func sharedInstance() -> CouncilmaticClient {
        
        struct Singleton {
            static var sharedInstance = CouncilmaticClient()
        }
        
        return Singleton.sharedInstance
    }
}
