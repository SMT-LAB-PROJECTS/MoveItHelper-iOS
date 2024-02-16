//
//  ContactUsViewController.swift
//  MoveIt
//
//  Created by Dushyant on 20/07/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class ContactUsViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var topLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var textView: JVFloatLabeledTextView!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var customerSupportLabel: UILabel!
    @IBOutlet weak var becomingProLabel: UILabel!
    @IBOutlet weak var becomingMuscleLabel: UILabel!
    @IBOutlet weak var dropLineLabel: UILabel!
    
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle("Contact Us")

//        textView.isHidden = true
//        submitButton.isHidden = true

        contentLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        textView.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        let leftBarButtonItem = StaticHelper.leftBarButtonWithImageNamed(imageName: "backward_arrow_icon", vc: self)
        submitButton.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 13.0)
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        headerView.frame.size.height = 504.0 * screenHeightFactor
        
        customerSupportLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        emailLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        becomingProLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        becomingMuscleLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        dropLineLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        
        
        let attribteString1 = NSMutableAttributedString.init(string: "Email: ")
        attribteString1.append(returnUnderlineText("support@gomoveit.com"))
        emailLabel.attributedText = attribteString1
        
        let attribteString2 = NSMutableAttributedString.init(string: "Questions about becoming a Move It Pro or Muscle: ")
        attribteString2.append(returnUnderlineText("helpers@gomoveit.com"))
        becomingProLabel.attributedText = attribteString2
        
        let attribteString3 = NSMutableAttributedString.init(string: "Interested in partnering with Move It for your business? ")
        attribteString3.append(returnUnderlineText("partners@gomoveit.com"))
        becomingMuscleLabel.attributedText = attribteString3
    }
    
    func returnUnderlineText(_ text: String) -> NSMutableAttributedString{
        let textRange = NSRange(location: 0, length: text.count)
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: textRange)
        // Add other attributes if needed
        return attributedText
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
      /*  NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)*/
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
      /*  NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)*/
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    @objc func leftButtonPressed(_ selector: UIButton){
        self.navigationController?.popViewController(animated: true)
    }

    
    //************************************************
    //MARK: - Keyboard Notification Methods
    //************************************************
    
  /*  @objc func keyboardWillShow(_ sender: Notification) {
        let kbSize = (sender.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        let duration: TimeInterval? = CDouble((sender.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval)!)
        UIView.animate(withDuration: duration!, animations: {() -> Void in
            let edgeInsets: UIEdgeInsets? = UIEdgeInsets(top: 0, left: 0, bottom: (kbSize.height), right: 0)
            self.tableView.contentInset = edgeInsets!
            self.tableView.scrollIndicatorInsets = edgeInsets!
        })
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        let duration: TimeInterval? = CDouble((sender.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval)!)
        UIView.animate(withDuration: duration!, animations: {() -> Void in
            let edgeInsets: UIEdgeInsets = UIEdgeInsets.zero
            self.tableView.contentInset = edgeInsets
            self.tableView.scrollIndicatorInsets = edgeInsets
        })
    }*/
    
    
    @IBAction func submitAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            self.view.makeToast("Please enter you feedback.")
            return
        }
        let param = ["description":textView.text.trimmingCharacters(in: .whitespacesAndNewlines)]
        
        CommonAPIHelper.saveQuery(VC: self, params: param) { (res, err, isExecuted) in
            if isExecuted{
                UIApplication.shared.keyWindow?.rootViewController?.view.makeToast("Your feedback submitted succesfully.")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

