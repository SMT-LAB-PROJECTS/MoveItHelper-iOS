//
//  UploadPhotoCollectionViewCell.swift
//  MoveIt
//
//  Created by Dushyant on 24/05/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class UploadPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var vehicleImgView: UIImageView!
    @IBOutlet weak var crossButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        vehicleImgView.layer.cornerRadius = 5.0 * screenHeightFactor
    }
}
