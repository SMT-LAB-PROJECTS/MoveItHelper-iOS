//
//  AdminChatViewController.swift
//  MoveIt
//
//  Created by Govind Patidar on 2/15/22.
//  Copyright © 2022 Jyoti. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import CCBottomRefreshControl
import MLKit
import SocketIO
import AVFoundation
import Alamofire
import QCropper
import IQKeyboardManagerSwift
import Lightbox


enum Storyboards : String {
    case Main, AdminChat
    func identifier() -> String {
        return self.rawValue
    }
}

class AdminChatViewController: UIViewController {
    
    // MARK: - IBOutlate's ....
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var messageTextView: JVFloatLabeledTextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var movenolongerView: UIView!
    @IBOutlet weak var movenolongerLabel: UILabel!
    
    @IBOutlet weak var bottomConst: NSLayoutConstraint!
    @IBOutlet weak var suggestionHeightConst: NSLayoutConstraint!
    @IBOutlet weak var tblHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!

    // MARK: - Variable's ....
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var customer_ID = Int()
    var chatUserType = ChatUserType.Admin
    var helper_ID = Int()
    var Tohelper_ID = Int()
    var isFromInfo = false
    var pageIndex = 1
    var chat_ID = Int()
    var helperName = "Move It Support"
    var customerName = ""
    var helperImgUrl = ""
    var customerImgUrl = ""
    var phoneNum = ""
    var refreshControl: UIRefreshControl!
    var nextPageAvl = false
    
    var isHelperChat = false
    var allImage = [String]()
    var isRefresh :Bool = false
    var tempChatArray = [[String: Any]]()
    
    var suggestionArray = [String]()
    var alertPermmisionView :AlertViewPermmision?
    let imagePickerController = UIImagePickerController()

    
    var folder_name:String = "helper_admin_chat"
    let SM1 = "send-message-helper-admin"
    let isAdminCount = "is-read-message-helper-admin"
    
