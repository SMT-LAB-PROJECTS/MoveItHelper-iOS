//
//  SimpleNotificationCell.swift
//  MoveIt
//
//  Created by RV on 28/07/21.
//  Copyright © 2021 Jyoti. All rights reserved.
//

import UIKit

class SimpleNotificationCell: UITableViewCell {

    
    @IBOutlet weak var bkView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var notificationTextLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        timeLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 8.0)
        notificationTextLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        
        bkView.layer.masksToBounds = true
        bkView.layer.cornerRadius = 10.0
        bkView.layer.borderWidth = 0.2
        bkView.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
