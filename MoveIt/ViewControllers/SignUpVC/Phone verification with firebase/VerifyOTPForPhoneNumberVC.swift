//
//  VerifyOTPForPhoneNumberVC.swift
//  MoveIt
//
//  Created by Manya Garg on 13/11/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVPinView
//protocol verifiedPhoneNumber {
//    func passPhoneNumber(countryCode: String , phoneNumber: String)
//}
class VerifyOTPForPhoneNumberVC: UIViewController , UITextFieldDelegate , AuthUIDelegate{

    //MARK: - properties
    @IBOutlet weak var tblView1: UITableView!
    @IBOutlet weak var insideView: UIView!
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var phnNumber: UILabel!
    @IBOutlet weak var editPhoneNum: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var firstCodeTxtField: UITextField!
    
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var secondCodeTxtField: UITextField!
    
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var thirdCodeTxtField: UITextField!
    
    @IBOutlet weak var fourthView: UIView!
    @IBOutlet weak var fourthCodeTxtField: UITextField!
    
    @IBOutlet weak var fifthView: UIView!
    @IBOutlet weak var fifthCodeTxtField: UITextField!
    
    @IBOutlet weak var sixthView: UIView!
    @IBOutlet weak var sixthCodeTxtField: UITextField!
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var getCodeButton: UIButton!
    @IBOutlet weak var resendCodeLbl: UILabel!
    
    @IBOutlet weak var tfOtp: SVPinView!
    
    var strPinValue = ""
    var numberDict = [String:String]()
    var resendCode = false
    var reverificationID = String()
    
    var counter = 60
    var isEdit = false
    var alertView :AlertPopupView?

  //  var firebaseVerification : verifiedPhoneNumber?
    
    //MARK: - override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        insideView.frame.size.height = 568 * screenHeightFactor
        
        setUpUI()
        self.navigationController?.isNavigationBarHidden = true
      
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        
       
