//
//  LoginVC.swift
//  MoveIt
//
//  Created by Jyoti on 16/04/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit
import Toast_Swift
import Alamofire

class LoginVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var loginTableView: UITableView!
    @IBOutlet weak var loginContentView: UIView!
    
    @IBOutlet weak var emailPassBGView: UIView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var forgotPasswordButtonOutlet: UIButton!
    @IBOutlet weak var passwordHideButtonOutlet: UIButton!
    @IBOutlet weak var loginWithEmailButtonOutlet: UIButton!
    
    var iconClick = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.setUpLoginUIData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)        
    }
    
    func setUpLoginUIData(){
        
        self.navigationController?.isNavigationBarHidden = true
       
        loginLabel.font = UIFont.josefinSansRegularFontWithSize(size: 16.0)
       
        emailPassBGView.layer.cornerRadius = 8.0 * (UIScreen.main.bounds.height/508)
        emailPassBGView.clipsToBounds = true;
        
        
        loginWithEmailButtonOutlet.clipsToBounds = true;
        loginWithEmailButtonOutlet.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        
        emailTextField.delegate = self
        emailTextField.tag = 0;
        emailTextField.returnKeyType = UIReturnKeyType.next
        
        passwordTextField.delegate = self
        passwordTextField.tag = 1;
        passwordTextField.returnKeyType = UIReturnKeyType.done
        
        emailLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        emailTextField.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
       
        forgotPasswordButtonOutlet.titleLabel?.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(hideKeyboard))
        self.loginTableView.addGestureRecognizer(tapGesture)
        
    }
    
    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        loginContentView.frame.size.height = 504 * UIScreen.main.bounds.size.height/568
        loginWithEmailButtonOutlet.layer.cornerRadius = (loginWithEmailButtonOutlet.frame.size.height/2.0)
        loginWithEmailButtonOutlet.layer.masksToBounds = true
    }
    

    //#MARK:- IBAction Methods

    @IBAction func loginBackButtonPressed(_ sender: Any) {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
     self.view.endEditing(true)
        let forgetVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(forgetVC, animated: true)
    }
    
    @IBAction func passwordHideButtonPressed(_ sender: Any) {
       // passwordTextField.isSecureTextEntry.toggle()
        if(iconClick == true) {
            passwordTextField.isSecureTextEntry = false
            passwordHideButtonOutlet.setImage(UIImage(named : "hide_icon"), for: UIControl.State.normal)
            
        } else {
            passwordTextField.isSecureTextEntry = true
            passwordHideButtonOutlet.setImage(UIImage(named : "unhide_icon"), for: UIControl.State.normal)
        }
        
        iconClick = !iconClick
    }
    
    @IBAction func loginWithEmailButtonPressed(_ sender: Any) {
        view.endEditing(true)
        self.passwordHideButtonOutlet.titleLabel?.numberOfLines = 2
        let emailId = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let deviceToken = UserDefaults.standard.value(forKey: "UserToken") as? String ?? ""
        
        if emailId!.isEmpty {
            self.view.makeToast("Please enter your email address.")
            return
        }
        else if password!.isEmpty{
            self.view.makeToast("Please enter password.")
            return
        }
            
        else{
            if !(emailId!.isEmpty){
                let emailRegEx: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
                let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
                var emailDomain = ""
                
                if let range = emailId?.range(of: "@") {
                    
                    emailDomain = "@" + String(emailId![range.upperBound...])
                }
                
                if emailTest.evaluate(with: emailId) == false {
                    self.view.makeToast("Please enter valid email address.")
                    return
                }
                else if password!.count < 3{
                    self.view.makeToast("Password must be 3 characters long.")
                    return
                }
                else{
                    if !StaticHelper.Connectivity.isConnectedToInternet {
                        StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: self, completion: nil)
                        return
                    }
                    
                    let dict:[String : Any] = [ "email_id" : emailId!, "password" : password!,"device_type" : "I", "device_token" : deviceToken, "device_name":modelName, "device_version":systemVersion, "app_version":appVersion ?? ""]
                    print("dict login", dict)
                    
                    if !StaticHelper.Connectivity.isConnectedToInternet {
                        StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: self, completion: nil)
                        return
                    }
                   
                    StaticHelper.shared.startLoader(self.view)
                    
                    AF.request(baseURL + helper_sign_in, method: .post, parameters: dict).responseJSON { (response) in
                        
                        DispatchQueue.main.async {
                        switch response.result {
                        case .success:
                            if response.response?.statusCode == 200 {
                                StaticHelper.shared.stopLoader()
                                print(response.value!)
                                let resposneDict = response.value as! [String: Any]
                                callAnalyticsEvent(eventName: "moveit_login", desc: ["description":"User Logged in to the app."])
                                if !resposneDict.isEmpty {
                                    
                                    UserCache.shared.saveUserData(resposneDict)
                                    let completedStep =  Int(resposneDict["signup_step"] as! Int)
                                    let helperType = Int(resposneDict["service_type"] as! Int)
                                    let isAgree = Int(resposneDict["is_agree"] as! Int)
                                    let isVerified =  Int(resposneDict["is_verified"] as! Int) 
                                    let isSecurityAdded =  Int(resposneDict["is_security_key_added"] as! Int)
                                    
                                    switch completedStep {
                                    case 1:
                                        if helperType == HelperType.Pro || helperType == HelperType.ProMuscle {
                                            StaticHelper.moveToViewController("Step2ViewController", animated: false)
                                        } else {
                                            StaticHelper.moveToViewController("Step4ViewController", animated: false)
                                        }
                                    case 2:
                                        StaticHelper.moveToViewController("Step3ViewController", animated: false)
                                    case 3:
                                        StaticHelper.moveToViewController("Step4ViewController", animated: false)
                                    case 4:
                                        StaticHelper.moveToViewController("Step5ViewController", animated: false)
                                    case 5:
                                        if isAgree == 0 {
                                            StaticHelper.moveToViewController("PdfViewerViewController", animated: false)
                                        } else if isSecurityAdded == 0 {
                                            StaticHelper.moveToViewController("SocialSecurityViewController", animated: false)
                                        } else {
                                            if isVerified == 1 {
                                                appDelegate.gotoHomeVC()                                     
                                            } else {
                                                StaticHelper.moveToViewController("PendingVerificationVC", animated: false)
                                            }
                                        }
                                    default:
                                        break
                                    }
                                }
                            }
                            else if response.response?.statusCode == 201{
                                StaticHelper.shared.stopLoader()
                                let responseJson = response.value as! [String: AnyObject]
                                self.view.makeToast(responseJson["message"] as? String)
                                
                            }else if response.response?.statusCode == 409{
                                StaticHelper.shared.stopLoader()
                                let responseJson = response.value as! [String: AnyObject]
                                self.view.makeToast(responseJson["message"] as? String)
                                StaticHelper.moveToViewController("LoginVC", animated: true)
                                print(responseJson)
                                
                            }else if response.response?.statusCode == 500{
                                StaticHelper.shared.stopLoader()
                                let responseJson = response.value as! [String: AnyObject]
                                self.view.makeToast(responseJson["message"] as? String)
                               
                            }else if response.response?.statusCode == 400{
                                StaticHelper.shared.stopLoader()
                                let responseJson = response.value as! [String: AnyObject]
                                self.view.makeToast(responseJson["message"] as? String)
                               
                            }else if response.response?.statusCode == 401{
                                StaticHelper.shared.stopLoader()
                                let responseJson = response.value as! [String: AnyObject]
                                self.view.makeToast(responseJson["message"] as? String)
                            }else if response.response?.statusCode == 403{
                                StaticHelper.shared.stopLoader()
                                appDelegate.showBlockedMessage()
                            }
                        case .failure(let error):
                            StaticHelper.shared.stopLoader()
                            self.view.makeToast(messageError)
                            print (error.localizedDescription)
                        }
                        }
                   }
                }
            }
        }
    }
    
    //************************************************
    //MARK: - Keyboard Notification Methods
    //************************************************
    
    @objc func keyboardWillShow(_ sender: Notification) {
        let kbSize = (sender.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        let duration: TimeInterval? = CDouble((sender.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval)!)
        UIView.animate(withDuration: duration!, animations: {() -> Void in
            let edgeInsets: UIEdgeInsets? = UIEdgeInsets(top: 0, left: 0, bottom: (kbSize.height), right: 0)
            self.loginTableView.contentInset = edgeInsets!
            self.loginTableView.scrollIndicatorInsets = edgeInsets!
        })
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        let duration: TimeInterval? = CDouble((sender.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval)!)
        UIView.animate(withDuration: duration!, animations: {() -> Void in
            let edgeInsets: UIEdgeInsets = UIEdgeInsets.zero
            self.loginTableView.contentInset = edgeInsets
            self.loginTableView.scrollIndicatorInsets = edgeInsets
        })
    }
    
    //#MARK:- UITextField Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      
        switch (textField.tag) {
        case 0:
             textField.resignFirstResponder()
             passwordTextField.becomeFirstResponder()
            break;
        case 1:
            passwordTextField.resignFirstResponder()
            break;
        
        default:
            break;
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
     
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
      
    }

    
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    
}

