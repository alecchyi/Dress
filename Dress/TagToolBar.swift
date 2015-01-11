//
//  TagToolBar.swift
//  Dress
//
//  Created by Alec on 14-12-28.
//  Copyright (c) 2014年 Alec. All rights reserved.
//


class TagToolBar: UIView {
    
    var allTags:NSArray?
    
    override init(frame:CGRect) {
        super.init(frame:frame)
//        getAllTag()
//        self.frame = frame
//        initSubview()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getAllTag(){
        allTags = NSMutableArray(contentsOfFile: DataService.shareService.getTagsPlist())
        if(allTags == nil){
            
            var tag:NSMutableDictionary = NSMutableDictionary()
            tag.setValue(0, forKey: "id")
            tag.setValue("运动", forKey: "name")
            
            var tag1 = NSMutableDictionary()
            tag1.setValue(1, forKey: "id")
            tag1.setValue("休闲", forKey: "name")
            
            var tag2 = NSMutableDictionary()
            tag2.setValue(2, forKey: "id")
            tag2.setValue("商务", forKey: "name")
            
            var tag3 = NSMutableDictionary()
            tag3.setValue(3, forKey: "id")
            tag3.setValue("流行", forKey: "name")
            allTags = NSMutableArray(array: [tag,tag1,tag2,tag3])
                        println(allTags)
            allTags!.writeToFile(DataService.shareService.getTagsPlist(), atomically: true)
        }else{
            println(4444)
        }
        
    }
    
    func initSubview(){
        var i:Int = 0
        
        while(i<allTags?.count){
            //            var x:Float = *(i,70)
            var frame:CGRect = CGRectMake(30, 10, 40, 30)
            var btn = UIButton(frame: frame)
            btn.titleLabel?.text = (allTags?.objectAtIndex(i) as NSDictionary).objectForKey("name") as? String
            btn.titleLabel?.textColor = UIColor.whiteColor()
            btn.backgroundColor = UIColor.blackColor()
            self.addSubview(btn)
            i++
            
        }
    }
}
