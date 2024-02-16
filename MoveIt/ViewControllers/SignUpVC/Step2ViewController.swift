//
//  Step2ViewController.swift
//  MoveIt
//
//  Created by Dushyant on 23/05/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit
import Alamofire

class Step2ViewController: UIViewController {
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

    @IBOutlet weak var ex1Label: UILabel!
    @IBOutlet weak var ex2Label: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var pickerBkView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var finalDate:String = ""
    var alertPermmisionView :AlertViewPermmision?
    var isHideBackButton = true

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
    
    let imagePickerController = UIImagePickerController()
//    var itemImage = UIImage()
//    var itemName = String()
    
    
    let datePicker = UIDatePicker()

    var selectedService: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(selectedService != -1) {
            setNavigationTitle("Update Information")
        } else {
            setNavigationTitle("Sign Up")
        }
//        self.navigationItem.leftBarButtonItem = nil
//        self.navigationItem.leftBarButtonItems = nil
        if isHideBackButton{
            self.navigationItem.setHidesBackButton(true, animated: true)
        }else{
            self.navigationItem.leftBarButtonItem = StaticHelper.leftBarButton(withImageNamed: "backward_arrow_icon", forVC: self)
          
        }
        //HIDE BACK BUTTOM
//        if let viewControllers = self.navigationController?.viewControllers {
//            if(viewControllers.count > 1) {
//                let leftBarButtonItem = StaticHelper.leftBarButtonWithImageNamed(imageName: "backward_arrow_icon", vc: self)
//                self.navigationItem.leftBarButtonItems = [leftBarButtonItem]
//            }
//        }
        vehicleYearLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        
        let label = UILabel()
        if(selectedService != -1) {
            label.text = "Step 1/2"
        } else {
            label.text = "Step 2/5"
        }
        label.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        label.textColor = darkPinkColor
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: label)
    
        self.setupUI()
        self.setYearDataSource()
        self.pickerBkView.isHidden = true

        vehicleTypeTextField.setLeftPaddingPoints(15.0)
        vehicleTypeTextField.setRightCaret(15.0, image: UIImage.init(named: "caret_down")!)
        vehicleYearTextField.setLeftPaddingPoints(15.0)
        vehicleYearTextField.setRightCaret(15.0, image: UIImage.init(named: "caret_down")!)
        topHeadLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        lblPhotoInsurance.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        lblPhotoInsurance.textColor = .gray
        
        self.viewPhotoInsurance.layer.borderWidth = 0.5
        self.viewPhotoInsurance.layer.borderColor = UIColor.lightGray.cgColor
        self.viewPhotoInsurance.layer.cornerRadius = 10.0
        
        self.collectionPhotoInsurance.delegate = self
        self.collectionPhotoInsurance.dataSource = self
        
        let tapgesture1 = UITapGestureRecognizer.init(target: self, action: #selector(hidePopup))
        self.pickerBkView.addGestureRecognizer(tapgesture1)
        
        contentView.backgroundColor = .white
    }

    @objc func hidePopup(){
        self.pickerBkView.isHidden = true
    }
    
    @objc func leftPressed(_ selector: Any){
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func hideKeyboard(){
        self.dismiss(animated: true, completion: nil)
    }
    @objc func leftButtonPressed(_ selector: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupUI(){

        headerView.frame.size.height = 700.0 * screenHeightFactor
        contentView.frame.size.height = 600.0 * screenHeightFactor
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
    
    @IBAction func nextAction(_ sender: Any) {
        
//        let completedStep =  Int(UserCache.shared.userInfo(forKey: kUserCache.completedStep)  as! Int)
//        if(completedStep > 1) {
//            let step3 = self.storyboard?.instantiateViewController(withIdentifier: "Step3ViewController") as! Step3ViewController
//            self.navigationController?.pushViewController(step3, animated: true)
//            return
//        }
        submitStep3Data()
    }
    
    func submitStep3Data(){
        

        
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
            self.view.makeToast("Please enter insurance number.")
        }
        else if finalDate.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            self.view.makeToast("Please select vehicle policy expiry date.")
        }
        else if imageUrls.count == 0 {
            self.view.makeToast("Please add insurance photo.")
        }
        else {
            self.saveVehicleInfo()
        }
        
    }
    
    //************************************************
    //MARK: - Keyboard Notification Methods
    //************************************************
    
    @objc func keyboardWillShow(_ sender: Notification) {
        let kbSize = (sender.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        let duration: TimeInterval? = CDouble((sender.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval)!)
        UIView.animate(withDuration: duration!, animations: {() -> Void in
            let edgeInsets: UIEdgeInsets? = UIEdgeInsets(top: 0, left: 0, bottom: (kbSize.height), right: 0)
            self.tableView.contentInset = edgeInsets!
            self.tableView.scrollIndicatorInsets = edgeInsets!
        })
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        let duration: TimeInterval? = CDouble((sender.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval)!)
        UIView.animate(withDuration: duration!, animations: {() -> Void in
            let edgeInsets: UIEdgeInsets = UIEdgeInsets.zero
            self.tableView.contentInset = edgeInsets
            self.tableView.scrollIndicatorInsets = edgeInsets
        })
    }
}

extension Step2ViewController: UITextFieldDelegate,PopUpDelegate{
        
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
    
    func saveVehicleInfo(){
        
        let vehicleID = vehcicleTypeData.firstIndex(of: vehicleType)! + 1
        
//        dict["vehicle_image_url"] = [imgWithKey[0]!,imgWithKey[1]!,imgWithKey[2]!,imgWithKey[3]!]

        let dict:[String : Any] = ["vehicle_type_id" : vehicleID, "vehicle_year" : self.vehicleYear,"plate_num" : vehiclePlateNumTextField.text!, "company_name" : vehicleCompnayTextField.text!,"model" : vehicleModelTextField.text!,"device_name": UIDevice.current.model,"device_version":UIDevice.current.systemVersion,"app_version": UIApplication.shared.versionBuild(), "insurance_number": insuranceNumberTextField.text!, "insurance_policy_expiry": finalDate, "insurance_photo": self.imageUrls]
        
        if(selectedService != -1) {
            let uploadVehicleImagesViewController = self.storyboard?.instantiateViewController(withIdentifier: "UploadVehicleImagesViewController") as! UploadVehicleImagesViewController
            uploadVehicleImagesViewController.dict = dict
            uploadVehicleImagesViewController.selectedService = self.selectedService
            self.navigationController?.pushViewController(uploadVehicleImagesViewController, animated: true)
            return
        }
        
        
        print(dict)
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: self, completion: nil)
            return
        }
        
        
        StaticHelper.shared.startLoader(self.view)
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
        AF.request(baseURL + helper_signup_step2, method: .post, parameters: dict, headers: header  ).responseJSON { (response) in
            
            DispatchQueue.main.async {
                StaticHelper.shared.stopLoader()

            switch response.result {
            case .success:
                print(response.response?.statusCode)
                if response.response?.statusCode == 200{
                    let resposneDict = response.value as! [String: Any]
                    
                    if !resposneDict.isEmpty{
                        UserCache.shared.updateUserProperty(forKey: kUserCache.completedStep, withValue:  2 as AnyObject)
                        
                        let step3 = self.storyboard?.instantiateViewController(withIdentifier: "Step3ViewController") as! Step3ViewController
                        self.navigationController?.pushViewController(step3, animated: true)
                    }
                } else if response.response?.statusCode == 409 {
                    let step3 = self.storyboard?.instantiateViewController(withIdentifier: "Step3ViewController") as! Step3ViewController
                    self.navigationController?.pushViewController(step3, animated: true)
                }
             
            case .failure(let error):
                StaticHelper.shared.stopLoader()
                self.view.makeToast(messageError)
                print (error.localizedDescription)
            }
            }
            
        }
        
    }
    
    
}

