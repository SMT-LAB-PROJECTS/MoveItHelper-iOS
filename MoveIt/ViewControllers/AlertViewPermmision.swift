//
//  AlertViewPermmision.swift
//  Move It
//
//  Created by Govind Kumar Patidar on 10/05/22.
//  Copyright © 2022 Jyoti. All rights reserved.
//


import UIKit
import Foundation
protocol AlertViewPermmisionDelegate: AnyObject {
    func alertViewPermmisionCLick(isOk:Bool)
}
class AlertViewPermmision: UIView, UITextViewDelegate {
    // MARK: - Outlate's....
    @IBOutlet var contentView: UIView!
  
    @IBOutlet weak var btnBackGround: UIButton!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnOk: UIButton!
    
    // MARK: - Variable's....
   weak var delegate : AlertViewPermmisionDelegate!
    var strPopupTitle = ""
    var strTitleMessage = ""
    var strMessage = ""
    // MARK: - View's method's ....
    override init(frame: CGRect) {
        super.init(frame: frame)
        commanInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commanInit()
    }
    private func commanInit(){
        shwoAnimate()
        //preViewConfig()
    }
    
    // MARK: - Required method's ....
    func preViewConfig(){
        contentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        popUpView.layer.cornerRadius = 10
        popUpView.layer.shadowOpacity = 0.9
        popUpView.backgroundColor = UIColor.white
        popUpView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        btnOk.layer.cornerRadius = 20
        titleView.layer.masksToBounds = true
        btnOk.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 15.0)
    }
    func shwoAnimate(){
        Bundle.main.loadNibNamed(XIBNibNamed.AlertViewPermmision, owner: self, options: nil)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(self.contentView)
        self.preViewConfig()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.lblTitle?.text = self.strPopupTitle
            self.lblTitle.font = UIFont.josefinSansSemiBoldFontWithSize(size: 16.0)

            let str1:String = self.strTitleMessage
            let str12:String = "\n\n"
            let str2:String = self.strMessage
            
            let attributedText = NSMutableAttributedString(string: str1, attributes: [NSAttributedString.Key.font: UIFont.josefinSansSemiBoldFontWithSize(size: 15), NSAttributedString.Key.foregroundColor: UIColor.black])
            attributedText.append(NSAttributedString(string: str12, attributes: [NSAttributedString.Key.font: UIFont.josefinSansRegularFontWithSize(size: 5), NSAttributedString.Key.foregroundColor: darkPinkColor]))
            attributedText.append(NSAttributedString(string: str2, attributes: [NSAttributedString.Key.font: UIFont.josefinSansRegularFontWithSize(size: 14), NSAttributedString.Key.foregroundColor: UIColor.black]))
            self.lblMessage.numberOfLines = 0
            self.lblMessage.attributedText = attributedText
            self.lblMessage.setLineSpacing()
            self.lblMessage.textAlignment = .center

            self.btnOk.setTitle(kStringPermission.goToSetting, for: .normal)
            self.titleView.roundCorners(corners: [.topLeft,.topRight], radius: 10)
            
        }
    }
    
    func removeAnimate(){
        UIView.animate(withDuration: 0.25, animations: {
            self.contentView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.contentView.alpha = 0.0
        }) { finished in
            if finished {
            }
        }
    }

    // MARK: - Action's ....
    @IBAction func okButtonTapped(_ sender: Any) {
        removeAnimate()
        if let complition = delegate {
            complition.alertViewPermmisionCLick(isOk: true)
        }
    }
    @IBAction func outSideButtonTapped(_ sender: Any) {
        removeAnimate()
        if let complition = delegate {
            complition.alertViewPermmisionCLick(isOk: false)
        }
    }
}

// MARK: - Extension for the UILabel's ....
extension UILabel {
    func setLineSpacing(lineSpacing: CGFloat = 2.0, lineHeightMultiple: CGFloat = 0.0) {

        guard let labelText = self.text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple

        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

        // (Swift 4.2 and above) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))


        // (Swift 4.1 and 4.0) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

        self.attributedText = attributedString
    }
}
