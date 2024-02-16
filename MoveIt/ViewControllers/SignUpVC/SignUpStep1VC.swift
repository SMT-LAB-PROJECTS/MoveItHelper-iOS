//
//  SignUpStep1VC.swift
//  MoveIt
//
//  Created by Jyoti on 23/04/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import AccountKit
import Alamofire

import GooglePlaces
import GoogleMaps
import CoreLocation

class SignUpStep1VC: UIViewController,UITextFieldDelegate,AKFViewControllerDelegate {
    
    var helperType:Int = HelperType.Pro
    
    @IBOutlet weak var btnTermsConditions: UIButton!
    @IBOutlet weak var btnPrivacyPolicy: UIButton!
    
    @IBOutlet weak var signUpLabel: UILabel!
    
    @IBOutlet weak var step1Label: UILabel!
    @IBOutlet weak var signStep1TableView: UITableView!
    @IBOutlet weak var signUpContentView: UIView!
   
    @IBOutlet weak var moveLabel: UILabel!
    @IBOutlet weak var truckBoxLabel: UILabel!
    @IBOutlet weak var fillLabel: UILabel!
    
    @IBOutlet weak var showPasswordButton: UIButton!
    
    @IBOutlet weak var phoneTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var firstNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var lastNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextfield: SkyFloatingLabelTextField!
    
    
    @IBOutlet weak var phoneNumberButtonOutlet: UIButton!
    @IBOutlet weak var dobTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var streetAddressTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var stateTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var cityTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var zipCodeTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var checkSelectImageview: UIImageView!
    @IBOutlet weak var checkBtnOutlet: UIButton!
    
    @IBOutlet weak var termsConditonLabel: UILabel!
    @IBOutlet weak var signUpButtonOutlet: UIButton!
    
    var _accountKit: AccountKitManager!
    var phoneLoginViewController: AKFViewController?
    var phoneNumber:String!
    
    
    var finalDate = String()
    
    var helperLat = 0.0
    var helperLong = 0.0
    
    @IBOutlet weak var btnBack: UIButton!
    var hideBackButton:Bool = false
    
    let termsAndCondition =  appDelegate.baseContentURL + "terms-conditions-mobile"
    let privacyPolicy =   appDelegate.baseContentURL + "privacy-policy-mobile"
    
