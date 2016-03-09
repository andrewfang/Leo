//
//  ChatTableViewCell.swift
//  nutrigood
//
//  Created by Andrew Fang on 11/13/15.
//  Copyright © 2015 Fang Industries. All rights reserved.
//

import UIKit

// This class defines the outlets and properties for a table view cell that looks like a chat box
class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var content: UILabel!
    
    var tip:Database.HtmlTip?
}
