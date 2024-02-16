//
//  UploadVehicleImagesViewController.swift
//  MoveIt
//
//  Created by RV on 11/06/21.
//  Copyright © 2021 Jyoti. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

class UploadVehicleImagesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bkImageView: UIView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var takePhotoLabel: UILabel!
    @IBOutlet weak var vehiclePhotoBkView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var photosLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var bottomLabel: UILabel!
    
    var selectedService: Int?
    var dict = [String : Any]()
    var imgWithKey = [Int:String]()
    var imagesArray = [UIImage](){
        didSet{
            if imagesArray.count == 0{
                self.vehiclePhotoBkView.isHidden = true
            }
            else{
                self.vehiclePhotoBkView.isHidden = false
            }
            self.collectionView.reloadData()
        }
    }
    
    let imgPicker = UIImagePickerController()
    var alertPermmisionView :AlertViewPermmision?

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle("Update Information")

        let leftBarButtonItem = StaticHelper.leftBarButtonWithImageNamed(imageName: "backward_arrow_icon", vc: self)
         self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let label = UILabel()
        label.text = "Step 2/2"
        label.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        label.textColor = darkPinkColor
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: label)
        
        imgPicker.delegate = self
        self.setupUI()
    }
    
    
    func setupUI(){
        
        headerView.frame.size.height = SCREEN_HEIGHT - 120
        contentView.layer.cornerRadius = 10.0 * screenHeightFactor
        titleLabel.font = UIFont.josefinSansBoldFontWithSize(size: 14.0)
        takePhotoLabel.font = UIFont.josefinSansRegularFontWithSize(size: 10.0)
        photosLabel.font = UIFont.josefinSansBoldFontWithSize(size: 14.0)
        bottomLabel.font = UIFont.josefinSansRegularFontWithSize(size: 10.0)
        submitButton.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 13.0)
    }
    
    func uploadImages(_ image: UIImage){
       
        
        let httpheader:HTTPHeaders = ["Auth-Token": UserCache.userToken() ?? ""]
        let imageData = image.jpegData(compressionQuality: 0.6)
                
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: self, completion: nil)
            return
        }
        
        StaticHelper.shared.startLoader(self.view)

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
            
        }, to: baseURL + kAPIMethods.upload_helper_vehicle_image, method: .post, headers:httpheader).responseJSON { (response) in
            defer{
                DispatchQueue.main.async{
                    StaticHelper.shared.stopLoader()
                }
            }
            DispatchQueue.main.async{
                StaticHelper.shared.stopLoader()
                print("resp is \(response)")
                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200{
                    self.imgWithKey[self.imgWithKey.count] = ((response.value as! [String:Any])["vehicle_image_url"] as! String)
                    self.collectionView.reloadData()
                } else{
                    self.imagesArray.removeLast()
                    self.view.makeToast("There is some issue while uploading image. Please upload again.")
                }
            }
        }
    }
    
    @objc func leftButtonPressed(_ selector: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitAction(_ sender: Any) {
        
        if imagesArray.count < 4{
            
            self.view.makeToast("You need to upload your vehicle front, left side, right side and back side photos.")
            return
        }
        savePhotos()
        
    }
    func showAlert(title:String, message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getProfileInfoHome"), object: nil)
            
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: HomeViewController.self) {
                    _ =  self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    func savePhotos(){
        
        
        dict["vehicle_image_url"] = [imgWithKey[0]!,imgWithKey[1]!,imgWithKey[2]!,imgWithKey[3]!]
        dict[kUserCache.service_type] = self.selectedService
                
        let header : HTTPHeaders = ["Content-Type":"application/json","Auth-Token":UserCache.userToken() ?? ""]
        
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: self, completion: nil)
            return
        }
        
        StaticHelper.shared.startLoader(self.view)
        AF.request(baseURL + kAPIMethods.update_helper_service_type, method: .post, parameters: dict,encoding: JSONEncoding.default,  headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
                StaticHelper.shared.stopLoader()
            switch response.result {
            case .success:
            
                if response.response?.statusCode == 200{
                    StaticHelper.shared.stopLoader()
                    if let resposneDict = response.value as? [String: Any] {
                        if !resposneDict.isEmpty{
                            print(resposneDict)
                            UserCache.shared.updateUserProperty(forKey: kUserCache.service_type , withValue: self.selectedService as AnyObject )
                            if let message = resposneDict["message"] as? String{
                                self.showAlert(title: "", message: message)
                            }
                            //self.dismiss(animated: true, completion: nil)
//                            UIApplication.shared.keyWindow?.rootViewController?.view.makeToast("Service Type change successfully.")
                        }
                    }
                }
            case .failure(let error):
                StaticHelper.shared.stopLoader()
                self.view.makeToast(messageError)
                print (error.localizedDescription)
            }
            }
            
        }
        
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
            showPermmisonAlert(AlertButtonTitle.alert,kStringPermission.cameraGalaryMessageTitle, kStringPermission.photosItemMessage)
        }else{
            let actionSheet = UIAlertController(title: "Choose from your choice", message: nil, preferredStyle: .actionSheet)
            let action1 = UIAlertAction(title: "Camera", style: .default) { (action:UIAlertAction) in
                DispatchQueue.main.async {
                    let permission = PermissionCameraHelper()
                    if permission.checkCameraPermission() == .accepted {
                        self.openCamera()
                    }else{
                        self.showPermmisonAlert(AlertButtonTitle.alert,kStringPermission.cameraMessageTitle, kStringPermission.photos1ItemMessage)
                    }
                }
            }
            let action2 = UIAlertAction(title: "Gallery", style: .default) { (action:UIAlertAction) in
                DispatchQueue.main.async {
                    let permission = PermissionPhotoHelper()
                    if permission.checkPhotoPermission() == .accepted {
                        self.openGallery()
                    }else{
                        self.showPermmisonAlert(AlertButtonTitle.alert,kStringPermission.galaryMessageTitle, kStringPermission.photosItemMessage)
                    }
                }
            }
            
            let action3 = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
                self.dismiss(animated: true, completion: {})
            }
            
            actionSheet.addAction(action1)
            actionSheet.addAction(action2)
            actionSheet.addAction(action3)
            
            DispatchQueue.main.async {
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
            
        }
    }
    
    @IBAction func addVehiclePhotosAction(_ sender: Any) {
        
        if imagesArray.count == 4{
            StaticHelper.showAlertViewWithTitle("", message: "You can upload upto 4 images for this vehicle.", buttonTitles: ["OK"], viewController: self, completion: nil)
            return
        } else if imagesArray.count >= 4 {
            //imagesArray.remo
            StaticHelper.showAlertViewWithTitle("", message: "You can upload upto 4 images for this vehicle.", buttonTitles: ["OK"], viewController: self, completion: nil)
            return
        }
        showActionSheetWithPermission()
    }
    
    func openCamera() {
        
        //  DispatchQueue.main.async {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            //already authorized
            
            self.imgPicker.allowsEditing = false
            self.imgPicker.sourceType = UIImagePickerController.SourceType.camera
            self.imgPicker.cameraCaptureMode = .photo
            self.imgPicker.modalPresentationStyle = .fullScreen
            self.present(self.imgPicker,animated: true,completion: nil)
        }
        
        else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    
                    return
                }
                else {
                    self.alertPromptToAllowCameraAccessViaSetting()
                }
            })
        }
        // }
        
        
    }
    
    func openGallery(){
        // DispatchQueue.main.async {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            self.imgPicker.allowsEditing = false
            self.imgPicker.sourceType = .photoLibrary
            self.imgPicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(self.imgPicker, animated: true, completion: nil)
        }
        //    }
        
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

