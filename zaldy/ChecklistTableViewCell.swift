//
//  ChecklistTableViewCell.swift
//  zaldy
//
//  Created by Andrew Fang on 3/7/16.
//  Copyright © 2016 Fang Industries. All rights reserved.
//

import UIKit

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
//            self.checkboxImageView.image = UIImage(named: "logCircleChecked")
            self.checkboxImageView.image = UIImage(named: "logCircleChecked")

        } else {
            self.checkboxImageView.image = UIImage(named: "logCircle")
        }
    }

}
