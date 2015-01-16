//
//  RulerViewBar.swift
//  Dress
//
//  Created by Alec on 15/1/17.
//  Copyright (c) 2015年 Alec. All rights reserved.
//

import UIKit

class RulerViewBar: UIView {

    override init(frame:CGRect) {
        super.init(frame:frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    func setRulerView(){
    
    }
    
    override func drawRect(rect: CGRect) {
        println(4433333)
        var context = UIGraphicsGetCurrentContext()
        CGContextSetRGBStrokeColor(context,0.1,0.1,0.1,1.0)
        CGContextMoveToPoint(context,0,2)
        CGContextAddLineToPoint(context, 18, 2)
        
        CGContextMoveToPoint(context,0,2)
        CGContextAddLineToPoint(context, 0, 400)
        
        CGContextMoveToPoint(context,0,400)
        CGContextAddLineToPoint(context, 18, 400)
        
        for var i=1;i<15;i++ {
            let y:CGFloat = CGFloat(i * 25)
            if(i%2 == 0){
                CGContextMoveToPoint(context,0, y)
                CGContextAddLineToPoint(context, 18, y)
            }else{
                CGContextMoveToPoint(context,0,y)
                CGContextAddLineToPoint(context, 10, y)
            }
        }
        CGContextStrokePath(context)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
