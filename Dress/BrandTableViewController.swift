//
//  BrandTableViewController.swift
//  Dress
//
//  Created by Alec on 15-2-13.
//  Copyright (c) 2015年 Alec. All rights reserved.
//

import UIKit

class BrandTableViewController: UITableViewController,UITableViewDelegate,UITableViewDataSource {

    var infoList:NSMutableArray?
    var selectedInfos:NSMutableArray?
    @IBOutlet var infoTableView:UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        self.infoTableView?.tableFooterView = UIView()
        self.infoTableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        self.infoTableView?.delegate = self
        self.infoTableView?.dataSource = self
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.selectedInfos = NSMutableArray()
        var innerQuery = AVQuery(className: "Brands")
        if(is_network_connected()){
            var brands:NSArray = innerQuery.findObjects()
            var query = AVQuery(className: "_File")
            query.whereKey("objectId", matchesKey: "logo_file_id", inQuery: innerQuery)
            query.findObjectsInBackgroundWithBlock({(objs:[AnyObject]!,error:NSError!) in
                if(error != nil){
                    println(error)
                }else{
                    var infos:NSMutableArray = NSMutableArray()
                    var files:NSMutableArray = NSMutableArray(array: objs)
                    for(var i=0;i<files.count;i++){
                        var file: AnyObject = files.objectAtIndex(i)
                        var item = NSMutableDictionary()
                        item.setValue(file, forKey: "brand_logo")
                        for(var j=0;j<brands.count;j++){
                            let brand: AVObject = brands.objectAtIndex(j) as! AVObject
                            if((brand.objectForKey("logo_file_id") as! String) == (file.objectForKey("objectId") as! String)){
                                item.setValue(brand.objectForKey("name"), forKey: "brand_name")
                                item.setValue(brand.objectForKey("objectId"), forKey: "brand_id")
                                infos.addObject(item)
                                break
                            }
                        }
                    }
                    self.infoList = NSMutableArray(array: infos)
                    self.infoTableView?.reloadData()
                }
            })
            
            
            query = AVQuery(className: "UserBrands")
            query.whereKey("user_id", equalTo: DataService.shareService.userToken!)
            query.getFirstObjectInBackgroundWithBlock({(obj:AnyObject!,error:NSError!) in
                if(error == nil){
                    let brands = obj.objectForKey("brands") as! NSArray
                    self.selectedInfos = NSMutableArray(array: brands)
                    self.infoTableView?.reloadData()
                }
            })
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let infos = self.infoList {
            return infos.count
        }else{
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as? UITableViewCell
        if(cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "reuseIdentifier")
        }
        
        let item = self.infoList?.objectAtIndex(indexPath.row) as! NSMutableDictionary
        
        // Configure the cell...
        cell?.textLabel?.text = item.objectForKey("brand_name") as? String
        cell?.imageView?.image = UIImage(named: "default_head")
        cell?.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
//        cell?.backgroundColor = UIColor.blueColor()
        let logo = item.objectForKey("brand_logo") as! AVObject
        var file:AVFile = AVFile.fileWithURL((logo.objectForKey("url") as! String)) as! AVFile
        file.getThumbnail(true, width: 120, height: 120, withBlock: {(img:UIImage!, error:NSError!) in
            if(error == nil){
                cell?.imageView?.image = img
            }else{
                cell?.imageView?.image = nil
            }
        
        })
        let id:String = item.objectForKey("brand_id") as! String
        if((self.selectedInfos?.containsObject(id))!  == true){
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        }else{
            cell?.accessoryType = UITableViewCellAccessoryType.None
        }
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        let item = self.infoList?.objectAtIndex(indexPath.row) as! NSMutableDictionary
        let id:String = item.objectForKey("brand_id") as! String
        if((self.selectedInfos?.containsObject(id))!  == true){
            self.selectedInfos?.removeObject(id)
            cell?.accessoryType = UITableViewCellAccessoryType.None
        }else{
            self.selectedInfos?.addObject(id)
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        
    }

    override func viewWillDisappear(animated: Bool) {
//        println(self.selectedInfos)
        if(is_network_connected()){
        
            var query = AVQuery(className: "UserBrands")
            query.whereKey("user_id", equalTo: DataService.shareService.userToken!)
            query.getFirstObjectInBackgroundWithBlock({(obj:AVObject!,error:NSError!) in
                var user_brands = AVObject(className: "UserBrands")
                if(error == nil){
                    obj.deleteInBackground()
                }
                
                if(self.selectedInfos!.count > 0){
                    user_brands.setObject(DataService.shareService.userToken!, forKey: "user_id")
                    user_brands.addUniqueObjectsFromArray(self.selectedInfos! as [AnyObject], forKey: "brands")
                    user_brands.saveInBackground()
                }
                
            })
        }
    }
}
