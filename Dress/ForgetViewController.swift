//
//  ForgetViewController.swift
//  Dress
//
//  Created by Alec on 15/7/15.
//  Copyright (c) 2015年 Alec. All rights reserved.
//

import UIKit

class ForgetViewController: UIViewController {

    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var codeBtn: UIButton!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtCode: UITextField!
    @IBOutlet weak var txtPwd: UITextField!
    
    var isSendCode:Bool = false
    var timerNum:Int = 60
    var timer:NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var leftBarItem = UIBarButtonItem(title:"取消", style: UIBarButtonItemStyle.Done, target: self, action: "clickBackBtn")
        leftBarItem.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = leftBarItem
        var rightBarItem = UIBarButtonItem(title:"提交", style: UIBarButtonItemStyle.Done, target: self, action: "clickResetBtn:")
        rightBarItem.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = rightBarItem
        self.navigationController?.navigationBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName) as [NSObject : AnyObject]
        self.codeBtn.titleLabel?.textAlignment = NSTextAlignment.Center
        
        var tapBgRecognizer = UITapGestureRecognizer(target: self, action: "tapBgView")
        self.view.addGestureRecognizer(tapBgRecognizer)
        
        self.codeBtn?.layer.cornerRadius = 5
        self.resetBtn.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func clickBackBtn(){
        self.timer?.invalidate()
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func clickResetBtn(sender: UIButton) {
        let phone = self.txtPhone.text
        let code = self.txtCode.text
        let pwd = self.txtPwd.text
        if(count(phone) != 11 || count(code) != 6 || count(pwd) < 6 || count(pwd) > 20){
            self.view.makeToast(message: "请输入正确的手机号码,验证码和密码", duration: 2.0, position: HRToastPositionCenter)
        }else{
            println(444444)
            AVUser.resetPasswordWithSmsCode(code, newPassword: pwd, block: {(successed:Bool, error:NSError!) in
                if(successed){
                    self.view.makeToast(message: "恭喜你密码已重置，现在可以登录啦！", duration: 2.0, position: HRToastPositionCenter)
                    self.dismissViewControllerAnimated(true, completion: nil)

                    NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "delayMethod", userInfo: nil, repeats: false)
                }else{
                    println(error);
                    self.view.makeToast(message: "抱歉，你的密码重置失败", duration: 2.0, position: HRToastPositionCenter)
                }
            })
        }
    }
    
    func delayMethod(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func clickCodeBtn(sender: AnyObject) {
        self.txtCode.text = ""
        if(self.isSendCode == false){
            let phone = self.txtPhone.text
            if(count(phone) == 11){
                
                self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "stopTimer:", userInfo: nil, repeats: true)
                self.codeBtn.enabled = false
                self.isSendCode = true
                self.txtCode.becomeFirstResponder()
                self.codeBtn.backgroundColor = UIColor(red: 253/255.0, green: 103/255.0, blue: 85/255.0, alpha: 0.6)
                AVUser.requestPasswordResetWithPhoneNumber(phone, block: {(successed:Bool,error:NSError!) in
                    if(!successed){
                        self.view.makeToast(message: "验证码发送失败", duration: 2.0, position: HRToastPositionCenter)
                    }else{
                        self.view.makeToast(message: "验证码发送成功，请在5分钟有效期之内使用", duration: 2.0, position: HRToastPositionCenter)
                    }
                })
            }else{
                self.view.makeToast(message: "请输入正确的手机号码", duration: 2.0, position: HRToastPositionCenter)
            }
            
        }
    }

    func stopTimer(sender:NSTimer){
        timerNum--
        if(sender.valid && timerNum == 0){
            sender.invalidate()
            self.codeBtn.enabled = true
            self.codeBtn.titleLabel?.text = "获取验证码"
            self.timerNum = 60
            self.isSendCode = false
            self.codeBtn.backgroundColor = mainBtnColor()
        }else{
            self.codeBtn.titleLabel?.text = "\(timerNum)秒"
            
        }
    }
    
    func tapBgView(){
        self.txtPhone.resignFirstResponder()
        self.txtPwd.resignFirstResponder()
        self.txtCode.resignFirstResponder()
    }

}
