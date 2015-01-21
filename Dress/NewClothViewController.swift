//
//  NewCloth.swift
//  Dress
//
//  Created by Alec on 14/12/25.
//  Copyright (c) 2014年 Alec. All rights reserved.
//

import UIKit

protocol NewClothViewControllerDelegate {
    func dismissModelView()
}

class NewClothViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,PickViewToolBarDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate {
    
    @IBOutlet var tagView:UIView?
    @IBOutlet var categoryBtn:UIButton?
    @IBOutlet var seasonBtn:UIButton?
    @IBOutlet var photoSeg:UISegmentedControl?
    @IBOutlet var photoImgView:UIImageView?
    @IBOutlet var advImgView:UIImageView?
    @IBOutlet var addClothView:UIView?
    @IBOutlet var lblCategory:UILabel?
    @IBOutlet var lblSeason:UILabel?
    var newClothDelegate:NewClothViewControllerDelegate?
    var _picPath:String?
    
    var categories = ["帽子","上衣","裤子","鞋子"] as [String]
    var pickViewType:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initClothView()
    }
    
    func initClothView(){
        //add save btn
        var rightBarBtnItem = UIBarButtonItem(title:"save", style: UIBarButtonItemStyle.Done, target: self, action: "clickSaveBtn")
        self.navigationItem.rightBarButtonItem = rightBarBtnItem
        self.lblCategory?.tag = 1000
        self.lblSeason?.tag = 1100
        
//        self.view.backGroundColor = UIColor.
        
        
    }
    
    func showToolBar(){
        hideToolBar()
        UIView.animateWithDuration(0.3, delay: 0.0, options:UIViewAnimationOptions.CurveEaseOut, animations:{
            var frame = UIScreen.mainScreen().bounds
            frame.origin.y = frame.size.height - 244
            frame.size.height = 200
            var pickView = PickViewToolBar(frame: frame)
            pickView.tag = 1024
            pickView.pickerView?.delegate = self
            pickView.pickerView?.dataSource = self
            pickView.delegate = self
            self.view.addSubview(pickView)
            self.view.bringSubviewToFront(pickView)
            }, completion:{(BOOL isFinished) in
                
        })
    }
    
    @IBAction func clickCategoryBtn(){
        self.categories = kCategories
        self.pickViewType = 0
        showToolBar()
        
    }
    
    @IBAction func clickSeasonBtn(){
        self.categories = kSeasons
        self.pickViewType = 1
        showToolBar()
        
    }
    
    @IBAction func clickSaveBtn(){
        println("saving")
        if(self._picPath == nil){
            var alert = UIAlertView(title: "提示", message: "请选择衣服照片", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "好")
            alert.show()
        }else{
            var params = NSMutableDictionary()
            params.setValue(self.lblSeason!.tag - 1100, forKey: "season")
            params.setValue(self.lblCategory!.tag - 1000, forKey: "type")
            params.setValue(self._picPath!, forKey: "picPath")
            params.setValue([0,1], forKey: "tags")
            
            var clothes = NSMutableArray(contentsOfFile: DataService.shareService.getUserClothPlist())
            if(clothes == nil){
                clothes = NSMutableArray()
            }
            clothes!.addObject(params)

            var plist = DataService.shareService.getUserClothPlist()
            var result = clothes!.writeToFile(plist, atomically: true)
            self.dismissViewControllerAnimated(true, completion: {})
            if(self.respondsToSelector("dismissModelView")){
                self.newClothDelegate?.dismissModelView()
            }
        }
    }
    
    @IBAction func clickBackBtn(){
        println("back")
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func clickPhotoBtn(){
        
        var sheet:UIActionSheet = UIActionSheet()
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            sheet.addButtonWithTitle("取消")
            sheet.addButtonWithTitle("拍照")
            sheet.addButtonWithTitle("相册")
            sheet.title = "选择照片"
            sheet.delegate = self
        }else{
            sheet = UIActionSheet(title: "选择照片", delegate:self, cancelButtonTitle:nil, destructiveButtonTitle:"取消",otherButtonTitles:"相册")
        }
        
        sheet.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        var imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        imgPicker.allowsEditing = true
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            if(buttonIndex==1){
                imgPicker.sourceType = UIImagePickerControllerSourceType.Camera
                self.presentViewController(imgPicker, animated: true, completion: {
                    
                })
            }else if(buttonIndex==2){
                imgPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                self.presentViewController(imgPicker, animated: true, completion: {
                    
                })
            }else{
                actionSheet.dismissWithClickedButtonIndex(buttonIndex, animated: true)
            }
        }else{
            if(buttonIndex==1){
                imgPicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
                self.presentViewController(imgPicker, animated: true, completion: {
                    
                })
            }else{
                actionSheet.dismissWithClickedButtonIndex(buttonIndex, animated: true)
            }
        }
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: NSDictionary) {
        var image = info.objectForKey(UIImagePickerControllerEditedImage) as UIImage
        self.photoImgView?.image = image
        let uuid = gen_uuid()
        var path = DataService.shareService.getUserClothDirPath() + "/" + uuid! + ".png"
        self._picPath = "/" + uuid! + ".png"
        var result:Bool = UIImagePNGRepresentation(image).writeToFile(path, atomically: true)
        if(false == result){
            println("failed")
        }
        picker.dismissViewControllerAnimated(true, completion: {
            //            println(info)
        })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        println("cancel")
        picker.dismissViewControllerAnimated(true, completion: {
        
        })
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.categories.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return self.categories[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(self.pickViewType==0){
            self.lblCategory!.tag = 1000 + row
        }else{
            self.lblSeason!.tag = 1100 + row
        }
    }
    
    func hideToolBar(){
        let subviews = self.view.subviews
        for subview in subviews as [UIView] {
            if(subview.tag==1024){
                UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                    subview.removeFromSuperview()
                    }, completion: {(BOOL isFinished) in
                })
                subview.removeFromSuperview()
                break
            }
        }
    }
    func clickToolBarCancelBtn() {
        hideToolBar()
    }
    
    func clickToolBarDoneBtn(){
        let row = self.pickViewType == 0 ? self.lblCategory!.tag - 1000 : self.lblSeason!.tag - 1100
        if(self.pickViewType==0){
            self.lblCategory!.text = self.categories[row]
        }else{
            self.lblSeason!.text = self.categories[row]
        }
        
        hideToolBar()
    }
    
}

