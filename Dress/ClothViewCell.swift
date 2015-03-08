//
//  ClothViewCell.swift
//  Dress
//
//  Created by Alec on 14/12/29.
//  Copyright (c) 2014年 Alec. All rights reserved.
//


class ClothViewCell: UICollectionViewCell {

    var imageView:UIImageView?
    var lblText:UILabel?
    
    override init(frame:CGRect){
        super.init(frame:frame)
        let frame = CGRectMake(5, 5, frame.size.width - 10, frame.size.height - 30)
        self.imageView = UIImageView(frame: frame)
        self.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        self.imageView?.userInteractionEnabled = true
        self.lblText = UILabel(frame: CGRectMake(5, frame.size.height, frame.size.width, 30))
        self.lblText?.font = UIFont.systemFontOfSize(12.0)
//        self.lblText?.textColor = UIColor.whiteColor()
        self.contentView.addSubview(self.imageView!)
        self.contentView.addSubview(self.lblText!)
//        self.contentView.backgroundColor = UIColor(red: 243/255.0, green: 243/255.0, blue: 241/255.0, alpha: 1.0)
        self.lblText?.textAlignment = NSTextAlignment.Center
        self.lblText?.textColor = mainWordColor()
    }
    

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
