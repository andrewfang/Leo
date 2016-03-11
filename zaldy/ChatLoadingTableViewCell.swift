//
//  ChatLoadingTableViewCell.swift
//  zaldy
//
//  Created by Andrew Fang on 3/6/16.
//  Copyright © 2016 Fang Industries. All rights reserved.
//

import UIKit

// This class defines the outlets and properties for a table view cell that looks like a loading response
class ChatLoadingTableViewCell: UITableViewCell {

    @IBOutlet weak var spinnerContainerView:UIView!
    
    private var loadingView: UIImageView?
    
    override func awakeFromNib() {
        updateUI()
        self.spinnerContainerView.layer.cornerRadius = 5.0
        self.spinnerContainerView.clipsToBounds = true
    }
    
    func updateUI() {
        self.loadingView?.removeFromSuperview()
        let loadingGif = UIImage.gifWithName("loading")
        let loadingView = UIImageView(image: loadingGif)
        let viewWidth: CGFloat = 40
        let viewHeight: CGFloat = viewWidth
        let viewX: CGFloat = self.spinnerContainerView.frame.midX - viewWidth / 2.0
        let viewY: CGFloat = self.spinnerContainerView.frame.midY - viewHeight / 2.0
        loadingView.frame = CGRect(x: viewX, y: viewY, width: viewWidth, height: viewHeight)
        self.addSubview(loadingView)
        self.loadingView = loadingView
    }

}
