//
//  AppDelegate.swift
//  PropPHL
//
//  Created by Kelly Innes on 9/14/15.
//  Copyright © 2015 Kelly Innes. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // if textfield's showing a keyboard, dismiss the keyboard and end editing on moving into background
        self.window?.endEditing(true)
        CoreDataStackManager.sharedInstance.saveContext()
    }

    func applicationWillEnterForeground(application: UIApplication) {
    
    }

    func applicationDidBecomeActive(application: UIApplication) {
        
    }

    func applicationWillTerminate(application: UIApplication) {
        CoreDataStackManager.sharedInstance.saveContext()
    }

}

