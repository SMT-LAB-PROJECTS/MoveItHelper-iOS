//
//  CommunityFooterTableViewCell.swift
//  MoveIt
//
//  Created by Dushyant on 28/05/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class CommunityFooterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var likeCoungImgView: UIImageView!
    
    @IBOutlet weak var likeCountLabel: UILabel!
    
    @IBOutlet weak var commentImgView: UIImageView!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var likeLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var comentLabel: UILabel!
    
    @IBOutlet weak var commentButton: UIButton!
    
    @IBOutlet weak var shareLabel: UILabel!
    
    @IBOutlet weak var shareButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
