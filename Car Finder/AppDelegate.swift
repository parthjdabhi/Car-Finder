//
//  AppDelegate.swift
//  Car Finder
//
//  Created by iParth on 11/25/16.
//  Copyright © 2016 Ecreate Infotech. All rights reserved.
//

import UIKit
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //let Identifier: String = UIDevice.currentDevice().identifierForVendor?.UUIDString ?? ""
        //NSLog("output is : %@", Identifier)
        
        SVProgressHUD.setDefaultStyle(.Dark)
        
        // Register for Push Notitications
        let settings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        // Launch Options
        
        // Handle notification
        if (launchOptions != nil) {
            // Launched from push notification
            if let remoteNotification = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as! [NSObject : AnyObject]? {
                print(remoteNotification)
                
                if let applicationIconBadgeNumber:NSInteger? = UIApplication.sharedApplication().applicationIconBadgeNumber {
                    if applicationIconBadgeNumber <= 1 {
                        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
                    } else {
                        UIApplication.sharedApplication().applicationIconBadgeNumber = applicationIconBadgeNumber! - 1
                    }
                }
                
                //if let something = remoteNotification["yourKey"] as? String {
                //    self.window!.rootViewController = UINavigationController(rootViewController: MyController(yourMember: something))
                //}
            }
        }
        
        //NSUserDefaults.standardUserDefaults().setObject("52d9e86e01f61fbb684ffa8aeb1da3b7322d20342b0ec8b5a49c2052be947e2e", forKey: "deviceToken")
        //UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        print(" openURL : ",url," option : ",options)
        return true
    }
    
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print(deviceToken)
        
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        NSUserDefaults.standardUserDefaults().setObject(tokenString, forKey: "deviceToken")
        NSUserDefaults.standardUserDefaults().synchronize()
        //Parth Device : 52d9e86e01f61fbb684ffa8aeb1da3b7322d20342b0ec8b5a49c2052be947e2e
        print("Device Token:", tokenString)
        
    }
    
    //Called if unable to register for APNS.
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        
        print("didFailToRegisterForRemoteNotificationsWithError" , error)
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey("deviceToken")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        let aps = userInfo["aps"] as! [String: AnyObject]
        print("Aps : ", aps)
        
        if application.applicationState == .Active {
            print("Application is already opened")
            
            // one input & one button
            let alert=UIAlertController(title: "Notification", message: aps["alert"] as? String ?? "New car arrived in feed", preferredStyle: .Alert);
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .Destructive, handler: nil));
            
            func yesHandler(actionTarget: UIAlertAction){
                print("YES -> !!");
                if let feed_data = aps["feed_data"] as? [String: AnyObject] {
                    if let link = feed_data["link"] as? String {
                        openURL(link)
                    }
                }
            }
            alert.addAction(UIAlertAction(title: "View", style: .Default, handler: yesHandler));
            
            UIApplication.topViewController()?.presentViewController(alert, animated: true, completion: nil)
            
            
        }
        else if application.applicationState == .Background {
            print("Application is in Background")
            if let feed_data = aps["feed_data"] as? [String: AnyObject] {
                if let link = feed_data["link"] as? String {
                    openURL(link)
                }
            }
        }
        else if application.applicationState == .Inactive {
            print("Application is Inactive")
            if let feed_data = aps["feed_data"] as? [String: AnyObject] {
                if let link = feed_data["link"] as? String {
                    openURL(link)
                }
            }
        }
        
        // If your app was running and in the foreground
        // Or
        // If your app was running or suspended in the background and the user brings it to the foreground by tapping the push notification
    }

}

