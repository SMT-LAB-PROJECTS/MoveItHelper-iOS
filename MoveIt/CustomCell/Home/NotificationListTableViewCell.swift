//
//  NotificationListTableViewCell.swift
//  Move It
//
//  Created by Dilip Technology on 21/04/21.
//  Copyright © 2021 Agicent Technologies. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class NotificationListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bkView: UIView!
    
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var notificationTextLabel: UILabel!
    @IBOutlet weak var imageheight: NSLayoutConstraint!
    
    override func prepareForReuse() {
        userImgView.image = UIImage.init(named: "User_placeholder")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        timeLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 8.0)
        notificationTextLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        //bkView.layer.cornerRadius = 1.0 * screenHeightFactor
        userImgView.layer.cornerRadius = 25
        
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
