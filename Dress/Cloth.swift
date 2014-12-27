//
//  Cloth.swift
//  Dress
//
//  Created by Alec on 14/12/24.
//  Copyright (c) 2014年 Alec. All rights reserved.
//

import Foundation

class Cloth {
    var _picPath:String?
    var _tags:[AnyObject]?
    var _season:Int = 0
    var _cloth_type:Int = 0
    
    init(params:NSMutableDictionary) {
        self._picPath? = params.objectForKey("picPath") as String
        self._cloth_type = params.objectForKey("type") as Int
        self._season = params.objectForKey("season") as Int
        self._tags = params.objectForKey("tags") as [Int]
        
        
    }
    
    func add() {
        
    }
    
    
}