    var originalImage: UIImage?
    var cropperState: CropperState?
    var chatArray = [[String: Any]](){
        didSet{
            tempChatArray = chatArray
            if self.chatArray.count > 0{
                for i in (0 ..< tempChatArray.count - 1)  {
                    for j in i + 1 ..< tempChatArray.count  {
                        if (tempChatArray[i]["chat_id"] as? Int) ?? 0 == (tempChatArray[j]["chat_id"] as? Int) ?? 0 {
                            self.chatArray.remove(at: j)
                        }
                    }
                }
                self.tableView.reloadData()
                if self.chatArray.count > 0 {
                    self.tableView.scrollToRow(at: IndexPath(item:self.chatArray.count-1, section: 0), at: .bottom, animated: true)
                }
            }else{
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - View life cycle method's....
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerController.delegate = self
        socketConnection()
        self.navgationBarConfiguration()
        self.uiConfigurationAfterStoryboard()
        self.getAdminAllChats()
        self.adminCountManage()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        adminChatNotificationCount = 0

        self.navigationController?.navigationBar.isHidden = false
        self.uiConfigurationAfterStoryboard()
        NotificationCenter.default.addObserver(self, selector: #selector(addmsg(_:)), name: NSNotification.Name(rawValue: SM1), object: nil)
        refreshControl.addTarget(self, action: #selector(getAdminChatsRefresh), for: UIControl.Event.valueChanged)
        self.tableView.keyboardDismissMode = .interactive
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        socketDisconnected()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - Required method's....
    static func getVCInstance() -> UIViewController{
        // This method returns the instance on it self to push or present in Navigation.
        return UIStoryboard(name: Storyboards.AdminChat.rawValue, bundle: .main).instantiateViewController(withIdentifier: "\(String(describing: self))")
    }
    
    func navgationBarConfiguration() {
        let leftBarButtonItem = StaticHelper.leftBarButtonWithImageNamed(imageName: "backward_arrow_icon", vc: self)
        self.navigationItem.leftBarButtonItems = [leftBarButtonItem]
        setNavigationTitle(helperName)
        
    }
    
    func uiConfigurationAfterStoryboard() {
        
        sendButton.layer.cornerRadius = 15.0 * screenHeightFactor
        sendButton.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        tableView.contentInset = UIEdgeInsets.init(top: 10, left: 0, bottom: 10, right: 0)
        tableView.refreshControl = refreshControl
        refreshControl = UIRefreshControl()
        refreshControl.triggerVerticalOffset = 100.0
        self.tableView.refreshControl = refreshControl
        
        messageTextView.floatingLabelTextColor = UIColor.clear
        messageTextView.alwaysShowFloatingLabel = false
        messageTextView.floatingLabel.isHidden = true
    }
    func showMediaData(_ imgIndex: Int) {
        let images = allImage.map({ (str) -> LightboxImage in
            if let imgUrl = URL(string: str) {
                return LightboxImage(imageURL:  imgUrl)
            }
            return LightboxImage(image: UIImage(named: "home_card_img_placeholder")!)
        })
        
        let controller = LightboxController(images: images)
        controller.modalPresentationStyle = .fullScreen
        controller.dynamicBackground = true
        controller.footerView.pageLabel.isHidden = true
        let globeButton = controller.headerView.closeButton
        globeButton.setBackgroundImage(UIImage(named: "btn_gradient"), for: .normal)
        globeButton.frame.size = CGSize(width: 80, height: 30)
        globeButton.layer.cornerRadius = 15.0
        globeButton.layer.masksToBounds = true
        controller.goTo(imgIndex, animated: true)
        // presentingViewController?.present(controller, animated: true, completion: nil)
        present(controller, animated: true, completion: {
            //controller.overlayView.didMoveToSuperview()
        })
        
    }
    
    //MARK: - Actions...
    @objc func leftButtonPressed(_ selector: Any){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "REFRESH_ADMIN_CHAT_COUNT"), object: nil)
        socketDisconnected()
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func cameraGalleryAction(_ sender: Any) {
        showPermmisonPopup()
    }
    @IBAction func sendAction(_ sender: Any) {
        self.view.endEditing(true)
        let message = messageTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if message.isEmpty{
            self.view.makeToast("Please enter your message.")
            return
        }
        view.layoutIfNeeded()
        textViewHeightConstraint.constant = 60
        UIView.animate(withDuration: 0.5, animations: {
             self.view.layoutIfNeeded()
        })
        self.suggestionHeightConst.constant = 0
        self.sendMessage(message: message)
    }
   
}
extension AdminChatViewController{
    func uploadImages(_ image: UIImage){
        let httpheader: HTTPHeaders = ["Auth-Token": UserCache.userToken() ?? ""]
        let imageData = image.jpegData(compressionQuality: 0.6)
        
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: self, completion: nil)
            return
        }
        StaticHelper.shared.startLoader(self.view)
        
        let parametersDict : Parameters = ["folder_name": folder_name] as [String : Any]
        
        AF.upload(multipartFormData: {
            multipartFormData in
            multipartFormData.append(imageData!, withName: "vehicle_image",fileName: "profile_img.jpg", mimeType: "image/jpg")
            
            for (key, value) in parametersDict {
                if value is String {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                } else if value is Int {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                }
            }
            
        }, to: baseURL + kAPIMethods.upload_helper_vehicle_image, method: .post, headers: httpheader).responseJSON { (response) in
            
            DispatchQueue.main.async {
                defer{
                    StaticHelper.shared.stopLoader()
                }
                print("resp is \(response)")
                if response.response?.statusCode == 200{
                    print(response)
                    let iamgeURl = (((response.value as! [String:Any])["vehicle_image_url"] as! String))
                    print(iamgeURl)
                    self.sendImageAPICall(iamgeURl)
                    //self.imageUrls.append( URL.init(string:(((response.value as! [String:Any])["vehicle_image_url"] as! String)))!)
                    
                } else{
                    StaticHelper.shared.stopLoader()
                    
                    //self.imagesArray.removeLast()
                    self.view.makeToast("There is some issue while uploading image. Please upload again.")
                }
            }
        }
        
    }
    func sendImageAPICall(_ image_url:String)
    {
        let params = ["message":"","msg_type": 2,"image_url":image_url,"timezone": TimeZone.current.identifier] as [String : Any]
        print(params)
        
        CommonAPIHelper.sendMessageToAdmin(VC: self, params: params) { [self] (res, error, isSend) in
            if error == nil{
                if isSend{
                    
                    self.chatArray.insert(res!, at: 0)
                    //self.messageTextView.text = ""
                    self.tableView.scrollToRow(at: IndexPath.init(row: self.chatArray.count - 1, section: 0), at: .bottom, animated: true)
                    self.sendMessageToSoket(chat_id: "\(res!["chat_id"] as? Int ?? 0)", msg_type: "\(res!["msg_type"] as? Int ?? 0)", created_datetime: (res!["created_datetime"] as? String ?? ""), message: (res!["message"] as? String ?? ""),sent_by: (res!["sent_by"] as? String ?? ""), helper_id: "\(res!["helper_id"] as? Int ?? 0)", image_url: (res!["image_url"] as? String ?? ""), name: (res!["name"] as? String ?? ""), photo_url: (res!["image_url"] as? String ?? ""))
                }
                else{
                }
            }
        }
    }
    func sendMessage(message:String)
    {
        let params = ["msg_type": 1,"message":message, "image_url":"", "timezone": TimeZone.current.identifier] as [String : Any]
        
        CommonAPIHelper.sendMessageToAdmin(VC: self, params: params) { [self] (res, error, isSend) in
            if error == nil{
                if isSend{
                    self.chatArray.insert(res!, at: 0)
                    self.messageTextView.text = ""
                    self.tableView.scrollToRow(at: IndexPath.init(row: self.chatArray.count - 1, section: 0), at: .bottom, animated: true)
                    self.sendMessageToSoket(chat_id: "\(res!["chat_id"] as? Int ?? 0)", msg_type: "\(res!["msg_type"] as? Int ?? 0)", created_datetime: (res!["created_datetime"] as? String ?? ""), message: (res!["message"] as? String ?? ""),sent_by: (res!["sent_by"] as? String ?? ""), helper_id: "\(res!["helper_id"] as? Int ?? 0)", image_url: (res!["image_url"] as? String ?? ""), name: (res!["name"] as? String ?? ""), photo_url: (res!["image_url"] as? String ?? ""))
                    
                }else{
                    
                }
            }
        }
    }
    func adminCountManage(){
        let dictMain = NSMutableDictionary()
        dictMain.setValue(profileInfo?.helper_id, forKey: "helper_id")
        socket.emit("\(isAdminCount)", dictMain)
    }
    //MARK: - Notification
    @objc func addmsg(_ notification: Notification) {
        if let data = notification.object as? [String : Any] {
            if (data["sent_by"] as? String ?? "" == "A"){
                if let helepr_id = data["helper_id"] as? String {
                    if profileInfo?.helper_id == Int(helepr_id){
                        self.chatArray.insert(data, at: 0)
                        self.tableView.scrollToRow(at: IndexPath.init(row: self.chatArray.count - 1, section: 0), at: .bottom, animated: true)
                    }
                }else if let helepr_id1 = data["helper_id"] as? Int{
                    if profileInfo?.helper_id == helepr_id1{
                        self.chatArray.insert(data, at: 0)
                        self.tableView.scrollToRow(at: IndexPath.init(row: self.chatArray.count - 1, section: 0), at: .bottom, animated: true)
                    }
                }else{
                    print("")
                }
                //call for admin count chat....
                adminCountManage()
            } else {
                print("")
            }
        }
    }
    
    func sendMessageToSoket(chat_id: String,msg_type: String,created_datetime: String,message: String,sent_by: String,helper_id: String,image_url: String,name: String,photo_url: String) {
        let dictMain = NSMutableDictionary()
        dictMain.setValue(chat_id, forKey: "chat_id")
        dictMain.setValue(msg_type, forKey: "msg_type")
        dictMain.setValue(created_datetime, forKey: "created_datetime")
        dictMain.setValue(message, forKey: "message")
        dictMain.setValue(sent_by, forKey: "sent_by")
        dictMain.setValue(helper_id, forKey: "helper_id")
        dictMain.setValue(image_url, forKey: "image_url")
        dictMain.setValue(name, forKey: "name")
        dictMain.setValue(photo_url, forKey: "image_url")
        socket.emit("send-message-helper-admin", dictMain)
    }
    
    @objc func getAdminChatsRefresh(){
        CommonAPIHelper.getAdminChatMesages(true, VC: self, page_index: pageIndex, chat_id: chat_ID, completetionBlock:  { (result, error, hasNextPage, jobStatus) in
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
                        self.chatArray.append(contentsOf: result!)
                        self.tableView.reloadData()
                        self.tableView.scrollToRow(at: IndexPath(item:0, section: 0), at: .top, animated: true)
                    }
                    
                    if jobStatus == false {
                        self.collectionView.isHidden = true
                        //                        self.movenolongerView.isHidden = false
                        self.navigationItem.rightBarButtonItem?.customView?.isHidden = true
                    }
                    
                } else{
                    self.navigationItem.rightBarButtonItem?.customView?.isHidden = true
                }
            }
        })
    }
    
    func getAdminAllChats(_ isLoader:Bool = false){
        CommonAPIHelper.getAdminChatMesages(isLoader, VC: self, page_index: pageIndex, chat_id: chat_ID, completetionBlock:  { (result, error, hasNextPage, jobStatus) in
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
                        //                        self.movenolongerView.isHidden = false
                        self.navigationItem.rightBarButtonItem?.customView?.isHidden = true
                    }
                    
                    
                } else{
                    self.navigationItem.rightBarButtonItem?.customView?.isHidden = true
                }
            }
        })
    }
}
extension AdminChatViewController: UITableViewDelegate, UITableViewDataSource,UITextViewDelegate{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatCell = tableView.dequeueReusableCell(withIdentifier: "SendMessagesTableViewCell", for: indexPath) as! SendMessagesTableViewCell
        
