//
//  SetNotificationViewController.swift
//  MoveIt
//
//  Created by Dushyant on 11/07/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class SetNotificationViewController: UIViewController {
    @IBOutlet weak var `switch`: UISwitch!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var receiveNotificationLabel: UILabel!
    @IBOutlet weak var subNotificationText: UILabel!
    @IBOutlet weak var notifyLabel: UILabel!
    @IBOutlet weak var subNotifyLabel: UILabel!
    
    var weekArray = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    var selectedDays = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle("Notification")
        
        receiveNotificationLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        notifyLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        subNotificationText.font = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        subNotifyLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        
        let leftBarButtonItem = StaticHelper.leftBarButtonWithImageNamed(imageName: "backward_arrow_icon", vc: self)
        let rightBarTextButton =  StaticHelper.rightBarButtonWithText(text: "Save", vc: self)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        self.navigationItem.rightBarButtonItem = rightBarTextButton
         self.setnotificationDays()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        topView.layer.cornerRadius = 10.0 * screenHeightFactor
        secondView.frame.size.width = 290.0 * screenWidthFactor
        secondView.roundCorners(corners: [.topLeft,.topRight], radius: 10.0 * screenHeightFactor)
    }
    func setnotificationDays(){
       
        if (profileInfo?.is_available) ?? 0 == 1{
            self.switch.setOn(true, animated: false)
        }
        else{
            self.switch.setOn(false, animated: false)
        }
        
        for vInfo in (profileInfo?.notification_days) ?? [] {
            if (vInfo["is_notification_on"] as? Int) ?? 0 == 1{
                selectedDays.append((vInfo["notification_day"] as? Int) ?? 0)
            }
        }
    }
    
    @objc func leftButtonPressed(_ selector: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
 
    @IBAction func switchAction(_ sender: Any) {
    }
    
    @objc func rightTextPressed(_ selector: UIButton){
        var paramData = [[String: Any]]()
        
        for i in 0...6{
            var dt = [String: Any]()
            if selectedDays.contains(i){
                dt = ["notification_day": i, "is_notification_on": 1]
            }
            else{
                dt = ["notification_day": i, "is_notification_on": 0]
            }
            
            paramData.append(dt)
            
        }
        
        var avl = 1
        if self.switch.isOn{
            avl = 1
        }
        else{
            avl = 0
        }
   //     var is avl = self.switch.is
        
        let param = ["data": paramData,"is_available": avl] as [String : Any]
        var switchaction = avl == 1 ? "on" : "off"
        callAnalyticsEvent(eventName: "moveit_notification_setting", desc: ["description":"\(profileInfo?.helper_id ?? 0) \(switchaction) setting changed"])
        CommonAPIHelper.setNotificationDays(VC: self, params: param) { (res,err, isExecuted) in
            if isExecuted{
                profileInfo?.is_available = avl
                profileInfo?.notification_days = paramData
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension SetNotificationViewController: UITableViewDelegate, UITableViewDataSource{
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        cell.notificationLabel.text = weekArray[indexPath.row]
        cell.setButton.addTarget(self, action: #selector(selectButton(_:)), for: .touchUpInside)
        if selectedDays.contains(indexPath.row){
            cell.setButton.isSelected = true
        }
        else{
            cell.setButton.isSelected = false
        }
        cell.setButton.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30.0 * screenHeightFactor
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoreSectionFooterTableViewCell") as! MoreSectionFooterTableViewCell
        return cell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30.0 * screenHeightFactor
    }
    
    @objc func selectButton(_ selector: UIButton){
     
        if selector.isSelected{
            selector.isSelected = false
            let index = selectedDays.index(of: selector.tag) as? Int ?? 0
            selectedDays.remove(at: index)
        }
        else{
            selector.isSelected = true
            selectedDays.append(selector.tag)
        }
    }
}
