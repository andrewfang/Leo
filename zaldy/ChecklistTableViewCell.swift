//
//  ChecklistTableViewCell.swift
//  zaldy
//
//  Created by Andrew Fang on 3/7/16.
//  Copyright © 2016 Fang Industries. All rights reserved.
//

import UIKit

// This class defines the outlets and properties for a table view cell that is inside the tableview inside the ChatLogTableViewCell
class ChecklistTableViewCell: UITableViewCell {

    @IBOutlet weak var checkboxImageView: UIImageView!
    @IBOutlet weak var checkboxTitle: UILabel!
    var checked = false {
        didSet {
           self.configCheck()
        }
    }
    
    override func awakeFromNib() {
        self.configCheck()
    }
    
    private func configCheck() {
        if (self.checked) {
            self.checkboxImageView.image = UIImage(named: "logCircleChecked")

        } else {
            self.checkboxImageView.image = UIImage(named: "logCircle")
        }
    }

}
