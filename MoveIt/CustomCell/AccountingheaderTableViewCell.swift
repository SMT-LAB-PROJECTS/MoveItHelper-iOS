//
//  AccountingheaderTableViewCell.swift
//  MoveIt
//
//  Created by Dushyant on 13/01/20.
//  Copyright © 2020 Jyoti. All rights reserved.
//

import UIKit

class AccountingheaderTableViewCell: UITableViewCell {

    @IBOutlet weak var PaypalImgView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var paymentTimeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dateLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 17.0)
        paymentTimeLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 15.0)
        amountLabel.font = UIFont.josefinSansBoldFontWithSize(size: 17.0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        PaypalImgView.layer.cornerRadius = PaypalImgView.bounds.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
