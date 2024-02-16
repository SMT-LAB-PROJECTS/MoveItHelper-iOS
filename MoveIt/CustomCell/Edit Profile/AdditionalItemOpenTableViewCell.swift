//
//  AdditionalItemOpenTableViewCell.swift
//  Move It Customer
//
//  Created by Dushyant on 07/05/19.
//  Copyright © 2019 Agicent Technologies. All rights reserved.
//

import UIKit

class AdditionalItemOpenTableViewCell: UITableViewCell {

    @IBOutlet weak var bkView: UIView!
    @IBOutlet weak var addditionalInfoLabel: UILabel!
    @IBOutlet weak var hideButton: UIButton!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var widthTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var depthTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var addtionInfoTextField: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bkView.layer.cornerRadius = 10.0 * screenHeightFactor
        
        addditionalInfoLabel.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        subTitleLabel.font = UIFont.josefinSansRegularFontWithSize(size: 10.0)
        widthTextField.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        heightTextField.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        depthTextField.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        weightTextField.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        addtionInfoTextField.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        
        /*widthTextField.addDoneButtonOnKeyboard()
        heightTextField.addDoneButtonOnKeyboard()
        depthTextField.addDoneButtonOnKeyboard()
        weightTextField.addDoneButtonOnKeyboard()*/
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
         widthTextField.setUnderLine(self.bkView, color: UIColor.lightGray)
         heightTextField.setUnderLine(self.bkView, color: UIColor.lightGray)
         depthTextField.setUnderLine(self.bkView, color: UIColor.lightGray)
         weightTextField.setUnderLine(self.bkView, color: UIColor.lightGray)
         addtionInfoTextField.setUnderLine(self.bkView, color: UIColor.lightGray)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
