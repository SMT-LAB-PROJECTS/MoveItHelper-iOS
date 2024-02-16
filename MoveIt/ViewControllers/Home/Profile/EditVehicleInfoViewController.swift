//
//  EditVehicleInfoViewController.swift
//  MoveIt
//
//  Created by Dilip Saket on 17/11/21.
//  Copyright © 2021 Jyoti. All rights reserved.
//

import UIKit
import Alamofire

class EditVehicleInfoViewController: UIViewController {
    @IBOutlet weak var topHeadLabel: UILabel!
    
    @IBOutlet weak var vehicleYearLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!

    @IBOutlet weak var vehicleTypeTextField: UITextField!
    @IBOutlet weak var vehicleYearTextField: UITextField!
    @IBOutlet weak var vehiclePlateNumTextField: UITextField!
    @IBOutlet weak var vehicleCompnayTextField: UITextField!
    @IBOutlet weak var vehicleModelTextField: UITextField!
    @IBOutlet weak var insuranceNumberTextField: UITextField!
    @IBOutlet weak var insuranceDateTextField: UITextField!
    
    @IBOutlet weak var viewPhotoInsurance: UIView!
    @IBOutlet weak var lblPhotoInsurance: UILabel!
    @IBOutlet weak var collectionPhotoInsurance: UICollectionView!

    @IBOutlet weak var viewPhotoVehicle: UIView!
    @IBOutlet weak var lblPhotoVehicle: UILabel!
    @IBOutlet weak var collectionPhotoVehicle: UICollectionView!

    @IBOutlet weak var ex1Label: UILabel!
    @IBOutlet weak var ex2Label: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var pickerBkView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var finalDate:String = ""
    var isComeFromServiceStoped:Bool = false
    var alertPermmisionView :AlertViewPermmision?

    var vehicleType = ""{
        didSet{
            vehicleTypeTextField.text = vehicleType
        }
    }
    
    var vehicleYear = Int(){
        didSet{
            vehicleYearTextField.text = String(vehicleYear)
            self.pickerBkView.isHidden = true
        }
    }
    
    var vehcicleTypeData = ["Pickup truck", "Cargo van", "Box truck", "Vehicle w/a trailer"]
    var yearData = [String]()
  
    var imagesArray = [UIImage]()
    var imageUrls = [String]()

    var imagesArrayV = [UIImage]()
    var imageUrlsV = [String]()

    let imagePickerController = UIImagePickerController()
    let datePicker = UIDatePicker()

    var isInsurance:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBarConfiguration()
        
        self.setupUI()
        self.setYearDataSource()
        self.pickerBkView.isHidden = true

        self.uiInitialSettings()
        
        let tapgesture1 = UITapGestureRecognizer.init(target: self, action: #selector(hidePopup))
        self.pickerBkView.addGestureRecognizer(tapgesture1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }


    func navigationBarConfiguration() {
        setNavigationTitle("Edit Vehicle Info")

        let leftBarButtonItem = StaticHelper.leftBarButtonWithImageNamed(imageName: "backward_arrow_icon", vc: self)
        self.navigationItem.leftBarButtonItems = [leftBarButtonItem]
    }
    
    func uiInitialSettings() {
        topHeadLabel.text = ""
        vehicleYearLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        vehicleTypeTextField.setLeftPaddingPoints(15.0)
        vehicleTypeTextField.setRightCaret(15.0, image: UIImage.init(named: "caret_down")!)
        vehicleYearTextField.setLeftPaddingPoints(15.0)
        vehicleYearTextField.setRightCaret(15.0, image: UIImage.init(named: "caret_down")!)
        topHeadLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)

        lblPhotoInsurance.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        lblPhotoInsurance.textColor = .gray

        lblPhotoVehicle.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        lblPhotoVehicle.textColor = .gray
        
        self.viewPhotoVehicle.layer.borderWidth = 0.5
        self.viewPhotoVehicle.layer.borderColor = UIColor.lightGray.cgColor
        self.viewPhotoVehicle.layer.cornerRadius = 10.0
        
        self.collectionPhotoVehicle.delegate = self
        self.collectionPhotoVehicle.dataSource = self

        self.viewPhotoInsurance.layer.borderWidth = 0.5
        self.viewPhotoInsurance.layer.borderColor = UIColor.lightGray.cgColor
        self.viewPhotoInsurance.layer.cornerRadius = 10.0
        
        self.collectionPhotoInsurance.delegate = self
        self.collectionPhotoInsurance.dataSource = self
        
        contentView.backgroundColor = .white
    }
        
