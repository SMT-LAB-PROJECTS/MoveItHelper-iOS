//
//  ChooseHelperCell.swift
//  MoveIt
//
//  Created by Jyoti on 18/04/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class ChooseHelperCell: UITableViewCell {
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var helperImageView: UIImageView!
    @IBOutlet weak var helperImageView1: UIImageView!
    @IBOutlet weak var helperImageView2: UIImageView!
    @IBOutlet weak var moveItLabel: UILabel!
    @IBOutlet weak var luggageDescriptionLabel: UILabel!
    @IBOutlet weak var pricingLabel: UILabel!
    
    override func prepareForReuse() {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        outerView.layer.cornerRadius = 10.0
        outerView.clipsToBounds = true
        
        moveItLabel.font = UIFont.josefinSansBoldFontWithSize(size: 13.0)
        pricingLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 13.0)
        
        luggageDescriptionLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 11.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
