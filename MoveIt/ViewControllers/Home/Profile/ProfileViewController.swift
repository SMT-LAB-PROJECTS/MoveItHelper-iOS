//
//  ProfileViewController.swift
//  MoveIt
//
//  Created by Dushyant on 24/06/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ProfileViewController: UIViewController {
  
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var imageBkView: UIView!
    @IBOutlet weak var ratingNumLabel: UILabel!
    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var helperImgView: UIImageView!
    @IBOutlet weak var helperProfileButton: UIButton!
    
    @IBOutlet weak var versionLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumLabel: UILabel!
    @IBOutlet weak var phoneNumTextField: UITextField!
    
    @IBOutlet weak var phoneNumEditButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var footerView: UIView!
    var profileOptionsArray = ["Vehicle Info","Accounting","Tip Payment Info","Payment Info","Change Service","W-9 form", "Helper Agreement", "App Tutorial", "Reset Password", "Account Settings", "Move It Helper Support"]
    
    var veheicleInfo = [String: Any]()
    var isEditPressed = false
    var message_notification_count = 0
    var profilePhoto = UIImage(){
        didSet{
            helperImgView.image = profilePhoto
            helperImgView.layer.cornerRadius = 8
            helperImgView.clipsToBounds = true
        }
    }
    
    var alertPermmisionView :AlertViewPermmision?
    var alertView :AlertPopupView?
    var profileURL = String()
    let imagePickerController = UIImagePickerController()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(getProfileInfo), name: NSNotification.Name(rawValue: "getProfileInfo"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getAdminChatCount), name: NSNotification.Name(rawValue: "ADMIN_CHAT_COUNT"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshAdminChatCount), name: NSNotification.Name(rawValue: "REFRESH_ADMIN_CHAT_COUNT"), object: nil)

        print("BEFORE = ", headerView.frame.size.height)
        headerView.backgroundColor = .white
        headerView.frame.size.height = headerView.frame.size.height-(SCREEN_HEIGHT-667)
        print("AFTER = ", headerView.frame.size.height)
        
        setNavigationTitle("My Profile")
        
        imageBkView.layer.cornerRadius = 8
        imageBkView.clipsToBounds = true
        
        if let versionLocal = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionLabel.text = "Version \(versionLocal)"
        }
        NotificationCenter.default.addObserver(self, selector: #selector(ReloadProfileView), name: NSNotification.Name(rawValue: "ReloadProfileView"), object: nil)
        logoutButton.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 15.0)
        userNameLabel.font            = UIFont.josefinSansSemiBoldFontWithSize(size: 15.0)
        userNameTextField.font        = UIFont.josefinSansSemiBoldFontWithSize(size: 15.0)
        ratingsLabel.font             = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        ratingNumLabel.font           = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        emailLabel.font               = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        phoneNumLabel.font            = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        
        let leftBarButtonItem = StaticHelper.leftBarButtonWithImageNamed(imageName: "backward_arrow_icon", vc: self)
        let rightBarTextButton =  StaticHelper.rightBarButtonWithText(text: "Edit", vc: self)
        userNameTextField.isUserInteractionEnabled = false
        phoneNumTextField.isUserInteractionEnabled = false
        
        helperProfileButton.isHidden = true
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        self.navigationItem.rightBarButtonItem = rightBarTextButton
        
        
        if profileInfo != nil{
            self.setupData()
        } else {
            if UserCache.userToken() != nil {
                self.getProfileInfo()
            }
        }
        self.getAdminChatCount()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()

    }
    @objc func ReloadProfileView() {
        phoneNumTextField.text = profileInfo?.phone_num!
        self.navigationController?.isNavigationBarHidden = false
    }

    func setupData(){
        
        if ((profileInfo?.service_type ?? 1) == 1) || ((profileInfo?.service_type ?? 1) == 3){
            profileOptionsArray = ["Vehicle Info","Accounting","Tip Payment Info","Payment Info","Change Service","W-9 form", "Helper Agreement", "App Tutorial", "Reset Password", "Account Settings", "Move It Helper Support"]
        } else{
            profileOptionsArray = ["Accounting","Tip Payment Info","Payment Info","Change Service","W-9 form", "Helper Agreement", "App Tutorial", "Reset Password", "Account Settings", "Move It Helper Support"]
        }
        
        userNameTextField.text = (profileInfo?.first_name!)! + " " + (profileInfo?.last_name!)!
        emailTextField.text = profileInfo?.email_id!
        phoneNumTextField.text = profileInfo?.phone_num!
        self.ratingNumLabel.text = String.init(format: "%.1f", (profileInfo?.avarage_rating!)!)
        if let photoURL = profileInfo?.photo_url,!photoURL.isEmpty{
            let url = URL.init(string: photoURL)
            helperImgView.af.setImage(withURL: url!)
        }
        tableView.reloadData()
    }
    func logoutServiceCall(){
        callAnalyticsEvent(eventName: "moveit_logout", desc: ["description":"\(profileInfo?.helper_id ?? 0) called logout function"])
        LocationUpdateGlobal.shared.stopUpdatingLocation()
        UserCache.shared.clearUserData()
        self.navigationController?.popToRootViewController(animated: false)
    }

    //MARK: - Actions
    @IBAction func editPhoneNumPressed(_ sender: UIButton) {
        let phoneNumVerificationVC = self.storyboard?.instantiateViewController(withIdentifier: "PhoneNumberVerificationVC") as! PhoneNumberVerificationVC
        phoneNumVerificationVC.isEdit = true
        self.navigationController?.pushViewController(phoneNumVerificationVC, animated: true)
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        self.showLogOutPopup(AlertButtonTitle.alert, kStringPermission.logout, AlertButtonTitle.no, AlertButtonTitle.yes)
        
//        let alertController = UIAlertController.init(title: "Are you sure you want to log out?", message: "", preferredStyle: .alert)
//
//        let yesButton = UIAlertAction.init(title: "Yes", style: .default) { (_) in
//            logoutServiceCall()
//        }
//
//        let cancelButton = UIAlertAction.init(title: "No", style: .cancel, handler: nil)
//
//        alertController.addAction(yesButton)
//        alertController.addAction(cancelButton)
//        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func leftButtonPressed(_ selector: Any){
        self.navigationController?.popViewController(animated: false)
    }

    @objc func rightTextPressed(_ selector: UIButton){
        
        if isEditPressed{
            isEditPressed = false
            let rightBarTextButton =  StaticHelper.rightBarButtonWithText(text: "Edit", vc: self)
            userNameTextField.isUserInteractionEnabled = false
//            phoneNumTextField.isUserInteractionEnabled = false
            phoneNumEditButton.isHidden = true
            self.navigationItem.rightBarButtonItem = rightBarTextButton
            helperProfileButton.isHidden = true
            photoUploadAction(profilePhoto)
        }
        else{
            let rightBarTextButton =  StaticHelper.rightBarButtonWithText(text: "Save", vc: self)
            userNameTextField.isUserInteractionEnabled = true
            phoneNumEditButton.isHidden = false
            self.navigationItem.rightBarButtonItem = rightBarTextButton
            isEditPressed = true
            userNameTextField.becomeFirstResponder()
            helperProfileButton.isHidden = false
        }
    }
   
    @IBAction func profileImagePressed(_ sender: Any) {
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
            showPermmisonAlert(AlertButtonTitle.alert, kStringPermission.cameraGalaryMessageTitle, kStringPermission.photosProfileMessage)
        }else{
            self.showActionSheet(in: self, title: "", message: kStringPermission.pickAnOption, buttonArray:  [kStringPermission.takePhoto, kStringPermission.choosePhoto], completion:{ (index) in
                if index == 0 {
                    let permission = PermissionCameraHelper()
                    if permission.checkCameraPermission() == .accepted {
                        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
                            self.imagePickerController.sourceType = .camera
                            //self.imagePickerController.allowsEditing = true
                            self.imagePickerController.cameraCaptureMode = .photo
                            self.imagePickerController.modalPresentationStyle = .fullScreen
                            self.imagePickerController.delegate = self
                            self.navigationController?.present(self.imagePickerController, animated: true, completion: nil)
                        }else{
                            let alert  = UIAlertController(title: kStringPermission.warning, message: kStringPermission.youDontHaveCamera, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: AlertButtonTitle.ok, style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }else{
                        self.showPermmisonAlert(AlertButtonTitle.alert, kStringPermission.cameraMessageTitle, kStringPermission.photosProfileMessage)
                    }
                }else if index == 1 {
                    let permission = PermissionPhotoHelper()
                    if permission.checkPhotoPermission() == .accepted {
                        self.imagePickerController.sourceType = .photoLibrary
                        //self.imagePickerController.allowsEditing = true
                        self.imagePickerController.delegate = self
                        self.navigationController?.present(self.imagePickerController, animated: true, completion: nil)
                    }else{
                        self.showPermmisonAlert(AlertButtonTitle.alert, kStringPermission.galaryMessageTitle, kStringPermission.photosProfileMessage)
                    }
                }else{
                    self.imagePickerController.dismiss(animated: true, completion: {})
                }
            })
        }
    }
    
    //MARK: - API
    @objc func getProfileInfo(){
         CommonAPIHelper.getProfile(VC: self) { (res, err, isExecuted) in
             if isExecuted{
                 DispatchQueue.main.async {
                     profileInfo =  HelperDetailsModel.init(profileDict: res!)
                     self.setupData()
                 }
             }
         }
     }
    @objc func getAdminChatCount(){
        CommonAPIHelper.getHelperNotificationCount(true, VC: self) { (result, error, status) in
            if (status == true){
                if let message_notification_count = result?["admin_chat_count"] as? Int {
                    self.tableView.reloadData()
                    self.message_notification_count = message_notification_count
                    adminChatNotificationCount = message_notification_count
//                    if adminChatNotificationCount != 0{
//                        self.navigationItem.leftBarButtonItem!.setBadge(text: "\(adminChatNotificationCount)")
//                    }
                }
            }
        }
    }
    
    func uploadImages(_ image: UIImage){
        
        let httpheader:HTTPHeaders = ["Auth-Token": UserCache.userToken() ?? ""]
        let imageData = image.jpegData(compressionQuality: 0.6)
        //StaticHelper.shared.startLoader(self.view)
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: self, completion: nil)
            return
        }
        callAnalyticsEvent(eventName: "moveit_update_profile", desc: ["description":"By profile picture"])
        let parametersDict : Parameters = ["folder_name": "vehicle_image"] as [String : Any]
        
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
            defer{
                StaticHelper.shared.stopLoader()
            }
            print("resp is \(response)")
            StaticHelper.shared.stopLoader()
            if response.response?.statusCode == 200{
                self.profileURL = ((response.value as! [String:Any])["vehicle_image_url"] as! String)
            } else{
                 
            }
        }
            
    }
        
    func photoUploadAction(_ image: UIImage) {
        if (userNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!.isEmpty{
            self.view.makeToast("Please enter your name.")
            return
        }
        if (phoneNumTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!.isEmpty{
            self.view.makeToast("Please enter mobile number.")
            return
        }
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: self, completion: nil)
            return
        }
        if profilePhoto.size != CGSize.zero{
            let phoneNum = UserCache.shared.userInfo(forKey: kUserCache.phone_num) as! String
            
            let httpheader:HTTPHeaders = ["Auth-Token": UserCache.userToken() ?? ""]
            let imageData = profilePhoto.jpegData(compressionQuality: 0.6)
            
            StaticHelper.shared.startLoader(self.view)
            let firstname = String((userNameTextField.text?.split(separator: " ").first!)!)
            
            var lastName = ""
            if (userNameTextField.text?.split(separator: " ").count)! >= 2{
                lastName = String((userNameTextField.text?.split(separator: " ").last!)!)
            }
            
            callAnalyticsEvent(eventName: "moveit_update_profile", desc: ["description":"By profile picture"])
            let parametersDict : Parameters = ["last_name": lastName,"first_name":firstname,"phone_num":(phoneNumTextField.text)!] as [String : Any]
            
            AF.upload(multipartFormData: {
                multipartFormData in
                multipartFormData.append(imageData!, withName: kUserCache.photo_url,fileName: "profile_img.jpg", mimeType: "image/jpg")
                for (key, value) in parametersDict {
                    if value is String {
                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                    } else if value is Int {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                    }
                }
            }, to: baseURL + kAPIMethods.update_helper_profile, method: .post, headers: httpheader).responseJSON { (response) in
                defer{
                    StaticHelper.shared.stopLoader()
                }
                print("resp is \(response)")
                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200{
                    print(response.value as! [String:Any])
                    profileInfo?.first_name = firstname
                    profileInfo?.last_name = lastName
                    profileInfo?.phone_num = self.phoneNumTextField.text
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getProfileInfo"), object: nil)
                    self.view.makeToast("Your profile has been updated successfully.")
                } else{
                    self.view.makeToast("There is some issue while updating profile. Please try again.")
                }
            }
            
        }
        else{
            let phoneNum = UserCache.shared.userInfo(forKey: kUserCache.phone_num) as! String
            
            let httpheader: HTTPHeaders = ["Auth-Token": UserCache.userToken() ?? ""]
            
            StaticHelper.shared.startLoader(self.view)
            let firstname = String((userNameTextField.text?.split(separator: " ").first!)!)
            
            var lastName = ""
            if (userNameTextField.text?.split(separator: " ").count)! >= 2{
                lastName = String((userNameTextField.text?.split(separator: " ").last!)!)
            }
            
            callAnalyticsEvent(eventName: "moveit_update_profile", desc: ["description":"Informtion has changed"])
            let parametersDict : Parameters = ["last_name": lastName,"first_name":firstname,"phone_num":(phoneNumTextField.text)!] as [String : Any]
            AF.request(baseURL + kAPIMethods.update_helper_profile, method: .post, parameters: parametersDict, headers: httpheader).responseJSON { (response) in
                
                DispatchQueue.main.async {
                switch response.result {
                case .success:
                    if response.response?.statusCode == 200{
                        StaticHelper.shared.stopLoader()
                        print(response.value as! [String:Any])
                        profileInfo?.first_name = firstname
                        profileInfo?.last_name = lastName
                        profileInfo?.phone_num = self.phoneNumTextField.text
                        self.view.makeToast("Your profile has been updated successfully.")
                    }
                    else if response.response?.statusCode == 401{
                        StaticHelper.shared.stopLoader()
                        let responseJson = response.value as! [String: AnyObject]
                        self.view.makeToast(responseJson["message"] as? String)
                    }
                case .failure(let error):
                    StaticHelper.shared.stopLoader()
                    self.view.makeToast(error.localizedDescription)
                }
                }
            }
        }
    }
    func reloadNotificationCountAdmin() {
        if adminChatNotificationCount != 0{
            DispatchQueue.main.async {
                self.navigationItem.leftBarButtonItem!.setBadge(text: "")
            }
        }
    }
    @objc func refreshAdminChatCount(){
        self.tableView.reloadData()
    }
}

