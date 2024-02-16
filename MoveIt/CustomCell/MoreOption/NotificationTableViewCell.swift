//
//  NotificationTableViewCell.swift
//  MoveIt
//
//  Created by Dushyant on 11/07/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var notificationLabel: UILabel!
    
    @IBOutlet weak var setButton: UIButton!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        notificationLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
