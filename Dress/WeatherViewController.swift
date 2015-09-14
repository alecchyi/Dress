//
//  WeatherViewController.swift
//  Clothes
//
//  Created by Alec on 14/12/17.
//  Copyright (c) 2014年 Alec. All rights reserved.
//

import UIKit
import CoreLocation


class WeatherViewController: UIViewController, CLLocationManagerDelegate,UMSocialUIDelegate {
    
    @IBOutlet var weatherView:UIView?
    @IBOutlet var clothesMainView:UIScrollView?
    @IBOutlet var headerImgView:UIImageView?
    @IBOutlet var shirtImgView:UIImageView?
    @IBOutlet var trouserImgView:UIImageView?
    @IBOutlet var leftItemBtn:UIBarButtonItem?
    
    var recommandedClothes:NSArray?
    var headerIdx:Int = 0
    var shirtIdx:Int = 0
    var trouserIdx:Int = 0
    var shoesIndx:Int = 0

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initTabbarItem()
        
        initMainView()
        
        fetchSystemTags()
        
        get_artical_tags()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setCurrentUser()
        fetchWeatherData()
        initClothesData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let frame = CGRectMake(0, 151, self.view.bounds.width, get_screen_height() - 151 - 44)
        self.clothesMainView!.frame = frame
        self.clothesMainView!.scrollsToTop = true
        self.clothesMainView!.contentSize = CGSizeMake(frame.size.width, 360 + 50)
        self.clothesMainView!.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initTabbarItem(){
        let tabbarImg:UIImage = UIImage(named: "weather_icon.png")!
        tabbarImg.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        var tabBarItem:UITabBarItem = UITabBarItem(title: "天气", image: tabbarImg, selectedImage: tabbarImg)
        self.tabBarController?.tabBar.tintColor = mainBtnColor()
        self.navigationController!.tabBarItem = tabBarItem
        self.navigationController!.navigationBar.tintColor = mainBtnColor()
    }


    func fetchWeatherData() {
        if(DataService.shareService.weather == nil){
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            var locationManager = DataService.shareService.locationManager()
            locationManager!.delegate = self
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            if(atof(UIDevice.currentDevice().systemVersion)>=8.0){
                locationManager!.requestAlwaysAuthorization()
            }
            locationManager!.startUpdatingLocation()
        }else{
            println("has weather data")
        }

    }
    
    func drawWeatherView(){
        self.weatherView!.backgroundColor = UIColor.clearColor()
        var frame = CGRectMake(0, 60, self.view.bounds.width, 85)
        self.weatherView!.frame = frame
        frame.origin.y = 2
        var dataView = WeatherView(frame: frame)
        dataView.setCustomView()
        self.weatherView!.addSubview(dataView)

    }
    
    func drawRulerView(){
        var frame = CGRectMake(5, 0, 20, self.view.bounds.height + 50)
        var rulerBar = RulerViewBar(frame: frame)
        self.clothesMainView!.addSubview(rulerBar)
    }
    
