//
//  CommunityTextContentTableViewCell.swift
//  MoveIt
//
//  Created by Dushyant on 28/05/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class CommunityTextContentTableViewCell: UITableViewCell {
    @IBOutlet weak var contentlabel: UILabel!
    
    @IBOutlet weak var seeMoreButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
