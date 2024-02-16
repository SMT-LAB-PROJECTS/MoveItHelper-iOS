//
//  Step2PopUpCell.swift
//  MoveIt
//
//  Created by Jyoti on 09/05/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class Step2PopUpCell: UITableViewCell {

    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var checkIconImageview: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        placeLabel.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
