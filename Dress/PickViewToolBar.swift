//
//  PickViewToolBar.swift
//  Dress
//
//  Created by Alec on 14-12-25.
//  Copyright (c) 2014年 Alec. All rights reserved.
//

import Foundation

protocol PickViewToolBarDelegate {
    func clickToolBarCancelBtn()
    func clickToolBarDoneBtn()
}
protocol PickViewToolBarDataSource {
}

class PickViewToolBar:UIView {

    let pickerView:UIPickerView?
    let toolBar:UIToolbar?
    var delegate:PickViewToolBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.backgroundColor = UIColor.whiteColor()
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
            delegate?.clickToolBarCancelBtn()
        }
        
    }
    
    func clickDoneBtn(){
        if(self.respondsToSelector("clickDoneBtn")){
            delegate?.clickToolBarDoneBtn()
        }
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    
}