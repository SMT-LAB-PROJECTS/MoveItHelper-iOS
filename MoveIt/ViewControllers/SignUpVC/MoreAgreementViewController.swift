//
//  MoreAgreementViewController.swift
//  MoveIt
//
//  Created by RV on 09/07/21.
//  Copyright © 2021 Jyoti. All rights reserved.
//

import UIKit
import WebKit

protocol MoreAgreementPopUpDelegate {
    func selectedItems(_ index: Int)
}

class MoreAgreementViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var webViewSig: WKWebView!
    
    let agreementList = ["This Arbitration Provision is the full and complete agreement relating to the formal resolution of disputes arising out of this Agreement. Except as stated in subsection v, above, in the event any portion of this Arbitration Provision is deemed unenforceable, the remainder of this Arbitration Provision will be enforceable.","By checking, You fully understand you are an independent enterprise which is required to maintain your own insurance and are not eligible for workers compensation benefits.","By checking, You expressly acknowledge You are liable for any damage to a person’s property and not limited to items being picked up, delivered, moved, transported to any destination.","By checking, You expressly acknowledge Move It is not your employer. You acknowledge You are economically independent from Move It.","By checking, You expressly acknowledge that You have read, understood, and taken steps to thoughtfully consider the consequences of this Agreement, that You agree to be bound by the terms and conditions of the Agreement, and that You are legally competent to enter into this Agreement with Company."]
    
    var agreementDelegate: MoreAgreementPopUpDelegate?
    
    var selectedIndex : [Int] = []
    
    var tableViewHeight: CGFloat {
        tableView.reloadData()
        tableView.layoutIfNeeded()
        return tableView.contentSize.height
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setPopViewDesign()
        if let viewControllers = self.navigationController?.viewControllers {
            if(viewControllers.count > 1) {
                let leftBarButtonItem = StaticHelper.leftBarButtonWithImageNamed(imageName: "backward_arrow_icon", vc: self)
                self.navigationItem.leftBarButtonItems = [leftBarButtonItem]
            }
        }
    }
    @objc func leftButtonPressed(_ selector: Any){
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
//        tableviewHeightConst.constant = tableViewHeight
    }
    
    @IBAction func backTouched(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    func setPopViewDesign(){
        
        self.view.backgroundColor = .white
        backView.backgroundColor = .white
        backView.layer.cornerRadius = 12
        backView.isUserInteractionEnabled = true
        tableView.isUserInteractionEnabled = true
        
    }
    
    @IBAction func agreeAction(_ sender: Any) {
        if selectedIndex.count != agreementList.count{
            self.view.makeToast("Please agree to background check.")
            return
        }
        self.showDigitalSignaturePad()
        //self.agreementAndSignatureCompleted()
    }
    
    func showDigitalSignaturePad() {
        let helper_auth_key =  String(UserCache.shared.userInfo(forKey: kUserCache.auth_key)  as? String ?? "")

        if(helper_auth_key != "") {
            let strURL = appDelegate.baseContentURL + kAPIMethods.signature_pad + helper_auth_key
//            let strURL = "https://dev.gomoveit.com/signature-pad/6c4ac2f659ac8170e11f1625ff87ef88"
            webViewSig.isHidden = false
            webViewSig.navigationDelegate = self
            webViewSig.load(URLRequest.init(url: URL.init(string: strURL)!))
            StaticHelper.shared.startLoader(self.view)
        }
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        StaticHelper.shared.stopLoader()
        
        if webView.url?.absoluteString.contains("is_set=1") == true {
            self.agreementAndSignatureCompleted()
        }
    }

    func agreementAndSignatureCompleted() {
        agreementDelegate?.selectedItems(1)
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)

    }
    
}

extension MoreAgreementViewController: UITableViewDelegate,UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return agreementList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let popUpCell = tableView.dequeueReusableCell(withIdentifier: "MoreAgreementCell", for: indexPath) as! MoreAgreementCell
        popUpCell.agreementTextLabel.text = agreementList[indexPath.row]
        popUpCell.wholeCellButton.setTitle("", for: .normal)
        popUpCell.agreementTextLabel.font = UIFont.josefinSansRegularFontWithSize(size: 13.0)

        popUpCell.actionHendler = {
            if popUpCell.checkButton.isSelected {
                popUpCell.checkButton.isSelected = false
                for (i,item) in self.selectedIndex.enumerated() {
                    if item == indexPath.row {
                        self.selectedIndex.remove(at: i)
                        break
                    }
                }
            } else{
                popUpCell.checkButton.isSelected = true
                self.selectedIndex.append(indexPath.row)
            }
        }
        return popUpCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let indvMessage = agreementList[indexPath.row]
        let height = (indvMessage).height(withConstrainedHeight: CGFloat(tableView.bounds.width-50), font: UIFont.josefinSansRegularFontWithSize(size: 13))
        if height < 20.0 {
            return 55.0 //* screenHeightFactor
        } else{
            return height //* screenHeightFactor
        }
    }
}
