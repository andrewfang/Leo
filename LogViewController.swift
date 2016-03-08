//
//  LogViewController.swift
//  zaldy
//
//  Created by Andrew Fang on 3/1/16.
//  Copyright © 2016 Fang Industries. All rights reserved.
//

import UIKit

class LogViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate, UITabBarControllerDelegate{

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var detailsTitleLabel: UILabel!
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var notReadyWarning:UILabel!
    
    private var whichDay:Int! = 12
    
    var dates = ["2/28", "2/29", "3/1", "3/2", "3/3", "3/4", "3/5", "3/6", "3/7", "3/8", "3/9", "3/10", "3/11"]
    var didExercise = [false, true, true, false, true, false, true, true, false, true, true, true, false]
    
    var connected = false {
        didSet {
            if (self.collectionView != nil) {
                self.setContentHidden(!connected)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Log"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir Light", size: 22.0)!, NSForegroundColorAttributeName: UIColor.appColor()]
        
        self.tabBarController?.tabBar.tintColor = UIColor.appColor()
//        if let bkgd = UIImage(named: "chatBackground") {
//            self.view.layer.contents = bkgd.CGImage
//        }
        
        self.tabBarController?.delegate = self
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tintColor = UIColor.appColor()
        
        self.detailsView.layer.cornerRadius = 10.0
        self.detailsView.backgroundColor = UIColor.appColor()
        
        self.detailsTitleLabel.text = "Exercise Log for Today"
        
        self.setContentHidden(!self.connected)
    }
    
    private func setContentHidden(shouldHide:Bool) {
        let alpha:CGFloat = shouldHide ? 0.0 : 1.0
        self.collectionView.alpha = alpha
        self.detailsView.alpha = alpha
        self.notReadyWarning.alpha = abs(alpha - 1)
    }
    
    // MARK: - Collection View delegate
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        var cellName:String
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Log Cell", forIndexPath: indexPath)
        
        if let cell = cell as? LogCollectionViewCell {
            cell.labelDate.text = dates[indexPath.item]
            if (!didExercise[indexPath.item]) {
                cell.imgCircle.image = UIImage(named: "logCircle")
            } else {
                cell.imgCircle.image = UIImage(named: "logCircleFilled")
            }
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.whichDay = indexPath.item
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        if let cell = cell as? LogCollectionViewCell {
            if (self.isToday()) {
                self.detailsTitleLabel.text = "Exercise Log for Today"
            } else {
                self.detailsTitleLabel.text = "Exercise Log for \(cell.labelDate.text!)"
            }
        }
        
        UIView.animateWithDuration(0.5, animations: {
            self.detailsView.alpha = 1.0
        })
        self.tableView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let width = UIScreen.mainScreen().bounds.width / 10
        return CGSizeMake(width, 65)
    }
    
    // MARK: - Table View Delegate
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("exerciseCell", forIndexPath: indexPath)
        if let cell = cell as? ChecklistTableViewCell {
            switch (indexPath.item) {
            case 0:
                cell.checkboxTitle.text = "\((whichDay + 10)) jumping jack"
            case 1:
                cell.checkboxTitle.text = "\((whichDay + 10) * 2) shoulder rolls"
            case 2:
                cell.checkboxTitle.text = "Stretch for \((whichDay)) minutes"
            default:
                break
            }
            
            if (self.isToday()) {
                if Database.didDoExercisesToday[indexPath.item] {
                    cell.checked = true
                } else {
                    cell.checked = false
                }
                cell.userInteractionEnabled = true
            } else {
                if didExercise[self.whichDay] {
                    cell.checked = true
                } else {
                    cell.checked = false
                }
                cell.userInteractionEnabled = false
            }

            
        }
//        switch (indexPath.item) {
//        case 0:
//            cell.textLabel?.text = "\((whichDay + 10)) jumping jack"
//        case 1:
//            cell.textLabel?.text = "\((whichDay + 10) * 2) shoulder rolls"
//        case 2:
//            cell.textLabel?.text = "T stretch for \((whichDay)) minutes"
//        default:
//            break
//        }
//        
//        if (self.isToday()) {
//            if Database.didDoExercisesToday[indexPath.item] {
//                cell.accessoryType = .Checkmark
//            } else {
//                cell.accessoryType = .None
//            }
//            cell.userInteractionEnabled = true
//        } else {
//            if didExercise[self.whichDay] {
//                cell.accessoryType = .Checkmark
//            } else {
//                cell.accessoryType = .None
//            }
//            cell.userInteractionEnabled = false
//        }

        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (self.isToday()) {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            if let cell = tableView.cellForRowAtIndexPath(indexPath) as? ChecklistTableViewCell {
                if cell.checked {
                    cell.checked = false
                    Database.didDoExercisesToday[indexPath.item] = false
                } else {
                    cell.checked = true
                    Database.didDoExercisesToday[indexPath.item] = true
                }
            }
            if (Database.didDoExercisesToday[0] && Database.didDoExercisesToday[1] && Database.didDoExercisesToday[2]) {
                self.didExercise[12] = true
                self.collectionView.reloadData()
            } else {
                self.didExercise[12] = false
                self.collectionView.reloadData()
            }
        }
    }
    
    func isToday() -> Bool {
        return self.whichDay == 12
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    //MARK:- Tabbar controller delegate
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        if let navvc = viewController as? UINavigationController {
            if let logvc = navvc.viewControllers.first as? LogViewController {
                logvc.tableView.reloadData()
            }
        }
    }
    
    
}
