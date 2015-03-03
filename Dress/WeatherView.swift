//
//  WeatherView.swift
//  Dress
//
//  Created by Alec on 15/1/16.
//  Copyright (c) 2015年 Alec. All rights reserved.
//


class WeatherView: UIView {
    
    let bgColor = UIColor(red: 243/255.0, green: 243/255.0, blue: 230/255.0, alpha: 0.75)
    
    var lblTemp:UILabel?
    var lblDesc:UILabel?

    override init(frame:CGRect){
        super.init(frame:frame)
        self.backgroundColor = mainNavBarColor()
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCustomView(){
        if let weather = DataService.shareService.weather {
            println(weather.objectForKey("dayPicUrl"))
            let picPath = weather.objectForKey("dayPicUrl") as? NSString
            if(picPath == nil){
                var lblWeather = UILabel(frame: CGRectMake(50, 10, 150, 20))
                lblWeather.text = "暂无天气数据"
                lblWeather.textColor = weatherWordColor()
                self.addSubview(lblWeather)
            }else{
                var wImgView = UIImageView(frame: CGRectMake(5, 20, 45, 45))
                wImgView.contentMode = UIViewContentMode.ScaleAspectFit
                let picUrl = NSURL(string: picPath!)
                let imgData:NSData = NSData(contentsOfURL: picUrl!)!
                var img:UIImage = UIImage(data: imgData, scale: 1.0)!
                
                wImgView.image = img
                self.addSubview(wImgView)
                var lblTempView = UILabel(frame: CGRectMake(5, 2, 80, 20))
                let temp:NSString = weather.objectForKey("temp") as NSString!
                lblTempView.text = temp
                lblTempView.font = UIFont.systemFontOfSize(14)
                lblTempView.textColor = weatherWordColor()
                self.addSubview(lblTempView)
                
                var lblCity = UILabel(frame: CGRectMake(5, 59, 80, 20))
                lblCity.text = weather.objectForKey("currentCity") as NSString!
                lblCity.font = UIFont.systemFontOfSize(14)
                lblCity.textColor = weatherWordColor()
                self.addSubview(lblCity)
                
                var lblWeather = UILabel(frame: CGRectMake(65, 2, 170, 20))
                lblWeather.text = (weather.objectForKey("weatherDesc") as NSString!) + " " + (weather.objectForKey("wind") as NSString!)
                lblWeather.font = UIFont.systemFontOfSize(14)
                lblWeather.textColor = weatherWordColor()
                self.addSubview(lblWeather)
                
                var lblIndexZs = UILabel(frame: CGRectMake(240, 2, 70, 20))
                lblIndexZs.text = weather.objectForKey("dressIndexZs") as NSString!
                lblIndexZs.font = UIFont.systemFontOfSize(14)
                lblIndexZs.textColor = weatherWordColor()
                self.addSubview(lblIndexZs)
                
                var dressTextView = UITextView(frame: CGRectMake(60, 18, 250, 70))
                dressTextView.editable = false
                dressTextView.selectable = false
                dressTextView.backgroundColor = UIColor.clearColor()
                dressTextView.text = (weather.objectForKey("dress") as NSString!) +  ":" + (weather.objectForKey("dressDesc") as NSString!)
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
