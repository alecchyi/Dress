//
//  SecondViewController.swift
//  Clothes
//
//  Created by Alec on 14/12/14.
//  Copyright (c) 2014年 Alec. All rights reserved.
//

import UIKit

class FindViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    var weiboTableView:UITableView?
    var weiboList:NSMutableArray?
    var pullRefreshControl:UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initFindView()
    }
    
    func initFindView(){
        //add AD view
        
        //add tableview for weibo
        var frame:CGRect = CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height - 100)
        self.weiboTableView = UITableView(frame: frame, style: UITableViewStyle.Grouped)
        
        self.weiboTableView!.delegate = self
        self.weiboTableView!.dataSource = self
        self.weiboTableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "WeiboViewCell")
        self.view.addSubview(self.weiboTableView!)
        
        frame.size.height = 30
        var refreshControl:UIRefreshControl = UIRefreshControl(frame: frame)
        refreshControl.tintColor = UIColor.grayColor()
        refreshControl.attributedTitle = NSAttributedString(string: "下拉更新")
        refreshControl.addTarget(self, action: "refreshWeiboData", forControlEvents: UIControlEvents.ValueChanged)
        
        self.pullRefreshControl = refreshControl
        self.weiboTableView!.addSubview(self.pullRefreshControl!)
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
        let manager = DataService.shareService.requestManager()
        let url = kWeiboApi + "2/statuses/home_timeline.json"
        let access_token:String = DataService.shareService.currentUser?.objectForKey("access_token") as String
        let params = ["uid":access_token,"source":kAppKeyForWeibo,"trim_user":1]
        manager!.GET(url,
            parameters: params,
            success: {(operation:AFHTTPRequestOperation!,response:AnyObject!) in
                let resp:NSDictionary = response as NSDictionary
                println(resp)
        },
            failure: {(operation:AFHTTPRequestOperation!, error:NSError!) in
                println("get weibo error")
        })
    }
    
    func fetchSharedClothes(){
        
    }
    
    func fetchADList(){
    
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("WeiboViewCell", forIndexPath: indexPath)
        as UITableViewCell
        
        cell.textLabel.text = "xxxxxx"
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func refreshWeiboData(){
    
        self.pullRefreshControl!.endRefreshing()
    }
}

