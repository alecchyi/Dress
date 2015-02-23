//
//  LoginViewController.swift
//  Dress
//
//  Created by Alec on 15-1-26.
//  Copyright (c) 2015年 Alec. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var weiboBtn:UIButton?
    @IBOutlet var qqBtn:UIButton?
    @IBOutlet var loginBtn:UIButton?
    
    override func viewDidLoad() {
        
        self.weiboBtn?.layer.cornerRadius = 20
//        self.weiboBtn?.backgroundColor = UIColor.brownColor()
        
        self.qqBtn?.layer.cornerRadius = 20
        self.loginBtn?.layer.cornerRadius = 15
//        self.qqBtn?.backgroundColor = UIColor.blueColor()
    }
    
    override func viewWillAppear(animated: Bool) {
       
    }
    
    override func viewDidAppear(animated: Bool) {
       
    }
    
    func dismissLoginView(){
        println("dismiss")
        self.navigationController?.popViewControllerAnimated(true)
    }
    
//    func loginCallBack(resp:UMSocialResponseEntity) -> UMSocialDataServiceCompletion {
//        if(resp.responseCode == UMSResponseCodeSuccess){
//            let account:UMSocialAccountEntity = (UMSocialAccountManager.socialAccountDictionary() as NSDictionary).valueForKey(UMShareToSina)
//            println(account.userName)
//            println(account.usid)
//            println(account.accessToken)
//        }
//    }
    
    @IBAction func closeLoginView(){
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func clickWeiboLoginBtn(){
        var request:WBAuthorizeRequest = WBAuthorizeRequest.request() as WBAuthorizeRequest;
        request.redirectURI = kWeiboRedirectURL
        request.scope = "all"
        var infos = NSMutableDictionary()
        infos.setValue("LoginViewController", forKey: "SSO_From")
        request.userInfo = infos
//            "SSO_From": "LoginViewController",
//            "Other_Info_1": 123,
//            "Other_Info_2": ["obj1", "obj2"],
//            "Other_Info_3": {"key1": "obj1", "key2": "obj2"}
//        };
        WeiboSDK.sendRequest(request)
        

    }
    
    @IBAction func clickWechatLoginBtn(){
        let snsPlatform:UMSocialSnsPlatform = UMSocialSnsPlatformManager.getSocialPlatformWithName(UMShareToQQ) as UMSocialSnsPlatform
        snsPlatform.loginClickHandler(self,UMSocialControllerService.defaultControllerService(),true, {(resp:UMSocialResponseEntity!) in
                println(resp.responseCode.value)
                println("login within umeng")
                if(resp.responseCode.value == UMSResponseCodeSuccess.value){
                    let accountDic:NSDictionary = UMSocialAccountManager.socialAccountDictionary()
                    let account:UMSocialAccountEntity = accountDic.valueForKey(UMShareToQQ) as UMSocialAccountEntity
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
    
}
