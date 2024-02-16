//
//  ChatViewController.swift
//  MoveIt
//
//  Created by Dushyant on 09/07/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import CCBottomRefreshControl
import MLKit
import SocketIO

class ChatViewController: UIViewController {

    var customer_ID = Int()
    
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var messageTextView: JVFloatLabeledTextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var movenolongerView: UIView!
    @IBOutlet weak var movenolongerLabel: UILabel!
    
    @IBOutlet weak var bottomConst: NSLayoutConstraint!
    @IBOutlet weak var suggestionHeightConst: NSLayoutConstraint!
    
    var helper_ID = Int()
    var Tohelper_ID = Int()
    var isFromInfo = false
    var pageIndex = 1
    var chat_ID = Int()
    var helperName = ""
    var customerName = ""
    var helperImgUrl = ""
    var customerImgUrl = ""
    var phoneNum = ""
    var requestId = ""
    var refreshControl: UIRefreshControl!
    var nextPageAvl = false
    
    var isHelperChat = false
    
    var chatArray = [[String: Any]](){
        didSet{
            self.tableView.reloadData()
            if self.chatArray.count > 0 {
                self.tableView.scrollToRow(at: IndexPath(item:self.chatArray.count-1, section: 0), at: .bottom, animated: true)
            }
        }
    }
    var suggestionArray = [String]()
    
//    //MARK: -Socket
//    let manager = SocketManager(socketURL: URL(string: socketURL)!, config: [.log(true), .compress])
//    var socket:SocketIOClient!//manager.defaultSocket
//    var resetAck: SocketAckEmitter?
//
//    var isSocketConnected = false
//
//    var static_activated = ""
//    let SM = "message"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        socket = manager.defaultSocket
        socketConnection()
        
        self.navgationBarConfiguration()
        self.uiConfigurationAfterStoryboard()
        
