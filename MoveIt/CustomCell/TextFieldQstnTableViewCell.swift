//
//  TextFieldQstnTableViewCell.swift
//  MoveIt
//
//  Created by Dushyant on 24/05/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class TextFieldQstnTableViewCell: UITableViewCell {
    @IBOutlet weak var bkView: UIView!
    
    @IBOutlet weak var qstnLabel: UILabel!
    
    @IBOutlet weak var listViewTextField: UITextField!
    @IBOutlet weak var additionInfoTextField: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bkView.layer.cornerRadius = 10.0 * screenHeightFactor
        qstnLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        listViewTextField.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        additionInfoTextField.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        listViewTextField.setLeftPaddingPoints(15.0)
        listViewTextField.setRightCaret(15.0, image: UIImage.init(named: "caret_down")!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
