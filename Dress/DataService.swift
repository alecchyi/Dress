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

    var _url : String?
    var managers:[AnyObject] = [0,1]
    
    class var shareService: DataService {
        
        return _SingletonInstance
    }
    
    func locationManager() -> CLLocationManager? {
        if((self.managers[0] as? CLLocationManager)? == nil){
            self.managers[0] = CLLocationManager()
        }
        return self.managers[0] as? CLLocationManager
    }
    
    func requestManager() -> AFHTTPRequestOperationManager? {
        if((self.managers[1] as? AFHTTPRequestOperationManager)? == nil){
            self.managers[1] = AFHTTPRequestOperationManager()
        }
        return self.managers[1] as? AFHTTPRequestOperationManager
    }

    func requestByUrl(params:NSMutableDictionary) {
        

    }
}
