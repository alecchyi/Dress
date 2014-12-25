//
//  FirstViewController.swift
//  Clothes
//
//  Created by Alec on 14/12/14.
//  Copyright (c) 2014年 Alec. All rights reserved.
//

import UIKit
//import PickViewToolBar

class ClothViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initClothView()
    }
    
    func initClothView(){
        //add new btn
        var rightBarBtnItem = UIBarButtonItem(title:"add", style: UIBarButtonItemStyle.Plain, target: self, action: "clickAddBtn")
        self.navigationItem.rightBarButtonItem = rightBarBtnItem
        
        
    }
    
    func clickAddBtn(){
        var newClothViewController = NewClothViewController()
        newClothViewController.title = "添加衣服"
        
        self.navigationController?.pushViewController(newClothViewController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