        let indvChat = chatArray[chatArray.count - 1 - indexPath.row]
        
        if (indvChat["sent_by"] as! String) == "H"{
            if let msg_type = (indvChat["msg_type"] as? Int){
                if msg_type == 1{ // text..
                    let chatCell = tableView.dequeueReusableCell(withIdentifier: "SendMessagesTableViewCell", for: indexPath) as! SendMessagesTableViewCell
//                    chatCell.messageLabel.text = (indvChat["message"] as! String)
                    chatCell.timeLabel.text = (indvChat["created_datetime"] as! String)
                    chatCell.messageDisplayWay(message:(indvChat["message"] as! String) )
                    let w = (indvChat["message"] as! String).width(withConstrainedHeight: 100, font: UIFont.josefinSansRegularFontWithSize(size: 16.0))
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
                }else{// Image..
                    let chatImgCell = tableView.dequeueReusableCell(withIdentifier: "SendImageTableViewCell", for: indexPath) as! SendImageTableViewCell
                    chatImgCell.setSenderImage((indvChat["image_url"] ?? "") as! String)
                    chatImgCell.timeLabel.text = (indvChat["created_datetime"] as! String)
                    
                    return chatImgCell
                }
                
            }else if let msg_type = (indvChat["msg_type"] as? String){
                if msg_type == "1"{ // text..
                    let chatCell = tableView.dequeueReusableCell(withIdentifier: "SendMessagesTableViewCell", for: indexPath) as! SendMessagesTableViewCell
//                    chatCell.messageLabel.text = (indvChat["message"] as! String)
                    chatCell.timeLabel.text = (indvChat["created_datetime"] as! String)
                    chatCell.messageDisplayWay(message:(indvChat["message"] as! String) )

                    let w = (indvChat["message"] as! String).width(withConstrainedHeight: 100, font: UIFont.josefinSansRegularFontWithSize(size: 16.0))
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
                }else{// Image..
                    let chatImgCell = tableView.dequeueReusableCell(withIdentifier: "SendImageTableViewCell", for: indexPath) as! SendImageTableViewCell
                    chatImgCell.setSenderImage((indvChat["image_url"] ?? "") as! String)
                    chatImgCell.timeLabel.text = (indvChat["created_datetime"] as! String)
                    
                    return chatImgCell
                }
                
            }else{
                return chatCell
            }
            
        }else{
            
            if let msg_type = (indvChat["msg_type"] as? Int){
                if msg_type == 1{ // text..
                    let chatCell = tableView.dequeueReusableCell(withIdentifier: "ReceiveMessagesTableViewCell", for: indexPath) as! ReceiveMessagesTableViewCell
//                    chatCell.messageLabel.text = (indvChat["message"] as! String)
                    chatCell.timeLabel.text = (indvChat["created_datetime"] as! String)
                    chatCell.messageDisplayWay(message:(indvChat["message"] as! String) )

                    let w = (indvChat["message"] as! String).width(withConstrainedHeight: 100, font: UIFont.josefinSansRegularFontWithSize(size: 16.0))
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
                }else{// Image..
                    let chatImgCell = tableView.dequeueReusableCell(withIdentifier: "ReceiveImageTableViewCell", for: indexPath) as! ReceiveImageTableViewCell
                    chatImgCell.setReceiverImage((indvChat["image_url"] ?? "") as! String)
                    chatImgCell.timeLabel.text = (indvChat["created_datetime"] as! String)
                    
                    return chatImgCell
                }
            }else if let msg_type = (indvChat["msg_type"] as? String){
                if msg_type == "1"{ // text..
                    let chatCell = tableView.dequeueReusableCell(withIdentifier: "ReceiveMessagesTableViewCell", for: indexPath) as! ReceiveMessagesTableViewCell
//                    chatCell.messageLabel.text = (indvChat["message"] as! String)
                    chatCell.timeLabel.text = (indvChat["created_datetime"] as! String)
                    chatCell.messageDisplayWay(message:(indvChat["message"] as! String) )

                    let w = (indvChat["message"] as! String).width(withConstrainedHeight: 100, font: UIFont.josefinSansRegularFontWithSize(size: 16.0))
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
                }else{// Image..
                    let chatImgCell = tableView.dequeueReusableCell(withIdentifier: "ReceiveImageTableViewCell", for: indexPath) as! ReceiveImageTableViewCell
                    chatImgCell.setReceiverImage((indvChat["image_url"] ?? "") as! String)
                    chatImgCell.timeLabel.text = (indvChat["created_datetime"] as! String)
                    
                    return chatImgCell
                }
            }
            return chatCell
        }
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = tableView.cellForRow(at: indexPath)
        let indvChat = chatArray[chatArray.count - 1 - indexPath.row]
        allImage.removeAll()
        if let msg_type = (indvChat["msg_type"] as? Int){
            
            if msg_type == 2{
                let imgUrlStr = (indvChat["image_url"] as? String ?? "")
                allImage.append(imgUrlStr)
                showMediaData(indexPath.row)
            }
        }else if let msg_type = (indvChat["msg_type"] as? String){
            
            if msg_type == "2"{
                let imgUrlStr = (indvChat["image_url"] as? String ?? "")
                allImage.append(imgUrlStr)
                showMediaData(indexPath.row)
            }
        }
        
    }
    func setInputFieldHeight(_ textView: UITextView){
        let numberOfLinesVisbleCount = (textView.numberOfLines())
        print("Line linesAfterChange textview:- \(textView.numberOfLines())")
        view.layoutIfNeeded()
        if numberOfLinesVisbleCount < 4{textViewHeightConstraint.constant = 60
        }else if numberOfLinesVisbleCount < 5{textViewHeightConstraint.constant = 80
        }else if numberOfLinesVisbleCount < 6{textViewHeightConstraint.constant = 100
        }else if numberOfLinesVisbleCount < 7{textViewHeightConstraint.constant = 120
        }else if numberOfLinesVisbleCount < 8{textViewHeightConstraint.constant = 150
        }else{textViewHeightConstraint.constant = 150
        }
        UIView.animate(withDuration: 0.5, animations: {
             self.view.layoutIfNeeded()
        })
    }
 
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        setInputFieldHeight(textView)
        return true //linesAfterChange <= textView.textContainer.maximumNumberOfLines
    }
}