extension ProfileViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileOptionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfilOptionTableViewCell", for: indexPath) as! ProfilOptionTableViewCell
        cell.optionLabel.text = profileOptionsArray[indexPath.row]
        cell.messageCountView.isHidden = true
        
        if cell.optionLabel.text == "Move It Helper Support"{
            if adminChatNotificationCount != 0 {
                cell.messageCountLabel.text = "\(adminChatNotificationCount)"
                cell.messageCountView.isHidden = false

            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if profileInfo == nil {
            return
        }
        if profileInfo?.service_type == HelperType.Muscle {
            switch indexPath.row {
            case 0:
               let accountingVC = self.storyboard?.instantiateViewController(withIdentifier: "AccountingInfoViewController") as! AccountingInfoViewController
               self.navigationController?.pushViewController(accountingVC, animated: true)
            case 1:
                callAnalyticsEvent(eventName: "moveit_check_tip_info", desc: ["description":"\(profileInfo?.helper_id ?? 0) checked tip info"])
                let paymentVC = self.storyboard?.instantiateViewController(withIdentifier: "TipsViewController") as! TipsViewController
                self.navigationController?.pushViewController(paymentVC, animated: true)
            case 2:
                callAnalyticsEvent(eventName: "moveit_check_payment_info", desc: ["description":"\(profileInfo?.helper_id ?? 0) checked payment info"])
                let paymentVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
                self.navigationController?.pushViewController(paymentVC, animated: true)
            case 3:
                let changeserviceVC = self.storyboard?.instantiateViewController(withIdentifier: "ChangeServiceViewController") as! ChangeServiceViewController
                changeserviceVC.selectService = profileInfo?.service_type
                self.navigationController?.pushViewController(changeserviceVC, animated: true)
            case 4:
                let w9FormVC = W9FormViewController()
                w9FormVC.isFromProfile = true
                self.navigationController?.pushViewController(w9FormVC, animated: true)
            case 5:
                let webViewObj = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                webViewObj.titleString = "Agreement"
                webViewObj.urlString = appDelegate.baseContentURL + kAPIMethods.get_agreement_mobile + "?auth_key=" + UserCache.userToken()!
                webViewObj.isComeFromAgreement = true
                self.navigationController?.pushViewController(webViewObj, animated: true)
            case 6:
                let tutorialVC = TutorialViewController()
                self.navigationController?.pushViewController(tutorialVC, animated: false)
            case 7:
                callAnalyticsEvent(eventName: "moveit_reset_password", desc: ["description":"Password reset successfully"])
                let resetPassVC = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordViewController") as! ResetPasswordViewController
                resetPassVC.isFromProfile = true
                self.navigationController?.pushViewController(resetPassVC, animated: true)
            case 8:
                let objProfileDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewControllerDetails") as! ProfileViewControllerDetails
                self.navigationController?.pushViewController(objProfileDetailsVC, animated: true)
            case 9:
//                callAnalyticsEvent(eventName: "moveit_reset_password", desc: ["description":"Password reset successfully"])
                self.message_notification_count = 0

                let adminChatVC = AdminChatViewController.getVCInstance() as! AdminChatViewController
                //                adminChatVC.isFromProfile = true
                self.navigationController?.pushViewController(adminChatVC, animated: true)
                
                
            default:
                break
            }
        }
        else {
            switch indexPath.row {

            case 0:
                callAnalyticsEvent(eventName: "moveit_vehicle_type", desc: ["description":"\(profileInfo?.helper_id ?? 0) checked vehicle info"])
                let vehicleVC = self.storyboard?.instantiateViewController(withIdentifier: "VehicleInfoViewController") as! VehicleInfoViewController
                self.navigationController?.pushViewController(vehicleVC, animated: true)
             case 1:
                let vehicleVC = self.storyboard?.instantiateViewController(withIdentifier: "AccountingInfoViewController") as! AccountingInfoViewController
                self.navigationController?.pushViewController(vehicleVC, animated: true)
            case 2:
                callAnalyticsEvent(eventName: "moveit_check_tip_info", desc: ["description":"\(profileInfo?.helper_id ?? 0) checked tip info"])
                let paymentVC = self.storyboard?.instantiateViewController(withIdentifier: "TipsViewController") as! TipsViewController
                self.navigationController?.pushViewController(paymentVC, animated: true)
            case 3:
                callAnalyticsEvent(eventName: "moveit_check_payment_info", desc: ["description":"\(profileInfo?.helper_id ?? 0) checked payment info"])
                let paymentVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
                self.navigationController?.pushViewController(paymentVC, animated: true)
            case 4:
                let changeserviceVC = self.storyboard?.instantiateViewController(withIdentifier: "ChangeServiceViewController") as! ChangeServiceViewController
                changeserviceVC.selectService = profileInfo?.service_type
                self.navigationController?.pushViewController(changeserviceVC, animated: true)
            case 5:
                let w9FormVC = W9FormViewController()
                w9FormVC.isFromProfile = true
                self.navigationController?.pushViewController(w9FormVC, animated: true)
            case 6:
                let webViewObj = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                webViewObj.titleString = "Agreement"
                webViewObj.urlString = appDelegate.baseContentURL + kAPIMethods.get_agreement_mobile + "?auth_key=" + UserCache.userToken()!
                webViewObj.isComeFromAgreement = true
                self.navigationController?.pushViewController(webViewObj, animated: true)
            case 7:
                let tutorialVC = TutorialViewController()
                self.navigationController?.pushViewController(tutorialVC, animated: false)
            case 8:
                callAnalyticsEvent(eventName: "moveit_reset_password", desc: ["description":"Password reset successfully"])
                let resetPassVC = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordViewController") as! ResetPasswordViewController
                resetPassVC.isFromProfile = true
                self.navigationController?.pushViewController(resetPassVC, animated: true)
            case 9:
                let objProfileDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewControllerDetails") as! ProfileViewControllerDetails
                self.navigationController?.pushViewController(objProfileDetailsVC, animated: true)
            case 10:
                
    //                callAnalyticsEvent(eventName: "moveit_reset_password", desc: ["description":"Password reset successfully"])
                self.message_notification_count = 0
                adminChatNotificationCount = 0

                    let adminChatVC = AdminChatViewController.getVCInstance() as! AdminChatViewController
                    //   adminChatVC.isFromProfile = true
                    self.navigationController?.pushViewController(adminChatVC, animated: true)
                
            default:
                
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
//MARK: -
extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let vehicleImgCell = collectionView.dequeueReusableCell(withReuseIdentifier: "VehicleImageCollectionViewCell", for: indexPath) as! VehicleImageCollectionViewCell

        return vehicleImgCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 40.0 * screenWidthFactor, height:  40.0 * screenWidthFactor)
    }
}

extension ProfileViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    //********************************
    //MARK: - Image Picker Methods
    //********************************
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        let photo = info[UIImagePickerController.InfoKey.originalImage] as! UIImage?
        profilePhoto = photo!
        self.dismiss(animated: true, completion: nil)
    }
    
    func showActionSheet(in controller: UIViewController, title: String?, message: String?, buttonArray: [String], completion block: @escaping (_ buttonIndex: Int) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for buttonTitle: String in buttonArray{
            let alertAction = UIAlertAction(title: buttonTitle, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                let index: Int = (buttonArray as NSArray).index(of: action.title ?? "defaultValue")
                block(index)
            })
            alertController.addAction(alertAction)
        }
        let alertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            block(buttonArray.count)
        })
        alertController.addAction(alertAction)
        DispatchQueue.main.async {
            if UIDevice.current.userInterfaceIdiom == .pad{
                if alertController.responds(to: #selector(getter: self.popoverPresentationController)) {
                    alertController.popoverPresentationController?.sourceView = self.helperImgView
                    alertController.popoverPresentationController?.sourceRect = self.helperImgView.bounds
                    self.present(alertController, animated: true, completion: {})
                }
                
            }
            else if UIDevice.current.userInterfaceIdiom == .phone {
                controller.present(alertController, animated: true, completion: {})
            }
        }
    }
}

// MARK: - ALert Permmison/Logout method's....
extension ProfileViewController:AlertViewPermmisionDelegate{
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
    
    //Logout...
    func showLogOutPopup(_ popUpTitleMsg:String = "", _ message:String,  _ cancelButtonTitle:String = "",  _ okButtonTitle:String = "", _ centerOkButtonTitle:String = ""){
        self.view.endEditing(true)
        AlertPopupView.instance.shwoDataWithClosures(popUpTitleMsg, message, cancelButtonTitle, okButtonTitle, centerOkButtonTitle){ status in
            if status{
                print("Okay")
                self.logoutServiceCall()
            }else{
                print("NO/Cancel")
            }
        }
    }
}


