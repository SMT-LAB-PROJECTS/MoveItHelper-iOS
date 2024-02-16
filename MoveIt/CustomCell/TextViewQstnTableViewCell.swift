//
//  TextViewQstnTableViewCell.swift
//  MoveIt
//
//  Created by Dushyant on 24/05/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class TextViewQstnTableViewCell: UITableViewCell {

    @IBOutlet weak var bkView: UIView!
    @IBOutlet weak var qstnLabel: UILabel!    
  
    @IBOutlet weak var textView: JVFloatLabeledTextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bkView.layer.cornerRadius = 10.0 * screenHeightFactor
        qstnLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)

        textView.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 5.0 * screenHeightFactor
        textView.contentInset = UIEdgeInsets.init(top: 0, left: 15.0 * screenHeightFactor, bottom: 0, right: 15.0 * screenHeightFactor)
        textView.floatingLabelTextColor = UIColor.clear
        textView.alwaysShowFloatingLabel = false
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
