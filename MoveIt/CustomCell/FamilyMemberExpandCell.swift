//
//  FamilyMemberExpandCell.swift
//  MoveIt
//
//  Created by Jyoti on 14/05/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class FamilyMemberExpandCell: UITableViewCell {

    @IBOutlet weak var outerViewCell: UIView!
    @IBOutlet weak var questLabel: UILabel!
    @IBOutlet weak var yesNoButtonOuterView: UIView!
    @IBOutlet weak var yesbuttonOutlet: UIButton!
    @IBOutlet weak var yesLabel: UILabel!
    @IBOutlet weak var noButonOutlet: UIButton!
   
    @IBOutlet weak var noLabel: UILabel!
    
    @IBOutlet weak var nameOuterView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailOuterview: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneOuterView: UIView!
    @IBOutlet weak var phoneTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        outerViewCell.layer.cornerRadius = 10.0
        outerViewCell.clipsToBounds = true
        
        questLabel.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        
        yesLabel.font = UIFont.josefinSansRegularFontWithSize(size: 10.0)
        noLabel.font = UIFont.josefinSansRegularFontWithSize(size: 10.0)
        
        nameOuterView.layer.cornerRadius = 5.0
        nameOuterView.layer.borderColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1).cgColor
        nameOuterView.layer.borderWidth = 1.0
        nameOuterView.clipsToBounds = true
        
        var myMutableStringName = NSMutableAttributedString()
        let name = "Name"
        myMutableStringName = NSMutableAttributedString(string:name, attributes: [NSAttributedString.Key.font:UIFont.josefinSansRegularFontWithSize(size: 12.0)])
        myMutableStringName.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 47/255, green: 44/255, blue: 61/255, alpha: 1), range:NSMakeRange(0,name.count))
        
        nameTextField.attributedPlaceholder = myMutableStringName
        
        emailOuterview.layer.cornerRadius = 5.0
        emailOuterview.layer.borderColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1).cgColor
        emailOuterview.layer.borderWidth = 1.0
        emailOuterview.clipsToBounds = true
        
        
        var myMutableStringEmail = NSMutableAttributedString()
        let email = "Email"
        myMutableStringEmail = NSMutableAttributedString(string:email, attributes: [NSAttributedString.Key.font:UIFont.josefinSansRegularFontWithSize(size: 12.0)])
        myMutableStringEmail.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 47/255, green: 44/255, blue: 61/255, alpha: 1), range:NSMakeRange(0,email.count))
        
        emailTextField.attributedPlaceholder = myMutableStringEmail
        
        phoneOuterView.layer.cornerRadius = 5.0
        phoneOuterView.layer.borderColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1).cgColor
        phoneOuterView.layer.borderWidth = 1.0
        phoneOuterView.clipsToBounds = true
        
        var myMutableStringPhone = NSMutableAttributedString()
        let phone = "Phone"
        myMutableStringPhone = NSMutableAttributedString(string:phone, attributes: [NSAttributedString.Key.font:UIFont.josefinSansRegularFontWithSize(size: 12.0)])
        myMutableStringPhone.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 47/255, green: 44/255, blue: 61/255, alpha: 1), range:NSMakeRange(0,phone.count))
        
        phoneTextField.attributedPlaceholder = myMutableStringPhone
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
