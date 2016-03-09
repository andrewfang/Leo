//
//  ChatLogTableViewCell.swift
//  zaldy
//
//  Created by Andrew Fang on 3/7/16.
//  Copyright © 2016 Fang Industries. All rights reserved.
//

import UIKit

// This class defines the outlets and properties for a table view cell that has the log for today's exercise
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
            // Grab the hard coded exercises from the database
            cell.checkboxTitle.text = Database.exercises[self.whichDay][indexPath.item]
            cell.checked = Database.didDoExercisesToday[indexPath.item]
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? ChecklistTableViewCell {
            cell.checked = !cell.checked
            Database.didDoExercisesToday[indexPath.item] = !Database.didDoExercisesToday[indexPath.item]
            
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    

}
