//
//  ForgotPasswordViewController.swift
//  Move It Customer
//
//  Created by Dushyant on 24/04/19.
//  Copyright © 2019 Agicent Technologies. All rights reserved.
//

import UIKit
import Alamofire

class ForgotPasswordViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var enterEmailLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var sendCodeLabel: UILabel!
    
    @IBOutlet weak var continueImgBkView: UIImageView!
    
    
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle("Forgot Password")
        
        enterEmailLabel.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        emailTextField.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        sendCodeLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        continueButton.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 13.0)
        continueButton.layer.cornerRadius = 20.0 * screenHeightFactor
        continueImgBkView.layer.cornerRadius = 20.0 * screenHeightFactor
        self.navigationItem.leftBarButtonItem = StaticHelper.leftBarButton(withImageNamed: "backward_arrow_icon", forVC: self)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        emailTextField.setUnderLine(self.view, color: lightPinkColor)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func leftPressed(_ selector: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let emailId = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if emailId!.isEmpty {
            self.view.makeToast("Please enter your email address.")
            return
        }
        else{
//            if !MoveItStaticHelper.shared.isInternetConnected {
//                MoveItStaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: self, completion: nil)
//                return
//            }
            if !(emailId!.isEmpty){
                let emailRegEx: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
                let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
                
                if emailTest.evaluate(with: emailId) == false {
                    self.view.makeToast("Please enter valid email address.")
                    return
                }
                else{
                    StaticHelper.shared.startLoader(self.view)
                    let parameters = ["email_id": emailId!] as Parameters
                    
                    AF.request(baseURL + kAPIMethods.send_helper_reset_password_code, method: .post, parameters: parameters).responseJSON { (response) in
                        
                        DispatchQueue.main.async {
                        switch response.result {
                        case .success:
                            StaticHelper.shared.stopLoader()
                            if response.response?.statusCode == 200{
                                callAnalyticsEvent(eventName: "moveit_forgot_password", desc: ["description":"Forgot password and succesfully."])
                                let apiResponse = response.value as! [String: Any]
                                let auth_key = apiResponse["auth_key"] as! String
                                self.presentOTPVerificationVC(email_id: emailId!, auth_key: auth_key)
                            }
                            else if response.response?.statusCode == 401{
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
        }
    }
    
    func presentOTPVerificationVC(email_id: String, auth_key: String){
        let otpVerificationVC = self.storyboard?.instantiateViewController(withIdentifier: "OTPVerificationViewController") as! OTPVerificationViewController
        otpVerificationVC.userEmail = email_id
        otpVerificationVC.authKey = auth_key
        self.navigationController?.pushViewController(otpVerificationVC, animated: true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
