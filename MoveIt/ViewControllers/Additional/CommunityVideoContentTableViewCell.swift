//
//  CommunityVideoContentTableViewCell.swift
//  MoveIt
//
//  Created by Dushyant on 28/05/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class CommunityVideoContentTableViewCell: UITableViewCell {

    @IBOutlet weak var contentImgView: UIImageView!
   
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
 
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
