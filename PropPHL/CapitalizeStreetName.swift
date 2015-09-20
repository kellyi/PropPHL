//
//  CapitalizeStreetName.swift
//  PropPHL
//
//  Created by Kelly Innes on 9/20/15.
//  Copyright © 2015 Kelly Innes. All rights reserved.
//

import Foundation

extension String {
    
    func capitalizeStreetName() -> String {
        var result = [Character]()
        let downcased = self.lowercaseString
        for c in downcased.characters {
            if result.count > 0 {
                if result.last == " " {
                    let capitalized = Character(String(c).uppercaseString)
                    result.append(capitalized)
                } else if result.count > 1 && result[result.count-1] == "c" && result[result.count-2] == "M" {
                    let capitalized = Character(String(c).uppercaseString)
                    result.append(capitalized)
                } else {
                    result.append(c)
                }
            } else {
                let capitalized = Character(String(c).uppercaseString)
                result.append(capitalized)
            }
        }
        return String(result)
    }
    
}