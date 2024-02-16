//
//  AddressInfoTableViewCell.swift
//  MoveIt
//
//  Created by Dushyant on 20/06/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class AddressInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var fromImageView: UIImageView!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var fromAddressLabel: UILabel!
    
    @IBOutlet weak var toLabel: UILabel!    
    @IBOutlet weak var toAddressLabel: UILabel!
//    @IBOutlet weak var fromAddressTextView: UITextView!
//    @IBOutlet weak var toAddressTextView: UITextView!
//    @IBOutlet weak var fromAddressConst: NSLayoutConstraint!
//    @IBOutlet weak var toAddressConst: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        fromLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        fromAddressLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        fromAddressLabel.numberOfLines = 0
//        toLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
//        toAddressLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