    func setupUI(){

        headerView.frame.size.height = 960.0 * screenHeightFactor
        contentView.frame.size.height = 580.0 * screenHeightFactor
        contentView.layer.cornerRadius = 10.0 * screenHeightFactor
        titleLabel.font = UIFont.josefinSansBoldFontWithSize(size: 12.0)
        subTitleLabel.font = UIFont.josefinSansRegularFontWithSize(size: 10.0)

        let fontSize = 12.0
        vehicleTypeTextField.font = UIFont.josefinSansSemiBoldFontWithSize(size: CGFloat(fontSize))
        vehicleYearTextField.font = UIFont.josefinSansSemiBoldFontWithSize(size: CGFloat(fontSize))
        vehiclePlateNumTextField.font = UIFont.josefinSansSemiBoldFontWithSize(size: CGFloat(fontSize))
        vehicleCompnayTextField.font = UIFont.josefinSansSemiBoldFontWithSize(size: CGFloat(fontSize))
        vehicleModelTextField.font = UIFont.josefinSansSemiBoldFontWithSize(size: CGFloat(fontSize))
        insuranceNumberTextField.font = UIFont.josefinSansSemiBoldFontWithSize(size: CGFloat(fontSize))
        insuranceDateTextField.font = UIFont.josefinSansSemiBoldFontWithSize(size: CGFloat(fontSize))
        
        nextButton.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 13.0)
        nextButton.layer.cornerRadius = 20.0 * screenHeightFactor
        ex1Label.font = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        ex2Label.font = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        vehicleTypeTextField.setLeftPaddingPoints(15.0)
        vehicleYearTextField.setLeftPaddingPoints(15.0)
        
        insuranceDateTextField.setLeftPaddingPoints(15.0)
        insuranceNumberTextField.setLeftPaddingPoints(15.0)
        vehiclePlateNumTextField.setLeftPaddingPoints(15.0)
        vehicleCompnayTextField.setLeftPaddingPoints(15.0)
        vehicleModelTextField.setLeftPaddingPoints(15.0)
        
        let attributes = [
            NSAttributedString.Key.font : UIFont.josefinSansRegularFontWithSize(size: CGFloat(fontSize)),
            NSAttributedString.Key.foregroundColor: greyplaceholderColor
        ]
        
        vehiclePlateNumTextField.attributedPlaceholder = NSAttributedString(string: "VEHICLE PLATE NUMBER", attributes:attributes)
        vehicleCompnayTextField.attributedPlaceholder = NSAttributedString(string: "VEHICLE MAKE", attributes:attributes)
        vehicleModelTextField.attributedPlaceholder = NSAttributedString(string: "VEHICLE MODEL", attributes:attributes)
        
        insuranceNumberTextField.attributedPlaceholder = NSAttributedString(string: "INSURANCE POLICY NUMBER", attributes:attributes)
        insuranceDateTextField.attributedPlaceholder = NSAttributedString(string: "SELECT POLICY EXPIRY DATE", attributes:attributes)
        self.vehicleYear = 0
        if let text = (profileInfo?.vehicleDetails?.type), text.count > 0{
            vehicleType = text
        }
        if let text = (profileInfo?.vehicleDetails?.type), text.count > 0{
            vehicleTypeTextField.text = text
        }
        if let text = profileInfo?.vehicleDetails?.vehicle_year, text.count > 0{
            self.vehicleYear = Int(text) ?? 0
        }
        if let text = (profileInfo?.vehicleDetails?.vehicle_year), text.count > 0{
            vehicleYearTextField.text = text
        }
        if let text = (profileInfo?.vehicleDetails?.plate_num), text.count > 0{
            vehiclePlateNumTextField.text = text
        }
        if let text = (profileInfo?.vehicleDetails?.company_name), text.count > 0{
            vehicleCompnayTextField.text = text
        }
        if let text = (profileInfo?.vehicleDetails?.model), text.count > 0{
            vehicleModelTextField.text = text
        }
        if let text = (profileInfo?.vehicleDetails?.insurance_number), text.count > 0{
            insuranceNumberTextField.text = text
        }
        if let text = (profileInfo?.vehicleDetails?.insurance_policy_expiry), text.count > 0{
            insuranceDateTextField.text = text
        }
        if let text = (profileInfo?.vehicleDetails?.insurance_policy_expiry), text.count > 0{
            finalDate = text
        }
        let arrV:[VehiclePhotosModel] = profileInfo?.vehicleDetails?.vehicle_photo_url ?? []
        for objPhoto in arrV {
            imageUrlsV.append(objPhoto.photo_url ?? "")
            imagesArrayV.append(UIImage())
        }
        let arrI = profileInfo?.vehicleDetails?.vehicle_insurance_photo_url ?? []
        for objPhoto in arrI {
            imageUrls.append(objPhoto.photo_url ?? "")
            imagesArray.append(UIImage())
        }
        
