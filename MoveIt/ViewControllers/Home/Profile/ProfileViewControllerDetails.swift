//
//  ProfileViewControllerDetails.swift
//  MoveIt
//
//  Created by SMT LABS 1 on 14/07/22.
//  Copyright © 2022 Jyoti. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import FirebaseAnalytics

protocol UpdateProfileDelegate {
   func profileUpdated()
}

class ProfileViewControllerDetails: UIViewController,UITextFieldDelegate{//, PasswordUpdatedDelegate, PhoneAuthVCDelegate

    @IBOutlet weak var scrlView: UIScrollView!
    
   @IBOutlet weak var nameLabel: UILabel!
  
   @IBOutlet weak var nameTextField: UITextField!
   @IBOutlet weak var imageBkView: UIView!
   @IBOutlet weak var imgView: UIImageView!
   @IBOutlet weak var userImgButton: UIButton!
   
   @IBOutlet weak var emailLabel: UILabel!
   @IBOutlet weak var emailTextField: UITextField!
   @IBOutlet weak var phoneNumLabel: UILabel!
   @IBOutlet weak var phoneNumberTextField: UITextField!
   
   @IBOutlet weak var resetPassButton: UIButton!
 
   @IBOutlet weak var btnImgView: UIImageView!
   var updateProfileDelegate: UpdateProfileDelegate?
   
   var profilePhoto = UIImage(){
       didSet{
           imgView.image = profilePhoto
       }
   }
   var isEditPressed = false
   let imagePickerController = UIImagePickerController()
   var imgURLString = String()
    var alertPermmisionView :AlertViewPermmision?

   @IBOutlet weak var phoneNumButton: UIButton!
   @IBOutlet weak var phoneNumEditImgView: UIImageView!
    @IBOutlet weak var emailIdEditImgView: UIImageView!
    
