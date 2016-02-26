//
//  ChatViewController.swift
//  zaldy
//
//  Created by Andrew Fang on 2/23/16.
//  Copyright © 2016 Fang Industries. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var chats:[ChatItem] = []
    
    var nextChat:ChatConvo = ChatConvo(ai: "Have you done your exercises for today?", user:["Yes!", "Not yet"])
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var chatOptionsWidth: NSLayoutConstraint!
    @IBOutlet weak var chatOptionsHeight: NSLayoutConstraint!
    
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

        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        
        
        self.title = "Zaldy"
        if let bkgd = UIImage(named: "chatBackground") {
            self.view.layer.contents = bkgd.CGImage
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "notificationChanged", name: "NotificationSettingsChanged", object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "clearChat", name: "AppEnteredForeground", object: nil)
        
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
    
    // MARK: - Collection View delegate
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
        let totalCharCount = self.nextChat.user.reduce(0, combine: {$0 + $1.characters.count})
        let padding = (numOfItems - 1) * 10
        var potentialWidth = CGFloat(numOfItems * 20 + padding + totalCharCount * 12)
        
        if (potentialWidth > UIScreen.mainScreen().bounds.width) {
            potentialWidth = UIScreen.mainScreen().bounds.width
            self.chatOptionsHeight.constant = 100
        } else {
            self.chatOptionsHeight.constant = 50
        }
        
        self.chatOptionsWidth.constant = potentialWidth
        
        return numOfItems
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(CGFloat(self.nextChat.user[indexPath.item].characters.count * 12 + 20), 40)
    }
    
    // MARK: - Chat responses
    func respond(sender: UIButton) {
        
        guard let buttonText = sender.titleLabel?.text else {
            return
        }
        
        self.chats.append(ChatItem(content: buttonText, type: .User))
        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.chats.count - 1, inSection: 0)], withRowAnimation: .Fade)
        
        if (!shouldPerformSpecialAction(sender)) {
            self.nextChat = Database.getResponseTo(buttonText)
            self.insertNextChat()
        }
    }
    
    // Basically a giant switch statement that responds based on user input
    func shouldPerformSpecialAction(sender: UIButton) -> Bool {
        
        guard let buttonText = sender.titleLabel?.text else {
            return false
        }
        
        if (buttonText.containsString("Here's a photo")) {
            
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
                self.insertNextChat()
            }))
            
            optionPicker.popoverPresentationController?.sourceView = sender
            optionPicker.popoverPresentationController?.sourceRect = sender.bounds
            optionPicker.popoverPresentationController?.permittedArrowDirections = .Up
            presentViewController(optionPicker, animated: true, completion: nil)
            return true
        } else if (buttonText.containsString("Set a reminder")) {
            
            let notifSettings = UIApplication.sharedApplication().currentUserNotificationSettings()
            
            if (notifSettings == nil || notifSettings?.types == UIUserNotificationType.None) {
                self.nextChat = ChatConvo(ai: "Looks like I'll need to enable push notifications first. Can I do that?", user: ["Enable notifications", "Not now"])
                self.insertNextChat()
                return true
            }
            
            let optionPicker = UIAlertController(title: "Set a reminder", message: "When do you want to be reminded?", preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            optionPicker.addAction(UIAlertAction(title: "5 minutes", style: .Default, handler: {action in
                self.setupReminder(1)
                self.nextChat = ChatConvo(ai: "I've scheduled a notification to remind you to do your exercises in 5 minutes", user: ["Thanks"])
                self.insertNextChat()
            }))
            
            optionPicker.addAction(UIAlertAction(title: "10 minutes", style: .Default, handler: {action in
                self.setupReminder(10)
                self.nextChat = ChatConvo(ai: "I've scheduled a notification to remind you to do your exercises in 10 minutes", user: ["Thanks"])
                self.insertNextChat()
            }))
            
            optionPicker.addAction(UIAlertAction(title: "30 minutes", style: .Default, handler: {action in
                self.setupReminder(30)
                self.nextChat = ChatConvo(ai: "I've scheduled a notification to remind you to do your exercises in 30 minutes", user: ["Thanks"])
                self.insertNextChat()
            }))
            
            optionPicker.addAction(UIAlertAction(title: "1 hour", style: .Default, handler: {action in
                self.setupReminder(60)
                self.nextChat = ChatConvo(ai: "I've scheduled a notification to remind you to do your exercises in 1 hour", user: ["Thanks"])
                self.insertNextChat()
            }))
            
            
            optionPicker.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: {action in
                self.nextChat = ChatConvo(ai: "Are you sure you don't want to set a reminder?", user: ["Set a reminder!", "Not now"])
                self.insertNextChat()
            }))
            
            optionPicker.popoverPresentationController?.sourceView = sender
            optionPicker.popoverPresentationController?.sourceRect = sender.bounds
            optionPicker.popoverPresentationController?.permittedArrowDirections = .Up
            presentViewController(optionPicker, animated: true, completion: nil)
            return true
        } else if (buttonText.containsString("Enable notifications")) {
            let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert ,.Badge , .Sound], categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
            return true
        } else if (buttonText.containsString("Go to settings")) {
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
            return true
        }
        return false
    }
    
    private func insertNextChat() {
        self.chats.append(ChatItem(content: self.nextChat.ai, type: .AI))
        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.chats.count - 1, inSection: 0)], withRowAnimation: .Fade)
        self.collectionView.reloadData()
        
        self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.chats.count - 1, inSection: 0), atScrollPosition: .Bottom, animated: false)
    }
    
    
    // MARK: - Reminder notification
    private func setupReminder(minutes:NSTimeInterval) {
        
        let notification = UILocalNotification()
        notification.fireDate = NSDate(timeIntervalSinceNow: 60*minutes)
        
        notification.alertBody = "Time to do your exercises!"
        notification.alertAction = "Okay!"
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        print(UIApplication.sharedApplication().scheduledLocalNotifications)
    }
    
    func notificationChanged() {
        let notifSettings = UIApplication.sharedApplication().currentUserNotificationSettings()
        if (notifSettings == nil || notifSettings?.types == UIUserNotificationType.None) {
            self.nextChat = ChatConvo(ai: "Notifications are still not enabled. Please go to Settings->Zaldy to enable notifications", user: ["Go to settings"])
            self.insertNextChat()
        } else {
            self.nextChat = ChatConvo(ai: "Thanks! Let's set up that reminder", user: ["Set a reminder!", "Not now"])
            self.insertNextChat()
        }
    }
    
    // MARK: Clear chat
    func clearChat() {
        self.chats.removeAll()
        self.tableView.reloadData()
        self.collectionView.reloadData()
    }
}

// MARK:- Image Picker
extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
        self.insertNextChat()
        
        picker.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Called on cancel
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        self.nextChat = ChatConvo(ai: "I'm sorry, I didn't get the photo. Can you try sending it again?", user: ["Here's a photo!", "Not now"])
        self.insertNextChat()
        
        picker.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
