//
//  InfoDetailViewController.swift
//  Dress
//
//  Created by Alec on 15-2-27.
//  Copyright (c) 2015年 Alec. All rights reserved.
//

import UIKit

class InfoDetailViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet var detailWebView:UIWebView?
    var infoObjId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavBarView()
        
        var frame = self.view.bounds
        self.detailWebView?.frame = frame
        self.detailWebView?.delegate = self
        
        initWebViewContent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func initNavBarView(){
        self.navigationItem.title = "详情"
    }
    
    func initWebViewContent(){
        var query = AVQuery(className: "InfoDetails")
        query.whereKey("info_id", equalTo: self.infoObjId)
        query.getFirstObjectInBackgroundWithBlock({(obj:AVObject!,error:NSError!) in
            var res = NSBundle.mainBundle().pathForResource("help", ofType: "html")
            var url:NSURL = NSURL(fileURLWithPath: (res! as String))!
            
            if(obj == nil){
                self.detailWebView?.loadHTMLString("<p style='text-align:center;'>数据读取有误</p>", baseURL: url)
            }else{
                self.detailWebView?.loadHTMLString(obj.objectForKey("detail") as String, baseURL: url)
            }
        })
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        return true
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
    }
}