    var screenStatusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }

   //MARK: - Life Cycle Methods
   override func viewDidLoad() {
       super.viewDidLoad()
       self.navigationBarConfiguration()
       self.uiConfigurationAfterStoryboard()
               
       NotificationCenter.default.addObserver(self, selector: #selector(verifiedPhoneNumber(notification:)), name: NSNotification.Name(rawValue: "phoneNumberNotifier"), object: nil)
   }
   
   override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       self.navigationController?.isNavigationBarHidden = false
       
       if(isEditPressed == true) {
           isEditPressed = false
           self.rightTextPressed(UIButton())
       }
   }
   
   func navigationBarConfiguration() {
       
       setNavigationTitle("My Profile")
//       let rightBarTextButton =  StaticHelper.rightBarButtonWithText(text: "Edit", vc: self)
//       self.navigationItem.rightBarButtonItem = rightBarTextButton
       self.navigationItem.leftBarButtonItem = StaticHelper.leftBarButton(withImageNamed: "backward_arrow_icon", forVC: self)
   }
   
   func uiConfigurationAfterStoryboard() {
       
       scrlView.contentInsetAdjustmentBehavior = .never
       scrlView.backgroundColor = .white
       scrlView.contentSize = CGSize(width: SCREEN_WIDTH, height: 200)

       nameLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
       nameTextField.font = UIFont.josefinSansSemiBoldFontWithSize(size: 15.0)
       emailLabel.font = UIFont.josefinSansRegularFontWithSize(size: 10.0)
       emailTextField.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
       phoneNumLabel.font = UIFont.josefinSansRegularFontWithSize(size: 10.0)
       phoneNumberTextField.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
       nameTextField.text = (profileInfo?.first_name)! + " " + (profileInfo?.last_name)!
       nameTextField.isUserInteractionEnabled = false
       emailTextField.isUserInteractionEnabled = false
       emailTextField.text = (profileInfo?.email_id)! //(UserCache.shared.userInfo(forKey: kUserCache.email_id) as! String)
       phoneNumberTextField.text = (profileInfo?.phone_num)!//(UserCache.shared.userInfo(forKey: kUserCache.phone_num) as! String)

       nameTextField.delegate = self
       emailTextField.delegate = self
       
       imgURLString = (profileInfo?.photo_url)!//(UserCache.shared.userInfo(forKey: kUserCache.photo_url) as! String)
       
       if  imgURLString.isEmpty {
           imgView.image = UIImage.init(named: "profile_screen_placeholder")
       } else {
           let imgURL =  URL.init(string: imgURLString)
           imgView.af.setImage(withURL: imgURL!)
       }
       imgView.layer.cornerRadius = 10.0
       imgView.layer.masksToBounds = true
       resetPassButton.isHidden = true

       userImgButton.isHidden = true
       btnImgView.isHidden = true
       phoneNumEditImgView.isHidden = true
       emailIdEditImgView.isHidden = true
       phoneNumButton.isHidden = true
       
//       let permission = PermissionCameraHelper()
//       let permissionPhoto = PermissionPhotoHelper()
//       if permission.checkCameraPermission() == .notDetermined {
//           let permission = PermissionCameraHelper()
//           permission.requestCameraPermission { (status) in
//           }
//       }
//       if permissionPhoto.checkPhotoPermission() == .notDetermined {
//           let permission2 = PermissionPhotoHelper()
//           permission2.requestPhotoPermission { (status) in
//           }
//       }
   }
   
    func clearPopupUserDefault(){
        let prefs = UserDefaults.standard
        prefs.removeObject(forKey: "helperrating")
        prefs.removeObject(forKey: "helpertip")
        prefs.removeObject(forKey: "apprating")

    }
   @objc func verifiedPhoneNumber(notification: NSNotification) {
       if let phnDict = notification.userInfo as NSDictionary? {
           let countryCode = phnDict["countryCode"] as! String
           let phnNumber = phnDict["phoneNumber"] as! String
           self.phoneNumberTextField.text =  countryCode + " " + phnNumber
       }
   }
   
   func phoneNumberverified(countryCode:String, phoneNumber:String) {
       self.phoneNumberTextField.text =  countryCode + " " + phoneNumber
   }
   
   @objc func leftPressed(_ selector: Any){
       self.navigationController?.popViewController(animated: false)
   }
   
   @objc func rightTextPressed(_ selector: UIButton){
       
       if isEditPressed {
//            isEditPressed = false
//            nameTextField.isUserInteractionEnabled = false
//            emailTextField.isUserInteractionEnabled = false
//            nameTextField.resignFirstResponder()
//            userImgButton.isHidden = true
//            btnImgView.isHidden = true
//            phoneNumEditImgView.isHidden = true
//            emailIdEditImgView.isHidden = true
//            phoneNumButton.isHidden = true
           photoUploadAction(profilePhoto)
       } else {
           let rightBarTextButton =  StaticHelper.rightBarButtonWithText(text: "Save", vc: self)
           nameTextField.isUserInteractionEnabled = true
           emailTextField.isUserInteractionEnabled = true
           self.navigationItem.rightBarButtonItem = rightBarTextButton
           userImgButton.isHidden = false
           isEditPressed = true
           nameTextField.becomeFirstResponder()
           btnImgView.isHidden = false
           phoneNumEditImgView.isHidden = false
           emailIdEditImgView.isHidden = false
           phoneNumButton.isHidden = false
       }
   }
    @IBAction func deleteMyAccountAction(_ sender: UIButton) {
           let objDeleteInfoVC = self.storyboard?.instantiateViewController(withIdentifier: "DeleteInfoViewController") as! DeleteInfoViewController
           self.navigationController?.pushViewController(objDeleteInfoVC, animated: true)
    }
   @IBAction func emailAction(_ sender: UIButton) {

       emailTextField.becomeFirstResponder()
   }

    @IBAction func phoneNumAction(_ sender: UIButton) {
        let phoneNumVerificationVC = self.storyboard?.instantiateViewController(withIdentifier: "PhoneNumberVerificationVC") as! PhoneNumberVerificationVC
        phoneNumVerificationVC.isEdit = true
        self.navigationController?.pushViewController(phoneNumVerificationVC, animated: true)
    }
   
   func photoUploadAction(_ image: UIImage) {
       if (nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!.isEmpty{
           let windows = UIApplication.shared.windows
           windows.last?.makeToast("Please enter your name.")
           nameTextField.becomeFirstResponder()
           return
       } else if (nameTextField.text == "Apple"){
           nameTextField.text = ""
           nameTextField.becomeFirstResponder()
           let windows = UIApplication.shared.windows
           windows.last?.makeToast("Please enter your name.")
           return
       }
       
//       if (emailTextField.text!.isValidEmail() == false) {
//           let windows = UIApplication.shared.windows
//           windows.last?.makeToast("Please enter valid email id.")
//           return
//       } else
       if(emailTextField.text!.contains("@apple.com") == true) {
           let windows = UIApplication.shared.windows
           windows.last?.makeToast("Please update valid email id.")
           return
       }
       
       if (phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!.isEmpty{
           let windows = UIApplication.shared.windows
           windows.last?.makeToast("Please enter phone number.")
           return
       }
       if !StaticHelper.Connectivity.isConnectedToInternet {
           StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: self, completion: nil)
           return
       }
       isEditPressed = false
       nameTextField.isUserInteractionEnabled = false
       emailTextField.isUserInteractionEnabled = false
       nameTextField.resignFirstResponder()
       userImgButton.isHidden = true
       btnImgView.isHidden = true
       phoneNumEditImgView.isHidden = true
       emailIdEditImgView.isHidden = true
       phoneNumButton.isHidden = true

       if profilePhoto.size != CGSize.zero{
           let httpheader:HTTPHeaders = ["Auth-Token": UserCache.userToken() ?? ""]
           let imageData = profilePhoto.jpegData(compressionQuality: 0.6)
           
           StaticHelper.shared.startLoader(self.view)
           
           
           let parametersDict : Parameters = ["email_id": (emailTextField.text)!,"name":(nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!,"phone_num":(phoneNumberTextField.text)!] as [String : Any]
           
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
           }, to: baseURL + kAPIMethods.update_helper_profile, method: .post, headers:httpheader).responseJSON { (response) in
               defer{
                   StaticHelper.shared.stopLoader()
               }
               if response.response?.statusCode == 200{
                   StaticHelper.shared.stopLoader()
                   UserCache.shared.saveUserData(response.value as! [String:Any])
                   self.userImgButton.isHidden = true
                   self.btnImgView.isHidden = true
                   let rightBarTextButton =  StaticHelper.rightBarButtonWithText(text: "Edit", vc: self)
                   self.navigationItem.rightBarButtonItem = rightBarTextButton
                   let windows = UIApplication.shared.windows
           windows.last?.makeToast("Your profile has been updated successfully.")
                   self.updateProfileDelegate?.profileUpdated()
               }else{
                   StaticHelper.shared.stopLoader()
                  let windows = UIApplication.shared.windows
           windows.last?.makeToast("There is some issue while uploading image. Please upload again.")
               }
//               FirebaseAnalytics.Analytics.logEvent(kFirebaseEvents.updateProfilePic, parameters:nil)
           }
       }
       else {
           
           let httpheader: HTTPHeaders = ["Auth-Token": UserCache.userToken() ?? ""]
           
           StaticHelper.shared.startLoader(self.view)
           
           let parametersDict : Parameters = ["email_id": (emailTextField.text)!,"name":(nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!,"phone_num":(phoneNumberTextField.text)!] as [String : Any]
           AF.request(baseURL + kAPIMethods.update_helper_profile, method: .post, parameters: parametersDict, headers: httpheader).responseJSON { (response) in
               switch response.result {
               case .success:
                   if response.response?.statusCode == 200{
                       StaticHelper.shared.stopLoader()
                       UserCache.shared.saveUserData(response.value as! [String:Any])
                        self.userImgButton.isHidden = true
                       self.btnImgView.isHidden = true
                        let rightBarTextButton =  StaticHelper.rightBarButtonWithText(text: "Edit", vc: self)
                        self.navigationItem.rightBarButtonItem = rightBarTextButton
                        let windows = UIApplication.shared.windows
           windows.last?.makeToast("Your profile has been updated successfully.")
                       self.updateProfileDelegate?.profileUpdated()
                   }
               case .failure(let error):
                   StaticHelper.shared.stopLoader()
                   let windows = UIApplication.shared.windows
           windows.last?.makeToast(error.localizedDescription)
               }
           }
       }
   }
   
   func passwordChanged() {
       let windows = UIApplication.shared.windows
           windows.last?.makeToast("Password has been updated successfully.")
   }
   
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
       return true
   }
   
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let yRef:CGFloat = screenStatusBarHeight + (self.navigationController?.navigationBar.frame.size.height ?? 0.0)!
        
        self.view.frame = CGRect(x: 0, y: yRef, width: self.view.frame.size.width, height: self.view.frame.size.height)
    }
    func logoutClearData(){
            UserCache.shared.clearUserData()
            self.clearPopupUserDefault()
            //self.navigationController?.popToRootViewController(animated: true)
            StaticHelper.moveToViewController("GetStartedViewController", animated: true)
    }
   //MARK: - Action Methods
   @IBAction func editAction(_ sender: Any) {
       
   }
   
   @IBAction func resetAction(_ sender: Any) {
       let resetVC = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordViewController") as! ResetPasswordViewController
       resetVC.isFromProfile = true
//       resetVC.passwordUpdatedDelegate = self
       self.navigationController?.pushViewController(resetVC, animated: true)
   }
   
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
            showPermmisonAlert(AlertButtonTitle.alert,kStringPermission.cameraGalaryMessageTitle, kStringPermission.photosProfileMessage)
        }else{
            self.showActionSheet(in: self, title: "", message: kStringPermission.pickAnOption, buttonArray:  [kStringPermission.takePhoto, kStringPermission.choosePhoto], completion:
                                    { (index) in
                if index == 0 {
                    
                    let permission = PermissionCameraHelper()
                    if permission.checkCameraPermission() == .accepted {
                        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
                        {
                            self.imagePickerController.sourceType = .camera
                            self.imagePickerController.allowsEditing = true
                            self.imagePickerController.cameraCaptureMode = .photo
                            self.imagePickerController.modalPresentationStyle = .fullScreen
                            self.imagePickerController.delegate = self
                            self.navigationController?.present(self.imagePickerController, animated: true, completion: nil)
                        } else {
                            let alert  = UIAlertController(title: kStringPermission.warning, message: kStringPermission.youDontHaveCamera, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: AlertButtonTitle.ok, style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }else{
                        self.showPermmisonAlert(AlertButtonTitle.alert,kStringPermission.cameraMessageTitle, kStringPermission.photosProfileMessage)
                    }
                } else if index == 1 {
                    let permission = PermissionPhotoHelper()
                    if permission.checkPhotoPermission() == .accepted {
                        self.imagePickerController.sourceType = .photoLibrary
                        self.imagePickerController.allowsEditing = true
                        self.imagePickerController.delegate = self
                        self.navigationController?.present(self.imagePickerController, animated: true, completion: nil)
                    }else{
                        self.showPermmisonAlert(AlertButtonTitle.alert,kStringPermission.galaryMessageTitle, kStringPermission.photosProfileMessage)
                    }
                } else {
                    self.imagePickerController.dismiss(animated: true, completion: {})
                }
            })
            
        }
        
    }
   @IBAction func userImgButtonAction(_ sender: Any) {
       showPermmisonPopup()
   }
}

extension ProfileViewControllerDetails:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
   
   //********************************
   //MARK: - Image Picker Methods
   //********************************
   
   func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       self.dismiss(animated: true, completion: nil)
   }
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       let photo = info[UIImagePickerController.InfoKey.originalImage] as! UIImage?
       profilePhoto = self.resizeImage(image: photo!, targetSize: CGSize.init(width: 720.0, height: 1080.0))
       //  self.placeholderImgView.image = #imageLiteral(resourceName: "camera_icon")
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
                   
                   alertController.popoverPresentationController?.sourceView = self.userImgButton
                   alertController.popoverPresentationController?.sourceRect = self.userImgButton.bounds
                   self.present(alertController, animated: true, completion: {})
               }
           }
           else if UIDevice.current.userInterfaceIdiom == .phone {
               controller.present(alertController, animated: true, completion: {})
           }
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

// MARK: - ALert Permmison method's ....
extension ProfileViewControllerDetails:AlertViewPermmisionDelegate{
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