extension AdminChatViewController: UICollectionViewDelegate, UICollectionViewDataSource{
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
extension AdminChatViewController{
    func showPermmisonPopup(){
        let permission = PermissionCameraHelper()
        let permissionPhoto = PermissionPhotoHelper()
        if permission.checkCameraPermission() == .notDetermined {
            let permission = PermissionCameraHelper()
            permission.requestCameraPermission { (status) in
            }
        }
        if permissionPhoto.checkPhotoPermission() == .notDetermined {
            let permission2 = PermissionPhotoHelper()
            permission2.requestPhotoPermission { (status) in
            }
        }
        if permission.checkCameraPermission() == .denied && permissionPhoto.checkPhotoPermission() == .denied {
            showPermmisonAlert(AlertButtonTitle.alert, kStringPermission.cameraGalaryMessageTitle, kStringPermission.photosHelperSupportMessage)
        }else{
            actionSheet()
        }
        
    }
    func actionSheet(){
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)//Choose from your choice
        
        let action1 = UIAlertAction(title: kStringPermission.takePhoto, style: .default) { (action:UIAlertAction) in
            
            let permission = PermissionCameraHelper()
            if permission.checkCameraPermission() == .accepted {
                self.openCamera()
            }else{
                self.showPermmisonAlert(AlertButtonTitle.alert,kStringPermission.cameraMessageTitle, kStringPermission.photosHelperSupportMessage)
            }
        }
        
