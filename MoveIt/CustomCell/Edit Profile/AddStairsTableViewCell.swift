//
//  AddStairsTableViewCell.swift
//  Move It
//
//  Created by Dushyant on 05/06/19.
//  Copyright © 2019 Agicent Technologies. All rights reserved.
//

import UIKit

class AddStairsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var bkView: UIView!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var heightConst: NSLayoutConstraint!
    @IBOutlet weak var addStairsBkView: UIView!
    @IBOutlet weak var stairsLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var bottomLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bkView.layer.cornerRadius = 10.0 * screenHeightFactor
        bkView.layer.borderColor = dullColor.cgColor
        bkView.layer.borderWidth = 0.5
        titleLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 11.0)
        stairsLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 11.0)
        bottomLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 9.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
