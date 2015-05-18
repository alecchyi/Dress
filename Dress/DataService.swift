//
//  DataLoader.swift
//  Clothes
//
//  Created by Alec on 14/12/22.
//  Copyright (c) 2014年 Alec. All rights reserved.
//

import Foundation
import CoreLocation

let _SingletonInstance:DataService = DataService()

class DataService {
    
    var _url:String?
    var managers:[AnyObject] = [0,1]
    var userToken:String? = nil
    var weather:NSMutableDictionary?
    var currentUser:NSMutableDictionary? = nil
    
    class var shareService: DataService {
        return _SingletonInstance
    }
    
    func locationManager() -> CLLocationManager? {
        if((self.managers[0] as? CLLocationManager) == nil){
            self.managers[0] = CLLocationManager()
        }
        return self.managers[0] as? CLLocationManager
    }
    
    func requestManager() -> AFHTTPRequestOperationManager? {
        if((self.managers[1] as? AFHTTPRequestOperationManager) == nil){
            self.managers[1] = AFHTTPRequestOperationManager()
        }
        return self.managers[1] as? AFHTTPRequestOperationManager
    }
    
    func requestByUrl(params:NSMutableDictionary) {
        
    }
    
    func setUserToken(token:NSString){
        if(self.userToken == nil){
            self.userToken = token as String
            var userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setValue(token, forKey: "userToken")
        }
    }
    
    func setWeather(data:NSMutableDictionary){
        if(self.weather == nil){
            self.weather = data
        }
    }
    
    func getUserClothPlist() -> String{
        let fileManager = NSFileManager.defaultManager()
        let storeFilePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        var documentDir = storeFilePath[0] as! String
        let path = documentDir.stringByAppendingPathComponent(DataService.shareService.userToken! + "/" + kClothPlist)
        if(!fileManager.fileExistsAtPath(path)){
            fileManager.createFileAtPath(path, contents: nil, attributes: nil)
        }
        return path
    }
    
    func getUserClothDirPath() -> String{
        let fileManager = NSFileManager.defaultManager()
        let storeFilePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        var documentDir = storeFilePath[0] as! String
        let path = documentDir.stringByAppendingPathComponent(DataService.shareService.userToken! + "/Clothes")
        var isDir:ObjCBool = false
        if(!fileManager.fileExistsAtPath(path, isDirectory: &isDir)){
            fileManager.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil, error: nil)
        }
        return path
    }
    
    func getTagsPlist() -> String{
        let fileManager = NSFileManager.defaultManager()
        let storeFilePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        var documentDir = storeFilePath[0] as! String
        let path = documentDir.stringByAppendingPathComponent(DataService.shareService.userToken! + "/" + kTagPlist)
        if(!fileManager.fileExistsAtPath(path)){
            fileManager.createFileAtPath(path, contents: nil, attributes: nil)
        }
        return path
    }
    
    func getWeatherPlist() -> String{
        let fileManager = NSFileManager.defaultManager()
        let storeFilePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        var documentDir = storeFilePath[0] as! String
        let path = documentDir.stringByAppendingPathComponent(kWeatherPlist)
        if(!fileManager.fileExistsAtPath(path)){
            fileManager.createFileAtPath(path, contents: nil, attributes: nil)
        }
        return path
    }
    
    func getUsersPlist() -> String{
        let fileManager = NSFileManager.defaultManager()
        let storeFilePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        var documentDir = storeFilePath[0] as! String
        let path = documentDir.stringByAppendingPathComponent(kUsersPlist)
        if(!fileManager.fileExistsAtPath(path)){
            fileManager.createFileAtPath(path, contents: nil, attributes: nil)
        }
        return path
    }
    
    func getRecommandClothes(data:NSMutableDictionary?) -> NSArray? {

        var weather:Weather = Weather(data: data!)
        let result = weather.anlysic() as NSArray!
//        println(result!)
        let myClothes = NSArray(contentsOfFile: DataService.shareService.getUserClothPlist())
        var headArr = NSMutableArray()
        var shirtArr = NSMutableArray()
        var trouserArr = NSMutableArray()
        var shoesArr = NSMutableArray()
        if let x = myClothes {
            for cloth in myClothes! {
                let season = cloth.objectForKey("season") as! Int
                let type = cloth.objectForKey("type") as! Int
                if(season == (result!.objectAtIndex(1) as! Int)){
                    if(type == 0 && (result!.objectAtIndex(0) as! Int) == 1){
                        headArr.addObject(cloth)
                    }else if(type == 1){
                        shirtArr.addObject(cloth)
                    }else if(type == 2){
                        trouserArr.addObject(cloth)
                    }else if(type == 3){
                        shoesArr.addObject(cloth)
                    }
                }
            }
        }
        return [headArr,shirtArr,trouserArr,shoesArr]
    }
    
    func getDBPath() -> String{
        let fileManager = NSFileManager.defaultManager()
        let storeFilePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        var documentDir = storeFilePath[0] as! String
        let path = documentDir.stringByAppendingPathComponent(kDBName)
        if(!fileManager.fileExistsAtPath(path)){
            fileManager.createFileAtPath(path, contents: nil, attributes: nil)
            
            let db = SQLiteDB.sharedInstance()
            let y = db.execute("drop table if exists infos", parameters: nil)
            println("y=\(y)")
            let x = db.execute("CREATE  TABLE 'infos' ('id' INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , 'user_token' VARCHAR NOT NULL  UNIQUE , 'content' VARCHAR, 'title' VARCHAR, 'user_id' varchar,'sourceType' varchar, 'small_img_url' varchar,'thumb_img_url' varchar,'link' varchar, 'created_at' datetime,'status' integer not null default 0, 'likes_count' integer default 0, 'shared_count' integer default 0,'author_name' varchar,'author_avatar_url' varchar,'tag_id' integer)", parameters: nil)
            println("x=\(x)")
        }
        return path
    }
    
}