        let action2 = UIAlertAction(title: kStringPermission.choosePhoto, style: .default) { (action:UIAlertAction) in
            
            let permission = PermissionPhotoHelper()
            if permission.checkPhotoPermission() == .accepted {
                self.openGallery()
            }else{
                self.showPermmisonAlert(AlertButtonTitle.alert,kStringPermission.galaryMessageTitle, kStringPermission.photosHelperSupportMessage)
            }
        }
        
        let action3 = UIAlertAction(title: AlertButtonTitle.cancel, style: .cancel) { (action:UIAlertAction) in
            self.dismiss(animated: true, completion: {})
        }
        
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        actionSheet.addAction(action3)
        
        //   DispatchQueue.main.async {
        if UIDevice.current.userInterfaceIdiom == .pad{
            if let popoverController = actionSheet.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            self.present(actionSheet, animated: true, completion: nil)
        }
        else if UIDevice.current.userInterfaceIdiom == .phone {
            self.present(actionSheet, animated: true, completion: {})
        }
    }
    func openCamera() {
        
        //  DispatchQueue.main.async {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            //already authorized
            self.imagePickerController.allowsEditing = false
            self.imagePickerController.sourceType = UIImagePickerController.SourceType.camera
            self.imagePickerController.cameraCaptureMode = .photo
            self.imagePickerController.modalPresentationStyle = .fullScreen
            self.present(self.imagePickerController,animated: true,completion: nil)
        }else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    return
                }else {
                    self.alertPromptToAllowCameraAccessViaSetting()
                }
            })
        }
    }
    
    func openGallery(){
        // DispatchQueue.main.async {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            self.imagePickerController.allowsEditing = false
            self.imagePickerController.sourceType = .photoLibrary
            self.imagePickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
    }
    
    //MARK: - Allow Camera in settings
    func alertPromptToAllowCameraAccessViaSetting() {
        
        let alert = UIAlertController(
            title: nil,
            message: "Camera Permission is required to upload vehicle photo.",
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { alert in
            if AVCaptureDevice.devices(for: AVMediaType.video).count > 0 {
                AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
                }
            }
        }
        )
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { alert in
            if AVCaptureDevice.devices(for: AVMediaType.video).count > 0 {
                AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
                    DispatchQueue.main.async() {
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                    print("Settings opened: \(success)") // Prints true
                                })
                            } else {
                                // Fallback on earlier versions
                                if UIApplication.shared.canOpenURL(settingsUrl) {
                                    UIApplication.shared.openURL(settingsUrl)
                                }
                                
                            }
                        }
                        
                    } }
            }
        })
        
        DispatchQueue.main.async() {
            self.present(alert, animated: true, completion: nil)
        }
    }
}