        self.collectionPhotoInsurance.reloadData()
        self.collectionPhotoVehicle.reloadData()

    }
    

    func setYearDataSource(){
        
        var startYear = "1990"
        let endDate = Date()
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy"
        let endYear = fmt.string(from: endDate)
        while Int(startYear)! <= Int(endYear)! {
       
           yearData.append(startYear)
           startYear = String(Int(startYear)! + 1)
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
                        self.showPermmisonAlert(AlertButtonTitle.alert,kStringPermission.cameraMessageTitle, kStringPermission.photos1ItemMessage)
                    }
                }else if index == 1 {
                    let permission = PermissionPhotoHelper()
                    if permission.checkPhotoPermission() == .accepted {
                        self.imagePickerController.sourceType = .photoLibrary
                        //self.imagePickerController.allowsEditing = true
                        self.imagePickerController.delegate = self
                        self.navigationController?.present(self.imagePickerController, animated: true, completion: nil)
                    }else{
                        self.showPermmisonAlert(AlertButtonTitle.alert,kStringPermission.galaryMessageTitle, kStringPermission.photosItemMessage)
                    }
                }else{
                    self.imagePickerController.dismiss(animated: true, completion: {})
                }
            })
        }
    }
    @objc func hidePopup(){
        self.pickerBkView.isHidden = true
    }
    
    @objc func hideKeyboard(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func leftButtonPressed(_ selector: Any){
        if isComeFromServiceStoped{
            self.navigationController?.isNavigationBarHidden = true
        }
        self.navigationController?.popViewController(animated: true)
       
    }

    @IBAction func nextAction(_ sender: Any) {
        self.submitStep3Data()
    }
    
    func submitStep3Data() {
        self.view.endEditing(true)
        if vehicleType.isEmpty{
            self.view.makeToast("Please select vehicle type.")
        }
        else if self.vehicleYearTextField.text! == "Select your vehicle year"{
             self.view.makeToast("Please select vehicle year.")
        }
        else if vehiclePlateNumTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            self.view.makeToast("Please enter vehicle plate number.")
        }
        else if vehicleCompnayTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            self.view.makeToast("Please enter vehicle company.")
        }
        else if vehicleModelTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            self.view.makeToast("Please enter vehicle model.")
        }
        else if insuranceNumberTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            self.view.makeToast("Please Enter Insurance Policy Number.")
        }
        else if finalDate.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            self.view.makeToast("Please select vehicle policy expiry date.")
        }
        else if imageUrls.count == 0 {
            self.view.makeToast("Please add insurance photo.")
        }
        else if imageUrlsV.count <= 3 {
            self.view.makeToast("Please front, left side, right side and back side photos.")
        }
        else{
            self.updateHelperVehicleInfoRequestAPICall()
//            if(isInsurance == true) {
//                self.saveVehicleInfo()
//            } else {
//                self.updateHelperVehicleInfoRequestAPICall()
//            }
        }
        
    }
    
    //************************************************
    //MARK: - Keyboard Notification Methods
    //************************************************
    