extension Step2ViewController: DateSelectedDelegate{
    func selectedDate(_ dateString: Date) {
        finalDate = dateString.stringDateWitHFormat("yyyy/MM/dd")
        self.insuranceDateTextField.text = dateString.stringDateWitHFormat("MM/dd/yyyy")
    }
}

extension Step2ViewController: UIPickerViewDelegate,UIPickerViewDataSource{
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


extension Step2ViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imagesArray.count == 3{
            return 3
        }
        else{
            return imagesArray.count + 1
        }
     
    }
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemImageCollectionViewCell", for: indexPath) as! ItemImageCollectionViewCell

        if imagesArray.count == 3{
            if imagesArray[indexPath.item].size == CGSize.zero{
                let url = URL.init(string: imageUrls[indexPath.item])
                itemCell.imageView.af.setImage(withURL: url!)
            }
            else{
                itemCell.imageView.image = imagesArray[indexPath.item]
            }
            
            itemCell.crossButton.isHidden = false
        }
        else{

            if indexPath.item == imagesArray.count{
                itemCell.imageView.image = UIImage.init(named: "add_item_photo")
                itemCell.crossButton.isHidden = true
            }
            else{
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
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showActionSheetWithPermission()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 50.0, height: 50.0)
        //return CGSize.init(width: 50.0 * screenHeightFactor, height: 50.0 * screenHeightFactor)
    }
    
    @objc func crossPressed(_ sender: UIButton){
        let index:Int = sender.tag
        if(index < self.imagesArray.count && index < self.imageUrls.count) {
            self.imagesArray.remove(at: index)
            self.imageUrls.remove(at: index)
        }
        self.collectionPhotoInsurance.reloadData()
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
                        self.showPermmisonAlert(AlertButtonTitle.alert, kStringPermission.cameraMessageTitle, kStringPermission.photos1ItemMessage)
                    }
                }else if index == 1 {
                    let permission = PermissionPhotoHelper()
                    if permission.checkPhotoPermission() == .accepted {
                        self.imagePickerController.sourceType = .photoLibrary
                        //self.imagePickerController.allowsEditing = true
                        self.imagePickerController.delegate = self
                        self.navigationController?.present(self.imagePickerController, animated: true, completion: nil)
                    }else{
                        self.showPermmisonAlert(AlertButtonTitle.alert, kStringPermission.galaryMessageTitle, kStringPermission.photosItemMessage)
                    }
                }else{
                    self.imagePickerController.dismiss(animated: true, completion: {})
                }
            })
        }
    }
}

