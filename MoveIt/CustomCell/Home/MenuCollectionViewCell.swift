//
//  MenuCollectionViewCell.swift
//  Move It Customer
//
//  Created by Dushyant on 11/05/19.
//  Copyright © 2019 Agicent Technologies. All rights reserved.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var adminChatCountView: UIView!
    @IBOutlet weak var adminChatCountLabel: UILabel!

    @IBOutlet private weak var labelBadgeCount: UILabel!
    @IBOutlet private weak var badgeview: UIView!

    var pageCount: String = "" {
        didSet {
            if pageCount == "0" || pageCount == "" {
                badgeview.isHidden = true
            } else {
                badgeview.isHidden = false
            }
            labelBadgeCount.text = pageCount
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        menuLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        dotView.layer.cornerRadius = 3.0 * screenHeightFactor
        if badgeview != nil {
            badgeview.clipsToBounds = true
            badgeview.layer.cornerRadius = 6.0
        }
//        adminChatCountView.layer.cornerRadius = 7.0
    }
}