//    @objc func keyboardWillShow(_ sender: Notification) {
//        let kbSize = (sender.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
//        let duration: TimeInterval? = CDouble((sender.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval)!)
//        UIView.animate(withDuration: duration!, animations: {() -> Void in
//            let edgeInsets: UIEdgeInsets? = UIEdgeInsets(top: 0, left: 0, bottom: (kbSize.height), right: 0)
//            self.tableView.contentInset = edgeInsets!
//            self.tableView.scrollIndicatorInsets = edgeInsets!
//        })
//    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        let duration: TimeInterval? = CDouble((sender.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval)!)
        UIView.animate(withDuration: duration!, animations: {() -> Void in
            let edgeInsets: UIEdgeInsets = UIEdgeInsets.zero
            self.tableView.contentInset = edgeInsets
            self.tableView.scrollIndicatorInsets = edgeInsets
        })
    }
}

extension EditVehicleInfoViewController: UITextFieldDelegate,PopUpDelegate{
        
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == insuranceDateTextField {
            let datePickerVC = self.storyboard?.instantiateViewController(withIdentifier: "DatePickerViewController") as! DatePickerViewController
            datePickerVC.modalPresentationStyle = .overFullScreen
            datePickerVC.isExpiry = true
            datePickerVC.dateSelectedDelegate = self
            self.present(datePickerVC, animated: true, completion: nil)
            return false
        } else if textField == vehicleTypeTextField{
          
            let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "PopUpTableViewController") as! PopUpTableViewController
            popupVC.modalPresentationStyle = .overFullScreen
            popupVC.popUpDelegate = self
            popupVC.dataSourceArray = self.vehcicleTypeData
            popupVC.popUpTitle = "Select Your Vehicle Type"
            if !vehicleType.isEmpty{
                let selectedIndex = vehcicleTypeData.index(of: vehicleType) as! Int
                popupVC.selectedIndex = selectedIndex
            }

