//
//  EditVehiclePhotoViewController.swift
//  MoveIt
//
//  Created by RV on 20/05/21.
//  Copyright © 2021 Jyoti. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

class EditVehiclePhotoViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var uploadPhotoLabel: UILabel!
    @IBOutlet weak var uploadImageOuterView: UIView!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var takeAMinuteLabel: UILabel!
    @IBOutlet weak var photosVehicleLabel: UILabel!
    @IBOutlet weak var needToUploadLabel: UILabel!
  
    @IBOutlet weak var photosCollectionview: UICollectionView!
    @IBOutlet weak var submitButtonOutlet: UIButton!
    
    let imgPicker = UIImagePickerController()
    var imagesArray = [VehiclePhotosModel]()
    var imagesArray2 = [VehiclePhotosModel]()
    
    var insurance_photo:[String] = []
    
    var isInsurance:Bool = false
    var alertPermmisionView :AlertViewPermmision?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBarConfiguration()
        
        self.setUpUI()
        
        if(isInsurance == true) {
            imagesArray = profileInfo?.vehicleDetails?.vehicle_insurance_photo_url ?? []
        } else {
            imagesArray = profileInfo?.vehicleDetails?.vehicle_photo_url ?? []
        }
    }
    
    func navigationBarConfiguration() {
        setNavigationTitle("Vehicle Info")
        let leftBarButtonItem = StaticHelper.leftBarButtonWithImageNamed(imageName: "backward_arrow_icon", vc: self)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    func setUpUI(){
        
        if(isInsurance == true) {
            uploadPhotoLabel.text = uploadPhotoLabel.text!.replacingOccurrences(of: "Vehicle", with: "Vehicle Insurance")
            //"Upload Vehicle Insurance Photos"
            takeAMinuteLabel.text = takeAMinuteLabel.text!.replacingOccurrences(of: "vehicle", with: "vehicle insurance")
            //"Take a minute to upload your "
            photosVehicleLabel.text = photosVehicleLabel.text!.replacingOccurrences(of: "Vehicle", with: "Vehicle Insurance")
            needToUploadLabel.text = "You need to upload your vehicle insurance document photo(s)"
        }
        
        uploadPhotoLabel.font = UIFont.josefinSansRegularFontWithSize(size: 14.0)
        takeAMinuteLabel.font = UIFont.josefinSansRegularFontWithSize(size: 10.0)
        photosVehicleLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        submitButtonOutlet.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        
        imgPicker.delegate = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        
        submitButtonOutlet.layer.cornerRadius = (submitButtonOutlet.frame.size.height/2.0)
        submitButtonOutlet.layer.masksToBounds = true
        
        uploadImageOuterView.layer.cornerRadius = uploadImageOuterView.frame.size.width/2
        uploadImageOuterView.layer.masksToBounds = true
        
        photoImageView.layer.cornerRadius = photoImageView.frame.size.width/2
        photoImageView.layer.masksToBounds = true
        
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
    @objc func leftButtonPressed(_ selector: Any){
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        
        if(isInsurance == true) {
            if imagesArray.count != 0 {
                self.updateInsuranceImage()
            } else {
                self.view.makeToast("Please upload alt least one vehicle insurance photo")
            }
        } else {
            if imagesArray.count == 4 {
                self.updateImage()
            } else {
                self.view.makeToast("Please upload 4 vehicle photos")
            }
        }
    }
    
    //#MARK:- UploadImageMethod
    @IBAction func uploadPhotoButtonPressed(_ sender: Any) {
        if imagesArray.count < 4 {
            showActionSheetWithPermission()
        }
    }
    
    func openCamera() {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            //already authorized
            imgPicker.allowsEditing = false
            imgPicker.sourceType = UIImagePickerController.SourceType.camera
            imgPicker.cameraCaptureMode = .photo
            imgPicker.modalPresentationStyle = .fullScreen
            present(imgPicker,animated: true,completion: nil)
        } else{
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    return
                } else {
                    self.alertPromptToAllowCameraAccessViaSetting()
                }
            })
        }
    }
    
    func openGallery(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imgPicker.allowsEditing = false
            imgPicker.sourceType = .photoLibrary
            imgPicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            present(imgPicker, animated: true, completion: nil)
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
    
    func uploadImages(_ image: UIImage) {
//
        let httpheader: HTTPHeaders = ["Auth-Token": UserCache.userToken() ?? ""]
        let imageData = image.jpegData(compressionQuality: 0.6)
        
       StaticHelper.shared.startLoader(self.view)
        if !StaticHelper.Connectivity.isConnectedToInternet {
                StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: self, completion: nil)
                return
            }
            
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
                StaticHelper.shared.stopLoader()
                
                var arrPhotosURL = profileInfo?.vehicleDetails?.vehicle_photo_url ?? []
                if(self.isInsurance == true) {
                    arrPhotosURL = profileInfo?.vehicleDetails?.vehicle_insurance_photo_url ?? []
                }
                
                if(arrPhotosURL.count == 0) {
                    let photoURL = ((response.value as! [String:Any])["vehicle_image_url"] as! String)

                    self.imagesArray.append(VehiclePhotosModel(photo_id: "", photo_url: photoURL))
                    self.imagesArray2.append(VehiclePhotosModel(photo_id: "", photo_url: photoURL))
                    self.insurance_photo.append(photoURL)
                } else {
                    
                    var arrItems = profileInfo?.vehicleDetails?.vehicle_photo_url ?? []
                    
                    if(self.isInsurance == true) {
                        arrItems = profileInfo?.vehicleDetails?.vehicle_insurance_photo_url ?? []
                    }
                    
                    for item in arrItems {
                        let id = item.photo_id
                        var isIn = false
                        for item2 in self.imagesArray {
                            if id == item2.photo_id {
                                isIn = true
                                break
                            }
                        }
                        if isIn == false{
                            self.imagesArray.append(VehiclePhotosModel(photo_id: id, photo_url: ((response.value as! [String:Any])["vehicle_image_url"] as! String)))
                            self.imagesArray2.append(VehiclePhotosModel(photo_id: id, photo_url: ((response.value as! [String:Any])["vehicle_image_url"] as! String)))
                            self.insurance_photo.append(((response.value as! [String:Any])["vehicle_image_url"] as! String))
                            break
                        }
                    }
                }
                
                self.photosCollectionview.reloadData()
            } else{
                 StaticHelper.shared.stopLoader()
                self.imagesArray.removeLast()
                self.view.makeToast("There is some issue while uploading image. Please upload again.")
            }
        }
        
    }
    
    func updateImage() {
        StaticHelper.shared.startLoader(self.view)
        //self.imagesArray2
        var parameters = [String: Any]()
        
//        if imagesArray.count == 4{
            StaticHelper.showAlertViewWithTitle("", message: "You can upload upto 4 images for this vehicle.", buttonTitles: ["OK"], viewController: self, completion: nil)
//            return
//        } else if imagesArray.count >= 4 {
//            //imagesArray.remo
//            StaticHelper.showAlertViewWithTitle("", message: "You can upload upto 4 images for this vehicle.", buttonTitles: ["OK"], viewController: self, completion: nil)
//            return
//        }
//        

        parameters["vehicle_photo_url"] = convertVehiclePhotosArrayToDictionaries(list: self.imagesArray2)
        
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!,"Content-Type":"application/json"]
        
        print(parameters,header)
                
        AF.request(baseURL + kAPIMethods.update_helper_vehicle_image, method: .post, parameters: parameters,encoding: JSONEncoding.default,headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
            switch response.result {
            case .success:
               StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200{
                    //self.view.makeToast("Code resent successfully.")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getProfileInfo"), object: nil)
                    self.navigationController?.popViewController(animated: true)
                } else if response.response?.statusCode == 401{
                        StaticHelper.shared.stopLoader()
                        let responseJson = response.value as! [String: AnyObject]
                        self.view.makeToast(responseJson["message"] as? String)
                    }else{
                    let apiResponse = response.value as! [String: Any]
                    self.view.makeToast(apiResponse["message"] as? String)
                }
            case .failure(let error):
                StaticHelper.shared.stopLoader()
                self.view.makeToast(error.localizedDescription)
            }
            }
        }
    }
    
    func updateInsuranceImage() {
                
        StaticHelper.shared.startLoader(self.view)

        let deviceToken = UserDefaults.standard.value(forKey: "UserToken") as? String ?? ""

        var parameters = [String: Any]()
        parameters["vehicle_type_id"] = (profileInfo?.vehicleDetails?.vehicle_type_id)
        parameters["vehicle_year"] = (profileInfo?.vehicleDetails?.vehicle_year)
        parameters["plate_num"] = (profileInfo?.vehicleDetails?.plate_num)
        parameters["company_name"] = (profileInfo?.vehicleDetails?.company_name)
        parameters["model"] = (profileInfo?.vehicleDetails?.model)
        parameters["device_type"] = "I"
        parameters["device_token"] = deviceToken
        parameters["insurance_number"] = (profileInfo?.vehicleDetails?.insurance_number)

        parameters["insurance_photo"] = insurance_photo
        
        
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!,"Content-Type":"application/json"]
        
        print(parameters,header)
        
        //update_helper_vehicle_info_request
        
        AF.request(baseURL + kAPIMethods.update_helper_vehicle_info_request, method: .post, parameters: parameters,encoding: JSONEncoding.default,headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
            switch response.result {
            case .success:
               StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200{
                    //self.view.makeToast("Code resent successfully.")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getProfileInfo"), object: nil)
                    self.navigationController?.popViewController(animated: true)
                } else if response.response?.statusCode == 401{
                        StaticHelper.shared.stopLoader()
                        let responseJson = response.value as! [String: AnyObject]
                        self.view.makeToast(responseJson["message"] as? String)
                    }
                else{
                    let apiResponse = response.value as! [String: Any]
                    self.view.makeToast(apiResponse["message"] as? String)
                }
            case .failure(let error):
                StaticHelper.shared.stopLoader()
                self.view.makeToast(error.localizedDescription)
            }
            }
        }
    }
    //*********************************************************
    // MARK :-- UIImagepicker Delegates Methods
    //*********************************************************
    
    
    //MARK: - Image Picker
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
         var image : UIImage!
         
         if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
             image = img
         } else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
             image = img
         }
         
        self.uploadImages(image)
        
        dismiss(animated:true, completion: nil)
        self.photosCollectionview.reloadData()
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imagesArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UploadPhotoCell
        
        cell.uploadphotoImageView.layer.cornerRadius = 5.0
        cell.uploadphotoImageView.layer.borderColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1).cgColor
        cell.uploadphotoImageView.layer.borderWidth = 1.0
        cell.uploadphotoImageView.layer.masksToBounds = true
                
        if let url = URL.init(string: imagesArray[indexPath.item].photo_url ?? "") {
            cell.uploadphotoImageView.af.setImage(withURL: url, placeholderImage: UIImage.init(named: "home_card_landscape_placeholder"), filter: nil, progress: nil, progressQueue: .main, imageTransition: .noTransition, runImageTransitionIfCached: .init()) { (_) in

            }
        } else {
            cell.uploadphotoImageView.image = UIImage(named: "home_card_landscape_placeholder")
        }

            cell.captureIcon.isHidden = true
            cell.deletePhotoButton.isHidden = false
            cell.deletePhotoaction = {
            self.imagesArray.remove(at: indexPath.item)
            collectionView.reloadData()
        }
        
        return cell
    }
    
   /* func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGSize.init(width: collectionView.bounds.width/3.0 - 10, height: collectionView.bounds.width/3.0 - 10)
        return size
    }*/
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")        
    }
}
// MARK: - ALert Permmison method's ....
extension EditVehiclePhotoViewController:AlertViewPermmisionDelegate{
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