extension UploadVehicleImagesViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let vehicleImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UploadPhotoCollectionViewCell", for: indexPath) as! UploadPhotoCollectionViewCell
        vehicleImageCell.vehicleImgView.image = imagesArray[indexPath.item]
        vehicleImageCell.vehicleImgView.tag = indexPath.row
        vehicleImageCell.crossButton.tag = indexPath.item
        vehicleImageCell.crossButton.addTarget(self, action: #selector(crossPressed(_:)), for: .touchUpInside)
        let AI = UIActivityIndicatorView()
        AI.center = vehicleImageCell.vehicleImgView.center
        vehicleImageCell.vehicleImgView.addSubview(AI)
        //
        
        print(imgWithKey)
        
        if imgWithKey.keys.contains(indexPath.row){
            AI.stopAnimating()
        }
        else{
            AI.startAnimating()
            AI.removeFromSuperview()
        }
        
        return vehicleImageCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let imgPreviewVC = self.storyboard?.instantiateViewController(withIdentifier: "ImagePreviewViewController") as! ImagePreviewViewController
        imgPreviewVC.selctedImage = self.imagesArray[indexPath.item]
        self.present(imgPreviewVC, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 55.0 * screenWidthFactor, height: 55.0 * screenWidthFactor)
    }
    
    @objc func crossPressed(_ selector: UIButton){
        self.imagesArray.remove(at: selector.tag)
        
    }
}

extension UploadVehicleImagesViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    //********************************
    //MARK: - Image Picker Methods
    //********************************
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var image : UIImage!
        
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            image = img
        } else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = img
        }
        image =  self.resizeImage(image: image!, targetSize: CGSize.init(width: 720.0, height: 1080.0))
        imagesArray.append(image)
        self.uploadImages(image)
        picker.dismiss(animated: true, completion: nil)
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
                    alertController.popoverPresentationController?.sourceView = self.collectionView
                    alertController.popoverPresentationController?.sourceRect = self.collectionView.bounds
                    self.present(alertController, animated: true, completion: {})
                }
            }
            else if UIDevice.current.userInterfaceIdiom == .phone {
                controller.present(alertController, animated: true, completion: {})
            }
        }
    }
}
// MARK: - ALert Permmison method's ....
extension UploadVehicleImagesViewController:AlertViewPermmisionDelegate{
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
