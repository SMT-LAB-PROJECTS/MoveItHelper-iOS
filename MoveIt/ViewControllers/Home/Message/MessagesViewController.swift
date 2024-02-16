//
//  MessagesViewController.swift
//  Move It Customer
//
//  Created by Dushyant on 10/05/19.
//  Copyright © 2019 Agicent Technologies. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var placeholderImgView: UIImageView!
    @IBOutlet weak var noMessageLabel: UILabel!
    
    var chatUserType = ChatUserType.Customer
    
    var chatVC:ChatViewController?
    
    var chats = [[String: Any]](){
        didSet{
            if chats.count == 0{
                self.placeholderView.isHidden = false
            } else {
                self.placeholderView.isHidden = true
            }
            self.tableView.reloadData()
        }
    }
    
    var page_index = 1
    
   lazy var refreshControl: UIRefreshControl = {
       let refreshControl = UIRefreshControl()
       refreshControl.addTarget(self, action:
                    #selector(getChats),
                                for: UIControl.Event.valueChanged)
       refreshControl.tintColor = violetColor
       return refreshControl
   }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
          
        self.tableView.addSubview(self.refreshControl)
        noMessageLabel.font = UIFont.josefinSansBoldFontWithSize(size: 17.0)
        
        if UIDevice.current.hasNotch {
            self.tableView.contentInset = UIEdgeInsets.init(top: 10, left: 0, bottom: 45.0 * screenHeightFactor, right: 0)
        } else {
            self.tableView.contentInset = UIEdgeInsets.init(top: 5, left: 0, bottom: 45.0 * screenHeightFactor, right: 0)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(getChats), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.chatVC = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.getChats()
    }
    
    @objc func leftButtonPressed(_ selector: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - API
    @objc func getChats() {
        if(SELECTED_TAB_INDEX != 2) {
            return
        }

        if self.chatUserType == ChatUserType.Customer {
            if(appDelegate.homeVC?.messagesViewController.selectedMenuIndex != 0) {
                return
            }
            CommonAPIHelper.getAllMesages(VC: self, page_index: self.page_index) { (result, error, isExecuted) in
                if error == nil{
                    if result != nil{
                        self.chats = result!
                        self.refreshControl.endRefreshing()
                    }
                }
            }
        } else {
            if(appDelegate.homeVC?.messagesViewController.selectedMenuIndex != 1) {
                return
            }
            CommonAPIHelper.getAllHelperMesages(VC: self, page_index: self.page_index) { (result, error, isExecuted) in
                if error == nil{
                    if result != nil{
                        self.chats = result!
                        self.refreshControl.endRefreshing()
                    }
                }
            }
        }
    }
    
    
    //MARK: - Redirection
    func redirectToTheMessageChat(_ userInfo: [AnyHashable : Any]) {
        if userInfo[AnyHashable("customer_id")] != nil {//CUSTOMER CHAT
//            guard let chatID = userInfo[AnyHashable("chat_id")] else {return}
            guard let cID = userInfo[AnyHashable("customer_id")] else {return}
            self.chatVC = (self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController)
//            self.chatVC!.chat_ID = Int("\(chatID)") ?? 0
            self.chatVC!.customer_ID = Int("\(cID)") ?? 0
            
            if let requestID = userInfo[AnyHashable("request_id")] as? String {
                self.chatVC!.requestId = requestID
            }
            if let requestID = userInfo[AnyHashable("request_id")] as? Int {
                self.chatVC!.requestId = requestID.description
            }
            self.navigationController?.pushViewController(self.chatVC!, animated: true)
                        
        } else {//HELPER CHAT
            guard let helperID = userInfo[AnyHashable("helper_id")] else {return}

            self.chatVC = (self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController)
            self.chatVC!.isHelperChat = true
            self.chatVC!.customer_ID = Int("\(helperID)") ?? 0
            self.chatVC!.Tohelper_ID = Int("\(helperID)") ?? 0
            if let requestID = userInfo[AnyHashable("request_id")] as? String {
                self.chatVC!.requestId = requestID
            }
            if let requestID = userInfo[AnyHashable("request_id")] as? Int {
                self.chatVC!.requestId = requestID.description
            }
            if(chatVC?.customer_ID == (profileInfo?.helper_id ?? 0)) {
                return
            }
            
            self.navigationController?.pushViewController(self.chatVC!, animated: true)
        }

    }
}

extension MessagesViewController: UITableViewDataSource, UITableViewDelegate{
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatcell =  tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as! ChatTableViewCell
        let indvChat = self.chats[indexPath.row]
        print(indvChat)
        if let url = URL.init(string: (indvChat["photo_url"] as! String)){
            chatcell.userImgView.af.setImage(withURL: url)
        }else{
            chatcell.userImgView.image = UIImage(named: "User_placeholder")
        }
        chatcell.messageLabel.text = (indvChat["message"] as! String)
        chatcell.nameLable.text = (indvChat["name"] as! String)
//        chatcell.timeLabel.text = self.manageDateTime(indvChat["created_datetime"] as! String)
        if let created_datetime = indvChat["created_datetime"]{
            chatcell.timeLabel.text = self.manageDateTime("\(created_datetime)")
        }else{
            chatcell.timeLabel.text = ""
        }
        return chatcell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0 * screenHeightFactor
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if chatUserType == ChatUserType.Helper {
            let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            let indvChat = self.chats[indexPath.row]
            if (indvChat["sender_id"] as! Int) == (profileInfo?.helper_id ?? 0) {
                chatVC.customer_ID = (indvChat["receiver_id"] as! Int)
                chatVC.Tohelper_ID = (indvChat["receiver_id"] as! Int)
            } else{
                chatVC.customer_ID = (indvChat["sender_id"] as! Int)
                chatVC.Tohelper_ID = (indvChat["sender_id"] as! Int)
            }
            chatVC.customerName = indvChat["name"] as! String
            chatVC.customerImgUrl = indvChat["photo_url"] as! String
            
            if let reqId = indvChat["request_id"] as? Int {
                chatVC.requestId =  reqId.description
            }
            if let reqId = indvChat["request_id"] as? String {
                chatVC.requestId =  reqId
            }
            
            chatVC.isHelperChat = true
            self.navigationController?.pushViewController(chatVC, animated: true)
        } else {
            let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            let indvChat = self.chats[indexPath.row]
          //  chatVC.chat_ID = indvChat["chat_id"] as! Int
//            chatVC.requestId = (indvChat["request_id"] as! Int).description
            chatVC.customerName = indvChat["name"] as! String
            chatVC.customerImgUrl = indvChat["photo_url"] as! String
            chatVC.customer_ID = (indvChat["customer_id"] as! Int)
            chatVC.isHelperChat = false
            if let reqId = indvChat["request_id"] as? Int {
                chatVC.requestId =  reqId.description
            }
            if let reqId = indvChat["request_id"] as? String {
                chatVC.requestId =  reqId
            }
            self.navigationController?.pushViewController(chatVC, animated: true)
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
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date)) years ago"   }
        if months(from: date)  > 0 { return "\(months(from: date)) months ago"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date)) weeks ago"   }
        if days(from: date)    > 0 { return "\(days(from: date)) days ago"    }
        if hours(from: date)   > 0 { return "\(hours(from: date)) hours ago"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date)) minutes ago" }
        if seconds(from: date) > 0 { return "\(seconds(from: date)) seconds ago" }
        return ""
    }
}
