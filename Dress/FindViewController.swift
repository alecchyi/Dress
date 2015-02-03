//
//  SecondViewController.swift
//  Clothes
//
//  Created by Alec on 14/12/14.
//  Copyright (c) 2014年 Alec. All rights reserved.
//

import UIKit
import Haneke

class FindViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var infoTableView:UITableView?
    var infoList:NSMutableArray?
    var pullRefreshControl:UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTabbarItem()
        
        initFindView()
        
    }
    
    func initFindView(){
        //add AD view
        
        //add tableview for weibo
        var frame:CGRect = CGRectMake(0, -30, self.view.bounds.size.width, self.view.bounds.size.height)
        self.infoTableView = UITableView(frame: frame, style: UITableViewStyle.Grouped)
        
        self.infoTableView!.delegate = self
        self.infoTableView!.dataSource = self
        var cellNib:UINib = UINib(nibName: "InfoListItemCell", bundle: nil)
        self.infoTableView!.registerNib(cellNib, forCellReuseIdentifier: "InfoListItemCell")
//        self.infoTableView!.registerClass(InfoListItemCell.self, forCellReuseIdentifier: "InfoListItemCell")
        self.view.addSubview(self.infoTableView!)
        
        frame.size.height = 30
        var refreshControl:UIRefreshControl = UIRefreshControl(frame: frame)
        refreshControl.tintColor = UIColor.grayColor()
        refreshControl.attributedTitle = NSAttributedString(string: "下拉更新")
        refreshControl.addTarget(self, action: "refreshWeiboData", forControlEvents: UIControlEvents.ValueChanged)
        
        self.pullRefreshControl = refreshControl
        self.infoTableView!.addSubview(self.pullRefreshControl!)
    }
    
    func initTabbarItem(){
        let tabbarImg:UIImage = UIImage(named: "find_icon.png")!
        tabbarImg.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.navigationController?.tabBarItem = UITabBarItem(title: "发现", image: tabbarImg, selectedImage: tabbarImg)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        
        if(has_bind_weibo()){
            fetchPersonalWeibo()
        }
        fetchSharedClothes()
    }
    
    func fetchPersonalWeibo(){
        MBProgressHUD.showHUDAddedTo(self.infoTableView, animated: true)
        var avQuery = AVQuery(className: "Infos")
        avQuery.cachePolicy = AVCachePolicy.NetworkElseCache
        avQuery.whereKey("status", equalTo: 1)
        avQuery.findObjectsInBackgroundWithBlock({(objs:[AnyObject]!,error:NSError!) in
            if((error) == nil){
                let objs:NSArray = objs as NSArray
                println(objs.count)
                self.infoList = NSMutableArray(array: objs)
                self.infoTableView?.reloadData()
            }else{
                println(error)
            }
            MBProgressHUD.hideHUDForView(self.infoTableView, animated: true)
        })
    }
    
    func fetchSharedClothes(){
        
    }
    
    func fetchADList(){
    
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:InfoListItemCell = tableView.dequeueReusableCellWithIdentifier("InfoListItemCell", forIndexPath: indexPath) as InfoListItemCell
        
        let item = self.infoList?.objectAtIndex(indexPath.row) as AVObject
        cell.lblTitle!.text = item.objectForKey("title") as? String
        
        cell.lblContent!.text = item.objectForKey("content") as? String
        let size:CGSize = cell.lblContent!.sizeThatFits(cell.lblContent!.frame.size)
        cell.lblContent!.numberOfLines = 0
        cell.lblContent!.frame = CGRectMake(8, 58, 307, size.height)
        cell.lblContent!.lineBreakMode = NSLineBreakMode.ByCharWrapping
        cell.lblContent!.sizeToFit()
        
        let like:Int = item.objectForKey("likes_count") as Int
        cell.lblLike?.text = "赞(\(like))"
        let share:Int = item.objectForKey("shared_count") as Int
        cell.lblShare?.text = "分享(\(share))"
        let source = item.objectForKey("source_type") as String
        cell.lblSource?.text = "来源:\(source)"
        cell.lblAuthor?.text = item.objectForKey("author_name") as? String
        let avatar_url = item.objectForKey("author_avatar_url") as? String

        if (avatar_url != nil) {
            let head_url = NSURL(string: avatar_url!)
            cell.headImg!.hnk_setImageFromURL(head_url!, placeholder: nil, format: nil, failure: nil, success: nil)
        }else{
            cell.headImg!.image = UIImage(named: "default_head.png")
        }
        let small_img_url = item.objectForKey("small_img_url") as? String
        if(small_img_url != nil){
            let img_url = NSURL(string: small_img_url!)
            cell.smallImg!.hnk_setImageFromURL(img_url!, placeholder: nil, format: nil, failure: nil, success: nil)
            cell.has_small_img = true
        }else{
            cell.has_small_img = false
        }
//        println("has_smalll_img----\(indexPath.row)-----\(cell.has_small_img)")
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let infos = self.infoList? {
            return infos.count
        }else{
            return 0
        }
       
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let items = self.infoList? {
            let item = self.infoList!.objectAtIndex(indexPath.row) as AVObject
            let content:NSString = (item.objectForKey("content") as? NSString)!
            var dict:NSMutableDictionary = NSMutableDictionary()
            dict.setObject(UIFont(name: "HelveticaNeue", size: 17)!, forKey: NSFontAttributeName)
            let size = content.sizeWithAttributes(dict)
//            println(size)
            let height = 58 + 10 + size.height + 25 + 5
            if let url:String = item.objectForKey("small_img_url") as? String {
                return height + 100 + 10
            }else{
                return height
            }
        }

        return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func refreshWeiboData(){
    
        self.pullRefreshControl!.endRefreshing()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("did selected")
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        println("did deselected")
    }
}

