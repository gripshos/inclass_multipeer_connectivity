//
//  AppDelegate.swift
//  mpc_chat
//
//  Created by Corey Baker on 10/9/18.
//  Copyright © 2018 University of Kentucky - CS 485G. All rights reserved.
//
//  Followed and made additions & upgrades to original tutorial by Gabriel Theodoropoulos
//  Swift: http://www.appcoda.com/chat-app-swift-tutorial/
//  Objective C: http://www.appcoda.com/intro-multipeer-connectivity-framework-ios-programming/
//  MPC documentation: https://developer.apple.com/documentation/multipeerconnectivity
//

import UIKit
import MultipeerConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var mpcManager: MPCManager!
    fileprivate var coreDataManager: CoreDataManager!
    var peerUUID = ""
    var peerDisplayName = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Clear items out for the first run
        if (UserDefaults.standard.object(forKey: kDefaultsKeyFirstRun) == nil){
            
            //Set all default values for first run
            UserDefaults.standard.setValue(nil, forKey: kAdvertisingUUID)
            UserDefaults.standard.setValue(nil, forKey: kPeerID)
            
            //This is no longer the first run
            UserDefaults.standard.setValue(kDefaultsKeyFirstRun, forKey: kDefaultsKeyFirstRun)
            UserDefaults.standard.synchronize()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.handleCoreDataInitializedReceived(_:)), name: Notification.Name(rawValue: kNotificationCoreDataInitialized), object: nil)
        self.coreDataManager = CoreDataManager.sharedCoreDataManager
        
        peerDisplayName = UIDevice.current.name
        
        guard let discovery = MPCChatUtility.buildAdvertisingDictionary() else{
            return false
        }
        
        guard let uuid = discovery[kAdvertisingUUID] else {
            return false
        }
        
        peerUUID = uuid
        
        self.mpcManager = MPCManager(kAppName, advertisingName: peerDisplayName, discoveryInfo: discovery)
        //DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
        
        //})
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    @objc func handleCoreDataInitializedReceived(_ notification: NSNotification) {
        //Set flag
        self.coreDataManager.setCoreDataAsReady()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationCoreDataIsReady), object: nil)
    }

}

