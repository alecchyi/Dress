//
//  InfoListItemCell.swift
//  Dress
//
//  Created by Alec on 15-1-30.
//  Copyright (c) 2015年 Alec. All rights reserved.
//

class InfoListItemCell: UITableViewCell {

    @IBOutlet var headImg:UIImageView?
    @IBOutlet var lblTitle:UILabel?
    @IBOutlet var lblSource:UILabel?
    @IBOutlet var lblTag:UILabel?
    @IBOutlet var lblContent:UILabel?
    @IBOutlet var likeImg:UIImageView?
    @IBOutlet var lblLike:UILabel?
    @IBOutlet var shareImg:UIImageView?
    @IBOutlet var lblShare:UILabel?
    @IBOutlet var lblAuthor:UILabel?
    @IBOutlet var smallImg:UIImageView?
    @IBOutlet var btnView:UIView?
    var has_small_img:Bool = false
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var frame:CGRect = self.lblContent!.frame
        frame.origin.x = 8
        frame.origin.y = 58

        if(self.has_small_img){
            frame.origin.x = 8
            frame.origin.y = frame.origin.y + frame.size.height + 5
            frame.size.width = 80
            frame.size.height = 80
            self.smallImg!.frame = frame
        }else{
            frame.origin.x = 8
            frame.origin.y = frame.origin.y + frame.size.height + 5
            frame.size.width = 0
            frame.size.height = 0
            self.smallImg!.frame = frame
        }
        frame.origin.y = frame.origin.y + frame.size.height + 5
        frame.size.width = self.btnView!.frame.size.width
        frame.size.height = 25
        self.btnView!.frame = frame
        self.btnView!.backgroundColor = UIColor.clearColor()
        var bottomLayer = CALayer(layer: nil)
        bottomLayer.frame = CGRectMake(0, 0, frame.size.width, 1)
        bottomLayer.backgroundColor = mainColor().CGColor
        self.btnView!.layer.addSublayer(bottomLayer)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
