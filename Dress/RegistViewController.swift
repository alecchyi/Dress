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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var leftBarItem = UIBarButtonItem(title:"取消", style: UIBarButtonItemStyle.Done, target: self, action: "clickBackBtn")
        leftBarItem.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = leftBarItem
        self.navigationController?.navigationBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName) as [NSObject : AnyObject]
        
        var tapBgRecognizer = UITapGestureRecognizer(target: self, action: "tapBgView")
        self.bgView.addGestureRecognizer(tapBgRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickBackBtn(){
        self.dismissViewControllerAnimated(true, completion: {})
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
   
    @IBAction func editPaswordEnd(sender: AnyObject) {
        println("end.....")
    }
    
    @IBAction func clickRegistBtn(sender: AnyObject) {
        println("click reg")
        self.tapBgView()
        let phone = self.txtUsername.text
        let pwd = self.txtPassword.text
        if(phone.isEmpty || pwd.isEmpty){
            self.bgView.makeToast(message: "请输入你的用户名和密码", duration: 2.0, position: HRToastPositionCenter)
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
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }else{
                        println(error);
                        self.bgView.makeToast(message: "抱歉，你的注册信息有误", duration: 2.0, position: HRToastPositionCenter)
                    }
                })
        }
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
    }

}
