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
    
    var recommandedClothes:NSArray?
    var headerIdx:Int = 0
    var shirtIdx:Int = 0
    var trouserIdx:Int = 0
    var shoesIndx:Int = 0

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initTabbarItem()
        
        initMainView()
        
        println("did load")
        
        fetchSystemTags()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        setCurrentUser()
        fetchWeatherData()
        initClothesData()
        println("will appear")
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
//        self.navigationController!.navigationBar.barTintColor = mainNavBarColor()
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
        var frame = CGRectMake(0, 60, self.view.bounds.width, 110)
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
        let frame = CGRectMake(0, 180, self.view.bounds.width, self.view.bounds.height)
        self.clothesMainView!.frame = frame
        self.clothesMainView!.scrollEnabled = true
        self.clothesMainView?.scrollsToTop = true
        self.clothesMainView?.showsHorizontalScrollIndicator = false
        self.clothesMainView?.showsVerticalScrollIndicator = true
        self.clothesMainView?.contentSize = CGSizeMake(frame.size.width, frame.size.height - 100)
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
    }
    
    func swipeSelector(sender:UISwipeGestureRecognizer){
        if let clothes = self.recommandedClothes? {
            var headerArr: NSArray = self.recommandedClothes?.objectAtIndex(0) as NSArray!
            if(headerArr.count==0){
                println("no hat")
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
                
                let header = headerArr.objectAtIndex(self.headerIdx) as NSMutableDictionary
                let picPath = header.objectForKey("picPath") as NSString
                let path = DataService.shareService.getUserClothDirPath().stringByAppendingString(picPath)
                self.headerImgView!.image = UIImage(contentsOfFile: path)
            }
        }
        
    }
    
    func swipeShirtSelector(sender:UISwipeGestureRecognizer){
        if let clothes = self.recommandedClothes? {
            var arr: NSArray = self.recommandedClothes?.objectAtIndex(1) as NSArray!
            if(arr.count==0){
                println("no shirt")
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
                
                let shirt = arr.objectAtIndex(self.shirtIdx) as NSMutableDictionary
                let picPath = shirt.objectForKey("picPath") as NSString
                let path = DataService.shareService.getUserClothDirPath().stringByAppendingString(picPath)
                self.shirtImgView!.image = UIImage(contentsOfFile: path)
            }
        }
    }
    
    func swipeTrouserSelector(sender:UISwipeGestureRecognizer){
        if let clothes = self.recommandedClothes? {
            var arr: NSArray = self.recommandedClothes?.objectAtIndex(2) as NSArray!
            if(arr.count==0){
                println("no trouser")
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
                let trouser = arr.objectAtIndex(self.trouserIdx) as NSMutableDictionary
                let picPath = trouser.objectForKey("picPath") as NSString
                let path = DataService.shareService.getUserClothDirPath().stringByAppendingString(picPath)
                self.trouserImgView!.image = UIImage(contentsOfFile: path)
            }
        }
    }
    
    func initClothesData(){
        if let weather = DataService.shareService.weather? {
            if(DataService.shareService.userToken != nil){
                self.recommandedClothes = DataService.shareService.getRecommandClothes(DataService.shareService.weather!)
            }
        }else{
          println("no weather data")
        }
        
    }
    
    func initMainView() {
//        let shareSelector:Selector = "shareSeletor:"
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
        var img = UIImage(named: "personal_bg_4")
        UMSocialSnsService.presentSnsIconSheetView(self, appKey: kUMKey, shareText: "share words", shareImage: img, shareToSnsNames: [UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToTencent,UMShareToQzone,UMShareToQQ,UMShareToEmail], delegate: self)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var location:CLLocation = locations[locations.count - 1] as CLLocation
        if(location.horizontalAccuracy>0){
            self.updateWeatherData(location.coordinate.longitude, lat: location.coordinate.latitude)
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("location error")
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
                
                self.saveWeatherData(responseObject as NSDictionary!)
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
        let status = weatherData.objectForKey("status") as NSString!
        let error = weatherData.objectForKey("error") as Int!
        let date = weatherData.objectForKey("date") as NSString!
        var weather = NSMutableDictionary()
        if(status! == "success" && error == 0){
            var results = weatherData.objectForKey("results") as NSArray!
            var datas:NSDictionary = results.objectAtIndex(0) as NSDictionary
            let currentCity = datas.objectForKey("currentCity") as NSString!
            weather.setValue(currentCity, forKey: "currentCity")
            var idxs = datas.objectForKey("index") as NSArray!
            for idx in idxs{
                let des = (idx as NSDictionary).objectForKey("des") as NSString!
                let title = (idx as NSDictionary).objectForKey("title") as NSString!
                let tipt = (idx as NSDictionary).objectForKey("tipt") as NSString!
                let zs = (idx as NSDictionary).objectForKey("zs") as NSString!
                if(tipt! == "穿衣指数"){
                    weather.setObject(tipt!, forKey: "dress")
                    weather.setObject(des!, forKey: "dressDesc")
                    weather.setObject(zs!, forKey: "dressIndexZs")
                    break
                }
            }
            let pm25:AnyObject? = datas.objectForKey("pm25")
            weather.setObject(pm25!, forKey: "pm25")
            var w_datas = datas.objectForKey("weather_data") as NSArray!
            for w_data in w_datas {
                let item = w_data as NSDictionary
                let date:NSString = item.objectForKey("date") as NSString!
                weather.setObject(formateCurDate(), forKey: "date")
                let dayPicUrl:NSString = item.objectForKey("dayPictureUrl") as NSString!
                weather.setObject(dayPicUrl, forKey: "dayPicUrl")
                let nightPicUrl:NSString = item.objectForKey("nightPictureUrl") as NSString!
                weather.setObject(nightPicUrl, forKey: "nightPicUrl")
                let temp:NSString = item.objectForKey("temperature") as NSString!
                weather.setObject(temp, forKey: "temp")
                let weatherDesc:NSString = item.objectForKey("weather") as NSString!
                weather.setObject(weatherDesc, forKey: "weatherDesc")
                let wind:NSString = item.objectForKey("wind") as NSString!
                weather.setObject(wind, forKey: "wind")
                break
            }
            
            DataService.shareService.setWeather(weather)
            var weatherList = NSArray(contentsOfFile: DataService.shareService.getWeatherPlist()) as NSArray!
            var newList = NSMutableArray()
//            println(weatherList)
            if(weatherList == nil){
                newList.addObject(weather)
            }else{
                let wData:NSMutableDictionary = weatherList.lastObject as NSMutableDictionary!
                let lastDate:NSString = wData.objectForKey("date") as NSString!
                let curDate:NSString = weather.objectForKey("date") as NSString!
                newList = NSMutableArray(array: weatherList!)
                if(curDate == lastDate){
                    newList.removeLastObject()
                    newList.addObject(weather)
                }else{
                    newList.addObject(weather)
                }
            }
            newList.writeToFile(DataService.shareService.getWeatherPlist(), atomically: true)
            if(DataService.shareService.userToken != nil){
                self.recommandedClothes = DataService.shareService.getRecommandClothes(DataService.shareService.weather!)
            }
            
        }else{
            println("weather status error")
        }
    }
    
    func didFinishGetUMSocialDataInViewController(response: UMSocialResponseEntity!) {
        println("sssssshare success")
        updateCurrentUserData("update_share_num")
    }
    
}
