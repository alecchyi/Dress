//
//  FirstViewController.swift
//  Clothes
//
//  Created by Alec on 14/12/14.
//  Copyright (c) 2014年 Alec. All rights reserved.
//

import UIKit
//import PickViewToolBar

class ClothViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,PickViewToolBarDelegate {
    
    @IBOutlet var tagView:UIView?
    @IBOutlet var categoryBtn:UIButton?
    @IBOutlet var seasonBtn:UIButton?
    @IBOutlet var photoSeg:UISegmentedControl?
    @IBOutlet var photoImgView:UIImageView?
    @IBOutlet var advImgView:UIImageView?
    @IBOutlet var addClothView:UIView?
    @IBOutlet var lblCategory:UILabel?
    @IBOutlet var lblSeason:UILabel?
    
    let categories = ["帽子","上衣","裤子","鞋子"] as [String]

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
        
        
    }
    
    @IBAction func clickCategoryTextField(){
        println(2222)
        UIView.animateWithDuration(0.3, delay: 0.0, options:UIViewAnimationOptions.CurveEaseOut, animations:{
            var frame = UIScreen.mainScreen().bounds
            frame.origin.y = frame.size.height - 244
            frame.size.height = 200
            var pickView = PickViewToolBar(frame: frame)
            pickView.tag = 1024
            pickView.pickerView?.delegate = self
            pickView.pickerView?.dataSource = self
            pickView.delegate = self
            self.view!.addSubview(pickView)
            self.view!.bringSubviewToFront(pickView)
            println(4444)
            }, completion:{(BOOL isFinished) in
                if(isFinished){
                println(555)
                }else{
                    println(666)
                }
        
        })
        
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
        
        self.lblCategory!.tag = 1000 + row
    }
    
    func clickCancelBtn() {
        let subviews = self.view!.subviews
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
    
    func clickDoneBtn(){
        let row = self.lblCategory!.tag - 1000
        self.lblCategory!.text = self.categories[row]
        clickCancelBtn()
    }

}

