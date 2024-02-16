//
//  RadioQstnTableViewCell.swift
//  MoveIt
//
//  Created by Dushyant on 24/05/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class RadioQstnTableViewCell: UITableViewCell {

    @IBOutlet weak var bkView: UIView!
    
    @IBOutlet weak var qstnLabel: UILabel!
  
    @IBOutlet weak var yesButton: UIButton!
    
    @IBOutlet weak var noButton: UIButton!
    
    @IBOutlet weak var yesLabel: UILabel!
    
    @IBOutlet weak var noLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bkView.layer.cornerRadius = 10.0 * screenHeightFactor
        qstnLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        yesLabel.font = UIFont.josefinSansRegularFontWithSize(size: 13.0)
        noLabel.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
