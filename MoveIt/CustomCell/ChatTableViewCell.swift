//
//  ChatTableViewCell.swift
//  MoveIt
//
//  Created by Dushyant on 09/07/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var bkView: UIView!
    
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func prepareForReuse() {
        self.userImgView.image = UIImage(named: "User_placeholder")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLable.font = UIFont.josefinSansSemiBoldFontWithSize(size: 13.0)
        timeLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        messageLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        bkView.layer.cornerRadius = 10.0 * screenHeightFactor
     
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        userImgView.layer.cornerRadius = userImgView.frame.size.height / 2

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
