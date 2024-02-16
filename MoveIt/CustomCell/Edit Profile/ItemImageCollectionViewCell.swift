//
//  ItemImageCollectionViewCell.swift
//  Move It Customer
//
//  Created by Dushyant on 07/05/19.
//  Copyright © 2019 Agicent Technologies. All rights reserved.
//

import UIKit

class ItemImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var crossButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.layer.cornerRadius = 10.0 * screenHeightFactor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
    }
}
