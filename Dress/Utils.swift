//
//  Utils.swift
//  Dress
//
//  Created by Alec on 14-12-26.
//  Copyright (c) 2014年 Alec. All rights reserved.
//

import Foundation


func gen_uuid() -> String? {
    var uuid = NSUUID(UUIDString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")
    return uuid?.UUIDString
}

func initLogin() {
    var userDefaults = NSUserDefaults.standardUserDefaults()
    var userToken = userDefaults.stringForKey("userToken")
    if((userToken?.isEmpty) == nil){
        DataService.shareService.setUserToken()
        userDefaults.setValue(DataService.shareService.userToken!, forKey: "userToken")
    }else{
        DataService.shareService.userToken = userToken
    }

}