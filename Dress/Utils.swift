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
//    println("=======================")
//    println(user)
    var query = AVUser.query()
    let loginType:AnyObject? = user.objectForKey("loginType")
    if((loginType as? String) == "sina_weibo"){
        query.whereKey("weibo_id", equalTo:user.objectForKey("weibo_uid")!)
    }else if((loginType as? String) == "tencent_qq"){
        query.whereKey("qq_id", equalTo:user.objectForKey("qq_uid")!)
    }

    query.getFirstObjectInBackgroundWithBlock({(user_info:AVObject!,error:NSError!) in
        if(error == nil){
            var login_type:String = user_info.objectForKey("login_type") as String
            var username:AnyObject?
            if(login_type == "sina_weibo"){
                username = user_info.objectForKey("weibo_id")
            }else{
                username = user_info.objectForKey("qq_id")
            }
            AVUser.logInWithUsernameInBackground("\(username!)", password: "123456", block: {(obj:AVUser!,error:NSError!) in
                if(error == nil){
                    println("succcss login with av")
                    var currentUser = AVUser.currentUser()
                    println(user.objectForKey("friends_count"))
                    DataService.shareService.setUserToken(currentUser.objectForKey("userToken") as NSString)
                    let logintype:String = user.objectForKey("loginType") as String
                    if(logintype != ""){
                        currentUser.setObject(logintype, forKey: "login_type")
                    }
                    let access_token:AnyObject? = user.objectForKey("access_token")
                    if(access_token != nil) {
                        currentUser.setObject(access_token!, forKey: "access_token")
                    }
                    let qq_id:AnyObject? = user.objectForKey("qq_uid")
                    if(qq_id != nil) {
                        currentUser.setValue(qq_id!, forKey: "qq_id")
                    }
                    let weibo_id:AnyObject? = user.objectForKey("weibo_uid")
                    if(weibo_id != nil) {
                        currentUser.setObject(weibo_id!, forKey: "weibo_id")
                    }
                    
                    
                    let clothes_count:AnyObject? = user.objectForKey("clothes_count")
                    if(clothes_count != nil) {
                        currentUser.setObject(clothes_count!, forKey: "clothes_count")
                    }
                    let shared_count:AnyObject? = user.objectForKey("shared_count")
                    if(shared_count != nil) {
                        currentUser.setObject(shared_count!, forKey: "shared_count")
                    }
                    if(login_type == "sina_weibo"){
                        println("fetch user data")
                        let manager = DataService.shareService.requestManager()
                        let url = kWeiboApi + "2/users/show.json"
                        let uid:String = "\(weibo_id!)"
                        let token:String = "\(access_token!)"
                        let params = ["uid":"\(uid)","access_token":"\(token)"]
                        manager!.GET(url,
                            parameters:params,
                            success: {(operation:AFHTTPRequestOperation!, response:AnyObject!) in
                                let resp:NSDictionary = response as NSDictionary
//                                                println(resp)
                                let nickname:AnyObject? = resp.objectForKey("name")
                                if(nickname != nil){
                                    currentUser.setObject(nickname!, forKey: "nickname")
                                }
                                let header_url:AnyObject? = resp.objectForKey("profile_image_url")
                                if(header_url != nil) {
                                    currentUser.setObject(header_url!, forKey: "header_url")
                                }
                                let follwers:AnyObject? = resp.objectForKey("followers_count")
                                if(follwers != nil) {
                                    currentUser.setObject(follwers!, forKey: "followers_count")
                                }
                                let friends_count:AnyObject? = resp.objectForKey("friends_count")
                                if(friends_count != nil) {
                                    currentUser.setObject(friends_count!, forKey: "friends_count")
                                }
                                println("get user data successfully")
                                currentUser.saveInBackgroundWithBlock({(succeeded:Bool,error:NSError!) in
                                    if(succeeded){
                                        println("user update success")
                                    }else{
                                        println(error)
                                    }
                                })
                            },
                            failure: {(operation:AFHTTPRequestOperation!, error:NSError!) in
                                println("fetch user error")
                                println(error)
                        })
                    }else{
                        let nickname:AnyObject? = user.objectForKey("nickname")
                        if(nickname != nil){
                            currentUser.setObject(nickname!, forKey: "nickname")
                        }
                        let header_url:AnyObject? = user.objectForKey("profile_image_url")
                        if(header_url != nil) {
                            currentUser.setObject(header_url!, forKey: "header_url")
                        }
                        let follwers:AnyObject? = user.objectForKey("followers_count")
                        if(follwers != nil) {
                            currentUser.setObject(follwers!, forKey: "followers_count")
                        }
                        let friends_count:AnyObject? = user.objectForKey("friends_count")
                        if(friends_count != nil) {
                            currentUser.setObject(friends_count!, forKey: "friends_count")
                        }
                        currentUser.saveInBackgroundWithBlock({(succeeded:Bool,error:NSError!) in
                            if(succeeded){
                                println("user update success")
                            }else{
                                println(error)
                            }
                        })
                    }
                    NSNotificationCenter.defaultCenter().postNotificationName("finishedLogin", object: nil)
                    
                }else{
                    println("login error")
                }
                
            })
            
        }else{
            var newUser = AVUser()
            let uuid = gen_uuid()
            newUser.setObject(uuid!, forKey: "userToken")
            newUser.password = "123456"

            let nickname:AnyObject? = user.objectForKey("nickname")
            if(nickname != nil){
                newUser.setObject(nickname!, forKey: "nickname")
            }
            let login_type:String = user.objectForKey("loginType") as String
            if(login_type != ""){
                newUser.setObject(login_type, forKey: "login_type")
            }
            let header_url:AnyObject? = user.objectForKey("profile_image_url")
            if(header_url != nil) {
                newUser.setObject(header_url!, forKey: "header_url")
            }
            let qq_id:AnyObject? = user.objectForKey("qq_uid")
            if(qq_id != nil) {
                newUser.setObject(qq_id!, forKey: "qq_id")
            }
            let weibo_id:AnyObject? = user.objectForKey("weibo_uid")
            if(weibo_id != nil) {
                newUser.setObject(weibo_id!, forKey: "weibo_id")
            }
            var username:AnyObject?
            if(login_type == "sina_weibo"){
                username = weibo_id
            }else{
                username = qq_id
            }
            newUser.username = "\(username!)"
            let follwers:AnyObject? = user.objectForKey("followers_count")
            if(follwers != nil) {
                newUser.setObject(follwers!, forKey: "followers_count")
            }
            let friends_count:AnyObject? = user.objectForKey("friends_count")
            if(friends_count != nil) {
                newUser.setObject(friends_count!, forKey: "friends_count")
            }
            let clothes_count:AnyObject? = user.objectForKey("clothes_count")
            if(clothes_count != nil) {
                newUser.setObject(clothes_count!, forKey: "clothes_count")
            }
            let access_token:AnyObject? = user.objectForKey("access_token")
            if(access_token != nil) {
                newUser.setObject(access_token!, forKey: "access_token")
            }
            let shared_count:AnyObject? = user.objectForKey("shared_count")
            if(shared_count != nil) {
                newUser.setObject(shared_count!, forKey: "shared_count")
            }
            newUser.signUpInBackgroundWithBlock({(succeeded:Bool,error:NSError!) in
                if(succeeded){
                    setUserDir(uuid!)
                    var currentUser = AVUser.currentUser()
                    if(currentUser != nil){
                        if(login_type == "sina_weibo"){
                            println("fetch user data")
                            let manager = DataService.shareService.requestManager()
                            let url = kWeiboApi + "2/users/show.json"
                            let uid:String = "\(weibo_id!)"
                            let token:String = "\(access_token!)"
                            let params = ["uid":"\(uid)","access_token":"\(token)"]
                            manager!.GET(url,
                                parameters:params,
                                success: {(operation:AFHTTPRequestOperation!, response:AnyObject!) in
                                    let resp:NSDictionary = response as NSDictionary
                                    let nickname:AnyObject? = resp.objectForKey("name")
                                    if(nickname != nil){
                                        currentUser.setObject(nickname!, forKey: "nickname")
                                    }
                                    let header_url:AnyObject? = resp.objectForKey("profile_image_url")
                                    if(header_url != nil) {
                                        currentUser.setObject(header_url!, forKey: "header_url")
                                    }
                                    let follwers:AnyObject? = resp.objectForKey("followers_count")
                                    if(follwers != nil) {
                                        currentUser.setObject(follwers!, forKey: "followers_count")
                                    }
                                    let friends_count:AnyObject? = resp.objectForKey("friends_count")
                                    if(friends_count != nil) {
                                        currentUser.setObject(friends_count!, forKey: "friends_count")
                                    }
                                    currentUser.saveInBackgroundWithBlock({(succeeded:Bool,error:NSError!) in
                                        if(succeeded){
                                            println("user update success")
                                        }else{
                                            println(error)
                                        }
                                    })
                                },
                                failure: {(operation:AFHTTPRequestOperation!, error:NSError!) in
                                    println("fetch user error in resg")
                                    println(error)
                            })
                        }
                        DataService.shareService.setUserToken(uuid!)
                    }
                    NSNotificationCenter.defaultCenter().postNotificationName("finishedLogin", object: nil)
                }else{
                    println("register bad")
                }
            })
        }
    })

    return true
}

