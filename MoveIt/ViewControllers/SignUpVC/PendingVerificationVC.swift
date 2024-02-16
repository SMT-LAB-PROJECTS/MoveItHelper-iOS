//
//  PendingVerificationVC.swift
//  MoveIt
//
//  Created by Jyoti on 24/04/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class PendingVerificationVC: UIViewController {
        
    @IBOutlet weak var pendingVerifyLabel: UILabel!
    @IBOutlet weak var registrationLabel: UILabel!
    @IBOutlet weak var notifyLabel: UILabel!
    @IBOutlet weak var termButtonOutlet: UIButton!
    @IBOutlet weak var privacyButtonOutlet: UIButton!
    
    @IBOutlet weak var proMuscleFAQ: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    
    let termsAndCondition =  appDelegate.baseContentURL + "terms-conditions-mobile"
    let privacyPolicy =   appDelegate.baseContentURL + "privacy-policy-mobile"
    let faq =    appDelegate.baseContentURL + "faq-mobile"
    let proFAQ =  appDelegate.baseContentURL + "faq-pro-muscles-mobile"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnSignUp.isHidden = true
        
        self.uiConfigurationAfterStoryboard()
        self.setUIParameters()
        self.getProfileInfo()
        
        NotificationCenter.default.addObserver(self, selector: #selector(profileVerifiedByAdmin), name: NSNotification.Name(rawValue: "profileVerifiedByAdmin"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(profileRejectedByAdmin), name: NSNotification.Name(rawValue: "ACCOUNT_REJECTED"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getProfileInfo), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }

    //MARK: - NotificationCenter
    @objc func profileVerifiedByAdmin() {
        self.getProfileInfo()
    }

    @objc func profileRejectedByAdmin() {
        self.getHelperRejectionMessage()
    }

    func uiConfigurationAfterStoryboard(){
        
        self.navigationController?.isNavigationBarHidden = true
        pendingVerifyLabel.font = UIFont.josefinSansBoldFontWithSize(size: 18.0)
        registrationLabel.font = UIFont.josefinSansRegularFontWithSize(size: 14.0)
        notifyLabel.font = UIFont.josefinSansRegularFontWithSize(size: 14.0)
        privacyButtonOutlet.titleLabel?.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        proMuscleFAQ.titleLabel?.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        termButtonOutlet.titleLabel?.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
    }
    
    func setUIParameters() {
        if UserCache.shared.userInfo(forKey: kUserCache.is_verified) as! Int == 2 {
            pendingVerifyLabel.text = "Application Rejected"
            registrationLabel.text = "Your application has been rejected\nfor few reasons. Please check your email for more info."
            notifyLabel.isHidden = true
        }
    }
    
    //MARK: - APIs
    @objc func getProfileInfo(){
        
        StaticHelper.shared.startLoader(self.view)
        CommonAPIHelper.getProfile(VC: self) { (res, err, isExecuted) in
            
            DispatchQueue.main.async {
                if isExecuted{
                  profileInfo =  HelperDetailsModel.init(profileDict: res!)
                  if profileInfo!.is_verified! == 0 {
                    StaticHelper.shared.stopLoader()
                  } else if profileInfo!.is_verified! == 1 {
                      NotificationCenter.default.removeObserver(self)
                      UserCache.shared.updateUserProperty(forKey: kUserCache.is_verified, withValue: 1 as AnyObject)
                      StaticHelper.shared.stopLoader()
                      self.gotoFormW9VC()
                  } else {
                    UserCache.shared.updateUserProperty(forKey: kUserCache.is_verified, withValue: 2 as AnyObject)
                    StaticHelper.shared.stopLoader()
                      
                      self.setUIParameters()
                      self.getHelperRejectionMessage()
                  }
                }
            }
        }
    }
    
    func getHelperRejectionMessage(){
        
        StaticHelper.shared.startLoader(self.view)
        CommonAPIHelper.getHelperRejectionMessage(VC: self) { (res, err, isExecuted) in
            
            DispatchQueue.main.async {
                StaticHelper.shared.stopLoader()
                if isExecuted {
                    self.btnSignUp.isHidden = false
                    self.pendingVerifyLabel.text = "Application Rejected"
                    let message:String = res?["message"] as? String ?? "Your application has been rejected\nfor few reasons. Please check your email for more info."
                    self.registrationLabel.text = message
                }
            }
        }
    }

    //MARK: - Actions
    @IBAction func btnSignupPressed(_ sender: Any) {
        let chooseHelperObj = self.storyboard?.instantiateViewController(withIdentifier: "ChooseHelperOrProsVC") as! ChooseHelperOrProsVC
        self.navigationController?.pushViewController(chooseHelperObj, animated: true)
    }

    @IBAction func termButtonPressed(_ sender: Any) {
        
            if let url = URL(string: "\(self.termsAndCondition)") {
                UIApplication.shared.open(url)
            }
//         let distanceVC = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
//         distanceVC.titleString = "Terms and conditions"
//         distanceVC.urlString = self.termsAndCondition
//         self.navigationController?.pushViewController(distanceVC, animated: true)
    }
    
    @IBAction func privacyButtonPressed(_ sender: Any) {
        
            if let url = URL(string: "\(self.privacyPolicy)") {
                UIApplication.shared.open(url)
            }
//        let distanceVC = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
//        distanceVC.titleString = "Privacy Policy"
//        distanceVC.urlString = self.privacyPolicy
//        self.navigationController?.pushViewController(distanceVC, animated: true)
        
    }
    @IBAction func proMuscleAction(_ sender: Any) {
        
            if let url = URL(string: "\(proFAQ)") {
                UIApplication.shared.open(url)
            }
//        let distanceVC = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
//        distanceVC.titleString = "Move It Pro & Muscle FAQs"
//        distanceVC.urlString = proFAQ
//        self.navigationController?.pushViewController(distanceVC, animated: true)
    }
    
    func gotoFormW9VC() {
        let formW9VC = W9FormViewController()
        self.navigationController?.pushViewController(formW9VC, animated: true)
    }
}
