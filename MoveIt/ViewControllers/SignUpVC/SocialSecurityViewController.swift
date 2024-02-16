//
//  SocialSecurityViewController.swift
//  MoveIt
//
//  Created by Dushyant on 14/10/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class SocialSecurityViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var headLabel: UILabel!
    @IBOutlet weak var securityTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var additionalLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle("Social Security Number")
        self.uiConfigurationAfterStoryboard()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        securityTextField.setUnderLine(self.view)
    }

    func uiConfigurationAfterStoryboard() {
        
        
        if let viewControllers = self.navigationController?.viewControllers {
            if(viewControllers.count > 1) {
                let leftBarButtonItem = StaticHelper.leftBarButtonWithImageNamed(imageName: "backward_arrow_icon", vc: self)
                self.navigationItem.leftBarButtonItems = [leftBarButtonItem]
            }
        }
                
        continueButton.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 13.0)
        headLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 13.0)
        additionalLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        securityTextField.font = UIFont.josefinSansRegularFontWithSize(size: 20.0)
    }
    
    @objc func leftButtonPressed(_ selector: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let text = securityTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if text!.isEmpty{
            self.view.makeToast("Please enter security number.")
        }
        else if text?.count != 11{
            self.view.makeToast("Please enter correct security number.")
        } else {
            CommonAPIHelper.saveSecurityKey(VC: self, params: ["security_key":text!]) { (res, err, isExe) in
                if isExe{
                    let socialVC = self.storyboard?.instantiateViewController(withIdentifier: "PendingVerificationVC") as! PendingVerificationVC
                    self.navigationController?.pushViewController(socialVC, animated: true)
                    
//                    if let vcStep = StaticHelper.getViewControllerWithID("PendingVerificationVC") {
//                        self.navigationController?.pushViewController(vcStep, animated: true)
//                    }
                }
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      
        let currentString: NSString = textField.text! as NSString
        let previousString =  textField.text
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        if previousString!.count > newString.length{
            if (previousString?.count == 5 && newString.length == 4) || (previousString?.count == 8 && newString.length == 7){
                
            }
        }
        else{
            if newString.length == 4 || newString.length == 7{
                textField.text =  textField.text! + "-"
            }
        }

        if newString.length == 12{
               return false
        }
        return true
    }
    
}
