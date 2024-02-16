//
//  ApartmentNumTableViewCell.swift
//  Move It
//
//  Created by Dushyant on 05/06/19.
//  Copyright © 2019 Agicent Technologies. All rights reserved.
//

import UIKit

class ApartmentNumTableViewCell: UITableViewCell {
   
    @IBOutlet weak var topConstant: NSLayoutConstraint!
    
    @IBOutlet weak var addresLabel: UILabel!
    @IBOutlet weak var apartmentTextField: UITextField!
    var placeholderText = "ENTER UNIT OR APARTMENT NUMBER"
    
    override func awakeFromNib() {
        super.awakeFromNib()
 
        addresLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 13.0)
        apartmentTextField.font = UIFont.josefinSansRegularFontWithSize(size: 14.0)
        let attriburteDict = [NSAttributedString.Key.font: UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)]
        apartmentTextField.attributedPlaceholder = NSAttributedString.init(string: placeholderText, attributes: attriburteDict)
        self.topConstant.constant = 15.0 * screenHeightFactor
    }

    override func layoutSubviews() {
        super.layoutSubviews()
     //   apartmentTextField.setUnderLine(self, color: dullColor)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
