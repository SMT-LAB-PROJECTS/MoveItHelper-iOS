//
//  UploadPhotoCell.swift
//  MoveIt
//
//  Created by Jyoti on 02/05/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class UploadPhotoCell: UICollectionViewCell {
    
    
    @IBOutlet weak var uploadphotoImageView: UIImageView!
    
    @IBOutlet weak var captureIcon: UIImageView!
    @IBOutlet weak var deletePhotoButton: UIButton!
    
    var deletePhotoaction:(()->())!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func deletePhotoButtonPressed(_ sender: Any) {
        deletePhotoaction()
    }
    
}
