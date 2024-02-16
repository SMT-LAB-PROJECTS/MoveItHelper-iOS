//
//  ListQstnTableViewCell.swift
//  MoveIt
//
//  Created by Dushyant on 24/05/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class ListQstnTableViewCell: UITableViewCell {

    @IBOutlet weak var bkView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
   
    @IBOutlet weak var listViewTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bkView.layer.cornerRadius = 10.0 * screenHeightFactor
        questionLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        listViewTextField.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
   
    }

    func setadditionalThings(){
        listViewTextField.setLeftPaddingPoints(15.0)
        listViewTextField.setRightCaret(15.0, image: UIImage.init(named: "caret_down")!)
      
    }
    func setplaceholderLabel(){
        //listViewTextField.text = ""
        listViewTextField.rightView = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