            self.present(popupVC, animated: true, completion: nil)
            return false
        } else if textField == vehicleYearTextField{
            self.pickerBkView.isHidden = false
            self.view.endEditing(true)
            return false
        }
        
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 1{
            vehicleCompnayTextField.becomeFirstResponder()
        }
        else if textField.tag == 2{
             vehicleModelTextField.becomeFirstResponder()
        }
        else{
            textField.resignFirstResponder()
        }
        
        return false
    }
    
    func selectedItems(_ index: Int) {
        callAnalyticsEvent(eventName: "moveit_vehicle_type", desc: ["description":vehcicleTypeData[index]])
        vehicleType = vehcicleTypeData[index]
    }
    
    func updateHelperVehicleInfoRequestAPICall() {
                
        let vehicleID = vehcicleTypeData.firstIndex(of: vehicleType)! + 1
        
        StaticHelper.shared.startLoader(self.view)

        let deviceToken = UserDefaults.standard.value(forKey: "UserToken") as? String ?? ""

        var parameters = [String: Any]()
        parameters["vehicle_type_id"] = vehicleID
        parameters["vehicle_year"] = self.vehicleYear
        parameters["plate_num"] = vehiclePlateNumTextField.text!
        parameters["company_name"] = vehicleCompnayTextField.text!
        parameters["model"] = vehicleModelTextField.text!
        parameters["device_type"] = "I"
        parameters["device_token"] = deviceToken
        parameters["insurance_number"] = insuranceNumberTextField.text!
        parameters["insurance_policy_expiry"] = finalDate
        
        if imagesArrayV.count >= 4 {
            parameters["vehicle_photo"] = [self.imageUrlsV[0], self.imageUrlsV[1], self.imageUrlsV[2], self.imageUrlsV[3]]
        } else {
            parameters["vehicle_photo"] = self.imageUrlsV
        }
        parameters["insurance_photo"] = self.imageUrls
        parameters["is_insurance_request"] = 0
        if isComeFromServiceStoped{
            parameters["is_insurance_request"] = 1
        }
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!,"Content-Type":"application/json"]
        
        print(parameters,header)
                
        AF.request(baseURL + kAPIMethods.update_helper_vehicle_info_request, method: .post, parameters: parameters,encoding: JSONEncoding.default,headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
            switch response.result {
            case .success:
               StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200{
                    let responseJson = response.value as! [String: AnyObject]
                    self.view.makeToast(responseJson["message"] as? String)
                    profileInfo!.vehicleDetails!.is_vehicle_request = "pending"
                    profileInfo!.vehicleDetails!.insurance_message_title = responseJson["insurance_message_title"] as? String
                    profileInfo!.vehicleDetails!.insurance_message = responseJson["insurance_message"] as? String
                    self.perform(#selector(self.popToVehicleVC), with: nil, afterDelay: 1.0)
                } else if response.response?.statusCode == 401{
                    StaticHelper.shared.stopLoader()
                    let responseJson = response.value as! [String: AnyObject]
                    self.view.makeToast(responseJson["message"] as? String)
                } else {
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
    func showInsuranceExpiredMessage(_ message:String = "", _ titleMessage:String = "") {
        
        InsuranceExpiryView.instance.shwoDataWithClosures(titleMessage, message, "", "", AlertButtonTitle.ok){ status in
            if status{
                print("Okay")
                self.navigationController?.popViewController(animated: true)
            }else{
                print("NO/Cancel")
            }
        }
        
//            let viVC = self.storyboard?.instantiateViewController(withIdentifier: "InsuranceExpiredVC") as! InsuranceExpiredVC
//            viVC.message = message
//            viVC.titleMessage = titleMessage
//            viVC.isPendingRequest = true
//            self.navigationController?.isNavigationBarHidden = true
//            self.navigationController?.pushViewController(viVC, animated: true)
    }
    
    @objc func popToVehicleVC() {
//        self.navigationController?.popViewController(animated: true)
        if !isComeFromServiceStoped{
            self.navigationController?.popViewController(animated: true)
        }else{
            CommonAPIHelper.getProfile(VC: self) { (res, err, isExecuted) in
                DispatchQueue.main.async { [self] in
                        profileInfo =  HelperDetailsModel.init(profileDict: res!)
                        showInsuranceExpiredMessage(profileInfo!.vehicleDetails!.insurance_message!, profileInfo!.vehicleDetails!.insurance_message_title!)
                }
            }
        }
    }
}

extension EditVehicleInfoViewController: DateSelectedDelegate{
    func selectedDate(_ dateString: Date) {
        finalDate = dateString.stringDateWitHFormat("yyyy-MM-dd")
        self.insuranceDateTextField.text = dateString.stringDateWitHFormat("MM/dd/yyyy")
    }
}

extension EditVehicleInfoViewController: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return yearData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return yearData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.vehicleYear = Int(yearData[row])!
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 20.0 * screenHeightFactor
    }
}


extension EditVehicleInfoViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(collectionView == collectionPhotoInsurance) {
            if imagesArray.count == 3{
                return 3
            } else {
                return imagesArray.count + 1
            }
        } else {
            if imagesArrayV.count >= 4{
                return 4
            } else {
                return imagesArrayV.count + 1
            }
        }
    }
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(collectionView == collectionPhotoInsurance) {
            let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemImageCollectionViewCell", for: indexPath) as! ItemImageCollectionViewCell

            if imagesArray.count == 3{
                if imagesArray[indexPath.item].size == CGSize.zero{
                    let url = URL.init(string: imageUrls[indexPath.item])
                    itemCell.imageView.af.setImage(withURL: url!)
                } else {
                    itemCell.imageView.image = imagesArray[indexPath.item]
                }
                
                itemCell.crossButton.isHidden = false
            } else {

                if indexPath.item == imagesArray.count{
                    itemCell.imageView.image = UIImage.init(named: "add_item_photo")
                    itemCell.crossButton.isHidden = true
                } else {
                    itemCell.crossButton.isHidden = false
                    if imagesArray[indexPath.item].size == CGSize.zero {
                        let url = URL.init(string: imageUrls[indexPath.item])
                        itemCell.imageView.af.setImage(withURL: url!)
                    } else {
                        itemCell.imageView.image = imagesArray[indexPath.item]
                    }
                }
            }
            itemCell.crossButton.tag = indexPath.row
            itemCell.crossButton.addTarget(self, action: #selector(crossPressed(_:)), for: .touchUpInside)
                        
            return itemCell
        } else {
            let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemImageCollectionViewCell", for: indexPath) as! ItemImageCollectionViewCell

            if imagesArrayV.count == 4 {
                if imagesArrayV[indexPath.item].size == CGSize.zero{
                    let url = URL.init(string: imageUrlsV[indexPath.item])
                    itemCell.imageView.af.setImage(withURL: url!)
                } else {
                    itemCell.imageView.image = imagesArrayV[indexPath.item]
                }
                
                itemCell.crossButton.isHidden = false
            } else {

                if indexPath.item == imagesArrayV.count {
                    itemCell.imageView.image = UIImage.init(named: "add_item_photo")
                    itemCell.crossButton.isHidden = true
                } else{
                    itemCell.crossButton.isHidden = false
                    if imagesArrayV[indexPath.item].size == CGSize.zero {
                        let url = URL.init(string: imageUrlsV[indexPath.item])
                        itemCell.imageView.af.setImage(withURL: url!)
                    } else {
                        itemCell.imageView.image = imagesArrayV[indexPath.item]
                    }
                }
            }
            itemCell.crossButton.tag = indexPath.row
            itemCell.crossButton.addTarget(self, action: #selector(crossPressedV(_:)), for: .touchUpInside)
            
            return itemCell

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == collectionPhotoInsurance) {
            isInsurance = true
            self.showActionSheetWithPermission()
        }else{
            isInsurance = false
            self.showActionSheetWithPermission()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 50.0, height: 50.0)
        //return CGSize.init(width: 50.0 * screenHeightFactor, height: 50.0 * screenHeightFactor)
    }
    
    @objc func crossPressed(_ sender: UIButton){
        
        isInsurance = true
        let index:Int = sender.tag
        if(index < self.imagesArray.count && index < self.imageUrls.count) {
            self.imagesArray.remove(at: index)
            self.imageUrls.remove(at: index)
        }
        self.collectionPhotoInsurance.reloadData()
    }
    
    @objc func crossPressedV(_ sender: UIButton){
        isInsurance = false
        let index:Int = sender.tag
        if(index < self.imagesArrayV.count && index < self.imageUrlsV.count) {
            self.imagesArrayV.remove(at: index)
            self.imageUrlsV.remove(at: index)
        }
        self.collectionPhotoVehicle.reloadData()
    }
}

