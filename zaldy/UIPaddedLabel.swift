//
//  UIPaddedLabel.swift
//  nutrigood
//
//  Created by Andrew Fang on 11/13/15.
//  Copyright © 2015 Fang Industries. All rights reserved.
//  From http://stackoverflow.com/questions/21167226/resizing-a-uilabel-to-accomodate-insets/21267507#21267507
//

import UIKit

// This class defines the layout for label that looks like a chat box
class UIPaddedLabel: UILabel {

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    var edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    
    override func textRectForBounds(bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect = edgeInsets.apply(bounds)
        rect = super.textRectForBounds(rect, limitedToNumberOfLines: numberOfLines)
        return edgeInsets.inverse.apply(rect)
    }
    
    override func drawTextInRect(rect: CGRect) {
        super.drawTextInRect(edgeInsets.apply(rect))
    }
}

extension UIEdgeInsets {
    var inverse : UIEdgeInsets {
        return UIEdgeInsets(top: -top, left: -left, bottom: -bottom, right: -right)
    }
    func apply(rect: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(rect, self)
    }
}
