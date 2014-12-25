//
//  NewCloth.swift
//  Dress
//
//  Created by Alec on 14/12/25.
//  Copyright (c) 2014年 Alec. All rights reserved.
//

import UIKit

class NewClothViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,PickViewToolBarDelegate {
    
    @IBOutlet var tagView:UIView?
    @IBOutlet var categoryBtn:UIButton?
    @IBOutlet var seasonBtn:UIButton?
    @IBOutlet var photoSeg:UISegmentedControl?
    @IBOutlet var photoImgView:UIImageView?
    @IBOutlet var advImgView:UIImageView?
    @IBOutlet var addClothView:UIView?
    @IBOutlet var lblCategory:UILabel?
    @IBOutlet var lblSeason:UILabel?
    
    var categories = ["帽子","上衣","裤子","鞋子"] as [String]
    var pickViewType:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initClothView()
    }
    
    func initClothView(){
        //add save btn
        var rightBarBtnItem = UIBarButtonItem(title:"save", style: UIBarButtonItemStyle.Done, target: self, action: "clickSaveBtn")
        self.navigationItem.rightBarButtonItem = rightBarBtnItem
        self.lblCategory?.tag = 1000
        self.lblSeason?.tag = 1100
        
//        self.view.backGroundColor = UIColor.
        
        
    }
    
    func showToolBar(){
        hideToolBar()
        UIView.animateWithDuration(0.3, delay: 0.0, options:UIViewAnimationOptions.CurveEaseOut, animations:{
            var frame = UIScreen.mainScreen().bounds
            frame.origin.y = frame.size.height - 244
            frame.size.height = 200
            var pickView = PickViewToolBar(frame: frame)
            pickView.tag = 1024
            pickView.pickerView?.delegate = self
            pickView.pickerView?.dataSource = self
            pickView.delegate = self
            self.view.addSubview(pickView)
            self.view.bringSubviewToFront(pickView)
            }, completion:{(BOOL isFinished) in
                
        })
    }
    
    @IBAction func clickCategoryBtn(){
        self.categories = ["帽子","上衣","裤子","鞋子"]
        self.pickViewType = 0
        showToolBar()
        
    }
    
    @IBAction func clickSeasonBtn(){
        self.categories = ["春季","夏季","秋季","冬季"];
        self.pickViewType = 1
        showToolBar()
        
    }
    
    @IBAction func clickSaveBtn(){
        println("saving")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.categories.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return self.categories[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        println(self.categories[row])
        if(self.pickViewType==0){
            self.lblCategory!.tag = 1000 + row
            self.lblSeason!.tag = 1100
        }else{
            self.lblCategory!.tag = 1000
            self.lblSeason!.tag = 1100 + row
        }
    }
    
    func hideToolBar(){
        let subviews = self.view.subviews
        for subview in subviews as [UIView] {
            if(subview.tag==1024){
                UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                    subview.removeFromSuperview()
                    }, completion: {(BOOL isFinished) in
                })
                subview.removeFromSuperview()
                break
            }
        }
    }
    func clickCancelBtn() {
        hideToolBar()
    }
    
    func clickDoneBtn(){
        let row = self.pickViewType == 0 ? self.lblCategory!.tag - 1000 : self.lblSeason!.tag - 1100
        if(self.pickViewType==0){
            self.lblCategory!.text = self.categories[row]
        }else{
            self.lblSeason!.text = self.categories[row]
        }
        
        clickCancelBtn()
    }
    
}

