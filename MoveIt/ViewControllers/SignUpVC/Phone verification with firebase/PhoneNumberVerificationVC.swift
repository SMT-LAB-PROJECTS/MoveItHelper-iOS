//
//  PhoneNumberVerificationVC.swift
//  MoveIt
//
//  Created by Manya Garg on 13/11/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import FirebaseAuth
import MBProgressHUD
import CountryPickerView

class PhoneNumberVerificationVC: UIViewController, UITextFieldDelegate ,CountryPickerViewDelegate
, CountryPickerViewDataSource, AuthUIDelegate{

    //MARK: - properties
    @IBOutlet weak var headerView: UIView!
    @IBOutlet var lblPhone: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var countryCodeTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var phoneNumberTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var codeButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var countryView: UIView!
    @IBOutlet weak var lineView: UIView!
    
    var numberDict = [String:String]()
    var counter = 30
    let cpv = CountryPickerView(frame: CGRect(x: 0, y: 0, width: 60 * screenWidthFactor , height: 20 * screenHeightFactor))
    var dailCode = String()
    var isEdit = false
    
    //MARK: - override method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
       self.navigationController?.isNavigationBarHidden = true
        
        cpv.showCountryCodeInView = false
        cpv.delegate = self
        countryView.addSubview(cpv)
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let flexibleSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard1(_:)))
        toolBar.setItems([flexibleSpace,doneButton], animated: false)
        phoneNumberTxtField.inputAccessoryView = toolBar
        
      
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.navigationController?.isNavigationBarHidden = true
       
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
         cpv.countryDetailsLabel.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
         cpv.countryDetailsLabel.textAlignment = .justified
        }
    func setUpUI(){

      lblPhone.font = UIFont.josefinSansRegularFontWithSize(size: 14.0)
    
      phoneNumberTxtField.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
      codeButton.titleLabel?.font =  UIFont.josefinSansRegularFontWithSize(size: 12.0)
      mainView.layer.cornerRadius = 8.0
      
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        lineView.backgroundColor = UIColor(red: 246.0/255, green: 174.0/255, blue: 184.0/255, alpha: 1.0)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        lineView.backgroundColor = UIColor(red: 152.0/255, green: 151.0/255, blue: 157.0/255, alpha: 1.0)
    }
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        
        dailCode = country.phoneCode
    }
    
    @objc func dismissKeyboard1(_ sender: UITextField){
        self.view.endEditing(true)
    }
    
    //MARK: - button actions
    
    @IBAction func codeButtonClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if (phoneNumberTxtField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count)! < 1 {
            self.view.makeToast("Please enter a valid Phone Number.")
        }
        else{
            let phoneNum = (cpv.countryDetailsLabel.text!) + String(phoneNumberTxtField.text!)
            self.dailCode = (cpv.countryDetailsLabel.text!)
            
            StaticHelper.shared.startLoader(self.view)
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNum, uiDelegate: nil) { (verificationID, error) in
                if let err = error{
                    StaticHelper.shared.stopLoader()
                    self.view.makeToast(err.localizedDescription)
                    print(err)
                    return
                }
                else{
                    StaticHelper.shared.stopLoader()
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyOTPForPhoneNumberVC")as! VerifyOTPForPhoneNumberVC
                    self.numberDict["verificationID"] = verificationID ?? ""
                    self.numberDict["countryCode"] = self.dailCode
                    self.numberDict["phoneNumber"] = self.phoneNumberTxtField.text
                    vc.isEdit = self.isEdit
                    vc.numberDict = self.numberDict
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                // UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            }
        }
    }
    
    @IBAction func backBttonClicked(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
