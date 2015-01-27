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
let kWeatherPlist = "weather.plist"
let kUsersPlist = "users.plist"
let kSeasons = ["春季","夏季","秋季","冬季"]
let kCategories = ["帽子","上衣","裤子","鞋子"]

func gen_uuid() -> String? {
    var uuid = NSUUID()
    return uuid.UUIDString
}

func initLogin() {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let userToken = userDefaults.stringForKey("userToken")
    if((userToken?.isEmpty) == nil){
//        DataService.shareService.setUserToken()
        userDefaults.setValue(DataService.shareService.userToken!, forKey: "userToken")
    }else{
        DataService.shareService.userToken = userToken
    }
    
}

func formateCurDate() -> NSString{
    let formate = NSDateFormatter()
    formate.dateFormat = "yyyyMMdd"
    return formate.stringFromDate(NSDate())
}

func saveUser(user:NSDictionary) -> Bool{
    var users = NSMutableArray(contentsOfFile: DataService.shareService.getUsersPlist())
    if(users == nil){
        users = NSMutableArray()
        
    }
    for(var i=0;i<users!.count;i++){
        let item:NSDictionary = users?.objectAtIndex(i) as NSDictionary
        if((item.objectForKey("userToken") as String) == (user.objectForKey("userToken") as String)){
            users!.removeObjectAtIndex(i)
            break
        }
    }
    users?.addObject(user)
    println(users!)
    return true
}

func userLogin(data:NSDictionary, type:Int){
    var user:NSMutableDictionary = NSMutableDictionary()
    if(type==1){
        user.setValue(data.objectForKey("uid"), forKey: "uid")
        user.setValue(data.objectForKey("access_token"), forKey: "access_token")
        let token:String = gen_uuid()! as String
        user.setValue(token, forKey: "userToken")
        user.setValue("sina_weibo", forKey: "loginType")
        saveUser(user)
        DataService.shareService.setUserToken(token)
    }
}

