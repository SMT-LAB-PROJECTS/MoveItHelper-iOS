//
//  ProfilOptionTableViewCell.swift
//  MoveIt
//
//  Created by Dushyant on 24/06/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class ProfilOptionTableViewCell: UITableViewCell {

    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var messageCountView: UIView!
    @IBOutlet weak var messageCountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        optionLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        messageCountView.layer.cornerRadius = 9

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
