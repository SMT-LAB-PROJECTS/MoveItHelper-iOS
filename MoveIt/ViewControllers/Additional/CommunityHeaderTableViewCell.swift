//
//  CommunityHeaderTableViewCell.swift
//  MoveIt
//
//  Created by Dushyant on 28/05/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class CommunityHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profilePicImgView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var personPostLabel: UILabel!
    
    @IBOutlet weak var moreButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
