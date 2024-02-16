//
//  MoreSectionTableViewCell.swift
//  MoveIt
//
//  Created by Dushyant on 10/07/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class MoreSectionTableViewCell: UITableViewCell {

    
    @IBOutlet weak var bkView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var settingLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        settingLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        bkView.frame.size.width = 290.0 * screenWidthFactor
        bkView.frame.size.height = 40.0 * screenWidthFactor
        bkView.roundCorners(corners: [.topLeft,.topRight], radius: 10.0)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
