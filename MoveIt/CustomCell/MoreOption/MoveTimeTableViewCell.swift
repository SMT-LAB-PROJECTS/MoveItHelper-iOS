//
//  MoveTimeTableViewCell.swift
//  Move It
//
//  Created by Dushyant on 12/06/19.
//  Copyright © 2019 Agicent Technologies. All rights reserved.
//

import UIKit

class MoveTimeTableViewCell: UITableViewCell {

    @IBOutlet weak var moveTimeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        moveTimeLabel.font = UIFont.josefinSansRegularFontWithSize(size: 13.0)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
