//
//  WeatherView.swift
//  Dress
//
//  Created by Alec on 15/1/16.
//  Copyright (c) 2015年 Alec. All rights reserved.
//


class WeatherView: UIView {
    
    let bgColor = UIColor(red: 243/255.0, green: 243/255.0, blue: 230/255.0, alpha: 1.0)

    override init(frame:CGRect){
        super.init(frame:frame)
        self.backgroundColor = self.bgColor
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCustomView(){
        println(DataService.shareService.weather!)
        if let weather = DataService.shareService.weather? {
            var wImgView = UIImageView(frame: CGRectMake(5, 25, 45, 45))
            wImgView.contentMode = UIViewContentMode.ScaleAspectFit
            let picPath = DataService.shareService.weather!.objectForKey("dayPicUrl") as NSString!
            if(picPath == nil){
                var lblWeather = UILabel(frame: CGRectMake(50, 10, 150, 20))
                lblWeather.text = "暂无天气数据"
                self.addSubview(lblWeather)
            }else{
                let picUrl = NSURL(string: picPath!)
                let imgData:NSData = NSData(contentsOfURL: picUrl!)!
                wImgView.image = UIImage(data: imgData, scale: 1.0)!
                self.addSubview(wImgView)
                var lblTempView = UILabel(frame: CGRectMake(5, 10, 80, 20))
                let temp:NSString = DataService.shareService.weather!.objectForKey("temp") as NSString!
                lblTempView.text = temp
                lblTempView.font = UIFont.systemFontOfSize(16)
                self.addSubview(lblTempView)
                
                var lblCity = UILabel(frame: CGRectMake(5, 65, 80, 20))
                lblCity.text = DataService.shareService.weather!.objectForKey("currentCity") as NSString!
                lblCity.font = UIFont.systemFontOfSize(14)
                self.addSubview(lblCity)
                
                var lblWeather = UILabel(frame: CGRectMake(55, 10, 140, 20))
                lblWeather.text = (DataService.shareService.weather!.objectForKey("weatherDesc") as NSString!) + " " + (DataService.shareService.weather!.objectForKey("wind") as NSString!)
                self.addSubview(lblWeather)
                
                var lblIndexZs = UILabel(frame: CGRectMake(230, 10, 70, 20))
                lblIndexZs.text = DataService.shareService.weather!.objectForKey("dressIndexZs") as NSString!
                self.addSubview(lblIndexZs)
                
                var dressTextView = UITextView(frame: CGRectMake(50, 30, 250, 70))
                dressTextView.editable = false
                dressTextView.selectable = false
                dressTextView.backgroundColor = self.bgColor
                dressTextView.text = (DataService.shareService.weather!.objectForKey("dress") as NSString!) +  ":" + (DataService.shareService.weather!.objectForKey("dressDesc") as NSString!)
                self.addSubview(dressTextView)
            }
        }else {
            var lblWeather = UILabel(frame: CGRectMake(50, 10, 150, 20))
            lblWeather.text = "暂无天气数据"
            self.addSubview(lblWeather)
        }
    }
}
