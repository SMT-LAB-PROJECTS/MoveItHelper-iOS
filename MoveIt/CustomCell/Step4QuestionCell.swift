//
//  Step4QuestionCell.swift
//  MoveIt
//
//  Created by Jyoti on 26/04/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class Step4QuestionCell: UITableViewCell {
    
    
    @IBOutlet weak var cellOuterView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
   
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var selectAreaLabel: UILabel!
    @IBOutlet weak var dropDownImageView: UIImageView!
    @IBOutlet weak var dropDownButtonOutlet: UIButton!
    
    
    @IBOutlet weak var radioButtonView: UIView!
    @IBOutlet weak var yesButtonOutlet: UIButton!
    @IBOutlet weak var yesButtonLabel: UILabel!
    @IBOutlet weak var noButtonOutlet: UIButton!
    @IBOutlet weak var noLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        cellOuterView.layer.cornerRadius = 10.0
        cellOuterView.clipsToBounds = true
        
        questionLabel.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
       
        dropDownView.layer.cornerRadius = 5.0
        dropDownView.layer.borderColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1).cgColor
        dropDownView.layer.borderWidth = 1.0
        dropDownView.clipsToBounds = true
        
        selectAreaLabel.font = UIFont.josefinSansRegularFontWithSize(size: 10.0)
        yesButtonLabel.font = UIFont.josefinSansRegularFontWithSize(size: 10.0)
        noLabel.font = UIFont.josefinSansRegularFontWithSize(size: 10.0)
       
        yesButtonOutlet.setImage(UIImage(named: "check_square_outline"), for: .normal)
        noButtonOutlet.setImage(UIImage(named: "check_square_outline"), for: .normal)
        
       // yesButtonOutlet.tag = 1100
     //   noButtonOutlet.tag = 1200
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        
        
    }

}
