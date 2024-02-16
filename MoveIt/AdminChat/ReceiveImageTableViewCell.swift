//
//  ReceiveImageTableViewCell.swift
//  MoveIt
//
//  Created by Govind Patidar on 2/16/22.
//  Copyright © 2022 Jyoti. All rights reserved.
//

import UIKit
import AlamofireImage

class ReceiveImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bkView: UIView!
//    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var receiverImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var widthConst: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
//        messageLabel.font = UIFont.josefinSansRegularFontWithSize(size: 14.0)
        timeLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bkView.layer.cornerRadius = 5.0 * screenHeightFactor

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func setReceiverImage(_ urlString:String) {
        let url = URL.init(string: urlString)
        let placeholderImage = UIImage(named: "home_card_img_placeholder")!
        receiverImage.af.setImage(withURL: url!, placeholderImage: placeholderImage)
    }
}
