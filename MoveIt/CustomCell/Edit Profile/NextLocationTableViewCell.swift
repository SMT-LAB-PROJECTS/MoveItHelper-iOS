//
//  NextLocationTableViewCell.swift
//  Move It
//
//  Created by Dushyant on 05/06/19.
//  Copyright © 2019 Agicent Technologies. All rights reserved.
//

import UIKit

class NextLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var bkView: UIView!
    @IBOutlet weak var markButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib(){
        super.awakeFromNib()
        bkView.layer.cornerRadius = 10.0 * screenHeightFactor
        bkView.layer.borderColor = dullColor.cgColor
        bkView.layer.borderWidth = 0.5
        titleLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 11.0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
