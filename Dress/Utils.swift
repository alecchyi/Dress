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
    setUserDir(user.objectForKey("userToken") as String)
    if(x==0){
        users!.addObject(user)
    }else{
        obj!.setValue(user.objectForKey("userToken"), forKey: "userToken")
        obj!.setValue(user.objectForKey("loginType"), forKey: "loginType")
        obj!.setValue(user.objectForKey("access_token"), forKey: "access_token")
        obj!.setValue(user.objectForKey("qq_uid"), forKey: "qq_uid")
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
        let token:String = set_user_token("sina_weibo",(data.objectForKey("uid") as String))
        user.setValue(token, forKey: "userToken")
        user.setValue("sina_weibo", forKey: "loginType")
        user.setValue(0, forKey: "shared_count")
        saveUser(user)
        DataService.shareService.setUserToken(token)
        
        fetchUserData(user, type)
    }else if(type==2){
        // login with qq
        user.setValue("tencent_qq", forKey: "loginType")
        let token:String = set_user_token("tencent_qq",(data.objectForKey("uid") as String))
        user.setValue(token, forKey: "userToken")
        user.setValue(data.objectForKey("access_token"), forKey: "access_token")
        user.setValue(data.objectForKey("uid"), forKey: "qq_uid")
        user.setValue(data.objectForKey("nickname"), forKey: "nickname")
        user.setValue(data.objectForKey("profile_image_url"), forKey: "profile_image_url")
        user.setValue(0, forKey: "followers_count")
        user.setValue(0, forKey: "friends_count")
        user.setValue(0, forKey: "shared_count")
        saveUser(user)
        DataService.shareService.setUserToken(token)
        DataService.shareService.currentUser = user
        NSNotificationCenter.defaultCenter().postNotificationName("finishedLogin", object: nil)
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
//                println(resp)
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
                println("fetch user error")
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
//                    println("has login token")
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

func mainColor() -> UIColor {
    return UIColor(red: 253/255.0, green: 219/255.0, blue: 251/255.0, alpha: 1.0)
}

func mainBtnColor() -> UIColor {
    return UIColor(red: 253/255.0, green: 103/255.0, blue: 85/255.0, alpha: 1.0)
}

func mainWordColor() -> UIColor {
    return UIColor(red: 80/255.0, green: 80/255.0, blue: 80/255.0, alpha: 1.0)
}

func weatherWordColor() -> UIColor {
    return UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
}

func mainNavBarColor() -> UIColor {
    return UIColor(red: 244/255.0, green: 119/255.0, blue: 146/255.0, alpha: 0.75)
}

func fetchSystemTags(){
    var allTags = NSMutableArray()
    
    var query = AVQuery(className: "Tags")
    query.whereKey("parent_id", equalTo: "system")
    query.getFirstObjectInBackgroundWithBlock({(obj:AVObject!, error:NSError!) in
        if(error==nil && obj !=  nil){
            var req = AVQuery(className: "Tags")
            req.whereKey("parent_id", equalTo: (obj.objectForKey("objectId") as String))
            req.findObjectsInBackgroundWithBlock({(tags:[AnyObject]!, err:NSError!) in
                if(err==nil && tags != nil){
                    let arr:NSArray = tags as NSArray
                    for(var i=0;i<arr.count;i++){
                        let item = arr.objectAtIndex(i) as AVObject
                        var tag:NSMutableDictionary = NSMutableDictionary()
                        tag.setValue(item.objectForKey("objectId"), forKey: "id")
                        tag.setValue(item.objectForKey("name"), forKey: "name")
                        tag.setValue(item.objectForKey("tagId"), forKey: "tagId")
                        allTags.addObject(tag)
//                        println("idx:\(i)")
                    }
                    allTags.writeToFile(DataService.shareService.getTagsPlist(), atomically: true)
                }
            })
        }else{
//            println("fetch system tags error")
        }
    })
    
}

func setUserDir(userToken:String){
    let fileManager = NSFileManager.defaultManager()
    let storeFilePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
    var documentDir = storeFilePath[0] as String
    let path = documentDir.stringByAppendingPathComponent(userToken)
    var isDir:ObjCBool = false
    if(!fileManager.fileExistsAtPath(path, isDirectory: &isDir)){
        fileManager.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil, error: nil)
    }
}

func set_user_token(loginType:String,uid:String) -> String{
    var users = NSMutableArray(contentsOfFile: DataService.shareService.getUsersPlist())
    if(users == nil){
        users = NSMutableArray()
    }
    var x:Int = 0
    var obj:String?
    for(var i=0;i<users!.count;i++){
        let item:NSDictionary = users?.objectAtIndex(i) as NSDictionary
        if((item.objectForKey("loginType") as String) == loginType){
            if(loginType == "sina_weibo" && (item.objectForKey("weibo_uid") as String) == uid){
                obj = item.objectForKey("userToken") as? String
                x = 1
                break
            }
            if(loginType == "tencent_qq" && (item.objectForKey("qq_uid") as String) == uid){
                obj = item.objectForKey("userToken") as? String
                x = 1
                break
            }
        }
    }
    if(x == 0){
        obj = gen_uuid()! as String
    }
    return obj!
}

func updateCurrentUserData(type:String){
    if(DataService.shareService.userToken != nil){
        var users = NSMutableArray(contentsOfFile: DataService.shareService.getUsersPlist())
        let token:String = DataService.shareService.userToken! as String
        println(token)
        if(users != nil){
            for(var i=0;i<users!.count;i++){
                var item:NSMutableDictionary = users?.objectAtIndex(i) as NSMutableDictionary
//                println(item.objectForKey("userToken"))
                if((item.objectForKey("userToken") as String) == token){
                    if(type=="update_share_num"){
                        var num:Int = item.objectForKey("shared_count") as Int
                        item.setValue(num + 1, forKey: "shared_count")
                    }
                    DataService.shareService.currentUser = item
                    
                    println("update share num")
                    break
                }
            }
        }
        users!.writeToFile(DataService.shareService.getUsersPlist(), atomically: true)
    }
}

