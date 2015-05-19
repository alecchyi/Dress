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
    var infoList:NSMutableArray?
    var pullRefreshControl:UIRefreshControl?
    var protoptypeCell:InfoListItemCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTabbarItem()
        
        initFindView()
        
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
        
        self.infoTableView!.frame = frame
        println(self.infoTableView!.frame);
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
        self._bannerView = GADBannerView(frame: CGRectMake(0, 64, 320, 50))
        
        self._bannerView?.adUnitID = APP_DISCOVER_ADMOB_AD_UNIT_ID
        self._bannerView?.rootViewController = self
        self._bannerView?.delegate = self

        self.view.addSubview(self._bannerView!)
        var request = GADRequest()
        request.testDevices = ["5B95C192-07BA-49FD-B572-AA23540A","cc95f15c6a339431d0d16e3184949be81f2"]
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
        fetchSharedClothes()
//        
//        for view:AnyObject in self.view.subviews {
//            if view is GADBannerView {
//                var bannerFrame = view.frame
//                var frame = self.pullRefreshControl?.frame
//                frame?.origin.y = bannerFrame.size.height
////                self.pullRefreshControl?.frame = frame!
//                frame = self.infoTableView!.frame
//                frame?.origin.y = 154
//                frame?.size.height = get_main_view_height() - 44
////                self.infoTableView?.frame = frame!
//                println(self.infoTableView?.frame)
//                println("appear in bannerview")
//                break
//            }
//        }
//        println(self.infoTableView?.frame)
    }
    
    func fetchArticals(){
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        var avQuery = AVQuery(className: "Infos")
        avQuery.cachePolicy = AVCachePolicy.NetworkElseCache
        avQuery.whereKey("status", equalTo: 1)
        avQuery.addAscendingOrder("likes_count")
        avQuery.findObjectsInBackgroundWithBlock({(objs:[AnyObject]!,error:NSError!) in
            if((error) == nil){
                let objs:NSArray = objs as NSArray
                self.infoList = NSMutableArray(array: objs)
                self.infoTableView?.reloadData()
            }else{
                println(error)
            }
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
    }
    
    func fetchSharedClothes(){
        
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:InfoListItemCell = tableView.dequeueReusableCellWithIdentifier("InfoListItemCell", forIndexPath: indexPath) as! InfoListItemCell

        let item = self.infoList?.objectAtIndex(indexPath.row) as! AVObject
        cell.lblTitle!.text = item.objectForKey("title") as? String
        cell.lblTitle?.numberOfLines = 0
        cell.lblTitle?.sizeToFit()
        
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
        let avatar_url = item.objectForKey("author_avatar_url") as? String
        cell.headImg!.image = UIImage(named: "default_head.png")
        if (avatar_url != nil) {
            ImageLoader.sharedLoader.imageForUrl(avatar_url!, completionHandler: {(image: UIImage?, url: String) in
                cell.headImg!.image = image
            })
        }
        let small_img_url = item.objectForKey("small_img_url") as? String
        if(small_img_url != nil){
            ImageLoader.sharedLoader.imageForUrl(small_img_url!, completionHandler: {(image: UIImage?, url: String) in
                cell.smallImg!.image = image
            })
            cell.has_small_img = true
        }else{
            cell.has_small_img = false
        }
//        println("has_smalll_img----\(indexPath.row)-----\(cell.has_small_img)")
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.mainView?.tag = 1000 + indexPath.row
        cell.likeBtn?.tag = 2000 + indexPath.row
        cell.shareBtn?.tag = 3000 + indexPath.row
        cell.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let infos = self.infoList {
            return infos.count
        }else{
            return 0
        }
       
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let items = self.infoList {
            var cell = self.protoptypeCell!
            
            let item = self.infoList!.objectAtIndex(indexPath.row) as! AVObject
            let content:String = item.objectForKey("content") as! String
            cell.lblContent?.text = content
            var size = cell.lblContent!.sizeThatFits(CGSizeMake(310, 2000))

            let height = 58 + 35 + size.height
            if let url:String = item.objectForKey("small_img_url") as? String {
                return height + 80
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
    
    func adViewDidReceiveAd(view: GADBannerView!) {
        
//        UIView.animateWithDuration(0.3, delay: 0.0, options:UIViewAnimationOptions.TransitionFlipFromBottom, animations:{
//            let bannerFrame = view.frame
//            println("ads receive")
//            
//            var frame = self.pullRefreshControl?.frame
//            frame?.origin.y = bannerFrame.size.height
//            frame = self.infoTableView!.frame
//            frame?.origin.y += 20
//            frame?.size.height -= 40
////            self.infoTableView?.frame = frame!
//            }, completion:{(BOOL isFinished) in
//                
//        })
    }
    
    func clickMainView(sender:UITapGestureRecognizer) {
        let tag = sender.view?.tag
        let item = self.infoList?.objectAtIndex(tag! - 1000) as! AVObject
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        var infoDetailViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("infoDetailViewController") as! InfoDetailViewController
        infoDetailViewController.infoObjId = item.objectForKey("objectId") as? String
        self.navigationController?.pushViewController(infoDetailViewController, animated: true)
    }
    
    func clickLikeBtn(tag:Int) {
        let item = self.infoList?.objectAtIndex(tag - 2000) as! AVObject
        var query = AVQuery(className: "Infos")
        let objId = item.objectForKey("objectId") as? String
        query.getObjectInBackgroundWithId(objId, block: {(obj:AVObject!,error:NSError!) in
            if(error == nil){
                var likes = obj.objectForKey("likes_count") as! Int
                likes++
                obj.setObject(likes, forKey: "likes_count")
                obj.saveInBackgroundWithBlock({(flag:Bool,error:NSError!) in
                    
                })
            }
        })
    }
    
    func clickShareBtn(tag: Int) {
        let item = self.infoList?.objectAtIndex(tag - 3000) as! AVObject
        let content = item.objectForKey("content") as? String
        UMSocialSnsService.presentSnsIconSheetView(self, appKey: kUMKey, shareText: content!, shareImage: nil, shareToSnsNames: [UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToTencent,UMShareToQzone,UMShareToQQ,UMShareToEmail], delegate: self)
        var query = AVQuery(className: "Infos")
        let objId = item.objectForKey("objectId") as? String
        query.getObjectInBackgroundWithId(objId, block: {(obj:AVObject!,error:NSError!) in
            if(error == nil){
                var shared = obj.objectForKey("shared_count") as! Int
                shared++
                obj.setObject(shared, forKey: "shared_count")
                obj.saveInBackgroundWithBlock({(flag:Bool,error:NSError!) in
                    
                })
            }
        })
    }
    
    func didFinishGetUMSocialDataInViewController(response: UMSocialResponseEntity!) {
//        println(response)
    }
}

