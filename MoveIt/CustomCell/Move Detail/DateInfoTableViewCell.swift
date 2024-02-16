//
//  DateInfoTableViewCell.swift
//  MoveIt
//
//  Created by Dushyant on 20/06/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class DateInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var imgViewIcon: UIImageView!
//    @IBOutlet weak var moveItemsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        moveItemsLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        dateLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
