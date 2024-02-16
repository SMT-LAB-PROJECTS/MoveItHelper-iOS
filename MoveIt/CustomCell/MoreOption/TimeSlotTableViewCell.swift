//
//  TimeSlotTableViewCell.swift
//  MoveIt
//
//  Created by Dushyant on 11/07/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class TimeSlotTableViewCell: UITableViewCell {

    
    @IBOutlet weak var bkView: UIView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var fromTimeTextField: UITextField!
    @IBOutlet weak var toTimeTextField: UITextField!
    @IBOutlet weak var addTimeSlotButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bkView.layer.cornerRadius = 15.0 * screenHeightFactor
        topLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        fromLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        toLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        fromTimeTextField.font = UIFont.josefinSansRegularFontWithSize(size: 14.0)
        toTimeTextField.font = UIFont.josefinSansRegularFontWithSize(size: 14.0)
        addTimeSlotButton.titleLabel!.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        
        fromTimeTextField.setRightPaddingWithImage(10.0, image: UIImage.init(named: "caret_down")!)
        toTimeTextField.setRightPaddingWithImage(10.0, image: UIImage.init(named: "caret_down")!)

        addTimeSlotButton.layer.cornerRadius = 5.0 * screenHeightFactor
        addTimeSlotButton.layer.borderColor = violetColor.cgColor
        addTimeSlotButton.layer.borderWidth = 1.0
        
        fromTimeTextField.layer.cornerRadius = 5.0 * screenHeightFactor
        fromTimeTextField.layer.borderColor = violetColor.cgColor
        fromTimeTextField.layer.borderWidth = 1.0
        
        toTimeTextField.layer.cornerRadius = 5.0 * screenHeightFactor
        toTimeTextField.layer.borderColor = violetColor.cgColor
        toTimeTextField.layer.borderWidth = 1.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
