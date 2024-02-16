//
//  GetNotificationTableViewCell.swift
//  MoveIt
//
//  Created by Dushyant on 06/08/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class GetNotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var bkView: UIView!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var notificationTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 13.0)
        timeLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        notificationTextLabel.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        notificationTextLabel.numberOfLines = 0
        bkView.layer.masksToBounds = true
        bkView.layer.cornerRadius = 10.0
        bkView.layer.borderWidth = 0.2
        bkView.layer.borderColor = UIColor.lightGray.cgColor
        
        
        userImgView.layer.masksToBounds = true
        userImgView.layer.cornerRadius = 20.0
    }
    
    override func prepareForReuse() {
        userImgView.image = UIImage.init(named: "User_placeholder")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
