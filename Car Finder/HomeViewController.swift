//
//  HomeViewController.swift
//  Car Finder
//
//  Created by iParth on 11/25/16.
//  Copyright © 2016 Ecreate Infotech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import WebBrowser

class HomeViewController: UIViewController {

    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnSubscribeFeed: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if isDeviceTokenRegistered() {
            setSubscribeButtonStyle(false)
        } else {
            setSubscribeButtonStyle(true)
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setSubscribeButtonStyle(isSubscribed:Bool)
    {
        if isSubscribed {
            self.lblDesc.text = "Do you want to subscribe car finder feed?"
            self.btnSubscribeFeed.setTitleColor(UIColor.greenColor(), forState: .Normal)
            self.btnSubscribeFeed.setTitle("Subscribe feed", forState: .Normal)
        }
        else
        {
            self.lblDesc.text = "Do you want to unsubscribe car finder feed?"
            self.btnSubscribeFeed.setTitleColor(UIColor.redColor(), forState: .Normal)
            self.btnSubscribeFeed.setTitle("Unsubscribe feed", forState: .Normal)
        }
    }
    

    @IBAction func actionSubscribeFeed(sender: AnyObject) {
        
        print("isDeviceTokenRegistered : ",isDeviceTokenRegistered())
        
        if isDeviceTokenRegistered() {
            // Remove
            if deviceToken == "" {
                SVProgressHUD.showErrorWithStatus("Sorry, We can't deregister your device!")
                return
            }
            
            let Parameters = ["submitted" : "1",
                              "device_id" : deviceToken]
            
            SVProgressHUD.showWithStatus("Loading..")
            Alamofire.request(.POST, url_deRegisterDevice, parameters: Parameters)
                .validate()
                .responseJSON { response in
                    switch response.result
                    {
                    case .Success(let data):
                        let json = JSON(data)
                        print("json.dictionary : ",json.dictionary)
                        
                        if let status = json["status"].string where status == "1"
                        {
                            SVProgressHUD.showSuccessWithStatus( json["msg"].string ?? "You are now not recive any feed!")
                            //To Mark Device is registered
                            NSUserDefaults.standardUserDefaults().removeObjectForKey("isDeviceTokenRegistered")
                            NSUserDefaults.standardUserDefaults().synchronize()
                            self.setSubscribeButtonStyle(true)
                            
                        } else  if let msg = json["msg"].string {
                            SVProgressHUD.showErrorWithStatus(msg)
                        } else {
                            SVProgressHUD.showErrorWithStatus("Unable to unsubscribe!")
                        }
                        
                    case .Failure(let error):
                        //SVProgressHUD.dismiss()
                        SVProgressHUD.showErrorWithStatus("Unable to complete request!")
                        print("Request failed with error: \(error)")
                        //CommonUtils.sharedUtils.showAlert(self, title: "Error", message: (error?.localizedDescription)!)
                    }
            }
            
        } else {
            
            if deviceToken == "" {
                SVProgressHUD.showErrorWithStatus("Sorry, We can't register your device!")
                return
            }
            
            let Parameters = ["submitted" : "1",
                              "device_id" : deviceToken]
            
            SVProgressHUD.showWithStatus("Loading..")
            Alamofire.request(.POST, url_registerDevice, parameters: Parameters)
                .validate()
                .responseJSON { response in
                    switch response.result
                    {
                    case .Success(let data):
                        let json = JSON(data)
                        print(json.dictionary)
                        
                        if let status = json["status"].string where status == "1"
                        {
                            SVProgressHUD.showSuccessWithStatus( json["msg"].string ?? "You are now recive All feed!")
                            //To Mark Device is registered
                            NSUserDefaults.standardUserDefaults().setObject("1", forKey: "isDeviceTokenRegistered")
                            NSUserDefaults.standardUserDefaults().synchronize()
                            self.setSubscribeButtonStyle(false)
                        } else  if let msg = json["msg"].string {
                            SVProgressHUD.showErrorWithStatus(msg)
                            //NSUserDefaults.standardUserDefaults().setObject("1", forKey: "isDeviceTokenRegistered")
                            //NSUserDefaults.standardUserDefaults().synchronize()
                        } else {
                            SVProgressHUD.showErrorWithStatus("Unable to subscribe!")
                        }
                        
                    case .Failure(let error):
                        //SVProgressHUD.dismiss()
                        SVProgressHUD.showErrorWithStatus("Unable to complete request!")
                        print("Request failed with error: \(error)")
                        //CommonUtils.sharedUtils.showAlert(self, title: "Error", message: (error?.localizedDescription)!)
                    }
            }
        }
        
    }
}

