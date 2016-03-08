//
//  ChatLogTableViewCell.swift
//  zaldy
//
//  Created by Andrew Fang on 3/7/16.
//  Copyright © 2016 Fang Industries. All rights reserved.
//

import UIKit

class ChatLogTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableContainerView:UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func awakeFromNib() {
        self.tableContainerView.layer.cornerRadius = 5.0
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tintColor = UIColor.appColor()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    private var whichDay = 12
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("exerciseCell", forIndexPath: indexPath)
        
        if let cell = cell as? ChecklistTableViewCell {
            switch (indexPath.item) {
            case 0:
                cell.checkboxTitle.text = "\((whichDay + 10)) jumping jack"
                cell.checked = false
            case 1:
                cell.checkboxTitle.text = "\((whichDay + 10) * 2) shoulder rolls"
                cell.checked = false
            case 2:
                cell.checkboxTitle.text = "T stretch for \((whichDay)) minutes"
                cell.checked = false
            default:
                break
            }
        } else {
            switch (indexPath.item) {
            case 0:
                cell.textLabel?.text = "\((whichDay + 10)) jumping jack"
            case 1:
                cell.textLabel?.text = "\((whichDay + 10) * 2) shoulder rolls"
            case 2:
                cell.textLabel?.text = "T stretch for \((whichDay)) minutes"
            default:
                break
            }
            
            if Database.didDoExercisesToday[indexPath.item] {
                cell.accessoryType = .Checkmark
            } else {
                cell.accessoryType = .None
            }
            cell.userInteractionEnabled = true
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? ChecklistTableViewCell {
            cell.checked = !cell.checked
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    

}
