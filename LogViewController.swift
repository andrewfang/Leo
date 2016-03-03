//
//  LogViewController.swift
//  zaldy
//
//  Created by Andrew Fang on 3/1/16.
//  Copyright © 2016 Fang Industries. All rights reserved.
//

import UIKit

class LogViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var labelHowManyDays: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Log"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir Light", size: 22.0)!, NSForegroundColorAttributeName: UIColor.appColor()]
        
        self.tabBarController?.tabBar.tintColor = UIColor.appColor()
        if let bkgd = UIImage(named: "chatBackground") {
            self.view.layer.contents = bkgd.CGImage
        }
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.labelHowManyDays.text = "Completed 7 of the last 14 days"
    }
    
    // MARK: - Collection View delegate
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        var cellName:String
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Log Cell", forIndexPath: indexPath)
        
        if let cell = cell as? LogCollectionViewCell {
            cell.labelDate.text = "3/\(indexPath.item)"
            if (indexPath.item % 2 == 0) {
                cell.imgCircle.image = UIImage(named: "logCircle")
            } else {
                cell.imgCircle.image = UIImage(named: "logCircleFilled")
            }
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
//        let numOfItems = self.nextChat.user.count
//        let totalCharCount = self.nextChat.user.reduce(0, combine: {$0 + $1.characters.count})
//        let padding = (numOfItems - 1) * 10
//        var potentialWidth = CGFloat(numOfItems * 20 + padding + totalCharCount * 12)
//        
//        if (potentialWidth > UIScreen.mainScreen().bounds.width) {
//            potentialWidth = UIScreen.mainScreen().bounds.width
//            self.chatOptionsHeight.constant = 100
//        } else {
//            self.chatOptionsHeight.constant = 50
//        }
        
//        self.chatOptionsWidth.constant = potentialWidth
        
        return 14
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let width = UIScreen.mainScreen().bounds.width / 10
        return CGSizeMake(width, 65)
    }
    
}
