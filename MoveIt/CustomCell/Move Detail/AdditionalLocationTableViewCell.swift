//
//  AdditionalLocationTableViewCell.swift
//  MoveIt
//
//  Created by Dushyant on 11/09/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class AdditionalLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var additionalPickupDetails: UILabel!
    @IBOutlet weak var staitLabel: UILabel!
    @IBOutlet weak var staitrsCoundLabel: UILabel!
    @IBOutlet weak var elevatorLabel: UILabel!
    @IBOutlet weak var elevatorCountLabel: UILabel!
    
    @IBOutlet weak var bkView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bkView.layer.cornerRadius = 10.0 * screenHeightFactor
        
        additionalPickupDetails.font = UIFont.josefinSansSemiBoldFontWithSize(size: 15.0)
        staitLabel.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        staitrsCoundLabel.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        elevatorLabel.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        elevatorCountLabel.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