        let phonenum =  numberDict["countryCode"]! + numberDict["phoneNumber"]!
        phnNumber.text = phonenum
        
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let flexibleSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard1(_:)))
        toolBar.setItems([flexibleSpace,doneButton], animated: false)
        firstCodeTxtField.inputAccessoryView = toolBar
        secondCodeTxtField.inputAccessoryView = toolBar
        thirdCodeTxtField.inputAccessoryView = toolBar
        fourthCodeTxtField.inputAccessoryView = toolBar
        fifthCodeTxtField.inputAccessoryView = toolBar
        sixthCodeTxtField.inputAccessoryView = toolBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.navigationController?.isNavigationBarHidden = true
        setUPOTPFieldView()

    }
    
    func setUpUI(){
        firstCodeTxtField.font = UIFont.josefinSansRegularFontWithSize(size: 20.0)
        secondCodeTxtField.font = UIFont.josefinSansRegularFontWithSize(size: 20.0)
        thirdCodeTxtField.font = UIFont.josefinSansRegularFontWithSize(size: 20.0)
        fourthCodeTxtField.font = UIFont.josefinSansRegularFontWithSize(size: 20.0)
        fifthCodeTxtField.font = UIFont.josefinSansRegularFontWithSize(size: 20.0)
        sixthCodeTxtField.font = UIFont.josefinSansRegularFontWithSize(size: 20.0)
        
         headingLbl.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
         phnNumber.font = UIFont.josefinSansSemiBoldFontWithSize(size: 17.0)
         continueButton.titleLabel?.font = UIFont.josefinSansRegularFontWithSize(size: 14.0)
         getCodeButton.titleLabel?.font = UIFont.josefinSansRegularFontWithSize(size: 14.0)
         resendCodeLbl.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        
        firstView.layer.cornerRadius = 5.0
        secondView.layer.cornerRadius = 5.0
        thirdView.layer.cornerRadius = 5.0
        fourthView.layer.cornerRadius = 5.0
        fifthView.layer.cornerRadius = 5.0
        sixthView.layer.cornerRadius = 5.0
    }
    
    @objc func dismissKeyboard1(_ sender: UITextField){
        self.view.endEditing(true)
    }
   @objc func update(){
        if counter > 0 {
            getCodeButton.isHidden = true
            resendCodeLbl.text = "Resend Code in \(counter) seconds"
        }
        else{
            resendCodeLbl.isHidden = true
            getCodeButton.isHidden = false
        }
    counter -= 1
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text
        guard let stringRange  = Range(range, in: currentText!) else{
            return false
        }
        let updatedString = currentText!.replacingCharacters(in: stringRange, with: string)
        print(updatedString)
        
    
        if string.count > 0{
            
            switch textField{
            case firstCodeTxtField:
                firstCodeTxtField.text = string
                secondCodeTxtField.becomeFirstResponder()
            case secondCodeTxtField:
                secondCodeTxtField.text = string
                thirdCodeTxtField.becomeFirstResponder()
            case thirdCodeTxtField:
                thirdCodeTxtField.text = string
                fourthCodeTxtField.becomeFirstResponder()
            case fourthCodeTxtField:
                fourthCodeTxtField.text = string
                fifthCodeTxtField.becomeFirstResponder()
            case fifthCodeTxtField:
                fifthCodeTxtField.text = string
                sixthCodeTxtField.becomeFirstResponder()
            case sixthCodeTxtField:
                sixthCodeTxtField.text = string
                sixthCodeTxtField.resignFirstResponder()
            default:
                break
            }
           
            return false
        }
      
             if textField.text?.count == 0 && string.count  == 0{
                switch textField{
                case firstCodeTxtField:
                    firstCodeTxtField.text = string
                    firstCodeTxtField.becomeFirstResponder()
                case secondCodeTxtField:
                    secondCodeTxtField.text = string
                    firstCodeTxtField.becomeFirstResponder()
                case thirdCodeTxtField:
                    thirdCodeTxtField.text = string
                    secondCodeTxtField.becomeFirstResponder()
                case fourthCodeTxtField:
                    fourthCodeTxtField.text = string
                    thirdCodeTxtField.becomeFirstResponder()
                case fifthCodeTxtField:
                    fifthCodeTxtField.text = string
                    fourthCodeTxtField.becomeFirstResponder()
                case sixthCodeTxtField:
                    sixthCodeTxtField.text = string
                    fifthCodeTxtField.becomeFirstResponder()
                default:
                    break
                }
                return false
            }
                else if textField.text!.count >= 1 && string.count == 0{
                    textField.text = string
                    return false
            }
           
        else{
            return false
        }
    }
    
    func verifyedNumberByFireBase(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "phoneNumberNotifier"), object: nil, userInfo: self.numberDict)
        if (self.isEdit) {
            let phonenum =  self.numberDict["countryCode"]! + " " + self.numberDict["phoneNumber"]!
            profileInfo?.phone_num! = phonenum
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadProfileView"), object: nil)
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: ProfileViewController.self) {
                    _ =  self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        } else{
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: SignUpStep1VC.self) {
                    _ =  self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        }
    }
    //MARK: - button actions
    @IBAction func editNumButtonClicked(_ sender: UIButton) {

        self.navigationController?.popViewController(animated: true)
    }
  
    
    @IBAction func continueButtonClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        
    //    let verificationID  = UserDefaults.standard.string(forKey: "authVerificationID")
     