    //MARK: - Method Start
    override func viewDidLoad() {
        super.viewDidLoad()
        //phoneNumber = "7999475488"
        self.setUpUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(verifiedPhoneNumber(notification:)), name: NSNotification.Name(rawValue: "phoneNumberNotifier"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       self.navigationController?.isNavigationBarHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func setUpUI(){
        
        self.navigationController?.isNavigationBarHidden = true
        
        signUpLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        step1Label.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        
        moveLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        truckBoxLabel.font = UIFont.josefinSansRegularFontWithSize(size: 10.0)
        fillLabel.font = UIFont.josefinSansRegularFontWithSize(size: 10.0)
        addressLabel.font = UIFont.josefinSansBoldFontWithSize(size: 12.0)
        termsConditonLabel.font = UIFont.josefinSansRegularFontWithSize(size: 10.0)
       
        outerView.layer.cornerRadius = 10.0
        outerView.clipsToBounds = true
        
        firstNameTextField.titleFont = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        lastNameTextField.titleFont = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        emailTextField.titleFont = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        passwordTextfield.titleFont = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        phoneTextField.titleFont = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        dobTextField.titleFont = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        streetAddressTextField.titleFont = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        stateTextField.titleFont = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        cityTextField.titleFont = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        zipCodeTextField.titleFont = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
    
        firstNameTextField.placeholderFont = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        lastNameTextField.placeholderFont = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        emailTextField.placeholderFont = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        passwordTextfield.placeholderFont = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        phoneTextField.placeholderFont = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        dobTextField.placeholderFont = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        streetAddressTextField.placeholderFont = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        stateTextField.placeholderFont = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        cityTextField.placeholderFont = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        zipCodeTextField.placeholderFont = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        dobTextField.delegate = self
        streetAddressTextField.delegate = self
        stateTextField.delegate = self
        cityTextField.delegate = self
        zipCodeTextField.delegate = self
        
        firstNameTextField.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        lastNameTextField.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        emailTextField.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        passwordTextfield.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        phoneNumberButtonOutlet.titleLabel?.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        phoneTextField.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        dobTextField.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        streetAddressTextField.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        stateTextField.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        cityTextField.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        zipCodeTextField.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        
        
        signUpButtonOutlet.titleLabel?.font = UIFont.josefinSansRegularFontWithSize(size: 14.0)
    
        checkBtnOutlet.isSelected = false;
        checkSelectImageview.image = UIImage(named: "check_square")
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(hideKeyboard))
        self.signStep1TableView.addGestureRecognizer(tapGesture)
    
        
        let firstAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(red: 246/255, green: 174/255, blue: 180/255, alpha: 1),NSAttributedString.Key.font: UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)]
        let secondAttributes = [NSAttributedString.Key.foregroundColor:  UIColor(red: 246/255, green: 174/255, blue: 180/255, alpha: 1),NSAttributedString.Key.font: UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)]

        let firstString = NSMutableAttributedString(string: "By clicking on sign up button you agree to our ", attributes: [NSAttributedString.Key.font: UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)])
        let secondString = NSAttributedString(string: "Terms & Conditions", attributes: firstAttributes)
        let thirdString = NSAttributedString(string: " and ")
        let fourthString = NSAttributedString(string: "Privacy Policy",attributes: secondAttributes)
        
        firstString.append(secondString)
        firstString.append(thirdString)
        firstString.append(fourthString)
        
        termsConditonLabel.attributedText = firstString
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.hideKeyboard))
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpace.width = 240*SCREEN_WIDTH
        toolBar.setItems([fixedSpace,doneButton], animated: false)
        zipCodeTextField.inputAccessoryView = toolBar
        
        // initialize Account Kit
        if _accountKit == nil {
            _accountKit = AccountKitManager(responseType: .accessToken)
        }
        
        if self.helperType == HelperType.Pro {
            step1Label.text = "Step 1/5"
             self.truckBoxLabel.text = "We are looking for honest, friendly, motivated, hardworking, able-bodied individuals with a pick-up truck, cargo van, box truck, or a vehicle w/a trailer to help move and deliver."
            self.moveLabel.text = "Move It Pro"
        } else if self.helperType == HelperType.Muscle {
            step1Label.text = "Step 1/3"
             self.truckBoxLabel.text = "We are looking for honest, friendly, motivated, hardworking, able-bodied individuals to assist Move It Pros or jobs that only need muscle."
            self.moveLabel.text = "Move It Muscle"
        } else if self.helperType == HelperType.ProMuscle {
            step1Label.text = "Step 1/5"
             self.truckBoxLabel.text = "We are looking for honest, friendly, motivated, hardworking, able-bodied individuals with a pick-up truck, cargo van, box truck, or a vehicle w/a trailer to help move and deliver."
            self.moveLabel.text = "Move It Pro & Muscle"
        }
        
    }
    
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        signUpContentView.frame.size.height =  960 * UIScreen.main.bounds.size.height/568//(830 / 504.0) * SCREEN_HEIGHT //800 * UIScreen.main.bounds.size.height/504
        signUpButtonOutlet.layer.cornerRadius = (signUpButtonOutlet.frame.size.height/2.0)
        signUpButtonOutlet.layer.masksToBounds = true
    }
    func redirectToTermsAndCondition(strURL:String, strTitle:String){
       let distanceVC = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
       distanceVC.titleString = strTitle
       distanceVC.urlString = strURL
       self.navigationController?.pushViewController(distanceVC, animated: true)
    }
    //MARK: - button actions
    
    @IBAction func actionsTNCPP(_ sender: UIButton) { //terms and conditions and privacy policy...
        switch sender.tag {
        case 0://TNC
            redirectToTermsAndCondition(strURL: self.termsAndCondition, strTitle: "Terms and conditions")
            break
        case 1://PP
            redirectToTermsAndCondition(strURL: self.privacyPolicy, strTitle: "Privacy Policy")
            break
        default:
            break
        }
    
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    
  
    @IBAction func checkButtonPressed(_ sender: Any) {
        if checkBtnOutlet.isSelected == true {
            checkBtnOutlet.isSelected = false
            checkSelectImageview.image = UIImage(named: "check_square")
           
        }else {
            checkBtnOutlet.isSelected = true
            checkSelectImageview.image = UIImage(named: "check_slct_icon")
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        
        self.signUpStep1Method()
    }
    
    @IBAction func phoneNumberButtonPressed(_ sender: Any) {
        self.signUpWithPhoneNumber()
    }
    
    //*********************************************************
    // MARK:- SIGNUP METHOD
    //*********************************************************
    
    func signUpStep1Method() {
        
//        let completedStep =  Int(UserCache.shared.userInfo(forKey: kUserCache.completedStep)  as? Int ?? 0) 
//        if(completedStep > 0) {
//            if self.helperType == HelperType.Pro || self.helperType == HelperType.ProMuscle{
//                let step2 = self.storyboard?.instantiateViewController(withIdentifier: "Step2ViewController") as! Step2ViewController
//                self.navigationController?.pushViewController(step2, animated: true)
//            } else if self.helperType == HelperType.Muscle {
//                let step4 = self.storyboard?.instantiateViewController(withIdentifier: "Step4ViewController") as! Step4ViewController
//                self.navigationController?.pushViewController(step4, animated: true)
//            }
//            return
//        }
        
        view.endEditing(true)
        let firstName = firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailId = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let dateOfBirth = dobTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let address = streetAddressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let state = stateTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let city = cityTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let zipcode = zipCodeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let deviceToken = UserDefaults.standard.value(forKey: "UserToken") as! String
                
        if firstName!.isEmpty {
            self.view.makeToast("Please enter your first name.")
            return
        }
        else if lastName!.isEmpty {
            self.view.makeToast("Please enter your last name.")
            return
        }
        else if emailId!.isEmpty {
            self.view.makeToast("Please enter your email address.")
            return
        }
        else if password!.isEmpty{
            self.view.makeToast("Please enter password.")
            return
        }
        else if phoneNumber == nil{
            self.view.makeToast("Please enter your phone number.")
            return
        }
        else if dateOfBirth!.isEmpty {
            self.view.makeToast("Please enter your date of birth.")
            return
        }
        else if address!.isEmpty {
            self.view.makeToast("Please enter street address.")
            return
        }
        else if state!.isEmpty {
            self.view.makeToast("Please enter your state.")
            return
        }
        else if city!.isEmpty {
            self.view.makeToast("Please enter your city.")
            return
        }
        else if zipcode!.isEmpty {
            self.view.makeToast("Please enter your zip code.")
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
                else if !checkBtnOutlet.isSelected{
                    self.view.makeToast("Please accept to our Terms of Services and Privacy Policy.")
                    return
                }
                else{
                    if !StaticHelper.Connectivity.isConnectedToInternet {
                        StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: self, completion: nil)
                        return
                    }
                    //deviceType, deviceToken, device_name ,device_version,app_version
                    let dict:[String : Any] = ["first_name" : firstName!, "last_name" : lastName!,"email_id" : emailId!, "password" : password!,"phone_num" : phoneNumber!, "dob" : finalDate,"helper_address" : address!, "helper_state" : state!,"helper_city" : city!, "helper_zipcode" : zipcode!,"helper_lat" : helperLat, "helper_long" : helperLong,"device_type" : "I", "device_token" : deviceToken,"service_type" : self.helperType,"device_name": UIDevice.current.model,"device_version":UIDevice.current.systemVersion,"app_version": UIApplication.shared.versionBuild(), "is_zipcode" : "true"]
                    print(dict)

                    self.helper_signup_step1_APICall(dict: dict)
                }
            }
        }
    }
    
    @IBAction func showPasswordAction(_ sender: Any) {
        
        if (sender as! UIButton).isSelected{
            passwordTextfield.isSecureTextEntry = true
            (sender as! UIButton).isSelected = false
        }
        else{
            passwordTextfield.isSecureTextEntry = false
            (sender as! UIButton).isSelected = true
        }
        
    }
    
    //*********************************************************
    // MARK:-- AKFViewControllerDelegate Methods
    //*********************************************************
    
    func prepareLoginViewController(loginViewController: AKFViewController) {
        
        loginViewController.delegate = self
        loginViewController.isSendToFacebookEnabled = true
        //loginViewController.isGetACallEnabled = true
        loginViewController.isSMSEnabled = true
        loginViewController.uiManager = SkinManager(skinType: .classic, primaryColor: UIColor.blue)
    }
    
    //MARK: - APIs
    func helper_signup_step1_APICall(dict: [String : Any]) {
        //let dict:[String : Any] = ["first_name" : firstName!, "last_name" : lastName!,"email_id" : emailId!, "password" : password!,"phone_num" : phoneNumber!, "dob" : finalDate,"helper_address" : address!, "helper_state" : state!,"helper_city" : city!, "helper_zipcode" : zipcode!,"helper_lat" : helperLat, "helper_long" : helperLong,"device_type" : "I", "device_token" : deviceToken,"service_type" : self.helperType,"device_name": UIDevice.current.model,"device_version":UIDevice.current.systemVersion,"app_version": UIApplication.shared.versionBuild(), "is_zipcode" : "true"]
        
        print(dict)
        
     StaticHelper.shared.startLoader(self.view)
        
     AF.request(baseURL + helper_signup_step1, method: .post, parameters: dict  ).responseJSON { (response) in
         
         DispatchQueue.main.async {
        switch response.result {
            case .success:
                if response.response?.statusCode == 201{
                    StaticHelper.shared.stopLoader()

                    let resposneDict = response.value as! [String: Any]
                    
                    if !resposneDict.isEmpty{
                        UserCache.shared.saveUserData(resposneDict)
                        UserCache.shared.updateUserProperty(forKey: kUserCache.auth_key, withValue:  resposneDict["auth_key"] as AnyObject)
                        UserCache.shared.updateUserProperty(forKey: kUserCache.completedStep, withValue:  resposneDict["signup_step"] as AnyObject)
                        UserCache.shared.updateUserProperty(forKey: kUserCache.service_type , withValue: self.helperType as AnyObject )
                        if self.helperType == HelperType.Pro || self.helperType == HelperType.ProMuscle{
                            
                            let step2 = self.storyboard?.instantiateViewController(withIdentifier: "Step2ViewController") as! Step2ViewController
                            self.navigationController?.pushViewController(step2, animated: true)

//                            if let vcStep = StaticHelper.getViewControllerWithID("Step2ViewController") {
//                                self.navigationController?.pushViewController(vcStep, animated: true)
//                            }
                        } else if self.helperType == HelperType.Muscle {
                            
                            let step4 = self.storyboard?.instantiateViewController(withIdentifier: "Step4ViewController") as! Step4ViewController
                            self.navigationController?.pushViewController(step4, animated: true)

//                            if let vcStep = StaticHelper.getViewControllerWithID("Step4ViewController") {
//                                self.navigationController?.pushViewController(vcStep, animated: true)
//                            }
                        }
                    }
                }
                else if response.response?.statusCode == 200{
                    StaticHelper.shared.stopLoader()
                    let responseJson = response.value as! [String: AnyObject]
                    UserCache.shared.saveUserData(responseJson)
                    self.view.makeToast((responseJson["message"] as! String))
                } else if response.response?.statusCode == 202 {
                    StaticHelper.shared.stopLoader()
                    let responseJson = response.value as! [String: AnyObject]
                    UserCache.shared.saveUserData(responseJson)
                    self.view.makeToast((responseJson["message"] as! String))
                } else if response.response?.statusCode == 409{
                    StaticHelper.shared.stopLoader()
                    let responseJson = response.value as! [String: AnyObject]
                    self.view.makeToast(responseJson["message"] as? String)
                } else if response.response?.statusCode == 500{
                    StaticHelper.shared.stopLoader()
                    let responseJson = response.value as! [String: AnyObject]
                    self.view.makeToast(responseJson["message"] as? String)
                } else if response.response?.statusCode == 400{
                    StaticHelper.shared.stopLoader()
                    let responseJson = response.value as! [String: AnyObject]
                    self.view.makeToast(responseJson["message"] as? String)
                } else if response.response?.statusCode == 403{
                    StaticHelper.shared.stopLoader()
                    UserDefaults.standard.removeObject(forKey: "auth_token")
                    UserDefaults.standard.removeObject(forKey: "User_Data_Dict")
                    UserDefaults.standard.synchronize()
                }
                case .failure(_):
                        let responseJson = response.value as? [String: AnyObject]
                        let strMsg:String? = responseJson?["message"] as? String
                            if(strMsg != nil) {
                        if response.response?.statusCode == 202 {
                            StaticHelper.shared.stopLoader()
                            let responseJson = response.value as! [String: AnyObject]
                            UserCache.shared.saveUserData(responseJson)
                            self.view.makeToast((strMsg))
                        } else {
                            StaticHelper.shared.stopLoader()
                            self.view.makeToast(messageError)
                        }
                    } else {
                        StaticHelper.shared.stopLoader()
                        self.view.makeToast(messageError)
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
            self.signStep1TableView.contentInset = edgeInsets!
            self.signStep1TableView.scrollIndicatorInsets = edgeInsets!
        })
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        let duration: TimeInterval? = CDouble((sender.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval)!)
        UIView.animate(withDuration: duration!, animations: {() -> Void in
            let edgeInsets: UIEdgeInsets = UIEdgeInsets.zero
            self.signStep1TableView.contentInset = edgeInsets
            self.signStep1TableView.scrollIndicatorInsets = edgeInsets
        })
    }
    
    
    //*********************************************************
    // MARK:-- LOGIN WITH ACCOUNTKIT
    //*********************************************************
    
    func signUpWithPhoneNumber(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PhoneNumberVerificationVC") as! PhoneNumberVerificationVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //MARK: - 
    @objc func verifiedPhoneNumber(notification: NSNotification){
        print(notification.userInfo ?? "")
        
        if let phnDict = notification.userInfo as NSDictionary?{
            
            let countryCode = phnDict["countryCode"] as! String
            let phnNumber = phnDict["phoneNumber"] as! String
            
            self.phoneNumber =  countryCode + " " + phnNumber
            self.phoneTextField.text  = phoneNumber
            self.phoneNumberButtonOutlet.titleLabel?.textColor = UIColor(red: 47/255, green: 44/255, blue: 61/255, alpha: 1)
        }
        
    }
    
    //*********************************************************
    // MARK:-- UITEXTFIELD DELEGATES
    //*********************************************************
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch (textField.tag) {
        case 0:
            textField.resignFirstResponder()
            lastNameTextField.becomeFirstResponder()
            break;
        case 1:
            textField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
            break;
        case 2:
            textField.resignFirstResponder()
            passwordTextfield.becomeFirstResponder()
            break;
        case 3:
             self.phoneNumberButtonPressed(phoneNumberButtonOutlet)
//            textField.resignFirstResponder()
//            phoneTextField.becomeFirstResponder()
            break;
        case 4:
           
//            textField.resignFirstResponder()
//            dobTextField.becomeFirstResponder()
            break;
        case 5:
            textField.resignFirstResponder()
            streetAddressTextField.becomeFirstResponder()
            break;
        case 6:
            textField.resignFirstResponder()
            stateTextField.becomeFirstResponder()
            break;
        case 7:
            textField.resignFirstResponder()
            cityTextField.becomeFirstResponder()
            break;
        case 8:
            textField.resignFirstResponder()
            zipCodeTextField.becomeFirstResponder()
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
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == dobTextField{
            let datePickerVC = self.storyboard?.instantiateViewController(withIdentifier: "DatePickerViewController") as! DatePickerViewController
            datePickerVC.modalPresentationStyle = .overFullScreen
            datePickerVC.dateSelectedDelegate = self
            self.present(datePickerVC, animated: true, completion: nil)
            return false
        }
        if textField == streetAddressTextField{
            let autocompleteController = GMSAutocompleteViewController()
                  autocompleteController.delegate = self
                    
                    // Specify the place data types to return.
                    let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                        UInt(GMSPlaceField.placeID.rawValue) | (GMSPlaceField.coordinate.rawValue)  |
                                                                (GMSPlaceField.formattedAddress.rawValue) )
                    autocompleteController.placeFields = fields
                    autocompleteController.modalTransitionStyle = .crossDissolve
                    // Display the autocomplete view controller.
                    present(autocompleteController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            return true
    }
        
    
    //MARK: - Hide Keyboard
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
}
extension SignUpStep1VC: DateSelectedDelegate{
    func selectedDate(_ dateString: Date) {
        

        finalDate = dateString.stringDateWitHFormat("yyyy/MM/dd")
        self.dobTextField.text = dateString.stringDateWitHFormat("MM/dd/yyyy")
    }
}


extension SignUpStep1VC: GMSAutocompleteViewControllerDelegate{
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
   
        helperLat      =    place.coordinate.latitude
        helperLong     =    place.coordinate.longitude
        streetAddressTextField.text = place.formattedAddress!
        print(place)
        
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(place.formattedAddress!) { (placemarks, error) in
            if((error) != nil){
                print("Error", error ?? "")
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                print("Lat: \(coordinates.latitude) -- Long: \(coordinates.longitude)")
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                  
                    print(pm.locality,pm.subLocality,pm.name)
                    
                    self.stateTextField.text = pm.administrativeArea
                    self.cityTextField.text = pm.locality
                    self.zipCodeTextField.text = pm.postalCode
              
                    
                    if pm.locality == nil || pm.administrativeArea == nil || pm.country  == nil{
                    }
                    else
                    {
                    }
                }
            }
            else{
            }
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