        NotificationCenter.default.addObserver(self, selector: #selector(addmsg(_:)), name: NSNotification.Name(rawValue: SM), object: nil)
        
        if (isHelperChat) {
            refreshControl.addTarget(self, action: #selector(getAllHelperChats), for: UIControl.Event.valueChanged)
            self.getAllHelperChats()
            self.movenolongerLabel.text = "Your Move It job is no longer active with this helper"
        } else {
            refreshControl.addTarget(self, action: #selector(getAllCustomerChats), for: UIControl.Event.valueChanged)
            self.getAllCustomerChats()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func navgationBarConfiguration() {
        setNavigationTitle(customerName)
        
        let rightBarbutton = StaticHelper.rightBarButtonWithImageNamed(imageName: "call_outline_icon", vc: self)
        let leftBarButtonItem = StaticHelper.leftBarButtonWithImageNamed(imageName: "backward_arrow_icon", vc: self)
        self.navigationItem.leftBarButtonItems = [leftBarButtonItem]
        self.navigationItem.rightBarButtonItem = rightBarbutton
    }

    func uiConfigurationAfterStoryboard() {
        
        sendButton.layer.cornerRadius = 15.0 * screenHeightFactor
        sendButton.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        tableView.contentInset = UIEdgeInsets.init(top: 10, left: 0, bottom: 10, right: 0)
        tableView.refreshControl = refreshControl
        refreshControl = UIRefreshControl()
        refreshControl.triggerVerticalOffset = 100.0

        messageTextView.floatingLabelTextColor = UIColor.clear
        messageTextView.alwaysShowFloatingLabel = false
        messageTextView.floatingLabel.isHidden = true
    }
    
    //MARK: - Actions
    @objc func leftButtonPressed(_ selector: Any){
//        socketDisconnected()
        self.navigationController?.popViewController(animated: true)
    }
   
    @objc func rightButtonPressed(_ selector: Any){
        let num = phoneNum.replacingOccurrences(of: " ", with: "")
        if(num.isEmpty) {
            self.view.makeToast("call detail not available.")
            return
        }
        self.dialNumber(number: num)
    }
    
    @objc func addmsg(_ notification: Notification) {
        
        if let data = notification.object as? [String : Any] {
            if (data["sent_by"] as? String ?? "" == "H"){
                if (Int(data["receiver_id"] as? String ?? "") ?? 0) == (profileInfo?.helper_id ?? 0) {
                    if (Int(data["sender_id"] as? String ?? "") ?? 0) == Tohelper_ID {
                        self.chatArray.insert(data, at: 0)

                        self.tableView.scrollToRow(at: IndexPath.init(row: self.chatArray.count - 1, section: 0), at: .bottom, animated: true)
                        let suggest = TextMessage(text: data["message"] as? String ?? "", timestamp: Date().timeIntervalSince1970, userID: "", isLocalUser: false)
                        
                        SmartReply.smartReply().suggestReplies(for: [suggest]) { (result, error) in
                            guard error == nil, let result = result else {
                                return
                            }
                            if result.status == .notSupportedLanguage {
                                self.suggestionHeightConst.constant = 0
                            } else if result.status == .success {
                                //Successful
                                self.suggestionArray.removeAll()
                                for suggestion in result.suggestions {
                                    self.suggestionArray.append(suggestion.text)
                                }
                                if !self.suggestionArray.isEmpty {
                                    self.suggestionHeightConst.constant = 48
                                    self.collectionView.reloadData()
                                    self.tableView.scrollToRow(at: IndexPath.init(row: self.chatArray.count - 1, section: 0), at: .bottom, animated: true)
                                }
                            }
                        }
                    }
                }
            } else {
                if (Int(data["helper_id"] as? String ?? "") ?? 0) == (profileInfo?.helper_id ?? 0) {
                    if (Int(data["customer_id"] as? String ?? "") ?? 0) == customer_ID {
                        self.chatArray.insert(data, at: 0)

                        self.tableView.scrollToRow(at: IndexPath.init(row: self.chatArray.count - 1, section: 0), at: .bottom, animated: true)
                        let suggest = TextMessage(text: data["message"] as? String ?? "", timestamp: Date().timeIntervalSince1970, userID: "", isLocalUser: false)
                        
                        SmartReply.smartReply().suggestReplies(for: [suggest]) { (result, error) in
                            guard error == nil, let result = result else {
                                return
                            }
                            if result.status == .notSupportedLanguage {
                                self.suggestionHeightConst.constant = 0
                            } else if result.status == .success {
                                //Successful
                                self.suggestionArray.removeAll()
                                for suggestion in result.suggestions {
                                    self.suggestionArray.append(suggestion.text)
                                }
                                if !self.suggestionArray.isEmpty {
                                    self.suggestionHeightConst.constant = 48
                                    self.collectionView.reloadData()
                                    self.tableView.scrollToRow(at: IndexPath.init(row: self.chatArray.count - 1, section: 0), at: .bottom, animated: true)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getCustomerDetail() {
        let request = "\(customer_ID)&request_id=\(requestId)"
        CommonAPIHelper.getCustomerDetailUrl(VC: self, customerId: request) { (result, error, hasNextPage) in
            if error == nil{
                if result != nil{
                    self.phoneNum = result!["phone_num"] as? String ?? ""
                }
            }
        }
    }
    
    @objc func getHelperInfo() {
        let param:[String: Any] = ["helper_id":Tohelper_ID,"sent_by": "H", "request_id":self.requestId]
        CommonAPIHelper.gewthelperInfofromId(VC: self, parameter: param) { (res, err, isExecuted) in
            if err == nil{
                if res != nil{
                    self.phoneNum = res?["phone_num"] as? String ?? ""
                }
            }
        }
    }
    
    func dialNumber(number : String) {
        
        if let url = URL(string: "tel://\(number)"),
            UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            // add error message here
        }
    }
    
    @objc func getAllCustomerChats(){
        CommonAPIHelper.getChatMesages(VC: self,
                                       page_index: pageIndex,
                                       request_id: Int(requestId) ?? 0,
                                       completetionBlock:  { (result, error, hasNextPage, jobStatus, requestId) in
            if error == nil{
                if result != nil{

                    if hasNextPage{
                        self.refreshControl.isHidden = true
                        self.pageIndex = self.pageIndex + 1
                        self.nextPageAvl = true
                        self.refreshControl.endRefreshing()
                    }
                    else{
                        self.nextPageAvl = false
                        self.refreshControl.isHidden = true
                        self.tableView.refreshControl = nil
                        self.refreshControl.endRefreshing()
                        self.tableView.refreshControl = nil
                    }
                    if self.pageIndex > 1{
                        self.chatArray =  result! + self.chatArray
                    }
                    else{
                        self.chatArray = result!
                    }
                    
                    if jobStatus == false {
                        self.collectionView.isHidden = true
                        self.movenolongerView.isHidden = false
                        self.navigationItem.rightBarButtonItem?.customView?.isHidden = true
                    }
                    
                    for info in self.chatArray {
                        print(info)
                        if (info["sent_by"] as! String) == "C"{
                            self.customerName = info["name"] as? String ?? ""
                            self.setNavigationTitle(self.customerName)
                            break
                        }
                    }
                    if self.chatArray.count > 0 {
                        if(self.chatArray.first?["sent_by"] as! String == "C"){
                            let suggest = TextMessage(text: self.chatArray.first?["message"] as! String, timestamp: Date().timeIntervalSince1970, userID: "", isLocalUser: false)
                            
                            //let nl = NaturalLanguage.naturalLanguage()
                            
                            SmartReply.smartReply().suggestReplies(for: [suggest]) { (result, error) in
                                guard error == nil, let result = result else {
                                    return
                                }
                                if result.status == .notSupportedLanguage {
                                    self.suggestionHeightConst.constant = 0
                                } else if result.status == .success {
                                    //Successful
                                    self.suggestionArray.removeAll()
                                    for suggestion in result.suggestions {
                                        self.suggestionArray.append(suggestion.text)
                                    }
                                    print(self.suggestionArray)
                                    if !self.suggestionArray.isEmpty {
                                        self.suggestionHeightConst.constant = 48
                                        self.collectionView.reloadData()
                                        self.tableView.scrollToRow(at: IndexPath.init(row: self.chatArray.count - 1, section: 0), at: .bottom, animated: true)
                                    }
                                }
                            }
                        } else {
                            self.suggestionHeightConst.constant = 0
                        }
                    }  else {
                        self.suggestionHeightConst.constant = 0
                    }

                    self.requestId = requestId
                    self.getCustomerDetail()

                } else{
                    self.navigationItem.rightBarButtonItem?.customView?.isHidden = true
                }
            }
        })
    }
    
    @objc func getAllHelperChats(){
        CommonAPIHelper.getHelperChatMesages(VC: self,
                                             page_index: pageIndex,
                                             receiver_id: Tohelper_ID,
                                             request_id: requestId,
                                             completetionBlock:  { (result, error, hasNextPage, jobStatus, requestId) in
            if error == nil{
                if result != nil{

                    if hasNextPage{
                        self.refreshControl.isHidden = true
                        self.pageIndex = self.pageIndex + 1
                        self.nextPageAvl = true
                        self.refreshControl.endRefreshing()
                    }
                    else{
                        self.nextPageAvl = false
                        self.refreshControl.isHidden = true
                        self.tableView.refreshControl = nil
                        self.refreshControl.endRefreshing()
                        self.tableView.refreshControl = nil
                    }
                    if self.pageIndex > 1{
                        self.chatArray =  result! + self.chatArray
                    }
                    else{
                        self.chatArray = result!
                    }
                    
                    if jobStatus == false {
                        self.collectionView.isHidden = true
                        self.movenolongerView.isHidden = false
                        self.navigationItem.rightBarButtonItem?.customView?.isHidden = true
                    }
                    
                    for i in self.chatArray {
                        if (i["receiver_id"] as! Int) == self.Tohelper_ID {
                            self.customerName = i["name"] as! String
                            self.setNavigationTitle(self.customerName)
                            break
                        }
                    }
                    if self.chatArray.count > 0 {
                        if !(self.chatArray.first?["receiver_id"] as! Int == self.Tohelper_ID){
                            let suggest = TextMessage(text: self.chatArray.first?["message"] as! String, timestamp: Date().timeIntervalSince1970, userID: "", isLocalUser: false)
                                                        
                            SmartReply.smartReply().suggestReplies(for: [suggest]) { (result, error) in
                                guard error == nil, let result = result else {
                                    return
                                }
                                if result.status == .notSupportedLanguage {
                                    self.suggestionHeightConst.constant = 0
                                } else if result.status == .success {
                                    //Successful
                                    self.suggestionArray.removeAll()
                                    for suggestion in result.suggestions {
                                        self.suggestionArray.append(suggestion.text)
                                    }
                                    print(self.suggestionArray)
                                    if !self.suggestionArray.isEmpty {
                                        self.suggestionHeightConst.constant = 48
                                        self.collectionView.reloadData()
                                        self.tableView.scrollToRow(at: IndexPath.init(row: self.chatArray.count - 1, section: 0), at: .bottom, animated: true)
                                    }
                                }
                            }
                        } else {
                            self.suggestionHeightConst.constant = 0
                        }
                    } else {
                        self.suggestionHeightConst.constant = 0
                    }
                    
                    self.requestId = requestId
                    self.getHelperInfo()
                }else{
                    self.navigationItem.rightBarButtonItem?.customView?.isHidden = true
                }
            }
        })
    }
    
    @IBAction func sendAction(_ sender: Any) {
       
        self.view.endEditing(true)
     
        let message = messageTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if message.isEmpty{
            self.view.makeToast("Please enter your message.")
            return
        }
        
        self.suggestionHeightConst.constant = 0
        if (isHelperChat) {
            let params = ["msg_type": 1,
                          "message":message,
                          "receiver_id":Tohelper_ID,
                          "request_id":requestId,
                          "timezone": TimeZone.current.identifier] as [String : Any]
            
            CommonAPIHelper.sendMessageToHelper(VC: self, params: params) { [self] (res, error, isSend) in
                if error == nil{
                    if isSend{
                        self.chatArray.insert(res!, at: 0)
                        self.messageTextView.text = ""
                        self.tableView.scrollToRow(at: IndexPath.init(row: self.chatArray.count - 1, section: 0), at: .bottom, animated: true)
                        sendMessage(chat_id: "\(res!["chat_id"] as? Int ?? 0)", msg_type: "\(res!["msg_type"] as? Int ?? 0)", created_datetime: (res!["created_datetime"] as? String ?? ""), message: (res!["message"] as? String ?? ""), helper_read_flag: "\(res!["helper_read_flag"] as? Int ?? 0)", customer_read_flag: "\(res!["customer_read_flag"] as? Int ?? 0)", sent_by: "H", customer_id: "\(res!["customer_id"] as? Int ?? 0)", helper_id: "\(res!["helper_id"] as? Int ?? 0)", image_url: (res!["image_url"] as? String ?? ""), name: (res!["name"] as? String ?? ""), photo_url: (res!["photo_url"] as? String ?? ""),chat_type: "1",sender_id: "\(profileInfo?.helper_id ?? 0)",receiver_id: "\(customer_ID)")
                    } else{
                    }
                }
            }
        } else{
            
            let params = ["msg_type": 1,
                          "sent_by":"H",
                          "message":message,
                          "to_user":customer_ID,
                          "request_id":requestId,
                          "timezone": TimeZone.current.identifier] as [String : Any]
            
            CommonAPIHelper.sendMessages(VC: self, params: params) { [self] (res, error, isSend) in
                if error == nil{
                    if isSend{
                        self.chatArray.insert(res!, at: 0)
                        self.messageTextView.text = ""
                        self.tableView.scrollToRow(at: IndexPath.init(row: self.chatArray.count - 1, section: 0), at: .bottom, animated: true)
                        sendMessage(chat_id: "\(res!["chat_id"] as? Int ?? 0)", msg_type: "\(res!["msg_type"] as? Int ?? 0)", created_datetime: (res!["created_datetime"] as? String ?? ""), message: (res!["message"] as? String ?? ""), helper_read_flag: "\(res!["helper_read_flag"] as? Int ?? 0)", customer_read_flag: "\(res!["customer_read_flag"] as? Int ?? 0)", sent_by: (res!["sent_by"] as? String ?? ""), customer_id: "\(res!["customer_id"] as? Int ?? 0)", helper_id: "\(res!["helper_id"] as? Int ?? 0)", image_url: (res!["image_url"] as? String ?? ""), name: (res!["name"] as? String ?? ""), photo_url: (res!["photo_url"] as? String ?? ""),chat_type: "0",sender_id: "\(profileInfo?.helper_id ?? 0)",receiver_id: "\(customer_ID)")
                    } else{
                    }
                }
            }
        }
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource,UITextViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let indvChat = chatArray[chatArray.count - 1 - indexPath.row] 
        if (isHelperChat) {
            if !((indvChat["receiver_id"] as? Int) == self.Tohelper_ID) {
                let chatCell = tableView.dequeueReusableCell(withIdentifier: "ReceiveMessagesTableViewCell", for: indexPath) as! ReceiveMessagesTableViewCell
//                chatCell.messageLabel.text = (indvChat["message"] as! String)
                chatCell.timeLabel.text = (indvChat["created_datetime"] as! String)
                chatCell.messageDisplayWay(message: (indvChat["message"] as! String))
                let w = (indvChat["message"] as! String).width(withConstrainedHeight: 100, font: UIFont.josefinSansRegularFontWithSize(size: 14.0))
                if w < 40.0{
                    chatCell.widthConst.constant = w + (40.0 * screenWidthFactor)
                }
                else if w > 40.0, w < 180.0{
                    chatCell.widthConst.constant = w + (40.0 * screenWidthFactor)
                }
                else{
                    chatCell.widthConst.constant = 220.0 * screenWidthFactor
                }
                return chatCell
            } else{
                let chatCell = tableView.dequeueReusableCell(withIdentifier: "SendMessagesTableViewCell", for: indexPath) as! SendMessagesTableViewCell
//                chatCell.messageLabel.text = (indvChat["message"] as! String)
                chatCell.timeLabel.text = (indvChat["created_datetime"] as! String)
                chatCell.messageDisplayWay(message: (indvChat["message"] as! String))
                let w = (indvChat["message"] as! String).width(withConstrainedHeight: 100, font: UIFont.josefinSansRegularFontWithSize(size: 14.0))
                
                if w < 40.0{
                    chatCell.widthConst.constant = w + (40.0 * screenWidthFactor)
                }
                else if w > 40.0, w < 180.0{
                    chatCell.widthConst.constant = w + (40.0 * screenWidthFactor)
                }
                else{
                    chatCell.widthConst.constant = 220.0 * screenWidthFactor
                }
                return chatCell
            }
        } else{
            if (indvChat["sent_by"] as! String) == "C"{
                let chatCell = tableView.dequeueReusableCell(withIdentifier: "ReceiveMessagesTableViewCell", for: indexPath) as! ReceiveMessagesTableViewCell
//                chatCell.messageLabel.text = (indvChat["message"] as! String)
                chatCell.timeLabel.text = (indvChat["created_datetime"] as! String)
                chatCell.messageDisplayWay(message: (indvChat["message"] as! String))
                let w = (indvChat["message"] as! String).width(withConstrainedHeight: 100, font: UIFont.josefinSansRegularFontWithSize(size: 14.0))
                if w < 40.0{
                    chatCell.widthConst.constant = w + (40.0 * screenWidthFactor)
                }
                else if w > 40.0, w < 180.0{
                    chatCell.widthConst.constant = w + (40.0 * screenWidthFactor)
                }
                else{
                    chatCell.widthConst.constant = 220.0 * screenWidthFactor
                }
                return chatCell
            } else{
                let chatCell = tableView.dequeueReusableCell(withIdentifier: "SendMessagesTableViewCell", for: indexPath) as! SendMessagesTableViewCell
//                chatCell.messageLabel.text = (indvChat["message"] as! String)
                chatCell.timeLabel.text = (indvChat["created_datetime"] as! String)
                chatCell.messageDisplayWay(message: (indvChat["message"] as! String))
                let w = (indvChat["message"] as! String).width(withConstrainedHeight: 100, font: UIFont.josefinSansRegularFontWithSize(size: 14.0))
                
                if w < 40.0{
                    chatCell.widthConst.constant = w + (40.0 * screenWidthFactor)
                }
                else if w > 40.0, w < 180.0{
                    chatCell.widthConst.constant = w + (40.0 * screenWidthFactor)
                }
                else{
                    chatCell.widthConst.constant = 220.0 * screenWidthFactor
                }
                return chatCell
            }
        }
    }
}

extension ChatViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return suggestionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuggestionCell", for: indexPath) as! SuggestionCell
        cell.titleLabel.text = suggestionArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        messageTextView.text = suggestionArray[indexPath.row]
    }
}

class SuggestionCell:UICollectionViewCell{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        backView.layer.cornerRadius = backView.frame.size.height / 2
        backView.layer.borderWidth = 1
        backView.layer.borderColor = UIColor.black.cgColor
    }
}

//MARK: -Socket
let manager = SocketManager(socketURL: URL(string: Socket_URL)!, config: [.log(false), .compress])
var socket:SocketIOClient = manager.defaultSocket
var resetAck: SocketAckEmitter?

var isSocketConnected = false

var static_activated = ""
let SM = "message"

//extension ChatViewController {
    
    //MARK: - Socket Connection
    func socketConnection() {
        addHandlers()
        socket.connect()
        manager.reconnects = false
    }

    func socketDisconnected() {
        socket.disconnect()
    }

    func addHandlers() {
        socket.on("message") {data, ack in
            print("socket.on message")
            print(data)
            return
        }
        
        socket.on("connect") {data, ack in
            print("socket.on connect")
            isSocketConnected = true
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Noti_UserConnected"), object: nil)
        }
        
        socket.on("disconnect") {data, ack in
            print("socket.on disconnect")
            isSocketConnected = false
            socket.removeAllHandlers()
            socketConnection()
        }
        
        socket.onAny {
            print("Got event: \($0.event), with items: \($0.items!)")
            getEvent(event: $0.items)
        }
    }

    func getEvent(event : [Any]?) {
        if let array = event,array.count > 0 {
            if let obj = array[0] as? NSDictionary {
                print("Your data ---->",obj)
                if let obd = obj as? [String : Any] {
                    
                    if let sent_by = obd["sent_by"] as? String {
                        if(sent_by == "C") {
                            getMessage(dict: obd)
                        } else {
                            if let sender_id = obd["sender_id"] as? String {
                                if(sender_id == "") {
                                    profileInfo?.helper_id = obd["sender_id"] as? Int ?? 0
                                } else {
                                    if(profileInfo?.helper_id! != Int(sender_id)!) {
                                        getMessage(dict: obd)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func sendMessage(chat_id: String,msg_type: String,created_datetime: String,message: String,helper_read_flag: String,customer_read_flag: String,sent_by: String,customer_id: String,helper_id: String,image_url: String,name: String,photo_url: String,chat_type: String,sender_id: String,receiver_id: String) {
        let dictMain = NSMutableDictionary()
        dictMain.setValue(chat_id, forKey: "chat_id")
        dictMain.setValue(msg_type, forKey: "msg_type")
        dictMain.setValue(created_datetime, forKey: "created_datetime")
        dictMain.setValue(message, forKey: "message")
        dictMain.setValue(helper_read_flag, forKey: "helper_read_flag")
        dictMain.setValue(customer_read_flag, forKey: "customer_read_flag")
        dictMain.setValue(sent_by, forKey: "sent_by")
        dictMain.setValue(customer_id, forKey: "customer_id")
        dictMain.setValue(helper_id, forKey: "helper_id")
        dictMain.setValue(image_url, forKey: "image_url")
        dictMain.setValue(name, forKey: "name")
        dictMain.setValue(photo_url, forKey: "photo_url")
        dictMain.setValue(chat_type, forKey: "chat_type")
        dictMain.setValue(sender_id, forKey: "sender_id")
        dictMain.setValue(receiver_id, forKey: "receiver_id")
        socket.emit("message", dictMain)
    }

    func getMessage(dict : [String : Any]) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SM), object: dict, userInfo: dict as [AnyHashable : Any])
    }
//}
