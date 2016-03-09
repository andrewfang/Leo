//
//  ChatResponseButton.swift
//  zaldy
//
//  Created by Andrew Fang on 2/23/16.
//  Copyright © 2016 Fang Industries. All rights reserved.
//

import UIKit

// This class styles the buttons in the UICollectionView part of the chat response
class ChatResponseButton: UIButton {
    
    override func drawRect(rect: CGRect) {
        
        self.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        
        // Title Attributes
        self.titleLabel?.font = UIFont(name: "Avenir Light", size: 17.0)
        self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        // Border
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
        self.layer.borderWidth = 0.0
        self.layer.backgroundColor = UIColor.appColor().CGColor
        
        self.addTarget(self, action: "tapped", forControlEvents: .TouchDown)
        self.addTarget(self, action: "untapped", forControlEvents: .TouchUpInside)
        self.addTarget(self, action: "untapped", forControlEvents: .TouchDragOutside)
    }
    
    override func intrinsicContentSize() -> CGSize {
        let size = super.intrinsicContentSize()
        return CGSizeMake(size.width + self.titleEdgeInsets.left + self.titleEdgeInsets.right,
            size.height + self.titleEdgeInsets.top + self.titleEdgeInsets.bottom)
    }
    
    func tapped() {
        self.alpha = 0.5
    }
    
    func untapped() {
        self.alpha = 1.0
    }
    
    
}