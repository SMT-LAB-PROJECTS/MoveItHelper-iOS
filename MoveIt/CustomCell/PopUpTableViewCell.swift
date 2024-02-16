//
//  PopUpTableViewCell.swift
//  MoveIt
//
//  Created by Dushyant on 24/05/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class PopUpTableViewCell: UITableViewCell {

    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var checkImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        itemLabel.font = UIFont.josefinSansRegularFontWithSize(size: 13.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
