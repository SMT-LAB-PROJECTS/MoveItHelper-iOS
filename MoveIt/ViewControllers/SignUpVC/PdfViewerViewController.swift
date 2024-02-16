//
//  PdfViewerViewController.swift
//  MoveIt
//
//  Created by Dushyant on 22/07/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit
import PDFKit
import WebKit


class PdfViewerViewController: UIViewController,WKUIDelegate, UIScrollViewDelegate, MoreAgreementPopUpDelegate {
    
    @IBOutlet weak var blView: UIView!
    @IBOutlet weak var downloadButton: UIButton!
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var bkView: UIView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var agreeLabel: UILabel!
    
    //More agreement....
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var popUpView: UIView!
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
        setNavigationTitle("Helper Agreement")
        getProfileInfo()
        
        if let viewControllers = self.navigationController?.viewControllers {
            if(viewControllers.count > 1) {
                let leftBarButtonItem = StaticHelper.leftBarButtonWithImageNamed(imageName: "backward_arrow_icon", vc: self)
                self.navigationItem.leftBarButtonItems = [leftBarButtonItem]
            }
        }
                
        agreeLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)

        webView.uiDelegate = self
        
        let urlreq = URLRequest.init(url: URL.init(string: (appDelegate.baseContentURL + "agreement-mobile"))!)
        webView.load(urlreq)

        webView.scrollView.delegate = self

        downloadButton.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 13.0)
        webView.scrollView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 110.0 * screenHeightFactor, right: 0.0)
    }
    
    @objc func leftButtonPressed(_ selector: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    func getProfileInfo(){
        CommonAPIHelper.getProfile(VC: self) { (res, err, isExecuted) in
            if isExecuted{
                profileInfo =  HelperDetailsModel.init(profileDict: res!)
                if let photoURL = profileInfo?.photo_url,!photoURL.isEmpty{
                } else{
                    let uploadPhotoVC = self.storyboard?.instantiateViewController(withIdentifier: "UploadPhotoViewController") as! UploadPhotoViewController
                    uploadPhotoVC.isFromHome = true
                    uploadPhotoVC.modalPresentationStyle = .overFullScreen
                    self.navigationController?.pushViewController(uploadPhotoVC, animated: true)
                }
            }
        }
    }
  
    @IBAction func checkAction(_ sender: Any) {
        if checkButton.isSelected {
            checkButton.isSelected = false
        } else{
             checkButton.isSelected = true
        }
    }
    @IBAction func agreeAction(_ sender: Any) {
        if checkButton.isSelected{
        } else{
            self.view.makeToast("Please agree to background check.")
            return
        }
        setPopViewDesign()
//        let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "MoreAgreementViewController") as! MoreAgreementViewController
//        popupVC.modalPresentationStyle = .overFullScreen
//        popupVC.agreementDelegate = self
//        self.navigationController?.pushViewController(popupVC, animated: true)
//        //self.present(popupVC, animated: true, completion: nil)
    
    }
    
    func selectedItems(_ index: Int) {
        print(#function)
        var params = [String: Any]()
        params = ["is_agree" : 1]
        CommonAPIHelper.saveAgreement(VC: self, params: params) { (res, err, isExecuted) in
            if isExecuted{
                                
                DispatchQueue.main.async {
                    
                    let socialVC = self.storyboard?.instantiateViewController(withIdentifier: "SocialSecurityViewController") as! SocialSecurityViewController
                    self.navigationController?.pushViewController(socialVC, animated: true)
//                    if let vcStep = StaticHelper.getViewControllerWithID("SocialSecurityViewController") {
//                        self.navigationController?.pushViewController(socialVC, animated: true)
//                    }
                }
            }
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
 
    }
}
extension PdfViewerViewController:WKNavigationDelegate{
    func showAnimate(){
        self.view.bringSubviewToFront(self.backView)
        UIView.transition(with: self.backView, duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.backView.alpha = 1.0
                            self.backView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                      })
    }
    func removeAnimate(){
        UIView.animate(withDuration: 0.25, animations: {
            self.backView.alpha = 0.0
            self.view.sendSubviewToBack(self.backView)
            // got to social controller...
            self.selectedItems(1)
        }) { finished in
        }
    }
    func setPopViewDesign(){
//        selectedIndex = []
        tableView.reloadData()
        webViewSig.isHidden = true
        popUpView.backgroundColor = .white
        popUpView.layer.cornerRadius = 12
        popUpView.isUserInteractionEnabled = true
        tableView.isUserInteractionEnabled = true
        showAnimate()
    }
    
    @IBAction func moreAgreeAction(_ sender: Any) {
        if selectedIndex.count != agreementList.count{
            self.view.makeToast("Please agree to background check.")
            return
        }
        self.showDigitalSignaturePad()
        //self.agreementAndSignatureCompleted()
    }
    
    func showDigitalSignaturePad() {
        let helper_auth_key =  String(UserCache.shared.userInfo(forKey: kUserCache.auth_key)  as? String ?? "")
        if(helper_auth_key != ""){
            let strURL = appDelegate.baseContentURL + kAPIMethods.signature_pad + helper_auth_key
//          let strURL = "https://dev.gomoveit.com/signature-pad/6c4ac2f659ac8170e11f1625ff87ef88"
            webViewSig.isHidden = false
            webViewSig.navigationDelegate = self
            webViewSig.load(URLRequest.init(url: URL.init(string: strURL)!))
            StaticHelper.shared.startLoader(self.view)
        }
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        StaticHelper.shared.stopLoader()
        if webView.url?.absoluteString.contains("is_set=1") == true {
            removeAnimate()
        }
    }
}
extension PdfViewerViewController:UITableViewDelegate, UITableViewDataSource{
    
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