//        let code = "\(firstCodeTxtField.text!)\(secondCodeTxtField.text!)\(thirdCodeTxtField.text!)\(fourthCodeTxtField.text!)\(fifthCodeTxtField.text!)\(sixthCodeTxtField.text!)"
        if strPinValue == ""{
            self.view.makeToast("Plesae enter OTP.")
        }else if strPinValue.trimmingCharacters(in: .whitespacesAndNewlines).count != 6 {
            self.view.makeToast("Invalid code!!")
        }
        else{
            if resendCode {
                numberDict["verificationID"] = reverificationID
            }
            StaticHelper.shared.startLoader(self.view)

            let credential = PhoneAuthProvider.provider().credential(withVerificationID: numberDict["verificationID"] ?? "" , verificationCode: strPinValue)
            
            Auth.auth().signIn(with: credential) { (authDataResult, error) in
                StaticHelper.shared.stopLoader()

                if let err = error{
                    print(err.localizedDescription)
                    self.view.makeToast(err.localizedDescription)
                    return
                }
                else{
//                    self.view.makeToast("phone number is verified successfully!!")
                    self.showAlertPopupView(kStringPermission.mobileVerification, kStringPermission.mobileVerificationMessage, "", "", AlertButtonTitle.ok)

                }
            }
        }
    }
  
    @IBAction func backButtonClicked(_ sender: UIButton) {
         self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func getCodeButtonClicked(_ sender: UIButton) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phnNumber.text!, uiDelegate: nil) { (verificationID, error) in
            if let err = error{
                StaticHelper.shared.stopLoader()
                self.view.makeToast(err.localizedDescription)
                print(err)
                return
            }
            else{
                self.reverificationID = verificationID!
                self.resendCode = true
                StaticHelper.shared.stopLoader()
                _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)

            }
            // UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
        }
    }
    
}

// MARK: - Confirimation popup method's....
extension VerifyOTPForPhoneNumberVC{
    //Alert...
    func showAlertPopupView(_ popUpTitleMsg:String = "", _ message:String,  _ cancelButtonTitle:String = "",  _ okButtonTitle:String = "", _ centerOkButtonTitle:String = ""){
        self.view.endEditing(true)
        AlertPopupView.instance.shwoDataWithClosures(popUpTitleMsg, message, cancelButtonTitle, okButtonTitle, centerOkButtonTitle){ status in
            if status{
                print("Okay")
                self.verifyedNumberByFireBase()
            }else{
                print("NO/Cancel")
            }
        }
    }
}
extension VerifyOTPForPhoneNumberVC{
    func setUPOTPFieldView(){
        
        tfOtp.pinLength = 6
        tfOtp.secureCharacter = ""//"\u{25CF}"
        tfOtp.interSpace = 8
        tfOtp.textColor = UIColor.darkGray
        tfOtp.borderLineColor = greyplaceholderColor
        tfOtp.activeBorderLineColor = greyplaceholderColor
        tfOtp.borderLineThickness = 1
        tfOtp.shouldSecureText = false
        tfOtp.allowsWhitespaces = false
        tfOtp.placeholder = TextString.otpPlaceholder//"******"
        tfOtp.tintColor = UIColor.darkGray
        tfOtp.deleteButtonAction = .deleteCurrentAndMoveToPrevious
        tfOtp.keyboardAppearance = .default
        tfOtp.becomeFirstResponderAtIndex = -1
        tfOtp.shouldDismissKeyboardOnEmptyFirstField = false
        tfOtp.font = UIFont.josefinSansSemiBoldFontWithSize(size: 22)
        tfOtp.keyboardType = .phonePad
        tfOtp.activeBorderLineThickness = 1
        tfOtp.fieldCornerRadius = 8
        tfOtp.activeFieldCornerRadius = 8
        tfOtp.style = .box
        tfOtp.fieldBackgroundColor = otpFiledBgColor
        tfOtp.activeFieldBackgroundColor = otpFiledBgColor
        tfOtp.didFinishCallback = didFinishEnteringPin(pin:)
        tfOtp.didChangeCallback = { pin in
            print("\(pin)")//The entered pin is
            self.strPinValue = ""
        }
    }
    func didFinishEnteringPin(pin:String) {
        //showAlert(title: "Success", message: "The Pin entered is \(pin)")
        print(pin)
        self.strPinValue = pin
    }

}
struct TextString{
    static let goBackText = "Go back"
    static let resendOTP = "Resend OTP"
    static let otpExpireIn = "OTP expire in "
    static let otpExpired = "OTP expired"
    static let forgotPsw = "Forgot password?"
    static let byClickingOnLogin = "By clicking on login, I accept all the"
    static let termsAndConditions = "term and conditions"
    static let otpPlaceholder = "XXXXXX"
    static let secondString = " sec"
    static let versionString = "Version"
    
    
}
