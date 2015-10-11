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
    var selectedTags:NSMutableArray?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTabbarItem()
        
        initClothView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        var frame = UIScreen.mainScreen().bounds
        frame.origin.x = 0
        frame.origin.y = 114
        frame.size.height = get_screen_height() - 114 - 44
        self.clothesCollectView!.frame = frame
    }
    
    func initTabbarItem(){
        let tabbarImg:UIImage = UIImage(named: "clothes_icon")!
        tabbarImg.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.navigationController?.tabBarItem = UITabBarItem(title: "衣橱", image: tabbarImg, selectedImage: tabbarImg)
    }
    
    func initClothView(){
        //add new btn
        var rightBarBtnItem = UIBarButtonItem(title:"添加", style: UIBarButtonItemStyle.Plain, target: self, action: "clickAddBtn")
        rightBarBtnItem.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = rightBarBtnItem
        
        //init clothes view
        var frame = UIScreen.mainScreen().bounds
        frame.origin.x = 0
        frame.origin.y = 114
        frame.size.height = get_screen_height() - 114 - 44
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
//        sheet.addButtonWithTitle("编辑")
        sheet.addButtonWithTitle("删除")
        sheet.title = "操作"
        sheet.delegate = self
        sheet.tag = 3000 + tag - 2000
        sheet.showInView(self.view)
    }
    
    func initTagView(){
        for view:AnyObject in self.tagsView!.subviews {
            if view is UIScrollView {
                view.removeFromSuperview()
                break
            }
        }
        self.selectedTags = NSMutableArray()
        var allTags = NSMutableArray(contentsOfFile: DataService.shareService.getTagsPlist())
        if(allTags != nil){
            var scrollView = UIScrollView(frame: self.tagsView!.bounds)
            scrollView.scrollsToTop = false
            scrollView.showsVerticalScrollIndicator = false
            scrollView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.decelerationRate = 0.3
            self.tagsView!.addSubview(scrollView)
            
            var sWidth:CGFloat = 0.0
            for var i:Int = 0; i < allTags?.count; i++ {
                var x:CGFloat = CGFloat(40) + CGFloat(i * 80)
                var frame:CGRect = CGRectMake(x, 12, 60, 26)
                var btn = UIButton(frame: frame)
                sWidth += frame.size.width + 30
                btn.setTitle((allTags?.objectAtIndex(i) as! NSDictionary).objectForKey("name") as? String, forState: UIControlState.Normal)
                btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                btn.titleLabel?.font = UIFont.systemFontOfSize(14.0)
                btn.backgroundColor = UIColor(red: 241/255.0, green: 103/255.0, blue: 214/255.0, alpha: 1.0)
                btn.layer.cornerRadius = frame.size.height * 0.5
                btn.setTitleColor(UIColor.brownColor(), forState: UIControlState.Highlighted)
                btn.addTarget(self, action: "seletedTagBtn:", forControlEvents: UIControlEvents.TouchUpInside)
                var item:NSDictionary = allTags?.objectAtIndex(i) as! NSDictionary
                btn.tag = 5000 + (item.objectForKey("tagId") as! Int)
                
                scrollView.addSubview(btn)
                var scrollSize:CGSize = scrollView.contentSize as CGSize
                scrollSize.width = sWidth
                scrollView.contentSize = scrollSize
            }
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
    }
    
    func clickAddBtn(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        var newClothViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("newClothViewController") as! NewClothViewController
        newClothViewController.newClothDelegate = self
        var navModelController = UINavigationController(rootViewController: newClothViewController)
        navModelController.navigationBar.barTintColor = mainNavBarColor()
        self.presentViewController(navModelController, animated: true, completion: {
            newClothViewController.selectedTags = NSMutableArray()
        })
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:ClothViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("ClothViewCell", forIndexPath: indexPath) as! ClothViewCell
        var cloth = self.clothesList!.objectAtIndex(indexPath.row) as! NSMutableDictionary
        var picPath = cloth.objectForKey("picPath") as! String
        var path = DataService.shareService.getUserClothDirPath().stringByAppendingPathComponent(picPath)
        let season = cloth.objectForKey("season") as! Int
        let type = cloth.objectForKey("type") as! Int
        cell.imageView!.image = UIImage(contentsOfFile: path)
        cell.lblText!.text = kSeasons[season] + " " + kCategories[type]
        
        cell.tag = 2000 + indexPath.row
        var longGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "longTapCell:")
        longGesture.delegate = self
        longGesture.numberOfTouchesRequired = 1
        longGesture.allowableMovement = 50.0
        longGesture.minimumPressDuration = 1.0
        cell.addGestureRecognizer(longGesture)
        
        var tapImgGesture = UITapGestureRecognizer(target: self, action: "tapImgGesture:")
        cell.imageView?.addGestureRecognizer(tapImgGesture)
        
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
        if(buttonIndex == 0){
            
        }else if(buttonIndex == 1){
            println("delete:\(actionSheet.tag)")
            let selectedIndex:Int = (actionSheet.tag - 3000) as Int
            deleteFileForPath(selectedIndex)
            
        }
    }

    func deleteFileForPath(row:Int){
        var cloth = self.clothesList!.objectAtIndex(row) as! NSMutableDictionary
        var picPath = cloth.objectForKey("picPath") as! String
        var path = DataService.shareService.getUserClothDirPath().stringByAppendingPathComponent(picPath)
        let fileManager = NSFileManager.defaultManager()
        if(fileManager.fileExistsAtPath(path)){
            fileManager.removeItemAtPath(path, error: nil)
            self.clothesList!.removeObjectAtIndex(row)
            self.clothesCollectView!.reloadData()
            self.clothesList!.writeToFile(DataService.shareService.getUserClothPlist(), atomically: true)
        }
    }
    
    func seletedTagBtn(sender:UIButton){
        if(self.selectedTags?.containsObject(sender.tag) == true){
            self.selectedTags?.removeObject(sender.tag)
            sender.backgroundColor = mainTagBgColor()
        }else{
            self.selectedTags?.addObject(sender.tag)
            sender.backgroundColor = UIColor.brownColor()
        }
        
        var allClothes = NSMutableArray(contentsOfFile: DataService.shareService.getUserClothPlist())
        if(allClothes == nil){
            allClothes = NSMutableArray()
        }
        if(self.selectedTags?.count>0){
            var clothes = NSMutableArray()
            for(var i=0;i<allClothes?.count;i++){
                let cloth:NSDictionary = allClothes?.objectAtIndex(i) as! NSDictionary
                let tags:NSArray = cloth.objectForKey("tags") as! NSArray
                for(var j=0;j<self.selectedTags?.count;j++){
                    let tag:Int = self.selectedTags?.objectAtIndex(j) as! Int
                    if(tags.containsObject(tag - 5000)){
                        clothes.addObject(cloth)
                        break
                    }
                }
            }
            allClothes = clothes
        }
        self.clothesList = allClothes
        self.clothesCollectView?.reloadData()
    }
    
    func tapImgGesture(sender:UITapGestureRecognizer){
        let imgView:UIImageView = sender.view as! UIImageView
        var info = JTSImageInfo()
        info.image = imgView.image
        info.referenceRect = imgView.frame
        info.referenceView = imgView.superview
        info.referenceContentMode = imgView.contentMode
        info.referenceCornerRadius = imgView.layer.cornerRadius
        
        var imgViewer = JTSImageViewController(imageInfo: info, mode: JTSImageViewControllerMode.Image, backgroundStyle: JTSImageViewControllerBackgroundOptions.Scaled)
        
        imgViewer.showFromViewController(self, transition: JTSImageViewControllerTransition._FromOriginalPosition)
    }
}

