//
//  PaymentViewController.swift
//  MoveIt
//
//  Created by Dushyant on 13/09/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit
import SafariServices


extension Notification.Name {
    static let braintreeConnectedRedirectNotification = Notification.Name(rawValue: "braintreeConnectedRedirectNotification")
}

class PaymentViewController: UIViewController,SFSafariViewControllerDelegate {
    
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var noPaymentLabel: UILabel!
    @IBOutlet weak var shortDescLabel: UILabel!
    
    var safariVC: SFSafariViewController?
    var urlString = String()
    
    @IBOutlet weak var paymentTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle("Payment Info")
        
        NotificationCenter.default.addObserver(self, selector: #selector(braintreeLogin(notification:)), name: .braintreeConnectedRedirectNotification, object: nil)
        noPaymentLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 15.0)
        shortDescLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        connectButton.titleLabel?.font = UIFont.josefinSansRegularFontWithSize(size: 14.0)
        
//        let leftBarButtonItem = StaticHelper.leftBarButtonWithImageNamed(imageName: "backward_arrow_icon", vc: self)
        let leftBarButtonItem = StaticHelper.leftBarButtonWithImageNamed(imageName: "backward_arrow_icon", vc: self)
        self.navigationItem.leftBarButtonItems = [leftBarButtonItem]

        
        if ((profileInfo?.is_payment_method_added) == 1){
            noPaymentLabel.text = "Edit Payment Info"
            connectButton.setTitle("Edit", for: .normal)
            shortDescLabel.text = "Move It uses Zelle to directly deposit your weekly earnings. You can edit your Zelle info anytime."
            self.paymentTextField.isUserInteractionEnabled = false
            self.paymentTextField.text = (profileInfo?.paypal_merchant_id)
        }
        else{
            noPaymentLabel.text = "Add Payment Info"
            connectButton.setTitle("Add", for: .normal)
            shortDescLabel.text = "Move It uses Zelle to directly deposit your weekly earnings. Add your Zelle ID below to receive you earning in your Zelle account."
            self.paymentTextField.isUserInteractionEnabled = true
        }
        
      
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProfileInfo()
    }
    
    func getProfileInfo(){
           StaticHelper.shared.startLoader(self.view)
           CommonAPIHelper.getProfile(VC: self) { (res, err, isExecuted) in
               if isExecuted{
                 profileInfo =  HelperDetailsModel.init(profileDict: res!)
                 if profileInfo!.is_verified! == 1{

                   StaticHelper.shared.stopLoader()
                       if ((profileInfo?.is_payment_method_added) == 1){
                           self.noPaymentLabel.text = "Edit Payment Info"
                           self.connectButton.setTitle("Edit", for: .normal)
                           self.shortDescLabel.text = "Move It uses Zelle to directly deposit your weekly earnings. You can edit your Zelle info anytime."
                           self.paymentTextField.isUserInteractionEnabled = false
                       }
                       else{
                           self.noPaymentLabel.text = "Add Payment Info"
                           self.connectButton.setTitle("Add", for: .normal)
                           self.shortDescLabel.text = "Move It uses Zelle to directly deposit your weekly earnings. Add your Zelle ID below to receive your earnings in your Zelle account."
                           self.paymentTextField.isUserInteractionEnabled = true
                       }
                 }
               }
           }
       }
    
    @objc func leftButtonPressed(_ selector: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func braintreeLogin(notification: NSNotification) {
        self.safariVC?.dismiss(animated: true, completion: nil)
        // perform any additional actions like transitioning to another view here
    }
    
    @IBAction func connectAction(sender: UIButton) {
        if sender.titleLabel?.text == "Edit"{
            DispatchQueue.main.async {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.paymentTextField.becomeFirstResponder()
                }

                
                self.paymentTextField.isUserInteractionEnabled = true
                self.connectButton.setTitle("Save", for: .normal)
            }
        } else {
            self.view.endEditing(true)
            if (paymentTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!{
                self.view.makeToast("Please enter valid email id.")
                return
            }
            savePaymentInfo()
        }
    }

    func savePaymentInfo(){
        
        let paypalID = paymentTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        callAnalyticsEvent(eventName: "moveit_edit_payment_info", desc: ["description":"Event when \(profileInfo?.helper_id ?? 0) Changed Payment Info"])
        CommonAPIHelper.savePaypalInfo(VC: self, params: ["paypal_id": paypalID]) { (res, err, isExe) in
            if isExe{
                
                    UserCache.shared.updateUserProperty(forKey: kUserCache.paypal_merchant_id, withValue: paypalID as AnyObject)
                    UserCache.shared.updateUserProperty(forKey: kUserCache.is_payment_method_added, withValue: 1 as AnyObject)
                    profileInfo?.paypal_merchant_id = paypalID
                    self.view.makeToast("Payment info updated successfully.")
                    self.paymentTextField.isUserInteractionEnabled = false
                    self.connectButton.setTitle("Edit", for: .normal)
            }
        }
    }
    
    
}
