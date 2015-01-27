//
//  LoginViewController.swift
//  Dress
//
//  Created by Alec on 15-1-26.
//  Copyright (c) 2015年 Alec. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var closeBtn:UIButton?
    
    override func viewDidLoad() {
        println(33333)
    }
    
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
    
    }
    
}
