//
//  PDCommonUtils.swift
//  Car Finder
//
//  Created by iParth on 11/26/16.
//  Copyright © 2016 Ecreate Infotech. All rights reserved.
//

import UIKit
import WebBrowser

class PDCommonUtils: NSObject {

}

// Constatnts

//http://barelabor.com/carfinder/api/registrion.php
//http://barelabor.com/carfinder/api/unregister.php
//device_id

let BaseURL  = "http://barelabor.com/carfinder/api/"

//Login Registration API
let url_registerDevice      = BaseURL + "registrion.php"
let url_deRegisterDevice    = BaseURL + "unregister.php"
let url_checkRegistration   = BaseURL + "checkRegister.php"


var deviceToken:String = {
    return NSUserDefaults.standardUserDefaults().objectForKey("deviceToken") as? String ?? ""
}()

func isDeviceTokenRegistered() -> Bool
{
    if let Token = NSUserDefaults.standardUserDefaults().objectForKey("isDeviceTokenRegistered") as? String
        where Token == "1" {
        return true
    }
    return false
}

func openURL(url:String) {
    let webBrowserViewController = WebBrowserViewController()
    // assign delegate
    //webBrowserViewController.delegate = self
    
    webBrowserViewController.language = .English
    //webBrowserViewController.tintColor = ...
    //webBrowserViewController.barTintColor = ...
    webBrowserViewController.toolbarHidden = false
    webBrowserViewController.showActionBarButton = true
    webBrowserViewController.toolbarItemSpace = 50
    webBrowserViewController.showURLInNavigationBarWhenLoading = true
    webBrowserViewController.showsPageTitleInNavigationBar = true
    //webBrowserViewController.customApplicationActivities = ...
    
    webBrowserViewController.loadURLString(url)
    UIApplication.topViewController()?.navigationController?.pushViewController(webBrowserViewController, animated: true)
}


extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}