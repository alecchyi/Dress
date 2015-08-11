//
//  RegistViewController.swift
//  Dress
//
//  Created by Alec on 15/7/15.
//  Copyright (c) 2015年 Alec. All rights reserved.
//

import UIKit

class RegistViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet var bgView: UIView!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtCode: UITextField!
    @IBOutlet weak var codeBtn: UIButton!
    @IBOutlet weak var regBtn: UIButton!
    
    var isSendCode:Bool = false
    var timerNum:Int = 60
    var timer:NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var leftBarItem = UIBarButtonItem(title:"取消", style: UIBarButtonItemStyle.Done, target: self, action: "clickBackBtn")
        leftBarItem.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = leftBarItem
        
        var rightBarItem = UIBarButtonItem(title:"提交", style: UIBarButtonItemStyle.Done, target: self, action: "clickRegistBtn:")
        rightBarItem.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = rightBarItem
        self.navigationController?.navigationBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName) as [NSObject : AnyObject]
        
        self.codeBtn.titleLabel?.textAlignment = NSTextAlignment.Center
        
        var tapBgRecognizer = UITapGestureRecognizer(target: self, action: "tapBgView")
        self.bgView.addGestureRecognizer(tapBgRecognizer)
        self.codeBtn?.layer.cornerRadius = 5
        self.regBtn?.layer.cornerRadius = 5
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
   
    @IBAction func clickBackBtn(){
        self.timer?.invalidate()
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func clickCodeBtn(sender: AnyObject) {
        self.txtCode.text = ""
        if(self.isSendCode == false){
            let phone = self.txtUsername.text
            if(count(phone) == 11){
                
                self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "stopTimer:", userInfo: nil, repeats: true)
                self.codeBtn.enabled = false
                self.isSendCode = true
                self.txtCode.becomeFirstResponder()
                self.codeBtn.backgroundColor = UIColor(red: 253/255.0, green: 103/255.0, blue: 85/255.0, alpha: 0.6)
//                AVOSCloud.requestSmsCodeWithPhoneNumber(phone, appName: "小衣橱", operation: "短信验证", timeToLive: 5, callback:{(successed:Bool, error:NSError!) in
//                    if(!successed){
//                        self.bgView.makeToast(message: "验证码发送失败", duration: 2.0, position: HRToastPositionCenter)
//                    }else{
//                        self.bgView.makeToast(message: "验证码发送成功，请在5分钟有效期之内使用", duration: 2.0, position: HRToastPositionCenter)
//                    }
//                })
            }else{
                self.view.makeToast(message: "请输入正确的手机号码", duration: 2.0, position: HRToastPositionCenter)
            }
            
        }
    }
    
    @IBAction func editPaswordEnd(sender: AnyObject) {
        println("end.....")
    }
    
    @IBAction func clickRegistBtn(sender: AnyObject) {
        println("click reg")
        self.tapBgView()
        let phone = self.txtUsername.text
        let pwd = self.txtPassword.text
//        let code = self.txtCode.text
        if(phone.isEmpty || pwd.isEmpty){
            self.bgView.makeToast(message: "请输入你的用户名,密码", duration: 2.0, position: HRToastPositionCenter)
        }else if(count(phone) != 11 || count(pwd) > 20){
            self.bgView.makeToast(message: "你输入的字符长度有误", duration: 2.0, position: HRToastPositionCenter)
        }else{

                var user = AVUser()
                user.username = phone
                user.password = pwd
                user.mobilePhoneNumber = phone
                let uuid = gen_uuid()
                user.setObject(uuid!, forKey: "userToken")
                user.setObject("register", forKey: "login_type")
                user.signUpInBackgroundWithBlock({(succeeded:Bool, error:NSError!) in
                    if(succeeded){
                        self.bgView.makeToast(message: "恭喜你注册成功，现在可以登录啦！", duration: 2.0, position: HRToastPositionCenter)
                        
                        NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "delayMethod", userInfo: nil, repeats: false)
                        
                    }else{
                        println(error);
                        self.bgView.makeToast(message: "抱歉，你的注册信息有误", duration: 2.0, position: HRToastPositionCenter)
                    }
                })
        }
    }
    
    func delayMethod(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        println(textField.text)
        if(textField.text == ""){
            return false
        }else{
            textField.resignFirstResponder()
            return true
        }
    }
    
    func tapBgView(){
        self.txtPassword.resignFirstResponder()
        self.txtUsername.resignFirstResponder()
        self.txtCode.resignFirstResponder()
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

}
