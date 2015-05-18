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
    
    @IBOutlet var tagsView:UIView?
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
    
    var categories:NSArray?
    var seasons:NSArray?
    var selectedTags:NSMutableArray?
    var allTags:NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //add save btn
        var rightBarBtnItem = UIBarButtonItem(title:"完成", style: UIBarButtonItemStyle.Done, target: self, action: "clickSaveBtn")
        rightBarBtnItem.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = rightBarBtnItem
        
        var leftBarItem = UIBarButtonItem(title:"取消", style: UIBarButtonItemStyle.Done, target: self, action: "clickBackBtn")
        leftBarItem.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = leftBarItem
        self.navigationController?.navigationBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName) as [NSObject : AnyObject]
        
        initClothView()
        initTagView()
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        initADView()
    }
    
    func initClothView(){

        self.lblCategory?.tag = 1000
        self.lblSeason?.tag = 1100

    }
    
    func initTagView(){
        var frame = UIScreen.mainScreen().bounds
        self.tagsView!.frame.size.width = frame.size.width
        
        self.allTags = NSMutableArray(contentsOfFile: DataService.shareService.getTagsPlist())
        
        var scrollView = UIScrollView(frame: self.tagsView!.bounds)
        scrollView.scrollsToTop = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        scrollView.showsHorizontalScrollIndicator = false
        
        self.tagsView!.addSubview(scrollView)
        
        var sWidth:CGFloat = 0.0
        for var i:Int = 0; i < allTags?.count; i++ {
            var x:CGFloat = CGFloat(50) + CGFloat(i * 80)
            var frame:CGRect = CGRectMake(x, 12, 60, 26)
            var btn = UIButton(frame: frame)
            sWidth += frame.size.width + 30
            btn.setTitle((allTags?.objectAtIndex(i) as! NSDictionary).objectForKey("name") as? String, forState: UIControlState.Normal)
            btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            btn.titleLabel?.font = UIFont.systemFontOfSize(14.0)
            btn.backgroundColor = mainTagBgColor()
            btn.layer.cornerRadius = frame.size.height * 0.5
            btn.setTitleColor(UIColor.brownColor(), forState: UIControlState.Highlighted)
            btn.addTarget(self, action: "seletedTagBtn:", forControlEvents: UIControlEvents.TouchUpInside)
            btn.tag = 5000 + i
            
            scrollView.addSubview(btn)
            var scrollSize:CGSize = scrollView.contentSize as CGSize
            scrollSize.width = sWidth
            scrollView.contentSize = scrollSize
        }

    }
    
    func initADView(){
        var frame:CGRect = self.advImgView!.bounds
        frame.origin.y = get_screen_height() - frame.size.height - 44
        self.advImgView?.frame = frame
    }
    
    func showToolBar(){
        hideToolBar()
        UIView.animateWithDuration(0.3, delay: 0.0, options:UIViewAnimationOptions.TransitionCurlUp, animations:{
            var frame = UIScreen.mainScreen().bounds
            frame.origin.y = frame.size.height - 230
            frame.size.height = 230
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
        self.seasons = kSeasons
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
            params.setValue(getSelectedTags(), forKey: "tags")
            
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
        hideToolBar()
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var image = info[UIImagePickerControllerEditedImage] as! UIImage
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
        if(self.categories!.count > self.seasons!.count){
            return self.categories!.count
        }
        return self.seasons!.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        var lblText = UILabel(frame: CGRectMake(0, 0, 100, 20))
        lblText.font = UIFont.systemFontOfSize(17)
        lblText.tintColor = mainWordColor()
        lblText.textAlignment = NSTextAlignment.Center
        if(component == 0){
            lblText.text = self.categories!.objectAtIndex(row) as? String
        }else{
            lblText.text = self.seasons!.objectAtIndex(row) as? String
        }
        return lblText
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(component == 0){
            self.lblCategory!.tag = 1000 + row
            self.lblCategory!.text = self.categories!.objectAtIndex(row) as? String
        }else{
            self.lblSeason!.tag = 1100 + row
            self.lblSeason!.text = self.seasons!.objectAtIndex(row) as? String
        }
    }
    
    func hideToolBar(){
        let subviews = self.view.subviews
        for subview in subviews as! [UIView] {
            if(subview.tag==1024){
                UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.TransitionCurlDown, animations: {
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
        hideToolBar()
    }

    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 25
    }
    
    func seletedTagBtn(sender:UIButton){
        if(self.selectedTags?.containsObject(sender.tag) == true){
            self.selectedTags?.removeObject(sender.tag)
            sender.backgroundColor = mainTagBgColor()
        }else{
            self.selectedTags?.addObject(sender.tag)
            sender.backgroundColor = UIColor.brownColor()
        }
        println(self.selectedTags!)
    }
    
    func getSelectedTags() -> NSArray {
        var arr = NSMutableArray()
        if(self.selectedTags?.count > 0){
            for(var i=0;i<self.selectedTags?.count;i++){
                var tag:Int = (selectedTags?.objectAtIndex(i) as! Int) - 5000
                var item:NSDictionary = allTags?.objectAtIndex(tag) as! NSDictionary
                arr.addObject(item.objectForKey("tagId")!)
            }
        }
        return arr
    }
}

