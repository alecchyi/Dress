//
//  Weather.swift
//  Dress
//
//  Created by Alec on 14/12/24.
//  Copyright (c) 2014年 Alec. All rights reserved.
//

import Foundation

class Weather {
    let _weather:String?
    let _weather_icon:String?
    let _city:String?
    let _temp:String?
    let _wind:String?
    let _dress:String?
    let _data:NSMutableDictionary?
    
    init(data:NSMutableDictionary) {
        self._data! = data
    }
    
    func anlysic(temp:String) -> String? {
        
        return ""
    }
}
