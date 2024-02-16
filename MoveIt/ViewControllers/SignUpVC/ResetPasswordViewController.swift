//
//  ResetPasswordViewController.swift
//  Move It Customer
//
//  Created by Dushyant on 24/04/19.
//  Copyright © 2019 Agicent Technologies. All rights reserved.
//

import UIKit
import Alamofire
class ResetPasswordViewController: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var setNewPassLabel: UILabel!
    @IBOutlet weak var newPassTextField: UITextField!
    @IBOutlet weak var confirmPassTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var showPasswordButton: UIButton!
    
    var authKey = ""
    var isFromProfile = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle("Reset Password")        
        
        self.navigationItem.leftBarButtonItem = StaticHelper.leftBarButton(withImageNamed: "backward_arrow_icon", forVC: self)
        headerView.frame.size.height = 504 * screenHeightFactor
      
        if isFromProfile{
            authKey = UserCache.userToken()!
        }
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        confirmPassTextField.setUnderLine(self.headerView, color: lightPinkColor)
        newPassTextField.setUnderLine(self.headerView, color: lightPinkColor)
    }
    
    func setupUI(){
        
        newPassTextField.font = UIFont.josefinSansSemiBoldFontWithSize(size: 15.0)
        confirmPassTextField.font = UIFont.josefinSansSemiBoldFontWithSize(size: 15.0)
        setNewPassLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 15.0)
        resetButton.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 13.0)
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(hideKeyboard))
        self.tableView.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    @objc func leftPressed(_ selector: Any){
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func showPasswordAction(_ sender: Any) {
        
        if showPasswordButton.isSelected{
            confirmPassTextField.isSecureTextEntry = true
            showPasswordButton.isSelected = false
        } else{
            confirmPassTextField.isSecureTextEntry = false
            showPasswordButton.isSelected = true
        }
    }
    
    @IBAction func resetPassAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let newPassword = newPassTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let confirmPassword = confirmPassTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if newPassword!.isEmpty{
            self.view.makeToast("Please enter password.")
            return
        }
        else if confirmPassword!.isEmpty{
            self.view.makeToast("Please enter confirm password.")
            return
        }
        else if newPassword! != confirmPassword!{
            self.view.makeToast("New Password and Confirm Password should be same.")
            return
        }
        else{
            
            
            if newPassword!.count < 3{
                self.view.makeToast("Password must be 3 characters long.")
                return
            }
            StaticHelper.shared.startLoader(self.view)
            let parameters = ["password": newPassword!] as Parameters
            let header : HTTPHeaders = ["Auth-Token":self.authKey]
            
            AF.request(baseURL + kAPIMethods.reset_helper_password, method: .post, parameters: parameters,headers:header).responseJSON { (response) in
                
                DispatchQueue.main.async {
                switch response.result {
                case .success:
                    StaticHelper.shared.stopLoader()
                    if response.response?.statusCode == 200{
                        callAnalyticsEvent(eventName: "moveit_reset_password", desc: ["description":"Password reset successfully"])
                        let apiResponse = response.value as! [String: Any]
                        let message = apiResponse["message"] as! String
                        if self.isFromProfile{
                            self.navigationController?.popViewController(animated: true)
                        }
                        else{
                            for controller in self.navigationController!.viewControllers as Array {
                                if controller.isKind(of: LoginVC.self) {
                                    self.navigationController!.popToViewController(controller, animated: true)
                                    break
                                }
                            }
                        }

                        UIApplication.shared.keyWindow?.rootViewController?.view.makeToast("Password has been updated successfully.")
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == newPassTextField{
            confirmPassTextField.becomeFirstResponder()
        }
        else{
            confirmPassTextField.resignFirstResponder()
        }
        return false
    }
}
