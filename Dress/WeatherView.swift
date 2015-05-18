//
//  WeatherView.swift
//  Dress
//
//  Created by Alec on 15/1/16.
//  Copyright (c) 2015年 Alec. All rights reserved.
//


class WeatherView: UIView {
    
    let bgColor = UIColor(red: 244/255.0, green: 119/255.0, blue: 146/255.0, alpha: 1.0)
    
    var lblTemp:UILabel?
    var lblDesc:UILabel?

    override init(frame:CGRect){
        super.init(frame:frame)
        self.backgroundColor = bgColor
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCustomView(){
        if let weather = DataService.shareService.weather {
//            println(weather.objectForKey("dayPicUrl"))
            let picPath = weather.objectForKey("dayPicUrl") as? NSString
            if(picPath == nil){
                var lblWeather = UILabel(frame: CGRectMake(50, 10, 150, 20))
                lblWeather.text = "暂无天气数据"
                lblWeather.textColor = weatherWordColor()
                self.addSubview(lblWeather)
            }else{
                var wImgView = UIImageView(frame: CGRectMake(5, 20, 45, 45))
                wImgView.contentMode = UIViewContentMode.ScaleAspectFit
                ImageLoader.sharedLoader.imageForUrl(picPath! as String, completionHandler: {(image:UIImage?, urlString:String) in
                    wImgView.image = image
                })
                self.addSubview(wImgView)
                var lblTempView = UILabel(frame: CGRectMake(5, 2, 80, 20))
                let temp:NSString = weather.objectForKey("temp") as! String
                lblTempView.text = temp as String
                lblTempView.font = UIFont.systemFontOfSize(14)
                lblTempView.textColor = weatherWordColor()
                self.addSubview(lblTempView)
                
                var lblCity = UILabel(frame: CGRectMake(5, 59, 80, 20))
                lblCity.text = weather.objectForKey("currentCity") as? String
                lblCity.font = UIFont.systemFontOfSize(14)
                lblCity.textColor = weatherWordColor()
                self.addSubview(lblCity)
                
                var lblWeather = UILabel(frame: CGRectMake(70, 2, 170, 20))
                lblWeather.text = (weather.objectForKey("weatherDesc") as! String) + " " + (weather.objectForKey("wind") as! String)
                lblWeather.font = UIFont.systemFontOfSize(14)
                lblWeather.textColor = weatherWordColor()
                self.addSubview(lblWeather)
                
                var lblIndexZs = UILabel(frame: CGRectMake(243, 2, 70, 20))
                lblIndexZs.text = weather.objectForKey("dressIndexZs") as? String
                lblIndexZs.font = UIFont.systemFontOfSize(14)
                lblIndexZs.textColor = weatherWordColor()
                self.addSubview(lblIndexZs)
                
                var dressTextView = UITextView(frame: CGRectMake(60, 18, 250, 70))
                dressTextView.editable = false
                dressTextView.selectable = false
                dressTextView.backgroundColor = UIColor.clearColor()
                dressTextView.text = (weather.objectForKey("dress") as! String) +  ":" + (weather.objectForKey("dressDesc") as! String)
                dressTextView.textColor = weatherWordColor()
                self.addSubview(dressTextView)
            }
        }else {
            var lblWeather = UILabel(frame: CGRectMake(50, 10, 150, 20))
            lblWeather.text = "暂无天气数据"
            lblWeather.textColor = UIColor.whiteColor()
            self.addSubview(lblWeather)
        }
    }
}
