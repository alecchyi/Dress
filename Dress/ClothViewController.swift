//
//  FirstViewController.swift
//  Clothes
//
//  Created by Alec on 14/12/14.
//  Copyright (c) 2014年 Alec. All rights reserved.
//

import UIKit
//import PickViewToolBar

class ClothViewController: UIViewController, NewClothViewControllerDelegate {
    
    @IBOutlet var clothesCollectView:UICollectionView?
    @IBOutlet var tagsView:UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initClothView()
    }
    
    func initClothView(){
        //add new btn
        var rightBarBtnItem = UIBarButtonItem(title:"add", style: UIBarButtonItemStyle.Plain, target: self, action: "clickAddBtn")
        self.navigationItem.rightBarButtonItem = rightBarBtnItem
        
        //init clothes view
        var frame = self.view.frame
        self.tagsView?.frame.size.width = frame.size.width
        self.clothesCollectView?.frame.size.width = frame.size.width
        
        
    }
    
    func clickAddBtn(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        var newClothViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("newClothViewController") as NewClothViewController
        newClothViewController.newClothDelegate = self
        self.presentViewController(newClothViewController, animated: true, completion: {
        
        })
    }
    
    func dismissModelView() {
        println("dismiss")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