extension EditVehicleInfoViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    	
    //********************************
    //MARK: - Image Picker Methods
    //********************************
    
    func uploadImages(_ isInsurance:Bool, _ image: UIImage){
//
//        let httpheader: HTTPHeaders = ["Auth-Token": UserCache.userToken() ?? ""]
        let imageData = image.jpegData(compressionQuality: 0.6)
        
       StaticHelper.shared.startLoader(self.view)
        if !StaticHelper.Connectivity.isConnectedToInternet {
                StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: self, completion: nil)
                return
            }
        var parametersDict = Parameters()
        if isInsurance{
            parametersDict = ["folder_name": "helper_insurance_photo"] as [String : Any]
            
        }else{
            parametersDict = ["folder_name": "vehicle_image"] as [String : Any]
        }

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
        }, to: baseURL + kAPIMethods.upload_helper_vehicle_image, method: .post).responseJSON { (response) in
            defer{
                StaticHelper.shared.stopLoader()
            }
            print("resp is \(response)")
            StaticHelper.shared.stopLoader()
            if response.response?.statusCode == 200{
                  StaticHelper.shared.stopLoader()
                if self.isInsurance == true {
                    self.imageUrls.append(((response.value as! [String:Any])["vehicle_image_url"] as! String))
                    self.collectionPhotoInsurance.reloadData()
                } else {
                    self.imageUrlsV.append(((response.value as! [String:Any])["vehicle_image_url"] as! String))
                    self.collectionPhotoVehicle.reloadData()
                }
            } else{
                 StaticHelper.shared.stopLoader()
                if self.isInsurance == false {
                    self.imagesArrayV.removeLast()
                } else {
                    self.imagesArray.removeLast()
                }
                self.view.makeToast("There is some issue while uploading image. Please upload again.")
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var photo = info[UIImagePickerController.InfoKey.originalImage] as! UIImage?
        photo = self.resizeImage(image: photo!, targetSize: CGSize.init(width: 720.0, height: 1080.0))
        if isInsurance == false {
            imagesArrayV.append(photo!)
            self.collectionPhotoVehicle.reloadData()
            self.uploadImages(false, photo!)

        } else {
            imagesArray.append(photo!)
            self.collectionPhotoInsurance.reloadData()
            self.uploadImages(true, photo!)

        }
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
                    alertController.popoverPresentationController?.sourceView = self.collectionPhotoInsurance
                    alertController.popoverPresentationController?.sourceRect = self.collectionPhotoInsurance.bounds
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
extension EditVehicleInfoViewController:AlertViewPermmisionDelegate{
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
