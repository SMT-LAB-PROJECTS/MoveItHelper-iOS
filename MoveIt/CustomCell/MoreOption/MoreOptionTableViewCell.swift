//
//  MoreOptionTableViewCell.swift
//  MoveIt
//
//  Created by Dushyant on 10/07/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class MoreOptionTableViewCell: UITableViewCell {
    @IBOutlet weak var bkView: UIView!
    
    @IBOutlet weak var optionLabel: UILabel!
    
    @IBOutlet weak var icomImgView: UIImageView!
    
    @IBOutlet weak var messageCountView: UIView!
    @IBOutlet weak var messageCountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        optionLabel.font = UIFont.josefinSansRegularFontWithSize(size: 14.0)
        messageCountView.layer.cornerRadius = 8

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
