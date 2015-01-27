//
//  PersonalViewController.swift
//  Clothes
//
//  Created by Alec on 14/12/21.
//  Copyright (c) 2014年 Alec. All rights reserved.
//

import UIKit

class PersonalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(animated: Bool) {

        var rightBarBtnItem = UIBarButtonItem(title:"登录", style: UIBarButtonItemStyle.Plain, target: self, action: "clickLoginBtn")
        self.navigationItem.rightBarButtonItem = rightBarBtnItem
    }

    func clickLoginBtn(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        var loginViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("loginViewController") as LoginViewController
//        var authView = AuthWeiboViewController()
        
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
}
