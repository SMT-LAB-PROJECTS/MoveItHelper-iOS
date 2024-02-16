//
//  AssembleTableViewCell.swift
//  Move It
//
//  Created by Dushyant on 07/06/19.
//  Copyright © 2019 Agicent Technologies. All rights reserved.
//

import UIKit

class AssembleTableViewCell: UITableViewCell {
   
    @IBOutlet weak var bkView: UIView!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var assembleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bkView.layer.cornerRadius = 10.0 * screenHeightFactor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        assembleLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 13.0)
        descriptionLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
    }
}
