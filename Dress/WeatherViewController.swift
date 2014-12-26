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
        print("sssss")
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
    
    func initMainView() {
        fetchWeatherData()
        self.weatherView!.backgroundColor = UIColor.clearColor()
        
        self.clothesMainView!.frame = CGRectMake(0, 160, self.view.bounds.width, self.view.bounds.height - 68)
        
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
                    println(responseObject.description)
        
            },
            failure:{(operation:AFHTTPRequestOperation!, error:NSError!) in
                println("Error," + error.localizedDescription)
        
        })
        
    }

}