    func setClothesMainView(){
        let frame = CGRectMake(0, 180, self.view.bounds.width, get_screen_height() - 180 - 44)
        self.clothesMainView!.contentSize = CGSizeMake(frame.size.width, 360)
        self.clothesMainView!.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        
        var bottomLayer = CALayer(layer: nil)
        bottomLayer.frame = CGRectMake(0, 0, frame.size.width, 1)
        bottomLayer.backgroundColor = mainColor().CGColor
        self.clothesMainView!.layer.addSublayer(bottomLayer)
        
        let swipeSelector:Selector = "swipeSelector:"
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: swipeSelector)
        leftSwipe.direction = UISwipeGestureRecognizerDirection.Left
        self.headerImgView!.addGestureRecognizer(leftSwipe)
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: swipeSelector)
        rightSwipe.direction = UISwipeGestureRecognizerDirection.Right
        self.headerImgView!.addGestureRecognizer(rightSwipe)
        
        let swipeShirtSelector:Selector = "swipeShirtSelector:"
        let leftShirtSwipe = UISwipeGestureRecognizer(target: self, action: swipeShirtSelector)
        leftShirtSwipe.direction = UISwipeGestureRecognizerDirection.Left
        self.shirtImgView!.addGestureRecognizer(leftShirtSwipe)
        let rightShirtSwipe = UISwipeGestureRecognizer(target: self, action: swipeShirtSelector)
        rightShirtSwipe.direction = UISwipeGestureRecognizerDirection.Right
        self.shirtImgView!.addGestureRecognizer(rightShirtSwipe)
        
        let swipeTrouserSelector:Selector = "swipeTrouserSelector:"
        let leftTrouserSwipe = UISwipeGestureRecognizer(target: self, action: swipeTrouserSelector)
        leftTrouserSwipe.direction = UISwipeGestureRecognizerDirection.Left
        self.trouserImgView!.addGestureRecognizer(leftTrouserSwipe)
        let rightTrouserSwipe = UISwipeGestureRecognizer(target: self, action: swipeTrouserSelector)
        rightTrouserSwipe.direction = UISwipeGestureRecognizerDirection.Right
        self.trouserImgView!.addGestureRecognizer(rightTrouserSwipe)
        
        var tapImgGesture = UITapGestureRecognizer(target: self, action: "tapImgGesture:")
        var tapImgGesture_1 = UITapGestureRecognizer(target: self, action: "tapImgGesture:")
        var tapImgGesture_2 = UITapGestureRecognizer(target: self, action: "tapImgGesture:")
        self.headerImgView!.addGestureRecognizer(tapImgGesture)
        self.shirtImgView!.addGestureRecognizer(tapImgGesture_1)
        self.trouserImgView!.addGestureRecognizer(tapImgGesture_2)
    }
    
    func swipeSelector(sender:UISwipeGestureRecognizer){
        if let clothes = self.recommandedClothes {
            var headerArr: NSArray = self.recommandedClothes?.objectAtIndex(0) as! NSArray
            if(headerArr.count==0){
                self.headerImgView!.image = UIImage(named: "hat_icon")
            }else{
                if(sender.direction == UISwipeGestureRecognizerDirection.Left){
                    self.headerIdx++
                    if(headerArr.count == self.headerIdx){
                        self.headerIdx = 0
                    }
                }else{
                    self.headerIdx--
                    if(-1 == self.headerIdx){
                        self.headerIdx = headerArr.count - 1
                    }
                }
                
                let header = headerArr.objectAtIndex(self.headerIdx) as! NSMutableDictionary
                let picPath = header.objectForKey("picPath") as! String
                let path = DataService.shareService.getUserClothDirPath().stringByAppendingString(picPath)
                self.headerImgView!.image = UIImage(contentsOfFile: path)
            }
        }
        
    }
    
    func swipeShirtSelector(sender:UISwipeGestureRecognizer){
        if let clothes = self.recommandedClothes {
            var arr: NSArray = self.recommandedClothes?.objectAtIndex(1) as! NSArray!
            if(arr.count==0){
                self.shirtImgView!.image = UIImage(named: "shirt_icon")
            }else{
                if(sender.direction == UISwipeGestureRecognizerDirection.Left){
                    self.shirtIdx++
                    if(arr.count == self.shirtIdx){
                        self.shirtIdx = 0
                    }
                }else{
                    self.shirtIdx--
                    if(-1 == self.shirtIdx){
                        self.shirtIdx = arr.count - 1
                    }
                }
                
                let shirt = arr.objectAtIndex(self.shirtIdx) as! NSMutableDictionary
                let picPath:String = shirt.objectForKey("picPath") as! String
                let path = DataService.shareService.getUserClothDirPath().stringByAppendingString(picPath)
                self.shirtImgView!.image = UIImage(contentsOfFile: path)
            }
        }
    }
    
    func swipeTrouserSelector(sender:UISwipeGestureRecognizer){
        if let clothes = self.recommandedClothes {
            var arr: NSArray = self.recommandedClothes?.objectAtIndex(2) as! NSArray
            if(arr.count==0){
                self.trouserImgView!.image = UIImage(named: "trousers_icon")
            }else{
                if(sender.direction == UISwipeGestureRecognizerDirection.Left){
                    self.trouserIdx++
                    if(arr.count == self.trouserIdx){
                        self.trouserIdx = 0
                    }
                }else{
                    self.trouserIdx--
                    if(-1 == self.trouserIdx){
                        self.trouserIdx = arr.count - 1
                    }
                }
                let trouser = arr.objectAtIndex(self.trouserIdx) as! NSMutableDictionary
                let picPath = trouser.objectForKey("picPath") as! NSString
                let path = DataService.shareService.getUserClothDirPath().stringByAppendingString(picPath as String)
                self.trouserImgView!.image = UIImage(contentsOfFile: path)
            }
        }
    }
    
    func initClothesData(){
        if let weather = DataService.shareService.weather {
            setClothesData()
        }else{
          println("no weather data")
        }
        
    }
    
    func initMainView() {
        var rightBarBtn:UIBarButtonItem = UIBarButtonItem(title:"分享", style: .Plain, target: self, action: "clickShareBtn")
        rightBarBtn.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = rightBarBtn

        drawRulerView()
        
        setClothesMainView()

        //init user Id
        
        
        //init ruler view
        
        //
    }
    
    func clickShareBtn() {
        var img = captureClothesView(self.clothesMainView!)
//        let shoter = UMSocialScreenShoterDefault.screenShoter()
//        img = shoter.getScreenShot()
        var url:String?
        if(img != nil){
            var data:NSData?
            if(UIImagePNGRepresentation(img) == nil){
                data = UIImageJPEGRepresentation(img, 1)
            }else{
                data = UIImagePNGRepresentation(img)
            }
            url = save_capture_img(data!)
            let str = NSURL(fileURLWithPath: url!)
            UMSocialData.defaultData().urlResource.setResourceType(UMSocialUrlResourceTypeImage, url: str!.absoluteString)
            UMSocialData.defaultData().extConfig.wechatSessionData.url = "https://dn-dress.qbox.me/index.html"
            UMSocialSnsService.presentSnsIconSheetView(self, appKey: kUMKey, shareText: kShareWords, shareImage: nil, shareToSnsNames: [UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToTencent,UMShareToQzone,UMShareToQQ,UMShareToEmail], delegate: self)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var location:CLLocation = locations[locations.count - 1] as! CLLocation
        if(location.horizontalAccuracy>0){
            self.updateWeatherData(location.coordinate.longitude, lat: location.coordinate.latitude)
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        self.drawWeatherView()
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
    
    func updateWeatherData(lon:CLLocationDegrees,lat:CLLocationDegrees){
        let manager = DataService.shareService.requestManager()
        let url = "http://api.map.baidu.com/telematics/v3/weather"
        let params = ["location":"\(lon),\(lat)", "output":"json","ak":"Vut1N7X9jZDiUfBOVhxfFYGv","mcode":"com.alecchyi.Clothes"]
        
        manager!.GET(url,
            parameters:params,
            success:{(operation:AFHTTPRequestOperation!, responseObject:AnyObject! ) in
                
                self.saveWeatherData(responseObject as! NSDictionary!)
                self.drawWeatherView()
                
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            },
            failure:{(operation:AFHTTPRequestOperation!, error:NSError!) in
                println("Error," + error.localizedDescription)
                self.drawWeatherView()
                MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
        
    }
    
    func saveWeatherData(weatherData:NSDictionary){
        let status = weatherData.objectForKey("status") as! String
        let error = weatherData.objectForKey("error") as! Int!
        let date = weatherData.objectForKey("date") as! String
        var weather = NSMutableDictionary()
        if(status == "success" && error == 0){
            var results = weatherData.objectForKey("results") as! NSArray
            var datas:NSDictionary = results.objectAtIndex(0) as! NSDictionary
            let currentCity = datas.objectForKey("currentCity") as! NSString
            weather.setValue(currentCity, forKey: "currentCity")
            var idxs = datas.objectForKey("index") as! NSArray!
            for idx in idxs{
                let des = (idx as! NSDictionary).objectForKey("des") as! NSString
                let title = (idx as! NSDictionary).objectForKey("title") as! NSString
                let tipt = (idx as! NSDictionary).objectForKey("tipt") as! NSString
                let zs = (idx as! NSDictionary).objectForKey("zs") as! NSString
                if(tipt == "穿衣指数"){
                    weather.setObject(tipt, forKey: "dress")
                    weather.setObject(des, forKey: "dressDesc")
                    weather.setObject(zs, forKey: "dressIndexZs")
                    break
                }
            }
            let pm25:AnyObject? = datas.objectForKey("pm25")
            weather.setObject(pm25!, forKey: "pm25")
            var w_datas = datas.objectForKey("weather_data") as! NSArray
            for w_data in w_datas {
                let item = w_data as! NSDictionary
                let date:NSString = item.objectForKey("date") as! NSString
                weather.setObject(formateCurDate(), forKey: "date")
                let dayPicUrl:NSString = item.objectForKey("dayPictureUrl") as! NSString
                weather.setObject(dayPicUrl, forKey: "dayPicUrl")
                let nightPicUrl:NSString = item.objectForKey("nightPictureUrl") as! NSString
                weather.setObject(nightPicUrl, forKey: "nightPicUrl")
                let temp:NSString = item.objectForKey("temperature") as! NSString
                weather.setObject(temp, forKey: "temp")
                let weatherDesc:NSString = item.objectForKey("weather") as! NSString
                weather.setObject(weatherDesc, forKey: "weatherDesc")
                let wind:NSString = item.objectForKey("wind") as! NSString
                weather.setObject(wind, forKey: "wind")
                break
            }
            
            DataService.shareService.setWeather(weather)
            var weatherList = NSArray(contentsOfFile: DataService.shareService.getWeatherPlist()) as NSArray!
            var newList = NSMutableArray()
            if(weatherList == nil){
                newList.addObject(weather)
            }else{
                let wData:NSMutableDictionary = weatherList.lastObject as! NSMutableDictionary
                let lastDate:NSString = wData.objectForKey("date") as! NSString
                let curDate:NSString = weather.objectForKey("date") as! NSString
                newList = NSMutableArray(array: weatherList!)
                if(curDate == lastDate){
                    newList.removeLastObject()
                    newList.addObject(weather)
                }else{
                    newList.addObject(weather)
                }
            }
            newList.writeToFile(DataService.shareService.getWeatherPlist(), atomically: true)
            setClothesData()
            
        }else{
            println("weather status error")
        }
    }
    
    func didFinishGetUMSocialDataInViewController(response: UMSocialResponseEntity!) {
        updateCurrentUserData("update_share_num")
    }
    
    
    func captureClothesView(scrollView:UIScrollView) -> UIImage? {
        var img:UIImage?

//        UIGraphicsBeginImageContextWithOptions(scrollView.contentSize,false,2.0)
//
//        let savedContentOffset = scrollView.contentOffset
//        let savedFrame = scrollView.frame
//        scrollView.contentOffset = CGPointZero
//        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height)
//        scrollView.layer.renderInContext(UIGraphicsGetCurrentContext())
//        
//        img = UIGraphicsGetImageFromCurrentImageContext()
//        scrollView.contentOffset = savedContentOffset
//        scrollView.frame = savedFrame
//        println(savedContentOffset)
////        UIGraphicsPopContext()
//        UIGraphicsEndImageContext()
        
//        CGRect rect = [[UIScreen mainScreen] bounds];
//        UIGraphicsBeginImageContext(rect.size);
//        
//        [view.layer renderInContext:context];
        
        let size = UIScreen.mainScreen().bounds.size
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        scrollView.layer.renderInContext(context)
        img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if(img != nil){
            return img!
        }
        return img
        
    }
    
    func tapImgGesture(sender:UITapGestureRecognizer){
        let imgView:UIImageView = sender.view as! UIImageView
        var info = JTSImageInfo()
        info.image = imgView.image
        info.referenceRect = imgView.frame
        info.referenceView = imgView.superview
        info.referenceContentMode = imgView.contentMode
        info.referenceCornerRadius = imgView.layer.cornerRadius
        
        var imgViewer = JTSImageViewController(imageInfo: info, mode: JTSImageViewControllerMode.Image, backgroundStyle: JTSImageViewControllerBackgroundOptions.Scaled)
        
        imgViewer.showFromViewController(self, transition: JTSImageViewControllerTransition._FromOriginalPosition)
    }
    
    @IBAction func clickTipBtn(sender: UIButton) {
        self.clothesMainView?.makeToast(message: "左右滑动图片切换衣服", duration: 2.0, position: HRToastPositionCenter)
    }
    
    @IBAction func clickLeftItemBtn(sender: UIBarButtonItem) {
        let title = sender.title
        if(title == "全部"){
            sender.title = "推荐"
        }else{
            sender.title = "全部"
        }
        setClothesData()
    }
    
    func setClothesData() {
        self.headerIdx = 0
        self.shirtIdx = 0
        self.trouserIdx = 0
        if(DataService.shareService.userToken != nil){
            if let weather = DataService.shareService.weather {
                let title = self.leftItemBtn?.title
                if(title == "全部"){
                    self.recommandedClothes = DataService.shareService.getRecommandClothes(weather, dataType:1)
                }else {
                    self.recommandedClothes = DataService.shareService.getRecommandClothes(weather, dataType:0)
                }
            }
            
        }
    }
}