extension AdminChatViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    //********************************
    //MARK: - Image Picker Methods
    //********************************
 
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var image : UIImage!
        
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            image = img
        } else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = img
        }
        self.originalImage = image
        
        let cropper = CropperViewController(originalImage: image)
        
        cropper.delegate = self
        
        picker.dismiss(animated: true) {
            self.present(cropper, animated: true, completion: nil)
        }

    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}
extension AdminChatViewController{
    
    //MARK: - Socket Connection
    func socketConnection() {
        addHandlers()
        socket.connect()
        manager.reconnects = false
    }
    
    func socketDisconnected() {
        socket.removeAllHandlers()
        socket.disconnect()
        socket.off(SM1)
    }
    
    func addHandlers() {
        socket.on("send-message-helper-admin") {data, ack in
            print("socket.on message")
            // self.tableView.reloadData()
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
        }
        
        socket.onAny {
            print("Got event: \($0.event), with items: \($0.items!)")
            self.getEvent(event: $0.items)
        }
    }
    
    func getEvent(event : [Any]?) {
        if let array = event,array.count > 0 {
            if let obj = array[0] as? NSDictionary {
                print("Your data ---->",obj)
                if let obd = obj as? [String : Any] {
                    if let sent_by = obd["sent_by"] as? String {
                        if(sent_by == "A") {
                            getMessage(dict: obd)
                        }
                    }
                }
            }
        }
    }
    
