//
//  SecondExpandableTableViewCell.swift
//  MoveIt
//
//  Created by Jyoti Negi on 16/05/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class SecondExpandableTableViewCell: UITableViewCell,UITextFieldDelegate {

    @IBOutlet weak var cellOuterView: UIView!
    @IBOutlet weak var queryLabel: UILabel!
    @IBOutlet weak var selectOuterView: UIView!
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var selectButtonOutlet: UIButton!
    @IBOutlet weak var otherOuterView: UIView!
    @IBOutlet weak var otherTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellOuterView.layer.cornerRadius = 10.0
        cellOuterView.layer.masksToBounds = true
        
        queryLabel.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
       
        selectOuterView.layer.cornerRadius = 5.0
        selectOuterView.layer.borderColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1).cgColor
        selectOuterView.layer.borderWidth = 1.0
        selectOuterView.layer.masksToBounds = true
        selectLabel.font = UIFont.josefinSansRegularFontWithSize(size: 10.0)
        
        
        otherOuterView.layer.cornerRadius = 5.0
        otherOuterView.layer.borderColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1).cgColor
        otherOuterView.layer.borderWidth = 1.0
        otherOuterView.layer.masksToBounds = true
        
        var myMutableString = NSMutableAttributedString()
        let name = "Write Here..."
        myMutableString = NSMutableAttributedString(string:name, attributes: [NSAttributedString.Key.font:UIFont.josefinSansRegularFontWithSize(size: 12.0)])
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 47/255, green: 44/255, blue: 61/255, alpha: 1), range:NSMakeRange(0,name.count))
        
        otherTextField.attributedPlaceholder = myMutableString
        otherTextField.delegate = self
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
