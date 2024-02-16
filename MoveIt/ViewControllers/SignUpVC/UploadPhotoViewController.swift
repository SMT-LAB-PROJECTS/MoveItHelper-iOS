//
//  UploadPhotoViewController.swift
//  Move It Customer
//
//  Created by Dushyant on 27/04/19.
//  Copyright © 2019 Agicent Technologies. All rights reserved.
//

import UIKit
import Alamofire

class UploadPhotoViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var youAreAllSetLabel: UILabel!
    @IBOutlet weak var takeMinuteLabel: UILabel!
    @IBOutlet weak var uploadPhotoBkView: UIView!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var doneBtnBkView: UIImageView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    var profilePhoto = UIImage(){
        didSet{
            userImgView.image = profilePhoto  
        }
    }
    var isFromHome = false
    var alertPermmisionView :AlertViewPermmision?

    let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let viewControllers = self.navigationController?.viewControllers {
            if(viewControllers.count > 1) {
                let leftBarButtonItem = StaticHelper.leftBarButtonWithImageNamed(imageName: "backward_arrow_icon", vc: self)
                self.navigationItem.leftBarButtonItems = [leftBarButtonItem]
            }
        }
        
        setupUI()
        self.navigationController?.isNavigationBarHidden = true        
    }
    
    func setupUI(){
        
        uploadPhotoBkView.layer.cornerRadius = 72.5 * screenHeightFactor
        titleLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 15.0)
        youAreAllSetLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        takeMinuteLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        doneButton.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 13.0)
        skipButton.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 15.0)
    }
    func showActionSheetWithPermission(){
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
            showPermmisonAlert(AlertButtonTitle.alert,kStringPermission.cameraGalaryMessageTitle, kStringPermission.photosItemMessage)        }else{
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
                            if self.isFromHome {
                                self.present(self.imagePickerController, animated: true, completion: nil)
                            } else {
                                self.navigationController?.present(self.imagePickerController, animated: true, completion: nil)
                            }                        }else{
                            let alert  = UIAlertController(title: kStringPermission.warning, message: kStringPermission.youDontHaveCamera, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: AlertButtonTitle.ok, style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }else{
                        self.showPermmisonAlert(AlertButtonTitle.alert,kStringPermission.cameraMessageTitle, kStringPermission.photos1ItemMessage)
                    }
                }else if index == 1 {
                    let permission = PermissionPhotoHelper()
                    if permission.checkPhotoPermission() == .accepted {
                        self.imagePickerController.sourceType = .photoLibrary
                        //self.imagePickerController.allowsEditing = true
                        self.imagePickerController.delegate = self
                        if self.isFromHome {
                            self.present(self.imagePickerController, animated: true, completion: nil)
                        } else {
                            self.navigationController?.present(self.imagePickerController, animated: true, completion: nil)
                        }
                        
                    }else{
                        self.showPermmisonAlert(AlertButtonTitle.alert,kStringPermission.galaryMessageTitle, kStringPermission.photosItemMessage)
                    }
                }else{
                    self.imagePickerController.dismiss(animated: true, completion: {})
                }
            })
        }
    }
    //MARK: - Action Methods
    @objc func leftButtonPressed(_ selector: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
   
    @IBAction func uplaodAction(_ sender: UIButton) {
       showActionSheetWithPermission()
    }
    
    
    @IBAction func doneAction(_ sender: UIButton) {
        
        if profilePhoto.size == CGSize.zero{
            self.view.makeToast("Please select image.")
            return
        }
        
        
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: self, completion: nil)
            return
        }
        if profilePhoto.size != CGSize.zero{
         
            let httpheader:HTTPHeaders = ["Auth-Token": UserCache.userToken() ?? ""]
            let imageData = profilePhoto.jpegData(compressionQuality: 0.6)
            
            StaticHelper.shared.startLoader(self.view)
            
            let firstname = UserCache.shared.userInfo(forKey: kUserCache.first_name) as! String
            let lastName  = UserCache.shared.userInfo(forKey: kUserCache.last_name)  as! String
            let phoneNum  = UserCache.shared.userInfo(forKey: kUserCache.phone_num)  as! String
            let parametersDict : Parameters = ["last_name": lastName,"first_name":firstname,"phone_num":phoneNum] as [String : Any]
            
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
                    StaticHelper.shared.stopLoader()
                    print(response.value as! [String:Any])
                    profileInfo?.first_name = firstname
                    profileInfo?.last_name = lastName
                    self.view.makeToast("Your profile has been updated successfully.")
                    
                    if self.isFromHome {
                        if(self.navigationController != nil) {                            
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            self.dismiss(animated: true, completion: nil)
                        }
                    } else {
                        self.gotoPDFVC()
                    }
                } else{
                    self.view.makeToast("There is some issue while updating profile. Please try again.")
                }
            }
        }
    }
    
    @IBAction func skipAction(_ sender: UIButton) {
        
        self.gotoPDFVC()

//        StaticHelper.moveToViewController("PdfViewerViewController", animated: true)
    }
    
    func gotoPDFVC() {
        let pdfVC = self.storyboard?.instantiateViewController(withIdentifier: "PdfViewerViewController") as! PdfViewerViewController
        self.navigationController?.pushViewController(pdfVC, animated: true)
    }
}
extension UploadPhotoViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
  
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
                    alertController.popoverPresentationController?.sourceView = self.uploadButton
                    alertController.popoverPresentationController?.sourceRect = self.uploadButton.bounds
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
extension UploadPhotoViewController:AlertViewPermmisionDelegate{
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
