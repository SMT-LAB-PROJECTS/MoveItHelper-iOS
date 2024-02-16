//
//  UploadPhotosViewController.swift
//  MoveIt
//
//  Created by Dushyant on 24/06/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

protocol UploadPhotosViewControllerDelegate {
    func dropOffPhotosUploaded(_ urlPhotos: [URL])
    func pickUpPhotosUploaded(_ urlPhotos: [URL])
}

class UploadPhotosViewController: UIViewController {

    var folder_name:String = ""
    var isImageUplpading:Bool = false
    var alertPermmisionView :AlertViewPermmision?

    var moveInfo : MoveDetailsModel?
    var delegate: UploadPhotosViewControllerDelegate?
    
    @IBOutlet weak var bkView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var gradImgView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var doneButton: UIButton!
    

    var isFromDropoff =  false
    var imagesArray = [UIImage]()
    var imageTempUrls = [URL]()
    var imageUrls = [URL](){
        didSet{
            collectionView.reloadData()
        }
    }
    var moveID = 0
    let imgPicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bkView.layer.cornerRadius = 15.0 * screenHeightFactor
        titleLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        gradImgView.layer.cornerRadius = 20.0 * screenHeightFactor
        if isFromDropoff {
            self.titleLabel.text = "Capture Items DropOff Photo"
            self.imageUrls = (moveInfo?.dropoff_photo_url)!
            self.imageTempUrls = (moveInfo?.dropoff_photo_url)!
            if (self.imageUrls.count) == 4 || (self.imageUrls.count) > 4{
                self.doneButton.isHidden = true
                self.gradImgView.isHidden = true
            }
        } else {
            self.imageUrls = (moveInfo?.pickup_photo_url)!
            self.imageTempUrls = (moveInfo?.pickup_photo_url)!
            if (self.imageUrls.count) == 4 || (self.imageUrls.count) > 4{
                self.doneButton.isHidden = true
                self.gradImgView.isHidden = true
            }
            self.titleLabel.text = "Capture Items Pickup Photo"
        }
        imgPicker.delegate = self
    }
    
    func pickupPhoto(){
        DispatchQueue.main.async {
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
    @IBAction func doneAction(_ sender: Any) {
        if imageUrls.count != 0{
            if imageTempUrls.count == imageUrls.count{
                self.dismiss(animated: true, completion: nil)
                return
            }
        }
        var imgURLFor = [URL]()
        var imgURLString = [String]()
        imgURLFor = imageUrls
        imgURLFor = imgURLFor.filter{ !imageTempUrls.contains($0) }
        print(imgURLFor)
        
        for imgURLs in imgURLFor {
            imgURLString.append("\(imgURLs)")
        }
        
        if isFromDropoff {
            if imgURLString.count == 0 {
                self.view.makeToast("Please upload items photo.")
                return
            }
            StaticHelper.shared.startLoader(self.view)
            CommonAPIHelper.uploadDropOffPhoto(VC: self, paramas: ["request_id": moveID,"photos":imgURLString], completetionBlock: { (result, error, isexecuted) in
                
                DispatchQueue.main.async {
                    StaticHelper.shared.stopLoader()
                    if error != nil{
                        return
                    } else {
                    
                        self.delegate?.dropOffPhotosUploaded(self.imageUrls)
                        let strMesage:String = result?["message"] as? String ?? "Photo uploaded successfully"
                        self.view.makeToast(strMesage)
                        self.perform(#selector(self.backAction), with: UIButton(), afterDelay: 1.0)
                    }
                }
            })
        } else {
            if imgURLString.count == 0 {
                self.view.makeToast("Please upload items photo.")
                return
            }
            StaticHelper.shared.startLoader(self.view)
            CommonAPIHelper.uploadPickUpPhoto(VC: self, paramas: ["request_id": moveID,"photos":imgURLString], completetionBlock: { (result, error, isexecuted) in
                
                DispatchQueue.main.async {
                    StaticHelper.shared.stopLoader()
                    if error != nil{
                        return
                    } else {
                        //self.moveInfo?.pickup_photo_url = self.imageUrls
                        self.delegate?.pickUpPhotosUploaded(self.imageUrls)
                        let strMesage:String = result?["message"] as? String ?? "Photo uploaded successfully"
                        self.view.makeToast(strMesage)
                        self.perform(#selector(self.backAction), with: UIButton(), afterDelay: 1.0)
                    }
                }
            })
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension UploadPhotosViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imageUrls.count == 4{
            return 4
        } else{
            if isFromDropoff,((moveInfo?.helper_status)! >= 4){
                return imageUrls.count
            }else if  !isFromDropoff,((moveInfo?.helper_status)! >= 3){
                 return imageUrls.count
            }else if (self.imageUrls.count) == 4 || (self.imageUrls.count) > 4{
                return imageUrls.count
            }else{
                return 1 + imageUrls.count
            }
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DeliveryPicCollectionViewCell", for: indexPath) as! DeliveryPicCollectionViewCell
        if (indexPath.item) == imageUrls.count,imageUrls.count != 4{
            cell.crossButton.isHidden = true
            cell.itemImgView.image = UIImage.init(named: "capture_photo")
            cell.itemImgView.contentMode = .center
        } else{
            cell.crossButton.isHidden = false
            cell.itemImgView.image =  UIImage.init(named: "home_card_landscape_placeholder")
            cell.itemImgView.af.setImage(withURL: self.imageUrls[indexPath.item])
            cell.itemImgView.contentMode = .scaleToFill
            if isFromDropoff{ //dropup
                if indexPath.row < Int((moveInfo?.dropoff_photo_url.count)!){
                    cell.crossButton.isHidden = true
                }else{
                    cell.crossButton.isHidden = false
                }
                
            }else{//Pickup
                if indexPath.row < Int((moveInfo?.pickup_photo_url.count)!){
                    cell.crossButton.isHidden = true
                }else{
                    cell.crossButton.isHidden = false
                }
            }
        }
        
        if isFromDropoff{
            if (moveInfo?.helper_status)! >= 4{
                cell.crossButton.isHidden = true
            }
        } else{
            if (moveInfo?.helper_status)! >= 3{
                cell.crossButton.isHidden = true
            }
        }
        cell.crossButton.tag = indexPath.item
        cell.crossButton.addTarget(self, action: #selector(crossPressed(_:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 75.0 * screenWidthFactor, height: 95 * screenHeightFactor)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      if (indexPath.item) == imageUrls.count{
          showActionSheetWithPermission()
    }
    else{
        UIImageView().af.setImage(withURL: self.imageUrls[indexPath.row], placeholderImage: UIImage.init(named: "home_card_landscape_placeholder"), filter: nil, progress: nil, progressQueue: .main, imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: true) { (response) in
            if let image = response.value {
                let imgPreviewVC = self.storyboard?.instantiateViewController(withIdentifier: "ImagePreviewViewController") as! ImagePreviewViewController
                imgPreviewVC.selctedImage = image
                self.present(imgPreviewVC, animated: true, completion: nil)
            }
        }
        //af_setImage(withURL: self.imageUrls[indexPath.item])
    }
    
    }
    
    @objc func crossPressed(_ selector: UIButton){
       
        imageUrls.remove(at: selector.tag)
    }
    
    //MARK: - APIs
    func uploadImages(_ image: UIImage){
        
        if(isImageUplpading == true) {
            return
        }
        print(#function)
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
                self.isImageUplpading = false
                defer{
                    StaticHelper.shared.stopLoader()
                }
                print("resp is \(response)")
                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200{
                    self.imageUrls.append( URL.init(string:(((response.value as! [String:Any])["vehicle_image_url"] as! String)))!)
                    self.collectionView.reloadData()
                } else{
                   self.imagesArray.removeLast()
                   self.view.makeToast("There is some issue while uploading image. Please upload again.")
               }
            }
        }
        
    }
    
    func openCamera() {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            //already authorized
            DispatchQueue.main.async {
                self.imgPicker.allowsEditing = false
                self.imgPicker.sourceType = UIImagePickerController.SourceType.camera
                self.imgPicker.cameraCaptureMode = .photo
                self.imgPicker.modalPresentationStyle = .fullScreen
                self.present(self.imgPicker,animated: true,completion: nil)
            }
           
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    print("grantedgrantedgrantedv")
                    self.openCamera()
                    return
                }
                else {
                    self.alertPromptToAllowCameraAccessViaSetting()
                }
            })
        }
    }
    
    func openGallery(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            DispatchQueue.main.async {
                self.imgPicker.allowsEditing = false
                self.imgPicker.sourceType = .photoLibrary
                self.imgPicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
                self.present(self.imgPicker, animated: true, completion: nil)
            }
        }
    }
    //MARK: - Allow Camera in settings
    
    func alertPromptToAllowCameraAccessViaSetting() {
        let alert = UIAlertController(
            title: nil,
            message: "Camera Permission is required for uploading Profile Picture.",
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
        
        present(alert, animated: true, completion: nil)
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


extension UploadPhotosViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    //********************************
    //MARK: - Image Picker Methods
    //********************************
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var image : UIImage!
        
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            image = img
        }
        else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            image = img
        }
        if image == nil{
            self.view.makeToast("There is some issue with this image. Please select another image.")
            return
        }
        
        image =  self.resizeImage(image: image!, targetSize: CGSize.init(width: 720.0, height: 1080.0))
        imagesArray.append(image)
        
        self.uploadImages(image)
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
extension UploadPhotosViewController:AlertViewPermmisionDelegate{
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
