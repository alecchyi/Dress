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
        let frame = CGRectMake(0, 0, frame.size.width, frame.size.height)
        self.imageView = UIImageView(frame: frame)
        self.lblText = UILabel(frame: CGRectMake(0, frame.size.height, frame.size.width, 30))
        
    }
    

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