func userLogin(data:NSDictionary, type:Int){
    var user:NSMutableDictionary = NSMutableDictionary()
    if(type==1){
        //login with weibo
        user.setValue(data.objectForKey("uid"), forKey: "weibo_uid")
        user.setValue(data.objectForKey("access_token"), forKey: "access_token")
        user.setValue("sina_weibo", forKey: "loginType")
        user.setValue(0, forKey: "shared_count")
        saveUser(user)
    }else if(type==2){
        // login with qq
        user.setValue("tencent_qq", forKey: "loginType")
        user.setValue(data.objectForKey("access_token"), forKey: "access_token")
        user.setValue(data.objectForKey("uid"), forKey: "qq_uid")
        user.setValue(data.objectForKey("nickname"), forKey: "nickname")
        user.setValue(data.objectForKey("profile_image_url"), forKey: "profile_image_url")
        user.setValue(0, forKey: "followers_count")
        user.setValue(0, forKey: "friends_count")
        user.setValue(0, forKey: "shared_count")
        saveUser(user)
    }
}

func has_bind_weibo() -> Bool {
    if(DataService.shareService.userToken != nil){
        let currentUser = AVUser.currentUser()
        if(currentUser != nil){
            let login_type:String = currentUser?.objectForKey("login_type") as String
            if(login_type != "" && login_type == "sina_weibo"){
                return true
            }
        }
    }
    return false
}

