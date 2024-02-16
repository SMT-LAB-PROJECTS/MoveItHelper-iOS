//
//  InsuranceExpiryView.swift
//  MoveIt
//
//  Created by SMT LABS 1 on 21/07/22.
//  Copyright © 2022 Jyoti. All rights reserved.
//

import Foundation


import UIKit
import Foundation
class InsuranceExpiryView: UIView, UITextViewDelegate {
    // MARK: - Outlate's....
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var btnBackGround: UIButton!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnCenterOk: UIButton!
    @IBOutlet weak var constHeightTitleView: NSLayoutConstraint!
    
    // MARK: - Variable's....
    var strPopupTitle = ""
    var strMessage = ""
    var strTitleCenterOk = ""
    var strTitleOk = ""
    var strTitleCancel = ""
    static let instance = InsuranceExpiryView()
    var buttonActions:(()->Bool)?
    var actionYes: (()->Void)?
    var actionNo: (()->Void)?
    
    // MARK: - View's method's ....
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed(XIBNibNamed.InsuranceExpiryView, owner: self, options: nil)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        // UIcomponent
        self.contentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.contentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    // MARK: - Required method's ....
    func shwoDataWithClosures(_ popUpTitleMsg:String, _ message:String,  _ cancelButtonTitle:String = "",  _ okButtonTitle:String = "", _ centerOkButtonTitle:String = "", completion:@escaping((Bool)->Void)){
        self.strPopupTitle = popUpTitleMsg
        self.strMessage = message//popUpTitleMsg + "\n\n" + message
        self.strTitleCancel = cancelButtonTitle
        self.strTitleOk = okButtonTitle
        self.strTitleCenterOk = centerOkButtonTitle
        self.btnCenterOk.isHidden = false
        self.titleView.isHidden = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.009) {
            
            self.lblTitle?.text = self.strPopupTitle
            self.lblMessage.text = self.strMessage
            
            self.btnCenterOk.setTitle(self.strTitleCenterOk, for: .normal)
            
            self.actionYes = { completion(true) }
            self.actionNo = { completion(false) }
            self.preViewConfig()
        }
    }
    func preViewConfig(){
        titleView.layer.masksToBounds = true
        btnCenterOk.layer.cornerRadius = 25
        btnCenterOk.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 15.0)
        
        self.lblTitle.font = UIFont.josefinSansSemiBoldFontWithSize(size: 16.0)
        self.lblMessage.numberOfLines = 0
        self.lblTitle.setLineSpacing(lineSpacing:2.25)
        self.lblMessage.setLineSpacing(lineSpacing:2.25)
        self.lblMessage.textAlignment = .center
        self.lblTitle.textAlignment = .center
        self.titleView.roundCorners(corners: [.topLeft,.topRight], radius: 10)
        self.popUpView.layer.cornerRadius = 10
        self.popUpView.layer.shadowOpacity = 0.9
        self.popUpView.backgroundColor = UIColor.white
        self.popUpView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.popUpView.layer.masksToBounds = true
        appDelegate.window?.addSubview(self.contentView)
        
    }
    // MARK: - Action's ....
    @IBAction func okButtonTapped(_ sender: Any) {
        contentView.removeFromSuperview()
        self.actionYes?()
    }
    @IBAction func outSideButtonTapped(_ sender: Any) {
        contentView.removeFromSuperview()
        self.actionNo?()
    }
}
