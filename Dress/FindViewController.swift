//
//  SecondViewController.swift
//  Clothes
//
//  Created by Alec on 14/12/14.
//  Copyright (c) 2014年 Alec. All rights reserved.
//

import UIKit
//import Haneke

class FindViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,GADBannerViewDelegate,InfoListItemCellDelegate,UMSocialUIDelegate {

    @IBOutlet var infoTableView:UITableView?
    @IBOutlet var _bannerView:GADBannerView?
    @IBOutlet var advImgView:UIImageView?
    
    var infoList = [AVObject]()
    var pullRefreshControl:UIRefreshControl?
    var protoptypeCell:InfoListItemCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTabbarItem()
        
        initFindView()
        self.infoTableView?.tableFooterView = UIView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        var frame:CGRect = self.infoTableView!.frame as CGRect
        frame.origin.y = 64
        frame.size.height = get_main_view_height()
        
//        self.infoTableView!.frame = frame
//        self.infoTableView?.contentSize = frame.size
    }
    
    func initFindView(){

        
        //add tableview for weibo
        var frame:CGRect = self.infoTableView!.frame as CGRect
        frame.size.height = get_main_view_height() - 44
        
//        self.infoTableView!.frame = frame
        
        var cellNib:UINib = UINib(nibName: "InfoListItemCell", bundle: nil)
        self.infoTableView!.registerNib(cellNib, forCellReuseIdentifier: "InfoListItemCell")
        self.protoptypeCell = self.infoTableView?.dequeueReusableCellWithIdentifier("InfoListItemCell") as? InfoListItemCell
        
        frame.size.height = 30
        var refreshControl:UIRefreshControl = UIRefreshControl(frame: frame)
        refreshControl.tintColor = UIColor.grayColor()
        refreshControl.attributedTitle = NSAttributedString(string: "下拉更新")
        refreshControl.addTarget(self, action: "refreshWeiboData", forControlEvents: UIControlEvents.ValueChanged)
        
        self.pullRefreshControl = refreshControl
        self.infoTableView!.addSubview(self.pullRefreshControl!)
        
        //add AD view
        self._bannerView = GADBannerView(frame: CGRectMake(0, 64, self.view.frame.size.width, 50))
        
        self._bannerView?.adUnitID = APP_DISCOVER_ADMOB_AD_UNIT_ID
        self._bannerView?.rootViewController = self
        self._bannerView?.delegate = self

        self.view.addSubview(self._bannerView!)
        var request = GADRequest()
        request.testDevices = [kGAD_SIMULATOR_ID]
        self._bannerView?.loadRequest(request)
    }
    
    func initTabbarItem(){
        var navBar = self.navigationController?.navigationBar
        navBar?.tintColor = UIColor.whiteColor()
        let tabbarImg:UIImage = UIImage(named: "find_icon.png")!
        tabbarImg.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.navigationController?.tabBarItem = UITabBarItem(title: "发现", image: tabbarImg, selectedImage: tabbarImg)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {

        fetchArticals()
    }
    
    func fetchArticals(){
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        var avQuery = AVQuery(className: "Infos")
        avQuery.cachePolicy = AVCachePolicy.NetworkElseCache
        avQuery.whereKey("status", equalTo: 1)
        avQuery.addAscendingOrder("likes_count")
        avQuery.findObjectsInBackgroundWithBlock({(objs:[AnyObject]!,error:NSError!) in
            if((error) == nil){
                if let infos = objs as? [AVObject] {
                    self.infoList = infos
                    self.infoTableView?.reloadData()
                }
            }else{
                println(error)
            }
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
    }
    
    func get_tag_name_by_tag_id(tagId:String) -> [AnyObject]{
        if((DataService.shareService.artical_tags) != nil){
            let tags = DataService.shareService.artical_tags
            
            for(var i=0;i<tags?.count;i++){
                let tag = tags?.objectAtIndex(i) as! AVObject
                if((tag.objectForKey("objectId") as! String) == tagId){
                    let colors = DataService.shareService.tags_colors
                    let x = colors.count > i ? i : 0
                    return [tag.objectForKey("name"), colors[x]]
                }
            }
        }
        return [""]
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:InfoListItemCell = tableView.dequeueReusableCellWithIdentifier("InfoListItemCell", forIndexPath: indexPath) as! InfoListItemCell

        let item = self.infoList[indexPath.row] as AVObject
        
        cell.lblTitle!.text = item["title"] as? String
        cell.lblTitle?.numberOfLines = 0
        cell.lblTitle!.lineBreakMode = NSLineBreakMode.ByCharWrapping
        cell.lblTitle!.sizeToFit()
        
        cell.lblContent!.text = item.objectForKey("content") as? String
        let size:CGSize = cell.lblContent!.sizeThatFits(cell.lblContent!.frame.size)
        cell.lblContent!.numberOfLines = 0
        cell.lblContent!.frame = CGRectMake(8, 58, 307, size.height)
        cell.lblContent!.lineBreakMode = NSLineBreakMode.ByCharWrapping
        cell.lblContent!.sizeToFit()
        
        let like:Int = item.objectForKey("likes_count") as! Int
        cell.lblLike?.text = "赞(\(like))"
        let share:Int = item.objectForKey("shared_count") as! Int
        cell.lblShare?.text = "分享(\(share))"
        let source = item.objectForKey("source_type") as! String
        cell.lblSource?.text = "来源:\(source)"
        cell.lblAuthor?.text = item.objectForKey("author_name") as? String
        
        cell.headImg!.image = UIImage(named: "default_head")
        if let avatar_url = item.objectForKey("author_avatar_url") as? String {
            ImageLoader.sharedLoader.imageForUrl(avatar_url, completionHandler: {(image: UIImage?, url: String) in
                cell.headImg!.image = image
            })
        }
        
        if let small_img_url = item.objectForKey("small_img_url") as? String {
            ImageLoader.sharedLoader.imageForUrl(small_img_url, completionHandler: {(image: UIImage?, url: String) in
                cell.smallImg!.image = image
            })
            cell.has_small_img = true
            cell.smallImg?.hidden = false
        }else{
            cell.has_small_img = false
            cell.smallImg?.hidden = true
        }

        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.mainView?.tag = 1000 + indexPath.row
        cell.likeBtn?.tag = 2000 + indexPath.row
        cell.shareBtn?.tag = 3000 + indexPath.row
        cell.shareBtn?.addTarget(self, action: "clickShareBtn", forControlEvents: UIControlEvents.TouchUpOutside)
        cell.delegate = self
        
        let tag_id = item.objectForKey("tag_id") as! String
        let tag_arr = get_tag_name_by_tag_id(tag_id)
        if(tag_arr.count == 2){
            cell.lblTag?.text = tag_arr[0] as? String
            cell.lblTag?.backgroundColor = tag_arr[1] as? UIColor
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.infoList.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            var cell = self.protoptypeCell!
            let frame = tableView.frame
            let item = self.infoList[indexPath.row] as AVObject
            let content:String = item.objectForKey("content") as! String
            cell.lblContent?.text = content
            var size = cell.lblContent!.sizeThatFits(frame.size)

            let height = 70 + 35 + size.height
            if let url:String = item.objectForKey("small_img_url") as? String {
                return height + 80
            }else{
                return height
            }

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func refreshWeiboData(){
        println("pull info datas")
        fetchArticals()
        self.pullRefreshControl!.endRefreshing()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("did selected")
        
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        println("did deselected")
    }
    
    func adViewDidReceiveAd(view: GADBannerView!) {
        
    }
    
    func clickMainView(sender:UITapGestureRecognizer) {
        let tag = sender.view?.tag
        let item = self.infoList[tag! - 1000] as AVObject
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        var infoDetailViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("infoDetailViewController") as! InfoDetailViewController
        infoDetailViewController.infoObjId = item.objectForKey("objectId") as? String
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationController?.pushViewController(infoDetailViewController, animated: true)
    }
    
    func clickLikeBtn(tag:Int, cell:InfoListItemCell) {
        let item = self.infoList[tag - 2000] as AVObject
        var query = AVQuery(className: "Infos")
        let objId = item.objectForKey("objectId") as? String
        var likes = 0
        query.getObjectInBackgroundWithId(objId!, block: {(obj:AVObject!,error:NSError!) in
            if(error == nil){
                likes = obj.objectForKey("likes_count") as! Int
                likes++
                obj.setObject(likes, forKey: "likes_count")
                obj.saveInBackgroundWithBlock({(flag:Bool,error:NSError!) in
                    cell.lblLike?.text = "赞(\(likes))"
                })
            }
        })
    }
    
    func clickShareBtn(tag: Int, cell:InfoListItemCell) {
        let item = self.infoList[tag - 3000] as AVObject
        let content = item.objectForKey("content") as? String
        UMSocialSnsService.presentSnsIconSheetView(self, appKey: kUMKey, shareText: content!, shareImage: nil, shareToSnsNames: [UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToTencent,UMShareToQzone,UMShareToQQ,UMShareToEmail], delegate: self)
        var query = AVQuery(className: "Infos")
        let objId = item.objectForKey("objectId") as? String
        var shared = 0
        query.getObjectInBackgroundWithId(objId!, block: {(obj:AVObject!,error:NSError!) in
            if(error == nil){
                shared = obj.objectForKey("shared_count") as! Int
                shared++
                obj.setObject(shared, forKey: "shared_count")
                obj.saveInBackgroundWithBlock({(flag:Bool,error:NSError!) in
                    
                })
            }
        })
    }
    
    func didFinishGetUMSocialDataInViewController(response: UMSocialResponseEntity!) {
            fetchArticals()
    }
}

