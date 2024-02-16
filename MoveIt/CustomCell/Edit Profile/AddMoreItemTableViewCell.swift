//
//  AddMoreItemTableViewCell.swift
//  Move It Customer
//
//  Created by Dushyant on 10/05/19.
//  Copyright © 2019 Agicent Technologies. All rights reserved.
//

import UIKit

class AddMoreItemTableViewCell: UITableViewCell {

    @IBOutlet weak var itemBkView: UIView!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var itemQuantityLabel: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        itemBkView.layer.cornerRadius = 10.0 * screenHeightFactor
        itemLabel.font = UIFont.josefinSansRegularFontWithSize(size: 14.0)
        itemQuantityLabel.font = UIFont.josefinSansRegularFontWithSize(size: 14.0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        itemQuantityLabel.layer.cornerRadius = (itemQuantityLabel.bounds.size.height / 2)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }


}
