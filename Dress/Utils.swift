//
//  Utils.swift
//  Dress
//
//  Created by Alec on 14-12-26.
//  Copyright (c) 2014年 Alec. All rights reserved.
//

import Foundation

let kClothPlist = "clothes.plist"
let kTagPlist = "tags.plist"
let kSeasons = ["春季","夏季","秋季","冬季"]
let kCategories = ["帽子","上衣","裤子","鞋子"]

func gen_uuid() -> String? {
    var uuid = NSUUID()
    return uuid.UUIDString
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