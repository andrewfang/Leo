//
//  ChatItem.swift
//  nutrigood
//
//  Created by Andrew Fang on 11/13/15.
//  Copyright © 2015 Fang Industries. All rights reserved.
//

import UIKit

struct ChatItem {
    var content:String!
    var type:ChatType!
    var tip:Database.HtmlTip?
    var image:UIImage?
    
    init(content:String, type:ChatType) {
        self.content = content
        self.type = type
    }
    
    init(tip:Database.HtmlTip, type:ChatType) {
        self.content = tip.tip
        self.type = type
        self.tip = tip
    }
    
    init(image:UIImage, type:ChatType) {
        self.image = image
        self.type = type
    }
}

enum ChatType {
    case User
    case AI
}