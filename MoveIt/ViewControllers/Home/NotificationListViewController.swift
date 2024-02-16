//
//  NotificationListViewController.swift
//  Move It
//
//  Created by Dilip Technology on 19/04/21.
//  Copyright © 2021 Agicent Technologies. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class NotificationListViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var placeholderImgView: UIImageView!
    @IBOutlet weak var noNotificationLabel: UILabel!
    
    var vcType = 0  //1- offer ,,2- appupdate
    var isAnonunce = false
    var isUpdate = false
    var notificationArray = [[String: Any]](){
        didSet{
            if notificationArray.count == 0{
                self.placeholderView.isHidden = false
            }
            else{
                self.placeholderView.isHidden = true
            }
            self.tableView.reloadData()
        }
    }
    var page_index = 1
    
    var notification_type:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         noNotificationLabel.font = UIFont.josefinSansBoldFontWithSize(size: 17.0)
        if UIDevice.current.hasNotch {
            self.tableView.contentInset = UIEdgeInsets.init(top: 40.0 * screenHeightFactor, left: 0, bottom: 150.0 * screenHeightFactor, right: 0)
        } else{
            self.tableView.contentInset = UIEdgeInsets.init(top: 25, left: 0, bottom: 150.0 * screenHeightFactor, right: 0)
        }
