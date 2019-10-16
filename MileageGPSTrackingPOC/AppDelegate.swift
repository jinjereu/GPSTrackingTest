//
//  AppDelegate.swift
//  MileageGPSTrackingPOC
//
//  Created by Ingrid Silapan on 15/10/19.
//  Copyright © 2019 Ingrid Silapan. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
      CoreDataStack.saveContext()
    }

    func applicationWillTerminate(_ application: UIApplication) {
      CoreDataStack.saveContext()
    }

}

