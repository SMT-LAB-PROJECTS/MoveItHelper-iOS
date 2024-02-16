//
//  Step5OptionalQuestionCell.swift
//  MoveIt
//
//  Created by Jyoti on 06/05/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class Step5OptionalQuestionCell: UITableViewCell,UITextViewDelegate {
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    
    
    @IBOutlet weak var radioButtonOuterView: UIView!
    @IBOutlet weak var yesbuttonOutlet: UIButton!
    @IBOutlet weak var yesLabel: UILabel!
    @IBOutlet weak var noButtonOutlet: UIButton!
    @IBOutlet weak var noLabel: UILabel!
    @IBOutlet weak var outerViewOtTxtview: UIView!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var textFieldOuterView: UIView!
    @IBOutlet weak var textfield: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        outerView.layer.cornerRadius = 5.0
        outerView.layer.masksToBounds = true
       
        questionLabel.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        
        textFieldOuterView.layer.cornerRadius = 5.0
        textFieldOuterView.layer.borderColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1).cgColor
        textFieldOuterView.layer.borderWidth = 1.0
        textFieldOuterView.clipsToBounds = true
        textfield.font = UIFont.josefinSansRegularFontWithSize(size: 10.0)
       
        var textString = NSMutableAttributedString()
        let placeholderText = "Select your estimate"
        textString = NSMutableAttributedString(string:placeholderText, attributes: [NSAttributedString.Key.font:UIFont.josefinSansRegularFontWithSize(size: 12.0)])
        textString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 47/255, green: 44/255, blue: 61/255, alpha: 1), range:NSMakeRange(0,placeholderText.count))
        
        textfield.attributedPlaceholder = textString
       
        
        yesLabel.font = UIFont.josefinSansRegularFontWithSize(size: 10.0)
        noLabel.font = UIFont.josefinSansRegularFontWithSize(size: 10.0)
       
        
        outerViewOtTxtview.layer.cornerRadius = 5.0
        outerViewOtTxtview.layer.borderColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1).cgColor
        outerViewOtTxtview.layer.borderWidth = 1.0
        outerViewOtTxtview.clipsToBounds = true
      
        textView.font = UIFont.josefinSansRegularFontWithSize(size: 10.0)
        textView.delegate = self
        textView.text = "Type Here..."
        textView.textColor = UIColor(red: 208/255, green: 207/255, blue: 209/255, alpha: 1)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //#MARK:- UITextView Delegates
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor(red: 208/255, green: 207/255, blue: 209/255, alpha: 1) {
            textView.text = ""
            textView.textColor = UIColor(red: 47/255, green: 44/255, blue: 61/255, alpha: 1)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == "" {
            
            textView.text = "Type Here..."
            textView.textColor = UIColor(red: 208/255, green: 207/255, blue: 209/255, alpha: 1)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        return changedText.count <= 255
    }
    

}
