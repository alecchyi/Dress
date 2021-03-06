//
//  PersonalViewController.swift
//  Clothes
//
//  Created by Alec on 14/12/21.
//  Copyright (c) 2014年 Alec. All rights reserved.
//

import UIKit

class PersonalViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var profileImg:UIImageView?
    @IBOutlet var lblFriendsNum:UILabel?
    @IBOutlet var lblFollowersNum:UILabel?
    @IBOutlet var lblNickname:UILabel?
    @IBOutlet var lblClothNum:UILabel?
    @IBOutlet var lblSharedNum:UILabel?
    @IBOutlet var detailTableView:UITableView?
    @IBOutlet var personalView:UIView?
    
    var detailArr:NSArray = ["我喜欢的风格","我喜欢的品牌","意见反馈","帮助","关于我们","退出当前账号"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTabbarItem()

        initTableView()
        // Do any additional setup after loading the view.
        self.detailTableView?.tableFooterView = UIView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        var frame = self.detailTableView?.frame
        frame?.size.height = get_screen_height() - 140 - 64 - 44

    }
    
    override func viewWillAppear(animated: Bool) {
        initPersonalView()
        
        if let currentUser = AVUser.currentUser() {
            self.profileImg?.image = UIImage(named: "default_head")
            if let path:String = currentUser.objectForKey("header_url") as? String{
                ImageLoader.sharedLoader.imageForUrl(path, completionHandler: {(image: UIImage?, url: String) in
                    self.profileImg!.image = image
                })
            }
            if let nickname = currentUser.objectForKey("nickname") as? String {
                self.lblNickname?.text = nickname
            }
            
            if let followers_count = currentUser.objectForKey("followers_count") as? Int {
                self.lblFollowersNum?.text = "粉丝\n\(followers_count)"
            }
            if let friends = currentUser.objectForKey("friends_count") as? Int {
                self.lblFriendsNum?.text = "关注\n\(friends)"
            }
            if let clothes = currentUser.objectForKey("clothes_count") as? Int {
                self.lblClothNum?.text = "衣服\n\(clothes)"
            }
            if let share = currentUser.objectForKey("shared_count") as? Int {
                self.lblSharedNum?.text = "分享\n\(share)"
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initPersonalView(){
        var idx:Int = Int(arc4random_uniform(UInt32(5)))
        if let view = self.personalView {
            var frame = self.view.frame
            var size = CGSizeMake(frame.size.width, view.frame.size.height)
            var b = CGRectMake(0, 0, frame.size.width, view.frame.size.height)
            UIGraphicsBeginImageContext(size)
            UIImage(named: "personal_bg_\(idx).png")?.drawInRect(b)
            var image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.personalView!.backgroundColor = UIColor(patternImage: image!)
        }
    }
    
    func initTableView(){
        self.detailTableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "DetailTableCell")
        self.detailTableView!.delegate = self
        
    }

    func initTabbarItem(){
        var navBar = self.navigationController?.navigationBar
        navBar?.tintColor = UIColor.whiteColor()
        let tabbarImg:UIImage = UIImage(named: "me_icon.png")!
        tabbarImg.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.navigationController?.tabBarItem = UITabBarItem(title: "我的", image: tabbarImg, selectedImage: tabbarImg)
    }

    func clickLoginBtn(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        var loginViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("loginViewController") as! LoginViewController
//        var authView = AuthWeiboViewController()
        
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    func clickLogoutBtn(){
        AVUser.logOut()
        DataService.shareService.userToken = nil
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.removeObjectForKey("userToken")
        DataService.shareService.weather = nil
        NSNotificationCenter.defaultCenter().postNotificationName("unLoginNotify", object: nil)
        if TaeSession.sharedInstance().isLogin() {
            print("be log out")
            let loginService = TaeSDK.sharedInstance().getService(ALBBLoginService) as? ALBBLoginService
            loginService?.logout()
            loginService?.setSessionStateChangedHandler({(TaeSession session) in
                if session.isLogin() {
                    print("is login now")
                }else{
                    print("is logout now")
                }
            })
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("DetailTableCell", forIndexPath: indexPath) as! UITableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.textLabel?.text = self.detailArr.objectAtIndex(indexPath.row) as? String
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row == 4){
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            var aboutViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("aboutViewController") as! AboutViewController
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
            self.navigationController?.pushViewController(aboutViewController, animated: true)
        }else if(indexPath.row == 3){
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            var helpViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("helpViewController") as! HelpViewController
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
            self.navigationController?.pushViewController(helpViewController, animated: true)
        }else if(indexPath.row == 2){
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            var feedbackViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("feedbackViewController") as! FeedbackViewController
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
            self.navigationController?.pushViewController(feedbackViewController, animated: true)
        }else if(indexPath.row == self.detailArr.count - 1){
            clickLogoutBtn()
        }else if(indexPath.row == 1){
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            var brandViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("brandViewController") as! BrandTableViewController
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
            self.navigationController?.pushViewController(brandViewController, animated: true)
        }else if(indexPath.row == 0){
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            var styleViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("styleViewController") as! StyleTableViewController
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
            self.navigationController?.pushViewController(styleViewController, animated: true)
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.detailArr.count
    }
}
