//
//  ChatResponseTextField.swift
//  zaldy
//
//  Created by Andrew Fang on 3/2/16.
//  Copyright © 2016 Fang Industries. All rights reserved.
//

import UIKit

class ChatResponseTextField: UITextField {

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {

        self.backgroundColor = UIColor.appColorAlphaHalf()
        self.layer.backgroundColor = UIColor.appColorAlphaHalf().CGColor
        self.textColor = UIColor.whiteColor()
        
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
        self.layer.borderWidth = 0.0
    }

}
