//
//  MoreSectionFooterTableViewCell.swift
//  MoveIt
//
//  Created by Dushyant on 10/07/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class MoreSectionFooterTableViewCell: UITableViewCell {

    @IBOutlet weak var bkView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        bkView.frame.size.width = 290.0 * screenWidthFactor
        bkView.roundCorners(corners: [.bottomRight,.bottomLeft], radius: 10.0)
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
