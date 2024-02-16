//
//  MoreViewController.swift
//  MoveIt
//
//  Created by Dushyant on 10/07/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {
    
    var sections = ["Settings","Support","Legal"]
    var settings = ["Notification","Distance","Availability"]
    var supports = ["Contact Us","FAQs","Move It Pro & Muscle FAQs", "Report a Problem", "Move It Helper Support"]
    var legal = ["Privacy Policy", "Terms and Conditions"]
    var headerIcons = ["setting_icon_n","support_icon","legal_icon"]
    @IBOutlet weak var tableView: UITableView!
    let termsAndCondition =   appDelegate.baseContentURL + "terms-conditions-mobile"
    
    let privacyPolicy =   appDelegate.baseContentURL + "privacy-policy-mobile"
    
    let faq =   appDelegate.baseContentURL + "faq-mobile"
    let proFAQ = appDelegate.baseContentURL + "faq-pro-muscles-mobile"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 50.0 * screenHeightFactor, right: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(getAdminChatCount), name: NSNotification.Name(rawValue: "ADMIN_CHAT_COUNT"), object: nil)
        self.getAdminChatCount()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        
    }
    
    @objc func getAdminChatCount(){
        CommonAPIHelper.getHelperNotificationCount(true, VC: self) { (result, error, status) in
            if (status == true) {
                if let message_notification_count = result?["admin_chat_count"] as? Int{
                    self.tableView.reloadData()
                    adminChatNotificationCount = message_notification_count
                    if adminChatNotificationCount != 0{
                        if StaticHelper.mainWindow().rootViewController?.topMostViewController() is MoreViewController {
                            let objVC:MoreViewController? = StaticHelper.mainWindow().rootViewController?.topMostViewController() as? MoreViewController
                            if objVC != nil{
                                self.navigationItem.leftBarButtonItem!.setBadge(text:"\(adminChatNotificationCount)")
                            }
                        }
                    }
                }
            }
        }
    }

    func reloadNotificationCountAdmin() {
        if adminChatNotificationCount != 0{
            self.navigationItem.leftBarButtonItem?.setBadge(text: "")
        }
    }
}

extension MoreViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return settings.count
        }
        else if section == 1{
            return supports.count
        }else {
            return legal.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoreOptionTableViewCell", for: indexPath) as! MoreOptionTableViewCell
        cell.messageCountView.isHidden = true
        if indexPath.section == 0{
            cell.optionLabel.text = settings[indexPath.row]
        }
        else if indexPath.section == 1{
            cell.optionLabel.text = supports[indexPath.row]
            if indexPath.row == 4{
                if adminChatNotificationCount != 0 {
                    cell.messageCountLabel.text = "\(adminChatNotificationCount)"
                    cell.messageCountView.isHidden = false
                }
            }
        }
        else{
            cell.optionLabel.text = legal[indexPath.row]
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0{
            switch indexPath.row{
                
            case 0:
                callAnalyticsEvent(eventName: "moveit_notification_setting", desc: ["description":"\(profileInfo?.helper_id ?? 0) set the notification setting"])
                let notificatioVC = self.storyboard?.instantiateViewController(withIdentifier: "SetNotificationViewController") as! SetNotificationViewController
                self.navigationController?.pushViewController(notificatioVC, animated: true)
                
            case 1:
                callAnalyticsEvent(eventName: "moveit_save_distance", desc: ["description":"\(profileInfo?.helper_id ?? 0) changed the distance related settings"])
                let distanceVC = self.storyboard?.instantiateViewController(withIdentifier: "DistanceViewController") as! DistanceViewController
                self.navigationController?.pushViewController(distanceVC, animated: true)
                
            case 2:
                callAnalyticsEvent(eventName: "moveit_save_availablity", desc: ["description":"\(profileInfo?.helper_id ?? 0) has changed his availability"])
                let availabilityVC = self.storyboard?.instantiateViewController(withIdentifier: "SetAvailabilityViewController") as! SetAvailabilityViewController
                self.navigationController?.pushViewController(availabilityVC, animated: true)
            default:
                let statasVC = self.storyboard?.instantiateViewController(withIdentifier: "StatsViewController") as! StatsViewController
                self.navigationController?.pushViewController(statasVC, animated: true)
            }
        }
        
        if indexPath.section == 1{
            switch indexPath.row{
                
            case 0:
                callAnalyticsEvent(eventName: "moveit_query", desc: ["description":"\(profileInfo?.helper_id ?? 0) contact the moveit"])
                let notificatioVC = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
                self.navigationController?.pushViewController(notificatioVC, animated: true)
                
            case 1:
                let distanceVC = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                distanceVC.titleString = "FAQs"
                distanceVC.urlString = faq
                self.navigationController?.pushViewController(distanceVC, animated: true)
                
            case 2:
                let distanceVC = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                distanceVC.titleString = "Move It Pro & Muscle FAQs"
                distanceVC.urlString = proFAQ
                self.navigationController?.pushViewController(distanceVC, animated: true)
                
            case 3:
                callAnalyticsEvent(eventName: "moveit_report_problem", desc: ["description":"\(profileInfo?.helper_id ?? 0) reported a problem"])
                let reportAProblemVC = self.storyboard?.instantiateViewController(withIdentifier: "ReportAProblemViewController") as! ReportAProblemViewController
                self.navigationController?.pushViewController(reportAProblemVC, animated: true)
            case 4:
                adminChatNotificationCount = 0
                let adminChatVC = AdminChatViewController.getVCInstance() as! AdminChatViewController
                // adminChatVC.isFromProfile = true
                self.navigationController?.pushViewController(adminChatVC, animated: true)
            default:
                break
            }
        }
        
        if indexPath.section == 2{
            switch indexPath.row{
                
            case 0:
                let distanceVC = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                distanceVC.titleString = "Privacy Policy"
                distanceVC.urlString = self.privacyPolicy
                self.navigationController?.pushViewController(distanceVC, animated: true)
                
            case 1:
                let distanceVC = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                distanceVC.titleString = "Terms and conditions"
                distanceVC.urlString = self.termsAndCondition
                self.navigationController?.pushViewController(distanceVC, animated: true)
                
            default:
                break
            }
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoreSectionTableViewCell") as! MoreSectionTableViewCell
        
        cell.settingLabel.text = sections[section]
        cell.imgView.image = UIImage.init(named: headerIcons[section])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  45.0 * screenHeightFactor
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoreSectionFooterTableViewCell") as! MoreSectionFooterTableViewCell
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0 * screenHeightFactor
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 35.0 * screenHeightFactor
    }
}