    func getMessage(dict : [String : Any]) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SM1), object: dict, userInfo: dict as [AnyHashable : Any])
    }
}
extension AdminChatViewController: CropperViewControllerDelegate {
    func cropperDidConfirm(_ cropper: CropperViewController, state: CropperState?) {
        cropper.dismiss(animated: true, completion: nil)
        
        if let state = state,
            let image = cropper.originalImage.cropped(withCropperState: state) {
            //self.cropImageView.image = image
            
            socketConnection()
            self.uploadImages(image)
        } else {
            print("Something went wrong")
        }
            
        }
}

// MARK: - ALert Permmison method's ....
extension AdminChatViewController:AlertViewPermmisionDelegate{
    func alertViewPermmisionCLick(isOk: Bool) {
        alertPermmisionView!.removeFromSuperview()
        alertPermmisionView = nil
        if isOk {
            let permission = PermissionCameraHelper()
            permission.requestCameraPermission { (status) in
            }
            let permission2 = PermissionPhotoHelper()
            permission2.requestPhotoPermission { (status) in
            }
        }
    }
    func showPermmisonAlert(_ popUpTitleMsg:String, _ titleMsg:String, _ message:String) {
       self.view.endEditing(true)
        alertPermmisionView = AlertViewPermmision(frame: appDelegate.window!.bounds)
        alertPermmisionView!.delegate = self
        alertPermmisionView!.strPopupTitle = popUpTitleMsg
        alertPermmisionView!.strTitleMessage = titleMsg
        alertPermmisionView!.strMessage = message
       appDelegate.window?.addSubview(alertPermmisionView!)
    }
}

//extension UITextView {
//    var numberOfCurrentlyDisplayedLines: Int {
//        let size = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
//        //for Swift <=4.0, replace with next line:
//        //let size = systemLayoutSizeFitting(UILayoutFittingCompressedSize)
//        return Int(((size.height - layoutMargins.top - layoutMargins.bottom) / font!.lineHeight))
//    }
//
//    /// Removes last characters until the given max. number of lines is reached
//    func removeTextUntilSatisfying(maxNumberOfLines: Int) {
//        while numberOfCurrentlyDisplayedLines > (maxNumberOfLines) {
//            text = String(text.dropLast())
//            layoutIfNeeded()
//        }
//    }
//}
//
//// Use it in UITextView's delegate method:
//func textViewDidChange(_ textView: UITextView) {
//    textView.removeTextUntilSatisfying(maxNumberOfLines: 10)
//}
extension UITextView{

    func numberOfLines() -> Int{
        if let fontUnwrapped = self.font{
            return Int(self.contentSize.height / fontUnwrapped.lineHeight)
        }
        return 0
    }

}
