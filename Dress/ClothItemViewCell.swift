//
//  ClothItemViewCell.swift
//  Dress
//
//  Created by dst-macpro1 on 15/10/12.
//  Copyright (c) 2015年 Alec. All rights reserved.
//

import UIKit

class ClothItemViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        self.imageView?.userInteractionEnabled = true
        self.lblText?.font = UIFont.systemFontOfSize(14.0)

        self.lblText?.textAlignment = NSTextAlignment.Center
        self.lblText?.textColor = mainWordColor()
    }

}
