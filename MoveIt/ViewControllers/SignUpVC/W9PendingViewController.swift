//
//  W9PendingViewController.swift
//  MoveIt
//
//  Created by Dilip Saket on 07/01/22.
//  Copyright © 2022 Jyoti. All rights reserved.
//

import UIKit

protocol W9PendingViewControllerDelegate {
    func resubmitRejectedForm()
}

class W9PendingViewController: UIViewController {

    var delegate:W9PendingViewControllerDelegate?
    
    var isFromProfile:Bool = false
    var isReject:Bool = false
    var isReminder:Bool = false
    var message:String = ""
    
    @IBOutlet weak var pendingTitle: UILabel!
    @IBOutlet weak var pendingMessage: UILabel!
    @IBOutlet weak var pendingNote: UILabel!
    @IBOutlet weak var btnResubmit: UIButton!
    
    let termsAndCondition =  appDelegate.baseContentURL + "terms-conditions-mobile"
    let privacyPolicy =   appDelegate.baseContentURL + "privacy-policy-mobile"
    let faq =    appDelegate.baseContentURL + "faq-mobile"
    let proFAQ =  appDelegate.baseContentURL + "faq-pro-muscles-mobile"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationTitle("W-9 form")

        let leftBarButtonItem = StaticHelper.leftBarButtonWithImageNamed(imageName: "backward_arrow_icon", vc: self)
        self.navigationItem.leftBarButtonItems = [leftBarButtonItem]
        
        NotificationCenter.default.addObserver(self, selector: #selector(formW9VerifiedAction), name: NSNotification.Name(rawValue: "W9_FORM_ACCEPT"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(formW9VerifiedReject), name: NSNotification.Name(rawValue: "W9_FORM_REJECT"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getHelperW9FormDetailAPICall), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        btnResubmit.isHidden = true
        
        if(isReject == true) {
            pendingTitle.text = "W-9 form Rejected"
            pendingMessage.text = message
            pendingNote.text = ""
            btnResubmit.isHidden = false
        }        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if(self.isFromProfile == true) {
            self.navigationController?.isNavigationBarHidden = false
        } else {
            self.navigationController?.isNavigationBarHidden = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.isNavigationBarHidden = false
    }
        
    @objc func leftButtonPressed(_ selector: Any){
       
       
        var isPopped:Bool = false
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: ProfileViewController.self) {
                isPopped = true
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
        
        if isReminder{
            DispatchQueue.main.async {
                appDelegate.gotoHomeVC()
            }
        }else if(isPopped == false) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func formW9VerifiedAction() {
        DispatchQueue.main.async {
            appDelegate.gotoHomeVC()
        }
        
//        NotificationCenter.default.removeObserver(self, forKeyPath: "W9_FORM_ACCEPT")
//        NotificationCenter.default.removeObserver(self, forKeyPath: "W9_FORM_REJECT")
    }
    
    @objc func formW9VerifiedReject() {
        btnResubmit.isHidden = true
//        if(isReject == true) {
            pendingTitle.text = "W-9 form Rejected"
            pendingMessage.text = message
            pendingNote.text = ""
            btnResubmit.isHidden = false
        //}/
//        NotificationCenter.default.removeObserver(<#T##Any#>)
//        NotificationCenter.default.removeObserver(self, forKeyPath: "W9_FORM_ACCEPT")
//        NotificationCenter.default.removeObserver(self, forKeyPath: "W9_FORM_REJECT")
    }
    
    //MARK: - API
    
    @objc func getHelperW9FormDetailAPICall() {
        
        StaticHelper.shared.startLoader(self.view)

        CommonAPIHelper.getHelperW9FormDetailAPICall(VC: self, completetionBlock: { (result, error, isexecuted) in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                StaticHelper.shared.stopLoader()
                
                if error != nil {
                    
                    return
                } else {
                    print("result = ", result)
                    let is_verified = result?["is_verified"] as? Int ?? 0
                    
                    if(is_verified == 1) {//Approve
                        appDelegate.gotoHomeVC()
                    } else if(is_verified == 2) {//Reject
                        self.formW9VerifiedReject()
                    }

                    return
                }
            }
        })
    }

    //MARK: - Actions
    @IBAction func btnResubmitPressed(_ sender: Any) {
        self.delegate?.resubmitRejectedForm()
        self.navigationController?.popViewController(animated: true)
        
    }

    @IBAction func termButtonPressed(_ sender: Any) {
         let distanceVC = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
         distanceVC.titleString = "Terms and conditions"
         distanceVC.urlString = self.termsAndCondition
         self.navigationController?.pushViewController(distanceVC, animated: true)
    }
    
    @IBAction func privacyButtonPressed(_ sender: Any) {
        let distanceVC = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        distanceVC.titleString = "Privacy Policy"
        distanceVC.urlString = self.privacyPolicy
        self.navigationController?.pushViewController(distanceVC, animated: true)
        
    }
    @IBAction func proMuscleAction(_ sender: Any) {
        let distanceVC = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        distanceVC.titleString = "Move It Pro & Muscle FAQs"
        distanceVC.urlString = proFAQ
        self.navigationController?.pushViewController(distanceVC, animated: true)
    }
    
    func gotoFormW9VC() {
        let formW9VC = W9FormViewController()
        self.navigationController?.pushViewController(formW9VC, animated: true)
    }
    
    
}
