//
//  NotificationsViewController.swift
//  Move It Customer
//
//  Created by Dushyant on 10/05/19.
//  Copyright © 2019 Agicent Technologies. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var placeholderImgView: UIImageView!
    @IBOutlet weak var noNotificationLabel: UILabel!
    
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
    
    lazy var refreshControl: UIRefreshControl = {
         let refreshControl = UIRefreshControl()
         refreshControl.addTarget(self, action:
                      #selector(getNotifications),
                                  for: UIControl.Event.valueChanged)
         refreshControl.tintColor = violetColor
         return refreshControl
     }()
    
    var page_index = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.addSubview(self.refreshControl)
        self.tableView.contentInset = UIEdgeInsets.init(top: 10, left: 0, bottom: 40, right: 0)
        noNotificationLabel.font = UIFont.josefinSansBoldFontWithSize(size: 17.0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getNotifications), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.getNotifications()
    }
        
    @objc func getNotifications(){
        if(SELECTED_TAB_INDEX != 3) {
            return
        } 

        CommonAPIHelper.getHelperNotification(VC: self, page_index: self.page_index) { (result, error, isExecuted) in
            if error == nil{
                if result != nil{
                    self.refreshControl.endRefreshing()
                    self.notificationArray = result!
                }
            }
        }
    }
}

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource,UITextViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dictNotification = notificationArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "GetNotificationTableViewCell", for: indexPath) as! GetNotificationTableViewCell
        
        if let url = URL.init(string: (dictNotification["photo_url"] as! String)){
            cell.userImgView.af.setImage(withURL: url)
        }
        else{
            cell.userImgView.image = UIImage.init(named: "User_placeholder")
        }
        cell.notificationTextLabel.text = (dictNotification["notification_text"] as! String)
        cell.nameLabel.text = (dictNotification["customer_name"] as! String)
        let str = self.manageDateTime("")
        if let notified_on = dictNotification["notified_on"]{
            cell.timeLabel.text = self.manageDateTime("\(notified_on)")
        }else{
            cell.timeLabel.text = ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
//        return 90.0 //* screenHeightFactor
        return UITableView.automaticDimension
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
}
