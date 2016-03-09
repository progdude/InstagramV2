//
//  ViewController.swift
//  InstagramV2
//
//  Created by Archit Rathi on 2/16/16.
//  Copyright © 2016 Archit Rathi. All rights reserved.
//

import UIKit
import Parse

let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class ViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate {

    
    
    
    var posts: [PFObject]!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var testImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        usernameLabel.text = PFUser.currentUser()?.username
       
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let query = PFQuery(className: "UserMedia")
        //query = PFQuery(className: "UserMedia", predicate: predicate)
        //query.whereKey("likesCount", lessThan: 100)
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20
        
        let media = PFObject(className: "UserMedia")
        //media["author"] = PFUser.currentUser()
         print("asdf")
        
        query.findObjectsInBackgroundWithBlock { (media: [PFObject]?, error: NSError?) -> Void in
            
            //self.tableView.reloadData()
            if let media = media {
                
                self.posts = media
                self.tableView.reloadData()
                //print(self.feed!)
                // do something with the data fetched
            } else {
                // handle error
            }
            
        }
        print("hello hello hello")
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    @IBAction func onLogout(sender: AnyObject) {
        PFUser.logOut()
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    /*func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            
            let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            //let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
            self.dismissViewControllerAnimated(false, completion: nil)
            testImage.image = originalImage
            
    }*/
    /*@IBAction func openPhotoLibrary(sender: AnyObject) {
        var photoPicker = UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.sourceType = .PhotoLibrary
        
        self.presentViewController(photoPicker, animated: true, completion: nil)
    }*/
    /*func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRectMake(0, 0, newSize.width, newSize.height))
        resizeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }*/
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let posts = posts {
            print(posts.count)
            return posts.count
        }
        else {
            return 0
        }
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        print("a")
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell", forIndexPath: indexPath) as! PostCell
        
        let post = self.posts![indexPath.row]
        //let numLikes = post["likesCount"]
        //print("a")
        cell.usernameLabel.text = post["author"].username
        cell.captionLabel.text = post["caption"] as? String
        //cell.numLikes.text = numLikes as? String
        //print("b")
        let pictureFile = post["media"] as! PFFile
        
        pictureFile.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    let image = UIImage(data:imageData)
                    cell.photoView.image = image
                }
            }
            
        }
        
        return cell
    }
    //optional public func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])

}

