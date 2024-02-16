//
//  AdditionalInfoClosedTableViewCell.swift
//  Move It Customer
//
//  Created by Dushyant on 07/05/19.
//  Copyright © 2019 Agicent Technologies. All rights reserved.
//

import UIKit

class AdditionalInfoClosedTableViewCell: UITableViewCell {

    @IBOutlet weak var bkView: UIView!
    @IBOutlet weak var additionalInfoLabel: UILabel!
    @IBOutlet weak var showButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bkView.layer.cornerRadius  = 10.0 * screenHeightFactor
        additionalInfoLabel.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
