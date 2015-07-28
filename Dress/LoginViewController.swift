//
//  LoginViewController.swift
//  Dress
//
//  Created by Alec on 15-1-26.
//  Copyright (c) 2015年 Alec. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,GADBannerViewDelegate {

    @IBOutlet var weiboBtn:UIButton?
    @IBOutlet var qqBtn:UIButton?
    @IBOutlet var loginBtn:UIButton?
    @IBOutlet var _bannerView:GADBannerView?

    @IBOutlet weak var txtPwd: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    override func viewDidLoad() {
        
        self.weiboBtn?.layer.cornerRadius = 17
//        self.weiboBtn?.backgroundColor = UIColor.brownColor()
        
        self.qqBtn?.layer.cornerRadius = 17
        self.loginBtn?.layer.cornerRadius = 13
//        self.qqBtn?.backgroundColor = UIColor.blueColor()
        
        initBannerView()
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "loginFailure", name: "loginFailure", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
       
    }
    
    override func viewDidAppear(animated: Bool) {
       
    }
    
    func dismissLoginView(){
        println("dismiss")
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func closeLoginView(){
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func clickWeiboLoginBtn(){
        var request:WBAuthorizeRequest = WBAuthorizeRequest.request() as! WBAuthorizeRequest;
        request.redirectURI = kWeiboRedirectURL
        request.scope = "all"
        var infos = NSMutableDictionary()
        infos.setValue("LoginViewController", forKey: "SSO_From")
        request.userInfo = infos as [NSObject : AnyObject]
        WeiboSDK.sendRequest(request)
        
    }
    
    @IBAction func clickWechatLoginBtn(){
        let snsPlatform:UMSocialSnsPlatform = UMSocialSnsPlatformManager.getSocialPlatformWithName(UMShareToQQ) as UMSocialSnsPlatform
        snsPlatform.loginClickHandler(self,UMSocialControllerService.defaultControllerService(),true, {(resp:UMSocialResponseEntity!) in
//                println(resp.responseCode.value)
//                println("login within umeng")
                if(resp.responseCode.value == UMSResponseCodeSuccess.value){
                    let accountDic:NSDictionary = UMSocialAccountManager.socialAccountDictionary()
                    let account:UMSocialAccountEntity = accountDic.valueForKey(UMShareToQQ) as! UMSocialAccountEntity
                    println(account.userName)
                    println(account.usid)
                    println(account.accessToken)
                    var userInfo = NSMutableDictionary()
                    userInfo.setValue(account.iconURL, forKey: "profile_image_url")
                    userInfo.setValue(account.userName, forKey: "nickname")
                    userInfo.setValue(account.usid, forKey: "uid")
                    userInfo.setValue(account.accessToken, forKey: "access_token")
                    userLogin(userInfo, 2)
                }
            
        })
    }
    
    func initBannerView(){
        var frame = self.view.bounds
        frame.origin.y -= 50
        self._bannerView?.frame = frame
        self._bannerView?.adUnitID = APP_LOGIN_ADMOB_AD_UNIT_ID
        self._bannerView?.rootViewController = self
        self._bannerView?.delegate = self
        var request = GADRequest()
        request.testDevices = ["5B95C192-07BA-49FD-B572-AA23540AD9E0","cc95f15c6a339431d0d16e3184949be81f2"]
        
        self._bannerView?.loadRequest(request)
    }
    
    func adViewDidReceiveAd(view: GADBannerView!) {
        println("ads login")
    }
    
    @IBAction func clickForgetBtn(sender: AnyObject) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        var forgetViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("forgetViewController") as! ForgetViewController
        var navModelController = UINavigationController(rootViewController: forgetViewController)
        navModelController.navigationBar.barTintColor = mainNavBarColor()
        self.presentViewController(navModelController, animated: true, completion: {
            //            newClothViewController.selectedTags = NSMutableArray()
        })
    }
    @IBAction func clickLoginBtn(sender: AnyObject) {
        let phone = self.txtPhone.text
        let pwd = self.txtPwd.text
        if(phone.isEmpty || pwd.isEmpty){
            self.view.makeToast(message: "请输入你的用户名和密码", duration: 2.0, position: HRToastPositionCenter)
        }else if(count(phone) != 11 || count(pwd) > 20){
            self.view.makeToast(message: "你输入的字符长度有误", duration: 2.0, position: HRToastPositionCenter)
        }else{
            
            var userInfo = NSMutableDictionary()
            userInfo.setValue("", forKey: "profile_image_url")
            userInfo.setValue(phone, forKey: "username")
            userInfo.setValue(pwd, forKey: "password")
            userLogin(userInfo, 3)
        }
    }
    
    @IBAction func clickRegBtn(sender: UIButton) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        var registViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("registViewController") as! RegistViewController
        var navModelController = UINavigationController(rootViewController: registViewController)
        navModelController.navigationBar.barTintColor = mainNavBarColor()
        self.presentViewController(navModelController, animated: true, completion: {
//            newClothViewController.selectedTags = NSMutableArray()
        })
    }
    
    func loginFailure(){
        self.view.makeToast(message: "你的用户名或密码有误", duration: 2.0, position: HRToastPositionCenter)
    }
    
}
