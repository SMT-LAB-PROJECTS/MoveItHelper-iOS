//
//  JunkRemovalTableViewCell.swift
//  Move It
//
//  Created by Dushyant on 16/10/19.
//  Copyright © 2019 Agicent Technologies. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class JunkRemovalTableViewCell: UITableViewCell {

    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var describeLabel: UILabel!
    @IBOutlet weak var junkTextView: JVFloatLabeledTextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       // Initialization code
       containerView.layer.cornerRadius = 10.0 * screenHeightFactor
       junkTextView.layer.borderColor = darkPinkColor.cgColor
       junkTextView.layer.borderWidth = 1.0
       junkTextView.layer.cornerRadius = 5.0 * screenHeightFactor
       //junkTextView.addDoneButtonOnKeyboard()
       junkTextView.contentInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
       describeLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
