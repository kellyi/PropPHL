//
//  ValidateAddressInput.swift
//  PropPHL
//
//  Created by Kelly Innes on 9/20/15.
//  Copyright © 2015 Kelly Innes. All rights reserved.
//

import UIKit

extension AddBlockViewController {
    
    // MARK: - Address Input Validation
    
    func roundStringToHundreds(n: String) -> Int? {
        func roundNToHundreds(n: Int) -> Int {
            return n >= 100 ? ((n / 100) * 100) : 1
        }
        return Int(n) != nil ? roundNToHundreds(Int(n)!) : nil
    }
    
    func getStreetNumberFromAddressString(s: String) -> String? {
        if s.characters.count == 0 {
            return nil
        } else if Int(s) != nil {
            return s
        } else if s.characters.first == " " {
            let newS = String(s.characters.dropFirst())
            return getStreetNumberFromAddressString(newS)
        } else if s.containsString("-") {
            let newS = (s.componentsSeparatedByString("-")[1])
            return getStreetNumberFromAddressString(newS)
        } else if s.containsString(" ") {
            let newS = (s.componentsSeparatedByString(" ")[0])
            return getStreetNumberFromAddressString(newS)
        } else {
            return nil
        }
    }
    
    func getStreetStringFromAddressString(s: String, flag: Bool = false) -> String? {
        let c: [Character] = ["1","2","3","4","5","6","7","8","9","0","-"]
        if s.characters.count == 0 {
            return nil
        } else if s.characters.first == " " {
            let newS = String(s.characters.dropFirst())
            return getStreetStringFromAddressString(newS, flag: true)
        } else if c.contains(s.characters.first!) && flag == false {
            let newS = String(s.characters.dropFirst())
            return getStreetStringFromAddressString(newS)
        } else {
            return s
        }
    }
    
    func streetBlockFromAddressString(s: String) -> String? {
        if let n = getStreetNumberFromAddressString(s) {
            if let street = getStreetStringFromAddressString(s) {
                return "\(roundStringToHundreds(n)!) \(street)"
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
}