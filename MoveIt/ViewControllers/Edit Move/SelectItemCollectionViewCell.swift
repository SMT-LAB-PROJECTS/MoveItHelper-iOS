//
//  SelectItemCollectionViewCell.swift
//  Move It Customer
//
//  Created by Dushyant on 01/05/19.
//  Copyright © 2019 Agicent Technologies. All rights reserved.
//

import UIKit

class SelectItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImgView: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        itemName.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        itemImgView.layer.cornerRadius = 8
    }
    
    func setDataInfo(_ dict: [ String:Any]){
        itemImgView.image = UIImage.init(named: dict["image"] as! String)
        itemName.text = (dict["itemName"] as! String)
    }
    
}
