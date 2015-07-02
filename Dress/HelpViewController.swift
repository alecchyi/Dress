//
//  HelpViewController.swift
//  Dress
//
//  Created by Alec on 15-2-13.
//  Copyright (c) 2015年 Alec. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController,UIWebViewDelegate {
    
    @IBOutlet var helpWebView:UIWebView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        initWebView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func initWebView(){
//        var res = NSBundle.mainBundle().pathForResource("help", ofType: "html")
//        var url:NSURL = NSURL(fileURLWithPath: (res! as String))!
//        var req:NSURLRequest = NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: NSTimeInterval.abs(5.0))
//        self.helpWebView?.loadRequest(req)
        

        var query = AVQuery(className: "InfoDetails")
        query.whereKey("info_id", equalTo: "help")
        query.getFirstObjectInBackgroundWithBlock({(obj:AVObject!,error:NSError!) in
            var res = NSBundle.mainBundle().pathForResource("help", ofType: "html")
            var url:NSURL = NSURL(fileURLWithPath: (res! as String))!
            
            if(obj == nil){
                self.helpWebView?.loadHTMLString("<p style='text-align:center;'>数据读取有误</p>", baseURL: url)
            }else{
                MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                let helperString:String = obj.objectForKey("detail") as! String
                let helperUrl:NSURL = NSURL(string: helperString)!
                self.helpWebView?.loadRequest(NSURLRequest(URL: helperUrl, cachePolicy: NSURLRequestCachePolicy.ReloadRevalidatingCacheData, timeoutInterval: 30))
            }
        })
        
        
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
}
