//
//  OTPVerificationViewController.swift
//  Move It Customer
//
//  Created by Dushyant on 27/04/19.
//  Copyright © 2019 Agicent Technologies. All rights reserved.
//

import UIKit
import Alamofire
class OTPVerificationViewController: UIViewController,UITextFieldDelegate {


    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var btnBkGradView: UIImageView!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    @IBOutlet weak var didNotGetButton: UIButton!
    var userEmail = ""
    var authKey = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setNavigationTitle("Verification Code")
        
        descLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        otpTextField.font = UIFont.josefinSansSemiBoldFontWithSize(size: 20.0)
        continueButton.titleLabel?.font = UIFont.josefinSansBoldFontWithSize(size: 13.0)
        continueButton.layer.cornerRadius = 20.0 * screenHeightFactor
        btnBkGradView.layer.cornerRadius = 20.0 * screenHeightFactor
        userEmailLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 20.0)
        userEmailLabel.text = userEmail
        didNotGetButton.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        self.navigationItem.leftBarButtonItem = StaticHelper.leftBarButton(withImageNamed: "backward_arrow_icon", forVC: self)
        //otpTextField.addDoneButtonOnKeyboard()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        otpTextField.setUnderLine(self.view, color: lightPinkColor)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func leftPressed(_ selector: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let otp = otpTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if otp!.isEmpty || (otp?.count)! < 6 {
            self.view.makeToast("Please enter valid OTP.")
            return
        }
        else{
            StaticHelper.shared.startLoader(self.view)
            let parameters = ["forgot_pass_code": otp!] as Parameters
            let header : HTTPHeaders = ["Auth-Token":self.authKey]
            
            print(parameters)
            print(header)
            
            AF.request(baseURL + kAPIMethods.validate_helper_reset_password_code, method: .post, parameters: parameters,headers:header).responseJSON { (response) in
                
                DispatchQueue.main.async {
                switch response.result {
                case .success:
                    StaticHelper.shared.stopLoader()
                    
                    if response.response?.statusCode == 200{
//                        let apiResponse = response.value as! [String: Any]
//                        let auth_key = apiResponse[APIParameters.auth_key] as! String
                        self.presentresetPasswordVC( auth_key: self.authKey)
                    }
                    else if response.response?.statusCode == 202{
                        let apiResponse = response.value as! [String: Any]
                        self.view.makeToast("Please enter correct OTP.")
                    }
                    else if response.response?.statusCode == 401{
                        let apiResponse = response.value as! [String: Any]
                        self.view.makeToast(apiResponse["message"] as? String)
                    }
                case .failure(let error):
                    StaticHelper.shared.stopLoader()
                    print(error.localizedDescription)
                    self.view.makeToast(error.localizedDescription)
                }
                }
            }
        }
    }
    
    func presentresetPasswordVC(auth_key: String){
        let otpVerificationVC = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordViewController") as! ResetPasswordViewController
        otpVerificationVC.authKey = auth_key
        self.navigationController?.pushViewController(otpVerificationVC, animated: true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 6
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    
    @IBAction func didNotGetCodeAction(_ sender: Any) {
        StaticHelper.shared.startLoader(self.view)
        let parameters = ["email_id": userEmail] as Parameters
        
        AF.request(baseURL + kAPIMethods.send_helper_reset_password_code, method: .post, parameters: parameters).responseJSON { (response) in
            DispatchQueue.main.async {
            switch response.result {
            case .success:
               StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200{
                    self.view.makeToast("Code resent successfully.")
                }
                    else if response.response?.statusCode == 401{
                        StaticHelper.shared.stopLoader()
                        let responseJson = response.value as! [String: AnyObject]
                        self.view.makeToast(responseJson["message"] as? String)
                    }
                else{
                    let apiResponse = response.value as! [String: Any]
                    self.view.makeToast(apiResponse["message"] as? String)
                }
            case .failure(let error):
                StaticHelper.shared.stopLoader()
                self.view.makeToast(error.localizedDescription)
            }
            }
        }
    }
}
