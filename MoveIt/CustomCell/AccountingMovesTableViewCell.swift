//
//  AccountingMovesTableViewCell.swift
//  MoveIt
//
//  Created by Dushyant on 13/01/20.
//  Copyright © 2020 Jyoti. All rights reserved.
//

import UIKit

class AccountingMovesTableViewCell: UITableViewCell {

    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateTimeLAbel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    
//    override func prepareForReuse() {
//        self.userImgView.image = UIImage(named: "User_placeholder")
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImgView.image = UIImage.init(named: "logo")

        nameLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 15.0)
        dateTimeLAbel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        amountLabel.font = UIFont.josefinSansBoldFontWithSize(size: 17.0)
    }
  
    override func layoutSubviews() {
          super.layoutSubviews()
          userImgView.layer.cornerRadius = userImgView.bounds.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
