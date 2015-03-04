//
//  StyleTableViewController.swift
//  Dress
//
//  Created by Alec on 15-2-13.
//  Copyright (c) 2015年 Alec. All rights reserved.
//

import UIKit

class StyleTableViewController: UITableViewController,UITableViewDataSource,UITableViewDelegate {

    var infoList:NSMutableArray?
    var selectedInfos:NSMutableArray?
    @IBOutlet var infoTableView:UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        initNavBarView()
        
        self.infoTableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        self.infoList = NSMutableArray()
    }
    
    func initNavBarView(){
        
        var navBar = self.navigationController?.navigationBar
        navBar?.tintColor = UIColor.whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        var query = AVQuery(className: "Tags")
        query.whereKey("parent_id", equalTo: "system")
        query.getFirstObjectInBackgroundWithBlock({(obj:AVObject!, error:NSError!) in
            if(error==nil && obj !=  nil){
                var req = AVQuery(className: "Tags")
                req.whereKey("parent_id", equalTo: (obj.objectForKey("objectId") as String))
                req.findObjectsInBackgroundWithBlock({(tags:[AnyObject]!, err:NSError!) in
                    if(err==nil && tags != nil){
                        self.infoList = NSMutableArray(array: tags)
                        self.infoTableView?.reloadData()
                    }
                })
            }else{
                self.infoList = NSMutableArray()
            }
        })
        self.selectedInfos = NSMutableArray()
        
        query = AVQuery(className: "UserTags")
        query.whereKey("user_id", equalTo: DataService.shareService.userToken!)
        query.getFirstObjectInBackgroundWithBlock({(obj:AnyObject!,error:NSError!) in
            if(error == nil){
                let tags = obj.objectForKey("tags") as NSArray
                self.selectedInfos = NSMutableArray(array: tags)
                self.infoTableView?.reloadData()
                println(self.selectedInfos)
            }
        })
    }
    
    override func viewWillDisappear(animated: Bool) {
        //        println(self.selectedInfos)
        var query = AVQuery(className: "UserTags")
        query.whereKey("user_id", equalTo: DataService.shareService.userToken!)
        query.getFirstObjectInBackgroundWithBlock({(obj:AVObject!,error:NSError!) in
            var user_tags = AVObject(className: "UserTags")
            if(error == nil){
                //                obj.deleteInBackground()
                obj.deleteInBackgroundWithBlock({(flag:Bool!,error:NSError!) in
                    
                })
            }
            if(self.selectedInfos!.count > 0){
                user_tags.setObject(DataService.shareService.userToken!, forKey: "user_id")
                user_tags.addUniqueObjectsFromArray(self.selectedInfos!, forKey: "tags")
                user_tags.saveInBackground()
            }
            
        })
        
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

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if let infos = self.infoList? {
            return infos.count
        }else{
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as? UITableViewCell
        if(cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "reuseIdentifier")
        }
        
        let item = self.infoList?.objectAtIndex(indexPath.row) as AVObject
        
        // Configure the cell...
        cell?.textLabel.text = item.objectForKey("name") as? String
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        let id:String = item.objectForKey("objectId") as String
        if((self.selectedInfos?.containsObject(id))!  == true){
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        }else{
            cell?.accessoryType = UITableViewCellAccessoryType.None
        }
        return cell!
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        let item = self.infoList?.objectAtIndex(indexPath.row) as AVObject
        let id:String = item.objectForKey("objectId") as String
        if((self.selectedInfos?.containsObject(id))!  == true){
            self.selectedInfos?.removeObject(id)
            cell?.accessoryType = UITableViewCellAccessoryType.None
        }else{
            self.selectedInfos?.addObject(id)
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
