//
//  ChatLoadingTableViewCell.swift
//  zaldy
//
//  Created by Andrew Fang on 3/6/16.
//  Copyright © 2016 Fang Industries. All rights reserved.
//

import UIKit

class ChatLoadingTableViewCell: UITableViewCell {

    @IBOutlet weak var spinner:UIActivityIndicatorView!
    @IBOutlet weak var spinnerContainerView:UIView!
    
    override func awakeFromNib() {
        self.spinnerContainerView.layer.cornerRadius = 5.0
        self.spinnerContainerView.clipsToBounds = true
    }

}
