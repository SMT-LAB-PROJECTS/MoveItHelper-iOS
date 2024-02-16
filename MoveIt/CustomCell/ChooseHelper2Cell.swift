//
//  ChooseHelper2Cell.swift
//  MoveIt
//
//  Created by RV on 04/06/21.
//  Copyright © 2021 Jyoti. All rights reserved.
//

import UIKit

class ChooseHelper2Cell: UITableViewCell {
    
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var helperImageView: UIImageView!
    @IBOutlet weak var moveItLabel: UILabel!
    @IBOutlet weak var luggageDescriptionLabel: UILabel!
    @IBOutlet weak var pricingLabel: UILabel!
    
    
    @IBOutlet weak var outerView2: UIView!
    @IBOutlet weak var helperImageView2: UIImageView!
    @IBOutlet weak var moveItLabel2: UILabel!
    @IBOutlet weak var luggageDescriptionLabel2: UILabel!
    @IBOutlet weak var pricingLabel2: UILabel!

    var moveItProHandler:(() -> ())!
    var moveItMuscleHandler:(() -> ())!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        outerView.layer.cornerRadius = 10.0
        outerView.clipsToBounds = true
        
        moveItLabel.font = UIFont.josefinSansBoldFontWithSize(size: 13.0)
        pricingLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 13.0)
        
        luggageDescriptionLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 11.0)
        
        outerView2.layer.cornerRadius = 10.0
        outerView2.clipsToBounds = true
        
        moveItLabel2.font = UIFont.josefinSansBoldFontWithSize(size: 13.0)
        pricingLabel2.font = UIFont.josefinSansSemiBoldFontWithSize(size: 13.0)
        
        luggageDescriptionLabel2.font = UIFont.josefinSansSemiBoldFontWithSize(size: 11.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func moveItProAction(_ sender: UIButton){
        moveItProHandler()
    }
    
    @IBAction func moveItMuscleAction(_ sender: UIButton){
        moveItMuscleHandler()
    }

}
