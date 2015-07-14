//
//  AppDelegate.swift
//  Dress
//
//  Created by Alec on 14/12/23.
//  Copyright (c) 2014年 Alec. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WeiboSDKDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showLoginPage", name: "unLoginNotify", object: nil)
        initLogin()
        initDataDB()
//        [WeiboSDK  .enableDebugMode]
        WeiboSDK.enableDebugMode(true)
        WeiboSDK.registerApp(kAppKeyForWeibo)
        
        AVOSCloud.setApplicationId(kAVCloudAppId, clientKey: kAVCloudClientKey)
        AVAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        //add umeng api
        UMSocialData.setAppKey(kUMKey)
        UMSocialWechatHandler.setWXAppId(kWeChatAppId, appSecret: kWeChatSecret, url: kShareRedirectUrl)
        UMSocialSinaHandler.openSSOWithRedirectURL("http://sns.whalecloud.com/sina2/callback")
        UMSocialQQHandler.setQQWithAppId(kQQAppId, appKey: kQQKey, url: kShareRedirectUrl)
        
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


    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        let str:String = url.scheme! as String
        if(str.hasPrefix(kWeChatAppId) || str.hasPrefix("tencent")){
            return UMSocialSnsService.handleOpenURL(url)
        }
        return WeiboSDK.handleOpenURL(url, delegate: self)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {

        let str:String = url.scheme! as String
        if(str.hasPrefix(kWeChatAppId) || str.hasPrefix("tencent")){
            return UMSocialSnsService.handleOpenURL(url)
        }
        return WeiboSDK.handleOpenURL(url, delegate: self)
    }
    
    func didReceiveWeiboRequest(request:WBBaseRequest!){
        
    }
    
    func didReceiveWeiboResponse(response: WBBaseResponse!) {
        if(response.isKindOfClass(WBAuthorizeResponse.self)){
            if(response.statusCode == WeiboSDKResponseStatusCode.Success){
                let resp = response as! WBAuthorizeResponse                
//                println(resp.userID!)
                let userInfo:NSDictionary = resp.userInfo as NSDictionary
                userLogin(userInfo, 1)
            }

        }
    }
    
    func showLoginPage(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        var loginViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("loginViewController") as! LoginViewController
        
        self.window!.rootViewController = loginViewController
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "dismissLoginView", name: "finishedLogin", object: nil)
    }
    
    func dismissLoginView(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let rootViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("rootTabViewController") as! UITabBarController

        self.window!.rootViewController = rootViewController
    }
    
    
}

