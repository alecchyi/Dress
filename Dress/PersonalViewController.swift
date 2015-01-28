//
//  PersonalViewController.swift
//  Clothes
//
//  Created by Alec on 14/12/21.
//  Copyright (c) 2014年 Alec. All rights reserved.
//

import UIKit

class PersonalViewController: UIViewController {
    
    @IBOutlet var profileImg:UIImageView?
    @IBOutlet var lblFriendsNum:UILabel?
    @IBOutlet var lblFollowersNum:UILabel?
    @IBOutlet var lblNickname:UILabel?
    @IBOutlet var lblClothNum:UILabel?
    @IBOutlet var lblSharedNum:UILabel?
    @IBOutlet var logoutView:UIView?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(animated: Bool) {
        if(DataService.shareService.userToken == nil){
            var rightBarBtnItem = UIBarButtonItem(title:"登录", style: UIBarButtonItemStyle.Plain, target: self, action: "clickLoginBtn")
            self.navigationItem.rightBarButtonItem = rightBarBtnItem
        }else{
            if(DataService.shareService.currentUser != nil){
                println("init view")
                let path:String = DataService.shareService.currentUser?.objectForKey("profile_image_url") as String
                println(path)
                let url = NSURL(string: path)
                let imgData:NSData = NSData(contentsOfURL: url!)!
                self.profileImg?.image = UIImage(data: imgData)
                self.lblNickname?.text = (DataService.shareService.currentUser!.objectForKey("nickname") as String)
                let followers_count:Int = (DataService.shareService.currentUser?.objectForKey("followers_count") as Int)
                self.lblFollowersNum?.text = "粉丝 \(followers_count)"
                let friends:Int = (DataService.shareService.currentUser?.objectForKey("friends_count") as Int)
                self.lblFriendsNum?.text = "关注 \(friends)"
                var clothes:Int = 0
                if(DataService.shareService.currentUser?.objectForKey("cloth_count") != nil){
                    clothes = (DataService.shareService.currentUser?.objectForKey("cloth_count") as Int)
                }
                self.lblClothNum?.text = "衣服 \(clothes)"
                var share:Int = 0
                if(DataService.shareService.currentUser?.objectForKey("shared_count") != nil){
                    share = DataService.shareService.currentUser?.objectForKey("shared_count") as Int
                }
                self.lblSharedNum?.text = "分享 \(share)"
                
                self.navigationItem.rightBarButtonItem = nil
                self.logoutView?.hidden = false
            }
            
        }
        
    }

    func clickLoginBtn(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        var loginViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("loginViewController") as LoginViewController
//        var authView = AuthWeiboViewController()
        
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    @IBAction func clickLogoutBtn(){
        DataService.shareService.currentUser = nil
        DataService.shareService.userToken = nil
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.removeObjectForKey("userToken")
        
    }
}