//         self.getNotifications()
    }
    func announceServiceCall(){
        if !isAnonunce{
            self.getNotifications(isComeFrom:"ANNOUNCE")
        }
    }
    func updateServiceCall(){
        if !isUpdate{
            self.getNotifications(isComeFrom:"UPDATE")
        }
    }
    func getNotifications(isComeFrom:String){
//        ANNOUNCE/UPDATE
        CommonAPIHelper.getDiscountHelperNotification(VC: UIApplication.shared.keyWindow?.rootViewController ?? self, page_index: self.page_index, notification_type:isComeFrom) { (result, error, isExecuted) in
            if error == nil{
                if result != nil{
                    if isComeFrom == "ANNOUNCE"{
                        self.isAnonunce = true
                        debugPrint("call ANNOUNCE method")
                    }
                    if isComeFrom == "UPDATE"{
                        self.isUpdate = true
                        debugPrint("call update method")
                    }
                    self.notificationArray = result!
                }
            }
            if(self.notification_type == "UPLOAD_INSURANCE_NOTIFICATION") {
                if self.vcType == 1 {
                    self.notification_type = ""
                    var nTitle = "Update Vehicle Information"
                    var nMessage = "For better service experience please update vehicle information along with vehicle insurance details."

                    for item in result! {
                        if (item["notification_type"] as! String == "UPLOAD_INSURANCE_NOTIFICATION") {
                            nTitle = (item["notification_title"] as? String) ?? nTitle
                            nMessage = (item["notification_text"] as? String) ?? nMessage
                            break;
                        }
                    }
                    DispatchQueue.main.async {
                        self.showPopUpUpdateVehicleInfo(nTitle, nMessage)
                    }
                }
            } else if(self.notification_type == "REJECT_VEHICLE_REQUEST") {
                
            } else if(self.notification_type == "ACCEPT_VEHICLE_REQUEST") {
                
            }
        }
    }
    
    func updateApp() {
        let viewUpdateBG = UIView()
        viewUpdateBG.frame = self.view.bounds
        viewUpdateBG.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        
        
        var width:CGFloat = 320
        let space:CGFloat = 20
        
        if(self.view.bounds.size.width < 500) {
            width = self.view.bounds.size.width-40.0
        }
        
        let viewUpdate = UIView()
        viewUpdate.layer.cornerRadius = 10.0
        viewUpdate.clipsToBounds = true
        viewUpdate.frame = CGRect(x: (self.view.bounds.size.width-width)/2.0, y: (self.view.bounds.size.height-280)/2.0, width: width, height: 280)
        viewUpdate.backgroundColor = .white
        viewUpdateBG.addSubview(viewUpdate)
        

        let lblTitle = UILabel()
        lblTitle.frame = CGRect(x: 20, y: 20, width: width-space-space, height: 50)
        lblTitle.text = "Move It Update"
        lblTitle.textAlignment = .center
        lblTitle.font = UIFont.josefinSansBoldFontWithSize(size: 20.0)
        viewUpdate.addSubview(lblTitle)
        
        let lblDesc = UILabel()
        lblDesc.frame = CGRect(x: 20, y: 70, width: width-space-space, height: 60)
        lblDesc.numberOfLines = 0
        lblDesc.textColor = .darkGray
        lblDesc.textAlignment = .center
        lblDesc.font = UIFont.josefinSansRegularFontWithSize(size: 15.0)
        lblDesc.text = "We have a new release of the app with new features. Please update the app."
        viewUpdate.addSubview(lblDesc)

        let btnUpdate = UIButton()
        btnUpdate.setBackgroundImage(UIImage.init(named: "btn_gradient"), for: .normal)
        btnUpdate.frame = CGRect(x:20, y: 140, width: width-space-space, height: 60)
        btnUpdate.setTitle("Update Now", for: .normal)
        btnUpdate.titleLabel?.font = UIFont.josefinSansRegularFontWithSize(size: 17.0)
        btnUpdate.setTitleColor(.black, for: .normal)
        btnUpdate.addTarget(self, action: #selector(self.btnUpdateClicked), for: .touchDown)
        viewUpdate.addSubview(btnUpdate)
        
        let btnSkip = UIButton()
        btnSkip.frame = CGRect(x:20, y: 210, width: width-space-space, height: 50)
        btnSkip.setTitle("Skip", for: .normal)
        btnSkip.titleLabel?.font = UIFont.josefinSansRegularFontWithSize(size: 17.0)
        btnSkip.setTitleColor(.black, for: .normal)
        btnSkip.addTarget(viewUpdateBG, action: #selector(viewUpdateBG.removeFromSuperview), for: .touchDown)
        viewUpdate.addSubview(btnSkip)
        self.view.addSubview(viewUpdateBG)
    }
    
    @objc func btnUpdateClicked()
    {
        if let url = URL(string: "itms-apps://apple.com/app/1488199360") {
            UIApplication.shared.open(url)
        }
    }
    
    //MARK: - Vehicle info
    func showPopUpUpdateVehicleInfo(_ title:String, _ message:String) {
        let viewUpdateBG = UIView()
        viewUpdateBG.frame = self.view.bounds
        viewUpdateBG.backgroundColor = UIColor.init(white: 0, alpha: 0.1)
        
        
        var width:CGFloat = 320
        let space:CGFloat = 20
        
        if(self.view.bounds.size.width < 500) {
            width = self.view.bounds.size.width-40.0
        }
        
        let viewUpdate = UIView()
        viewUpdate.layer.cornerRadius = 10.0
        viewUpdate.clipsToBounds = true
        viewUpdate.frame = CGRect(x: (self.view.bounds.size.width-width)/2.0, y: (self.view.bounds.size.height-280)/2.0, width: width, height: 280)
        viewUpdate.backgroundColor = .white
        viewUpdateBG.addSubview(viewUpdate)
        
        let lblTitleBlack = UILabel()
        lblTitleBlack.frame = CGRect(x: 0, y: 0, width: width, height: 44)
        lblTitleBlack.text = "Announcement"
        lblTitleBlack.textAlignment = .center
        lblTitleBlack.textColor = .white
        lblTitleBlack.backgroundColor = .black
        lblTitleBlack.font = UIFont.josefinSansBoldFontWithSize(size: 17.0)
        viewUpdate.addSubview(lblTitleBlack)

        let lblTitle = UILabel()
        lblTitle.frame = CGRect(x: 20, y: 50, width: width-space-space, height: 50)
        lblTitle.text = title//"Update Vehicle Information"
        lblTitle.textAlignment = .center
        lblTitle.font = UIFont.josefinSansBoldFontWithSize(size: 17.0)
        viewUpdate.addSubview(lblTitle)
        
        let lblDesc = UILabel()
        lblDesc.frame = CGRect(x: 20, y: 100, width: width-space-space, height: 60)
        lblDesc.numberOfLines = 0
        lblDesc.textColor = .darkGray
        lblDesc.textAlignment = .center
        lblDesc.font = UIFont.josefinSansRegularFontWithSize(size: 15.0)
        lblDesc.text = message//"For better service experience please update vehicle information along with vehicle insurance details."
        //"Please update your profile information, so we can provide you enhanced service experience."
        viewUpdate.addSubview(lblDesc)

        let btnUpdate = UIButton()
        btnUpdate.setBackgroundImage(UIImage.init(named: "btn_gradient"), for: .normal)
        btnUpdate.frame = CGRect(x:20, y: 180, width: width-space-space, height: 60)
        btnUpdate.setTitle("Update", for: .normal)
        btnUpdate.titleLabel?.font = UIFont.josefinSansRegularFontWithSize(size: 17.0)
        btnUpdate.setTitleColor(.black, for: .normal)
        btnUpdate.addTarget(viewUpdateBG, action: #selector(viewUpdateBG.removeFromSuperview), for: .touchDown)
        btnUpdate.addTarget(self, action: #selector(self.btnUpdateVehicleClicked), for: .touchDown)
        viewUpdate.addSubview(btnUpdate)
        
        let btnSkip = UIButton()
        btnSkip.frame = CGRect(x:width, y: viewUpdate.frame.origin.y-15, width: 34, height: 34)
        //btnSkip.setTitle("Skip", for: .normal)
        btnSkip.setImage(UIImage.init(named: "ic_close"), for: .normal)
        btnSkip.titleLabel?.font = UIFont.josefinSansRegularFontWithSize(size: 17.0)
        btnSkip.setTitleColor(.black, for: .normal)
        btnSkip.addTarget(viewUpdateBG, action: #selector(viewUpdateBG.removeFromSuperview), for: .touchDown)
        viewUpdateBG.addSubview(btnSkip)
        self.view.addSubview(viewUpdateBG)
    }
    @objc func btnUpdateVehicleClicked()
    {
        let vehicleVC = self.storyboard?.instantiateViewController(withIdentifier: "VehicleInfoViewController") as! VehicleInfoViewController
        self.navigationController?.pushViewController(vehicleVC, animated: true)

    }
}

extension NotificationListViewController: UITableViewDelegate, UITableViewDataSource,UITextViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let indvNot = notificationArray[indexPath.row]
        let notificationType = indvNot["notification_type"] as! String
        if notificationType == "SIMPLE_NOTIFICATION" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleNotificationCell", for: indexPath) as! SimpleNotificationCell
            cell.nameLabel.text = (indvNot["notification_title"] as! String)
            cell.notificationTextLabel.text = (indvNot["notification_text"] as! String)
            if let created_at = indvNot["created_at"]{
                cell.timeLabel.text = self.manageDateTime("\(created_at)")
            }else{
                cell.timeLabel.text = ""
            }
            return cell
        } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationListTableViewCell", for: indexPath) as! NotificationListTableViewCell
            if let url = URL.init(string: (indvNot["photo_url"] as! String)){
                cell.userImgView.af.setImage(withURL: url)
                cell.imageheight.constant = 50
            } else{
                  cell.userImgView.image = UIImage.init(named: "home_card_img_placeholder")
                cell.imageheight.constant = 0
            }
            cell.notificationTextLabel.text = (indvNot["notification_text"] as! String)
            cell.nameLabel.text = (indvNot["notification_title"] as! String)
            if let created_at = indvNot["created_at"]{
                cell.timeLabel.text = self.manageDateTime("\(created_at)")
            }else{
                cell.timeLabel.text = ""
            }
            return cell
        }
    }
        
    func manageDateTime(_ datetimeString : String) -> String{
        print(datetimeString)
        if datetimeString == ""{
            return ""
        }
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "MM-dd-yyyy HH:mm:ss"
        dateFormate.locale = NSLocale.current
        let createdDate = dateFormate.date(from: datetimeString)
        let cmprString =  Date().offset(from: createdDate!)
        if cmprString == nil || cmprString == "" {return ""}
        return cmprString
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indvNot = notificationArray[indexPath.row]
        let notificationType = indvNot["notification_type"] as! String
        //use for update notificaiton status isDeliverd & isRead...
        if let is_update = indvNot["is_read"] as? String{
            if is_update == "0"{
                if let notification_id = indvNot["notification_id"] as? String{
                    CommonAPIHelper.updateNotificationStatusAPI(parameters: ["notification_id":"\(notification_id)", "is_delivered" : "1", "is_read": "1"])
                        
                }
            }
        }
        if notificationType == "PROMOTIONAL_NOTIFICATION" {
            let pramotionalVC = self.storyboard?.instantiateViewController(withIdentifier: "PramotionalNotificationViewController") as! PramotionalNotificationViewController
            pramotionalVC.modalPresentationStyle = .overFullScreen
            pramotionalVC.price = indvNot["coupon_code"] as? String
            pramotionalVC.titleText = indvNot["notification_title"] as? String
            pramotionalVC.code = indvNot["coupon_code"] as? String
            pramotionalVC.desc = indvNot["notification_text"] as? String
            pramotionalVC.photo_url = indvNot["photo_url"] as? String
            self.present(pramotionalVC, animated: true, completion: nil)
        } else if notificationType == "APP_UPDATE_NOTIFICATION" {
            
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.isUpdateAvailable() { hasUpdates in
                
              print("is update available: \(hasUpdates)")
                if(hasUpdates == true) {
                    self.updateApp()
                } else{
                    self.view.makeToast("You are using the latest app version")
                }
            }
        }  else if notificationType == "UPLOAD_INSURANCE_NOTIFICATION" {
            let nTitle = indvNot["notification_title"] as? String ?? ""
            let nMessage = indvNot["notification_text"] as? String ?? ""
            
            self.showPopUpUpdateVehicleInfo(nTitle, nMessage)
        } else if notificationType == "SIMPLE_NOTIFICATION" {
            let pramotionalVC = self.storyboard?.instantiateViewController(withIdentifier: "SimpleNotificationsAlertViewController") as! SimpleNotificationsAlertViewController
            pramotionalVC.modalPresentationStyle = .overFullScreen
            pramotionalVC.titleText = indvNot["notification_title"] as? String
            pramotionalVC.desc = indvNot["notification_text"] as? String
           self.present(pramotionalVC, animated: true, completion: nil)
        }
    }
    
}
