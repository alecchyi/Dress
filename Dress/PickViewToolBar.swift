//
//  PickViewToolBar.swift
//  Dress
//
//  Created by Alec on 14-12-25.
//  Copyright (c) 2014年 Alec. All rights reserved.
//

import Foundation

protocol PickViewToolBarDelegate {
    func clickCancelBtn()
    func clickDoneBtn()
}
protocol PickViewToolBarDataSource {
}

class PickViewToolBar:UIView,UIPickerViewDataSource {

    let pickerView:UIPickerView?
    let toolBar:UIToolbar?
    var delegate:PickViewToolBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        println("sssssss")
        self.backgroundColor = UIColor.grayColor()
        self.pickerView = UIPickerView(frame: CGRectMake(0, 44, frame.size.width, frame.size.height - 44))
        self.toolBar = UIToolbar(frame: CGRectMake(0, 0, frame.size.width, 44))
        self.toolBar?.barStyle = UIBarStyle.Default
        var leftBtnItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "clickCancelBtn")
        var fixedBtnItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        var rightBtnItem = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Plain, target: self, action: "clickDoneBtn")
        var array = [leftBtnItem,fixedBtnItem,rightBtnItem]
        
        self.toolBar?.setItems(array, animated: true)
        self.addSubview(self.toolBar!)
        self.addSubview(self.pickerView!)
        
    }

    func clickCancelBtn(){
        if(self.respondsToSelector("clickCancelBtn")){
            println(333222)
            delegate?.clickCancelBtn()
        }
        
    }
    
    func clickDoneBtn(){
        if(self.respondsToSelector("clickDoneBtn")){
            delegate?.clickDoneBtn()
        }
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    
}