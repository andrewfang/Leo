//
//  ChatViewController.swift
//  zaldy
//
//  Created by Andrew Fang on 2/23/16.
//  Copyright © 2016 Fang Industries. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var chats:[ChatItem] = []
    
    var nextChat:ChatConvo = ChatConvo(ai: "Have you done your exercises for today?", user:["Yes!", "Not yet"])
    
//    var nextChatResponse = ["I did my exercises today!"]
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var chatOptionsWidth: NSLayoutConstraint!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    private struct Constants {
        static let UserCell = "userCell"
        static let AICell = "aiCell"
        static let UserImageCell = "UserImageCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.appColor()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100.0
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
//        self.flowLayout = UICollectionViewFlowLayout()
//        self.collectionView.collectionViewLayout = self.flowLayout
//        self.flowLayout.itemSize = CGSizeMake(48.0, 100.0)
//        self.flowLayout.scrollDirection = .Horizontal
//        self.flowLayout.minimumInteritemSpacing = 5.0

        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        
        
        self.title = "Zaldy"
        if let bkgd = UIImage(named: "chatBackground") {
            self.view.layer.contents = bkgd.CGImage
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if (self.chats.count == 0) {
            self.chats.append(ChatItem(content: self.nextChat.ai, type: .AI))
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.chats.count - 1, inSection: 0)], withRowAnimation: .Fade)
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell
        let chatItem = chats[indexPath.item]
        
        // Different chat type for different user
        if chatItem.type == ChatType.AI {
            cell = tableView.dequeueReusableCellWithIdentifier(Constants.AICell, forIndexPath: indexPath)
        } else if chatItem.type == .User && chatItem.image == nil {
            cell = tableView.dequeueReusableCellWithIdentifier(Constants.UserCell, forIndexPath: indexPath)
        } else if chatItem.type == .User && chatItem.image != nil {
            cell = tableView.dequeueReusableCellWithIdentifier(Constants.UserImageCell, forIndexPath: indexPath)
        } else {
            // Shouldn't really get to this case but...
            cell = tableView.dequeueReusableCellWithIdentifier(Constants.UserCell, forIndexPath: indexPath)
        }
        
        // Set the text to be the chat item's content
        if let cell = cell as? ChatTableViewCell {
            if chatItem.type == .User {
                cell.content.backgroundColor = UIColor.appColor()
            }
            
            cell.content.text = chatItem.content
            if let tip = chatItem.tip {
                cell.tip = tip
                if tip.url != nil {
                    cell.content.text = cell.content.text! + " 🔗"
                }
            }
        } else if let cell = cell as? ChatImageTableViewCell {
            if chatItem.type == .User {
                cell.chatView.backgroundColor = UIColor.appColor()
            }
            
            cell.sentImage.image = chatItem.image
        }
        
        cell.layoutIfNeeded()
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    @IBAction func sayRandomTip(sender: UIButton) {
        guard let buttonText = sender.titleLabel?.text else {
            return
        }
        
        self.chats.append(ChatItem(content: buttonText, type: .User))
        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.chats.count - 1, inSection: 0)], withRowAnimation: .Fade)
        
        let tip = Database.getRandomTip()
        self.chats.append(ChatItem(content: tip, type: .AI))
        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.chats.count - 1, inSection: 0)], withRowAnimation: .Fade)
        
        self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.chats.count - 1, inSection: 0), atScrollPosition: .Bottom, animated: false)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let urlString = self.chats[indexPath.item].tip?.url {
            if let _ = NSURL(string: urlString) {
                //                performSegueWithIdentifier(CellSegues.ShowWebSegue, sender: url)
            }
        }
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    // MARK: - Collection view
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Action Cell", forIndexPath: indexPath)
        if let cell = cell as? ChatResposeCollectionViewCell {
            cell.btnResponse.setTitle(self.nextChat.user[indexPath.item], forState: .Normal)
            cell.btnResponse.addTarget(self, action: "respond:", forControlEvents: .TouchUpInside)
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let numOfItems = self.nextChat.user.count
        self.chatOptionsWidth.constant = CGFloat(numOfItems * 150 + (numOfItems - 1) * 10)
        return numOfItems
    }
    
    func respond(sender: UIButton) {
        
        guard let buttonText = sender.titleLabel?.text else {
            return
        }
        
        self.chats.append(ChatItem(content: buttonText, type: .User))
        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.chats.count - 1, inSection: 0)], withRowAnimation: .Fade)
        
        if (buttonText.containsString("photo")) {
            
            let optionPicker = UIAlertController(title: "Exercise Image", message: "Fetch the photo of you doing your PT exercise", preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            // Allow user to take a photo
            if (UIImagePickerController.isSourceTypeAvailable(.Camera)) {
                optionPicker.addAction(alertActionWithPickerType(.Camera, title: "Camera"))
            }
            
            // Allow user to choose from saved photos
            if (UIImagePickerController.isSourceTypeAvailable(.SavedPhotosAlbum)) {
                optionPicker.addAction(alertActionWithPickerType(.SavedPhotosAlbum, title: "Album"))
            }
            
            optionPicker.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: {action in
                self.nextChat = ChatConvo(ai: "I'm sorry, I didn't get the photo. Can you try sending it again?", user: ["Here's a photo!", "Not now"])
                self.chats.append(ChatItem(content: self.nextChat.ai, type: .AI))
                self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.chats.count - 1, inSection: 0)], withRowAnimation: .Fade)
                self.collectionView.reloadData()
                
                self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.chats.count - 1, inSection: 0), atScrollPosition: .Bottom, animated: false)
            }))
            
            optionPicker.popoverPresentationController?.sourceView = sender
            optionPicker.popoverPresentationController?.sourceRect = sender.bounds
            optionPicker.popoverPresentationController?.permittedArrowDirections = .Up
            presentViewController(optionPicker, animated: true, completion: nil)
        } else {
        
            self.nextChat = Database.getResponseTo(buttonText)
            self.chats.append(ChatItem(content: self.nextChat.ai, type: .AI))
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.chats.count - 1, inSection: 0)], withRowAnimation: .Fade)
            
            self.collectionView.reloadData()
            
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.chats.count - 1, inSection: 0), atScrollPosition: .Bottom, animated: false)
        }
    }
    
    // MARK:- Image Picker
    // Add in a alert action option that triggers a UIImagePickerController
    private func alertActionWithPickerType(pickerType:UIImagePickerControllerSourceType, title:String) -> UIAlertAction {
        return UIAlertAction(title: title, style: .Default, handler: { action in
            let imgPicker = UIImagePickerController()
            imgPicker.allowsEditing = true
            imgPicker.delegate = self
            imgPicker.sourceType = pickerType
            imgPicker.navigationBar.translucent = false
            imgPicker.navigationBar.tintColor = UIColor.whiteColor()
            imgPicker.navigationBar.barTintColor = UIColor.appColor()
            imgPicker.navigationBar.titleTextAttributes = [
                NSForegroundColorAttributeName : UIColor.whiteColor(),
                NSFontAttributeName : UIFont.systemFontOfSize(18.0, weight: UIFontWeightLight),
            ]
            self.presentViewController(imgPicker, animated: true, completion: nil)
        })
    }
    
    // Called when the user confirms a photo
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.chats.append(ChatItem(image: image, type: .User))
        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.chats.count - 1, inSection: 0)], withRowAnimation: .Fade)
        self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.chats.count - 1, inSection: 0), atScrollPosition: .Bottom, animated: false)
        
        self.nextChat = ChatConvo(ai: "Your form looks great! Keep up the good work!", user: ["Sweet"])
        self.chats.append(ChatItem(content: self.nextChat.ai, type: .AI))
        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.chats.count - 1, inSection: 0)], withRowAnimation: .Fade)
        self.collectionView.reloadData()

        picker.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Called on cancel
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        self.nextChat = ChatConvo(ai: "I'm sorry, I didn't get the photo. Can you try sending it again?", user: ["Here's a photo!", "Not now"])
        self.chats.append(ChatItem(content: self.nextChat.ai, type: .AI))
        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.chats.count - 1, inSection: 0)], withRowAnimation: .Fade)
        self.collectionView.reloadData()
        
        self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.chats.count - 1, inSection: 0), atScrollPosition: .Bottom, animated: false)
        
        picker.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Segues kicked off by cell
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == CellSegues.FoodDetailSegue {
//            if let item = sender as? FoodItem,
//                let destVc = segue.destinationViewController as? FoodDetailsViewController {
//                    destVc.item = item
//            }
//        } else if segue.identifier == CellSegues.ShowWebSegue {
//            if let link = sender as? NSURL,
//                let navVC = segue.destinationViewController as? UINavigationController {
//                    if let destVc = navVC.viewControllers.first as? WebViewController {
//                        destVc.linkUrl = link
//                    }
//            }
//        }
    }
    
    
}
