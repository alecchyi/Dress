//
//  WeatherView.swift
//  Dress
//
//  Created by Alec on 15/1/16.
//  Copyright (c) 2015年 Alec. All rights reserved.
//


class WeatherView: UIView {

    override init(frame:CGRect){
        super.init(frame:frame)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCustomView(){
        
        if let weather = DataService.shareService.weather? {
            var wImgView = UIImageView(frame: CGRectMake(5, 10, 45, 45))
            wImgView.contentMode = UIViewContentMode.ScaleAspectFit
            let picPath = DataService.shareService.weather!.objectForKey("dayPicUrl") as NSString!
            let picUrl = NSURL(string: picPath!)
            let imgData:NSData = NSData(contentsOfURL: picUrl!)!
            wImgView.image = UIImage(data: imgData, scale: 1.0)!
            self.addSubview(wImgView)
            var lblTempView = UILabel(frame: CGRectMake(5, 55, 80, 20))
            let temp:NSString = DataService.shareService.weather!.objectForKey("temp") as NSString!
            lblTempView.text = temp
            self.addSubview(lblTempView)
            var lblWeather = UILabel(frame: CGRectMake(55, 10, 70, 20))
            lblWeather.text = DataService.shareService.weather!.objectForKey("weatherDesc") as NSString!
            self.addSubview(lblWeather)
            
            var lblIndexZs = UILabel(frame: CGRectMake(130, 10, 70, 20))
            lblIndexZs.text = DataService.shareService.weather!.objectForKey("dressIndexZs") as NSString!
            self.addSubview(lblIndexZs)
            
            var dressTextView = UITextView(frame: CGRectMake(50, 30, 250, 70))
            dressTextView.editable = false
            dressTextView.text = (DataService.shareService.weather!.objectForKey("dress") as NSString!) +  ":" + (DataService.shareService.weather!.objectForKey("dressDesc") as NSString!)
            self.addSubview(dressTextView)
            
        }else {
            println(44444)
            var lblWeather = UILabel(frame: CGRectMake(50, 5, 50, 20))
            lblWeather.text = "暂无天气数据"
            self.addSubview(lblWeather)
        }
    }
}
