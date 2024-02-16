//
//  DropOff2TableViewCell.swift
//  Move It
//
//  Created by RV on 17/06/21.
//  Copyright © 2021 Agicent Technologies. All rights reserved.
//

import UIKit
import AlamofireImage


class DropOff2TableViewCell: UITableViewCell {

    @IBOutlet weak var bkView: UIView!
    @IBOutlet weak var serviceImageView: UIImageView!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var servicePrice: UILabel!
    @IBOutlet weak var serviceDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bkView.layer.cornerRadius = 10.0 * screenHeightFactor
        serviceName.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        servicePrice.font = UIFont.josefinSansRegularFontWithSize(size: 10.0)
        serviceDescriptionLabel.font = UIFont.josefinSansRegularFontWithSize(size: 8.0)
        servicePrice.isHidden = true
    }

    func setInfo(_ dict: [String: Any]){
        serviceName.text = (dict["name"] as! String)
        let imgURL = URL.init(string:  (dict["photo_url"] as! String))
        serviceImageView.af.setImage(withURL: imgURL!)
        serviceDescriptionLabel.text = (dict["description"] as! String)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
