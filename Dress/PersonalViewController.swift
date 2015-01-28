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
            let path:String = DataService.shareService.currentUser?.objectForKey("profile_image_url") as String
            let url = NSURL(string: path)
            let imgData:NSData = NSData(contentsOfURL: url!)!
            self.profileImg?.image = UIImage(data: imgData)
            self.lblNickname?.text = (DataService.shareService.currentUser!.objectForKey("nickname") as String)
            self.lblFollowersNum?.text = "粉丝 " + (DataService.shareService.currentUser?.objectForKey("followers_count") as String)
            self.lblFriendsNum?.text = "关注 " + (DataService.shareService.currentUser?.objectForKey("friends_count") as String)
            self.lblClothNum?.text = "衣服 " + (DataService.shareService.currentUser?.objectForKey("cloth_count") as String)
            self.lblSharedNum?.text = "分享 " + (DataService.shareService.currentUser?.objectForKey("shared_count") as String)
        }
        
    }

    func clickLoginBtn(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        var loginViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("loginViewController") as LoginViewController
//        var authView = AuthWeiboViewController()
        
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
}
