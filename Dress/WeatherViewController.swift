//
//  WeatherViewController.swift
//  Clothes
//
//  Created by Alec on 14/12/17.
//  Copyright (c) 2014年 Alec. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var weatherView:UIView?
    @IBOutlet var clothesMainView:UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
//        print("sssss")
        // Do any additional setup after loading the view.
        initMainView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func fetchWeatherData() {
        var locationManager = DataService.shareService.locationManager()
        locationManager!.delegate = self
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        if(atof(UIDevice.currentDevice().systemVersion)>=8.0){
            locationManager!.requestAlwaysAuthorization()
        }
        locationManager!.startUpdatingLocation()
    }
    
    func drawWeatherView(){
        self.weatherView!.backgroundColor = UIColor.clearColor()
        var frame = CGRectMake(0, 60, self.view.bounds.width, 110)
        self.weatherView!.frame = frame
        frame.origin.y = 0
        println(frame)
        var dataView = WeatherView(frame: frame)
        dataView.setCustomView()
        self.weatherView!.addSubview(dataView)
    }
    
    func drawRulerView(){
        var frame = CGRectMake(5, 0, 20, self.view.bounds.height - 100)
        var rulerBar = RulerViewBar(frame: frame)
        self.clothesMainView!.addSubview(rulerBar)
    }
    
    func initMainView() {
        
        fetchWeatherData()
        
        drawRulerView()
        
        self.clothesMainView!.frame = CGRectMake(0, 180, self.view.bounds.width, self.view.bounds.height - 68)
        
        //init user Id
        
        
        //init ruler view
        
        //
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var location:CLLocation = locations[locations.count - 1] as CLLocation
        if(location.horizontalAccuracy>0){
            updateWeatherData(location.coordinate.longitude, lat: location.coordinate.latitude)
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println(error)
    }
    
    func updateWeatherData(lon:CLLocationDegrees,lat:CLLocationDegrees){
        let manager = DataService.shareService.requestManager()
        let url = "http://api.map.baidu.com/telematics/v3/weather"
        let params = ["location":"\(lon),\(lat)", "output":"json","ak":"Vut1N7X9jZDiUfBOVhxfFYGv","mcode":"com.alecchyi.Clothes"]
        
        manager!.GET(url,
            parameters:params,
            success:{(operation:AFHTTPRequestOperation!, responseObject:AnyObject! ) in
                
                self.saveWeatherData(responseObject as NSDictionary!)
            },
            failure:{(operation:AFHTTPRequestOperation!, error:NSError!) in
                println("Error," + error.localizedDescription)
        
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
//            println(currentCity)
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
                weather.setObject(date, forKey: "date")
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
            
        }

        DataService.shareService.setWeather(weather)
//        println(DataService.shareService.weather!)
        drawWeatherView()
    }

}
