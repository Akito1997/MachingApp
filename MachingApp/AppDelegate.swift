//
//  AppDelegate.swift
//  MachingApp
//
//  Created by 田中　玲桐 on 2021/02/17.
//

import UIKit
import Firebase
import UserNotifications
import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)

        FirebaseApp.configure()
                
        window=UIWindow(frame: UIScreen.main.bounds)
        
        window?.makeKeyAndVisible()
        
        let view=ControlView()
        
        window?.rootViewController=view
        
        
        return true
    }

}


