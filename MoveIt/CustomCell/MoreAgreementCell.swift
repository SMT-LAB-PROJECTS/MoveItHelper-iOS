//
//  MoreAgreementCell.swift
//  MoveIt
//
//  Created by RV on 09/07/21.
//  Copyright © 2021 Jyoti. All rights reserved.
//

import UIKit

class MoreAgreementCell: UITableViewCell {
    
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var wholeCellButton: UIButton!
    @IBOutlet weak var agreementTextLabel: UILabel!
    
    var actionHendler: (() -> ())!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func checkAction(_ sender: Any) {
        actionHendler()
//        if checkButton.isSelected {
//            checkButton.isSelected = false
//        } else{
//             checkButton.isSelected = true
//        }
    }

}
