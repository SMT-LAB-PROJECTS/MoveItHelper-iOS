//
//  PopupReasonTblViewCell.swift
//  MoveIt
//
//  Created by Govind Kumar Patidar on 13/05/22.
//  Copyright © 2022 Jyoti. All rights reserved.
//

import UIKit

class PopupReasonTblViewCell: UITableViewCell {
    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnCell: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        lblTitle.font = UIFont.josefinSansRegularFontWithSize(size: 13.0)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
