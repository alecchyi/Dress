//
//  FeedbackViewController.swift
//  Dress
//
//  Created by Alec on 15-2-13.
//  Copyright (c) 2015年 Alec. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController,UITextViewDelegate {

    @IBOutlet var feedbackView:UITextView?
    @IBOutlet var submitBtn:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = .None
        
        // Do any additional setup after loading the view.
        
        self.submitBtn?.layer.cornerRadius = 5
//        self.feedbackView?.textAlignment = NSTextAlignment.Left
        self.feedbackView?.delegate = self
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
    
    @IBAction func clickSubmitBtn(){
        var content = self.feedbackView?.text
        if(content == "请输入您的建议" || content == ""){
            self.view.makeToast(message: "请输入你的建议", duration: 2.0, position: HRToastPositionTop)
        }else{
            var obj = AVObject(className: "Feedbacks")
            obj.setObject(content!, forKey: "content")
            obj.setObject(DataService.shareService.userToken!, forKey: "userInfo")
            obj.saveInBackgroundWithBlock({(success:Bool, error:NSError!) in
//                println(success)
                if(error != nil){
                    self.view.makeToast(message: "很遗憾，提交失败", duration: 1.0, position: HRToastPositionCenter)
                }else{
                    self.view.makeToast(message: "感谢您的反馈", duration: 1.0, position: HRToastPositionCenter)
                    NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval.abs(1.0), target: self, selector: "triggerBackBtn:", userInfo: nil, repeats: false)
                }
            })
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        var content = self.feedbackView?.text
        if(content == "请输入您的建议"){
            content = ""
            
        }
        self.feedbackView?.text = content
    }

    func triggerBackBtn(timer:NSTimer){
        self.navigationController?.popViewControllerAnimated(true)
    }
}
