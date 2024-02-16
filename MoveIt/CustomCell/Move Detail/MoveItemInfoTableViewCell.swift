//
//  MoveItemInfoTableViewCell.swift
//  MoveIt
//
//  Created by Dushyant on 20/06/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class MoveItemInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var bkView: UIView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemUnitLabel: UILabel!
    @IBOutlet weak var itemDetailsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        itemNameLabel.font = UIFont.josefinSansRegularFontWithSize(size: 14.0)
        itemUnitLabel.font = UIFont.josefinSansRegularFontWithSize(size: 14.0)
        itemDetailsLabel.font = UIFont.josefinSansRegularFontWithSize(size: 8.0)
        itemDetailsLabel.textColor = darkPinkColor
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        bkView.layer.cornerRadius = 10.0 * screenHeightFactor
        itemUnitLabel.layer.cornerRadius = (itemUnitLabel.bounds.size.height / 2)
    }
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
