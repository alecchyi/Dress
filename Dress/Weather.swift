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
        self._temp = data!.objectForKey("temp") as NSString!
        self._wind = data!.objectForKey("wind") as NSString!
        self._weather = data!.objectForKey("weatherDesc") as NSString!
        self._dress = data!.objectForKey("dress") as NSString!
        self._city = data!.objectForKey("currentCity") as NSString!
        
    }
    
    func anlysic() -> String? {
        //header when temp <=5 need hat
        let idx = advance(self._temp!.endIndex, -1)
        println(self._temp?.substringToIndex(idx))
        let temp = self._temp!.substringToIndex(idx) as NSString
        if(temp.intValue <= 5){
            println("need hat")
        }
        //shirt according the temp and season of date
        let calendar = NSCalendar.currentCalendar()
        println(calendar.monthSymbols)
        return ""
    }
}
