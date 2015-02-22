//
//  FirstViewController.swift
//  Clothes
//
//  Created by Alec on 14/12/14.
//  Copyright (c) 2014年 Alec. All rights reserved.
//

import UIKit
//import PickViewToolBar

class ClothViewController: UIViewController, NewClothViewControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIActionSheetDelegate,UIGestureRecognizerDelegate {
    
    @IBOutlet var clothesCollectView:UICollectionView?
    @IBOutlet var tagsView:UIView?
    
    var clothesList:NSMutableArray?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTabbarItem()
        
        initClothView()
    }
    
    func initTabbarItem(){
        let tabbarImg:UIImage = UIImage(named: "clothes_icon.png")!
        tabbarImg.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.navigationController?.tabBarItem = UITabBarItem(title: "衣橱", image: tabbarImg, selectedImage: tabbarImg)
    }
    
    func initClothView(){
        //add new btn
        var rightBarBtnItem = UIBarButtonItem(title:"添加", style: UIBarButtonItemStyle.Plain, target: self, action: "clickAddBtn")
        rightBarBtnItem.tintColor = mainBtnColor()
        self.navigationItem.rightBarButtonItem = rightBarBtnItem
        
        //init clothes view
        var frame = UIScreen.mainScreen().bounds
        frame.origin.x = 0
        frame.origin.y = 114
        frame.size.height = 400
        self.tagsView!.frame.size.width = frame.size.width
        self.clothesCollectView!.frame = frame
        
        frame.size.height = 50
        frame.origin.x = 0
        frame.origin.y = 64
//        self.tagsView = TagToolBar(frame: frame)
        if(DataService.shareService.userToken == nil){
        
        }else{
            initTagView()
            initCollectView()
            
            
        }
    }
    
    func initMenuView(tag:Int){
        
        var sheet:UIActionSheet = UIActionSheet()
        sheet.addButtonWithTitle("取消")
        sheet.addButtonWithTitle("编辑")
        sheet.addButtonWithTitle("删除")
        sheet.title = "操作"
        sheet.delegate = self
        sheet.tag = 3000 + tag - 2000
        sheet.showInView(self.view)
    }
    
    func initTagView(){
        self.tagsView!.backgroundColor = mainColor()

        for view:AnyObject in self.tagsView!.subviews {
            if view is UIScrollView {
                view.removeFromSuperview()
                break
            }
        }
        var allTags = NSMutableArray(contentsOfFile: DataService.shareService.getTagsPlist())
        if(allTags != nil){
            var scrollView = UIScrollView(frame: self.tagsView!.bounds)
            scrollView.scrollsToTop = false
            scrollView.showsVerticalScrollIndicator = false
            scrollView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
            scrollView.showsHorizontalScrollIndicator = false
            
            self.tagsView!.addSubview(scrollView)
            
            var sWidth:CGFloat = 0.0
            for var i:Int = 0; i < allTags?.count; i++ {
                var x:CGFloat = CGFloat(40) + CGFloat(i * 80)
                var frame:CGRect = CGRectMake(x, 12, 60, 26)
                var btn = UIButton(frame: frame)
                sWidth += frame.size.width + 30
                btn.setTitle((allTags?.objectAtIndex(i) as NSDictionary).objectForKey("name") as? String, forState: UIControlState.Normal)
                btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                btn.titleLabel?.font = UIFont.systemFontOfSize(14.0)
                btn.backgroundColor = UIColor(red: 241/255.0, green: 103/255.0, blue: 214/255.0, alpha: 1.0)
                btn.layer.cornerRadius = frame.size.height * 0.5
                
                scrollView.addSubview(btn)
                var scrollSize:CGSize = scrollView.contentSize as CGSize
                scrollSize.width = sWidth
                scrollView.contentSize = scrollSize
            }
        }else{
            println(4343434)
        }
    }
    
    func initCollectView(){
        var allClothes = NSMutableArray(contentsOfFile: DataService.shareService.getUserClothPlist())
        if(allClothes == nil){
            allClothes = NSMutableArray()
        }
        self.clothesList = allClothes!
        self.clothesCollectView!.registerClass(ClothViewCell.self, forCellWithReuseIdentifier: "ClothViewCell")
        self.clothesCollectView!.delegate = self
        self.clothesCollectView!.dataSource = self
//        self.clothesCollectView!.backgroundColor = UIColor.blackColor()
    }
    
    func clickAddBtn(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        var newClothViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("newClothViewController") as NewClothViewController
        newClothViewController.newClothDelegate = self
        self.presentViewController(newClothViewController, animated: true, completion: {
        
        })
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:ClothViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("ClothViewCell", forIndexPath: indexPath) as ClothViewCell
        var cloth = self.clothesList!.objectAtIndex(indexPath.row) as NSMutableDictionary
        var picPath = cloth.objectForKey("picPath") as String
        var path = DataService.shareService.getUserClothDirPath().stringByAppendingPathComponent(picPath)
        let season = cloth.objectForKey("season") as Int
        let type = cloth.objectForKey("type") as Int
        cell.imageView!.image = UIImage(contentsOfFile: path)
        cell.lblText!.text = kSeasons[season] + " " + kCategories[type]
        
        cell.tag = 2000 + indexPath.row
        var longGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "longTapCell:")
        longGesture.delegate = self
        longGesture.numberOfTouchesRequired = 1
        longGesture.allowableMovement = 50.0
        longGesture.minimumPressDuration = 1.0
        cell.addGestureRecognizer(longGesture)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.clothesList!.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    func dismissModelView() {
        println("dismiss")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if(DataService.shareService.userToken==nil){
        
        }else{
            initTagView()
            var allClothes = NSMutableArray(contentsOfFile: DataService.shareService.getUserClothPlist())
            if(allClothes == nil){
                allClothes = NSMutableArray()
            }
            self.clothesList = allClothes!
            self.clothesCollectView!.reloadData()
        }
    }
    
    
    
    func longTapCell(sender:UILongPressGestureRecognizer){
        if(sender.state == UIGestureRecognizerState.Began){
            let tag = sender.view?.tag
            initMenuView(tag!)
        }
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if(buttonIndex == 1){
            
        }else if(buttonIndex == 2){
            println("delete:\(actionSheet.tag)")
            let selectedIndex:Int = (actionSheet.tag - 3000) as Int
            deleteFileForPath(selectedIndex)
            
        }
    }

    func deleteFileForPath(row:Int){
        var cloth = self.clothesList!.objectAtIndex(row) as NSMutableDictionary
        var picPath = cloth.objectForKey("picPath") as String
        var path = DataService.shareService.getUserClothDirPath().stringByAppendingPathComponent(picPath)
        let fileManager = NSFileManager.defaultManager()
        if(fileManager.fileExistsAtPath(path)){
            fileManager.removeItemAtPath(path, error: nil)
            self.clothesList!.removeObjectAtIndex(row)
            self.clothesCollectView!.reloadData()
            self.clothesList!.writeToFile(DataService.shareService.getUserClothPlist(), atomically: true)
        }
    }
}

