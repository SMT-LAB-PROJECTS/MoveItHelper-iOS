//
//  AddItemTableViewCell.swift
//  Move It Customer
//
//  Created by Dushyant on 06/05/19.
//  Copyright © 2019 Agicent Technologies. All rights reserved.
//

import UIKit

class AddItemTableViewCell: UITableViewCell {

    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var itemNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

        itemNameLabel.font = UIFont.josefinSansRegularFontWithSize(size: 10.0)
        itemImage.layer.cornerRadius = 5.0 * screenHeightFactor
    }
    
    override func prepareForReuse() {
        itemImage.image = UIImage.init(named: "home_card_img_placeholder")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
