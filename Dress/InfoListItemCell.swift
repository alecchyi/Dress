//
//  InfoListItemCell.swift
//  Dress
//
//  Created by Alec on 15-1-30.
//  Copyright (c) 2015年 Alec. All rights reserved.
//

protocol InfoListItemCellDelegate {
    func clickMainView(sender:UITapGestureRecognizer)
    func clickLikeBtn(tag:Int)
    func clickShareBtn(tag:Int)
}

class InfoListItemCell: UITableViewCell {

    @IBOutlet var headImg:UIImageView?
    @IBOutlet var lblTitle:UILabel?
    @IBOutlet var lblSource:UILabel?
    @IBOutlet var lblTag:UILabel?
    @IBOutlet var lblContent:UILabel?
    @IBOutlet var likeBtn:UIButton?
    @IBOutlet var lblLike:UILabel?
    @IBOutlet var shareBtn:UIButton?
    @IBOutlet var lblShare:UILabel?
    @IBOutlet var lblAuthor:UILabel?
    @IBOutlet var smallImg:UIImageView?
    @IBOutlet var btnView:UIView?
    @IBOutlet var mainView:UIView?
    
    var delegate:InfoListItemCellDelegate?
    var indexPath:NSIndexPath?
    
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
        let height = frame.origin.y
        frame = self.mainView!.frame
        frame.size.height = height
        self.mainView!.frame = frame
        self.btnView!.backgroundColor = UIColor.clearColor()
        var bottomLayer = CALayer(layer: nil)
        bottomLayer.frame = CGRectMake(0, 0, frame.size.width - 15, 1)
        bottomLayer.backgroundColor = mainColor().CGColor
        self.btnView!.layer.addSublayer(bottomLayer)
        
        let clickMainView:Selector = "clickMainView:"
        let tapActionGesture = UITapGestureRecognizer(target: self, action: clickMainView)
        self.mainView?.removeGestureRecognizer(tapActionGesture)
        self.mainView?.addGestureRecognizer(tapActionGesture)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init() {
        super.init()
        
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func clickMainView(sender:UITapGestureRecognizer) {
        if(self.respondsToSelector("clickMainView:")){
            delegate?.clickMainView(sender)
        }
    }
    
    @IBAction func clickLikeBtn(){
        let tag = self.likeBtn?.tag
        delegate?.clickLikeBtn(tag!)
    }
    
    @IBAction func clickShareBtn(){
        let tag = self.shareBtn?.tag
        delegate?.clickShareBtn(tag!)
    }
}