extension Step2ViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    //********************************
    //MARK: - Image Picker Methods
    //********************************
    
    func uploadImages(_ image: UIImage){
//
//        let httpheader: HTTPHeaders = ["Auth-Token": UserCache.userToken() ?? ""]
        let imageData = image.jpegData(compressionQuality: 0.6)
        
       StaticHelper.shared.startLoader(self.view)
        if !StaticHelper.Connectivity.isConnectedToInternet {
                StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: self, completion: nil)
                return
            }
            
        let parametersDict : Parameters = ["folder_name": "helper_insurance_photo"] as [String : Any]

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
            DispatchQueue.main.async {
            StaticHelper.shared.stopLoader()
            if response.response?.statusCode == 200{
                  StaticHelper.shared.stopLoader()
                self.imageUrls.append(((response.value as! [String:Any])["vehicle_image_url"] as! String))
                self.collectionPhotoInsurance.reloadData()
            } else{
                 StaticHelper.shared.stopLoader()
                self.imagesArray.removeLast()
                self.view.makeToast("There is some issue while uploading image. Please upload again.")
            }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var photo = info[UIImagePickerController.InfoKey.originalImage] as! UIImage?
        photo = self.resizeImage(image: photo!, targetSize: CGSize.init(width: 720.0, height: 1080.0))
        imagesArray.append(photo!)
        self.uploadImages(photo!)
        self.collectionPhotoInsurance.reloadData()
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
extension Step2ViewController:AlertViewPermmisionDelegate{
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
