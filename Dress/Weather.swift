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
    
    init(data:NSMutableDictionary?) {
        self._data = data!
        self._temp = data!.objectForKey("temp") as? String
        self._wind = data!.objectForKey("wind") as? String
        self._weather = data!.objectForKey("weatherDesc") as? String
        self._dress = data!.objectForKey("dress") as? String
        self._city = data!.objectForKey("currentCity") as? String
        self._weather_icon = nil
        
    }
    
    func anlysic() -> NSArray? {
        //header when temp <=5 need hat
        let idx = advance(self._temp!.endIndex, -1)
        let temp = self._temp!.substringToIndex(idx) as NSString
        var hasHat:Int = 0
        if(temp.intValue <= 5){
            hasHat = 1
        }
        //shirt according the temp and season of date
        let month:NSDate = NSDate()
        let formate = NSDateFormatter()
        formate.dateFormat = "Mdd"
        let day = formate.stringFromDate(month).toInt()
        var season:Int = 0
        if(day! <= 621 && day! > 320){
            season = 0
        }else if(day!>621 && day! <= 923){
            season = 1
        }else if(day! > 923 && day! <= 1221){
            season = 2
        }else{
            season = 3
        }
        
        return [hasHat,season]
    }
}