func setCurrentUser(){
    
    if(DataService.shareService.userToken == nil){
        let currentUser = AVUser.currentUser()
        if(currentUser != nil){
            DataService.shareService.setUserToken(currentUser.objectForKey("userToken") as NSString)
        }
    }
}

func initDataDB(){
    let path = DataService.shareService.getDBPath()
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

func mainTagBgColor() -> UIColor {
    return UIColor(red: 241/255.0, green: 103/255.0, blue: 214/255.0, alpha: 1.0)
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
                }else{
                    println("fetch tags error")
                    println(err)
                }
            })
        }else{
            println("fetch system tags error")
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
//        var users = NSMutableArray(contentsOfFile: DataService.shareService.getUsersPlist())
//        let token:String = DataService.shareService.userToken! as String
//        println(token)
//        if(users != nil){
//            for(var i=0;i<users!.count;i++){
//                var item:NSMutableDictionary = users?.objectAtIndex(i) as NSMutableDictionary
////                println(item.objectForKey("userToken"))
//                if((item.objectForKey("userToken") as String) == token){
//                    if(type=="update_share_num"){
//                        var num:Int = item.objectForKey("shared_count") as Int
//                        item.setValue(num + 1, forKey: "shared_count")
//                    }
//                    DataService.shareService.currentUser = item
//                    
//                    println("update share num")
//                    break
//                }
//            }
//        }
//        users!.writeToFile(DataService.shareService.getUsersPlist(), atomically: true)
        var currentUser = AVUser.currentUser()
        if(type=="update_share_num"){
            var num:Int = currentUser.objectForKey("shared_count") as Int
            currentUser.setObject(num + 1, forKey: "shared_count")
            currentUser.saveInBackground()
        }
    }
    
}

func save_capture_img(img:NSData) -> String {
    let fileManager = NSFileManager.defaultManager()
    let storeFilePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
    var documentDir = storeFilePath[0] as String
    let name = gen_uuid()! as String
    let path = documentDir.stringByAppendingPathComponent(name + ".jpg")
    if(!fileManager.fileExistsAtPath(path)){
        fileManager.createFileAtPath(path, contents: img, attributes: nil)
    }
    return path
}

