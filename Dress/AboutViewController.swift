//
//  AboutViewController.swift
//  Dress
//
//  Created by Alec on 15-2-13.
//  Copyright (c) 2015年 Alec. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet var aboutWebView:UIWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        initContentView()
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

    func initContentView(){
        var query = AVQuery(className: "InfoDetails")
        query.whereKey("info_id", equalTo: "about")
        query.getFirstObjectInBackgroundWithBlock({(obj:AVObject!,error:NSError!) in
            var res = NSBundle.mainBundle().pathForResource("help", ofType: "html")
            var url:NSURL = NSURL(fileURLWithPath: (res! as String))!
            
            if(obj == nil){
                self.aboutWebView?.loadHTMLString("<p style='text-align:center;'>数据读取有误</p>", baseURL: url)
            }else{
                MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                self.aboutWebView?.loadHTMLString(obj.objectForKey("detail") as! String, baseURL: url)
                let aboutString:String = obj.objectForKey("detail") as! String
                let aboutUrl:NSURL = NSURL(string: aboutString)!
                self.aboutWebView?.loadRequest(NSURLRequest(URL: aboutUrl, cachePolicy: NSURLRequestCachePolicy.ReloadRevalidatingCacheData, timeoutInterval: 30))
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
