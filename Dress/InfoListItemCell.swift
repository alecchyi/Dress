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
    @IBOutlet var contentTextView:UITextView?
    @IBOutlet var likeImg:UIImageView?
    @IBOutlet var lblLike:UILabel?
    @IBOutlet var shareImg:UIImageView?
    @IBOutlet var lblShare:UILabel?
    @IBOutlet var lblAuthor:UILabel?
    @IBOutlet var smallImg:UIImageView?
    @IBOutlet var btnView:UIView?
    
    override func setNeedsLayout() {
//        println("dffffff")
        super.setNeedsLayout()
    }
    
    override func layoutIfNeeded() {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        println("layout subviews")
//        self.contentTextView!.
        var dict:NSMutableDictionary = NSMutableDictionary()
        dict.setObject(UIFont(name: "HelveticaNeue", size: 17)!, forKey: NSFontAttributeName)
        let size = self.contentTextView!.text.sizeWithAttributes(dict)
        var frame:CGRect = self.contentTextView!.bounds as CGRect
//        size = self.contentTextView!.contentSize
        frame.origin.x = 5
        frame.origin.y = 55
        
        if(self.smallImg?.hidden == false){
            frame.size.height = size.height + 20
            self.contentTextView!.frame = frame
            
            frame.origin.x = 8
            frame.origin.y = frame.origin.y + frame.size.height
            frame.size.width = 80
            frame.size.height = self.smallImg!.frame.size.height
            self.smallImg!.frame = frame
        }else{
            frame.size.height = size.height + 10
            self.contentTextView!.frame = frame
            frame.origin.x = 8
            frame.origin.y = frame.origin.y + frame.size.height
            frame.size.width = 0
            frame.size.height = 0
            self.smallImg!.frame = frame
            println("hidden")
        }
        frame.origin.y = frame.origin.y + frame.size.height + 5
        frame.size.width = self.btnView!.frame.size.width
        frame.size.height = 25
        self.btnView!.frame = frame
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
