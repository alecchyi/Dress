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
let kWeiboApi = "https://api.weibo.com/"
let kWeiboOpeatorId = 5421836100
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
        
    }else{
        DataService.shareService.userToken = userToken
        userDefaults.setValue(DataService.shareService.userToken!, forKey: "userToken")
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
        user = fetchUserData(user, type)
        saveUser(user)
        DataService.shareService.setUserToken(token)
        DataService.shareService.currentUser = user
    }
}

func fetchUserData(data:NSMutableDictionary, type:Int) -> NSMutableDictionary{
    if(type == 1){
        let manager = DataService.shareService.requestManager()
        let url = kWeiboApi + "2/users/show.json"
        let uid:String = data.objectForKey("uid") as String
        let token:String = data.objectForKey("access_token") as String
        let params = ["uid":"\(uid)","access_token":"\(token)"]
        manager!.GET(url,
            parameters:params,
            success: {(operation:AFHTTPRequestOperation!, response:AnyObject!) in
                let resp:NSDictionary = response as NSDictionary
                data.setValue(resp.objectForKey("screen_name"), forKey: "nickname")
                data.setValue(resp.objectForKey("profile_image_url"), forKey: "profile_image_url")
                data.setValue(resp.objectForKey("followers_count"), forKey: "followers_count")
                data.setValue(resp.objectForKey("friends_count"), forKey: "friends_count")
                
            },
            failure: {(operation:AFHTTPRequestOperation!, error:NSError!) in
                
        })
    }
    
    return data
}

func has_bind_weibo() -> Bool {
    if(DataService.shareService.userToken != nil){
        let login_type:String = DataService.shareService.currentUser?.objectForKey("loginType") as String
        if(login_type != "" && login_type == "sina_weibo"){
            return true
        }
    }
    return false
}

