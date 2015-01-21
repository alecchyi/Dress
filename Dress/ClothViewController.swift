//
//  FirstViewController.swift
//  Clothes
//
//  Created by Alec on 14/12/14.
//  Copyright (c) 2014年 Alec. All rights reserved.
//

import UIKit
//import PickViewToolBar

class ClothViewController: UIViewController, NewClothViewControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet var clothesCollectView:UICollectionView?
    @IBOutlet var tagsView:UIView?
    
    var clothesList:NSMutableArray?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initClothView()
    }
    
    func initClothView(){
        //add new btn
        var rightBarBtnItem = UIBarButtonItem(title:"添加", style: UIBarButtonItemStyle.Plain, target: self, action: "clickAddBtn")
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
        initTagView()
        initCollectView()
    }
    
    func initTagView(){
        var allTags = NSMutableArray(contentsOfFile: DataService.shareService.getTagsPlist())
        if(allTags == nil){
            var tag:NSMutableDictionary = NSMutableDictionary()
            tag.setValue(0, forKey: "id")
            tag.setValue("运动", forKey: "name")
            
            var tag1 = NSMutableDictionary()
            tag1.setValue(1, forKey: "id")
            tag1.setValue("休闲", forKey: "name")
            
            var tag2 = NSMutableDictionary()
            tag2.setValue(2, forKey: "id")
            tag2.setValue("商务", forKey: "name")
            
            var tag3 = NSMutableDictionary()
            tag3.setValue(3, forKey: "id")
            tag3.setValue("流行", forKey: "name")
            allTags = NSMutableArray(array: [tag,tag1,tag2,tag3])
            
            allTags!.writeToFile(DataService.shareService.getTagsPlist(), atomically: true)
        }

        for var i:Int = 0; i < allTags?.count; i++ {
            var x:CGFloat = CGFloat(50) + CGFloat(i * 70)
            var frame:CGRect = CGRectMake(x, 10, 40, 30)
            var btn = UIButton(frame: frame)
            btn.setTitle((allTags?.objectAtIndex(i) as NSDictionary).objectForKey("name") as? String, forState: UIControlState.Normal)
            btn.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
            btn.backgroundColor = UIColor.whiteColor()
            self.tagsView!.addSubview(btn)
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
        var allClothes = NSMutableArray(contentsOfFile: DataService.shareService.getUserClothPlist())
        if(allClothes == nil){
            allClothes = NSMutableArray()
        }
        self.clothesList = allClothes!
        println(3333)
        
        self.clothesCollectView!.reloadData()
    }
}

