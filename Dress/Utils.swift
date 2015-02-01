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
let kDBName = "data.db"
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
        NSNotificationCenter.defaultCenter().postNotificationName("unLoginNotify", object: nil)
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
    var x:Int = 0
    var obj:NSMutableDictionary?
    for(var i=0;i<users!.count;i++){
        let item:NSDictionary = users?.objectAtIndex(i) as NSDictionary
        if((item.objectForKey("userToken") as String) == (user.objectForKey("userToken") as String)){
            obj = NSMutableDictionary(dictionary: item)
            x = 1
            users!.removeObjectAtIndex(i)
            break
        }
    }
    if(x==0){
        users!.addObject(user)
    }else{
        obj!.setValue(user.objectForKey("loginType"), forKey: "loginType")
        obj!.setValue(user.objectForKey("access_token"), forKey: "access_token")
        obj!.setValue(user.objectForKey("weibo_uid"), forKey: "weibo_uid")
        obj!.setValue(user.objectForKey("nickname"), forKey: "nickname")
        obj!.setValue(user.objectForKey("profile_image_url"), forKey: "profile_image_url")
        obj!.setValue(user.objectForKey("followers_count"), forKey: "followers_count")
        obj!.setValue(user.objectForKey("friends_count"), forKey: "friends_count")
        obj!.setValue(user.objectForKey("clothes_count"), forKey: "clothes_count")
        
        users!.addObject(obj!)
    }
    println(users!)
    users!.writeToFile(DataService.shareService.getUsersPlist(), atomically: true)
    return true
}

func userLogin(data:NSDictionary, type:Int){
    var user:NSMutableDictionary = NSMutableDictionary()
    if(type==1){
        //login with weibo
        user.setValue(data.objectForKey("uid"), forKey: "weibo_uid")
        user.setValue(data.objectForKey("access_token"), forKey: "access_token")
        let token:String = gen_uuid()! as String
        user.setValue(token, forKey: "userToken")
        user.setValue("sina_weibo", forKey: "loginType")
        saveUser(user)
        DataService.shareService.setUserToken(token)
        
        fetchUserData(user, type)
    }
}

func fetchUserData(data:NSMutableDictionary, type:Int) -> NSMutableDictionary{
    var user = NSMutableDictionary(dictionary: data)
    if(type == 1){
        println("fetch user data")
        let manager = DataService.shareService.requestManager()
        let url = kWeiboApi + "2/users/show.json"
        let uid:String = data.objectForKey("weibo_uid") as String
        let token:String = data.objectForKey("access_token") as String
        let params = ["uid":"\(uid)","access_token":"\(token)"]
        println(params)
        manager!.GET(url,
            parameters:params,
            success: {(operation:AFHTTPRequestOperation!, response:AnyObject!) in
                let resp:NSDictionary = response as NSDictionary
                println(resp)
                user.setValue(resp.objectForKey("name"), forKey: "nickname")
                user.setValue(resp.objectForKey("profile_image_url"), forKey: "profile_image_url")
                user.setValue(resp.objectForKey("followers_count"), forKey: "followers_count")
                user.setValue(resp.objectForKey("friends_count"), forKey: "friends_count")
                println("get user data successfully")
                saveUser(user)
                DataService.shareService.currentUser = user
                NSNotificationCenter.defaultCenter().postNotificationName("finishedLogin", object: nil)
            },
            failure: {(operation:AFHTTPRequestOperation!, error:NSError!) in
                
        })
    }
    return user
}

func has_bind_weibo() -> Bool {
    if(DataService.shareService.userToken != nil){
        if(DataService.shareService.currentUser != nil){
            let login_type:String = DataService.shareService.currentUser?.objectForKey("loginType") as String
            println(login_type)
            if(login_type != "" && login_type == "sina_weibo"){
                return true
            }
        }
    }
    return false
}

func setCurrentUser(){
    if(DataService.shareService.userToken != nil){
        var users = NSMutableArray(contentsOfFile: DataService.shareService.getUsersPlist())
        println(DataService.shareService.getUsersPlist())
        let token:String = DataService.shareService.userToken! as String
        println(token)
        if(users == nil){
            println("nil users")
        }else{
            for(var i=0;i<users!.count;i++){
                let item:NSDictionary = users?.objectAtIndex(i) as NSDictionary
                println(item.objectForKey("userToken"))
                if((item.objectForKey("userToken") as String) == token){
                    DataService.shareService.currentUser = item as? NSMutableDictionary
                    println("has login token")
                    break
                }
            }
        }
        
    }
}

func initDataDB(){
    let path = DataService.shareService.getDBPath()
    println(path)
    
    
}

