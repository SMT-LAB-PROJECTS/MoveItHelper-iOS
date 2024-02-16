//
//  VehicleInfoViewController.swift
//  MoveIt
//
//  Created by Dushyant on 19/07/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit
import Alamofire

class VehicleInfoViewController: UIViewController {

    @IBOutlet weak var vehicleTypeLabel: UILabel!
    @IBOutlet weak var vehicleTypeTextField: UITextField!
    
    @IBOutlet weak var vehicleYearLabel: UILabel!
    @IBOutlet weak var vehicleYearTextField: UITextField!
    
    @IBOutlet weak var vehiclePlateLabel: UILabel!
    @IBOutlet weak var vehiclePlateTextField: UITextField!
    
    @IBOutlet weak var vehicleMakeLabel: UILabel!
    @IBOutlet weak var vehicleMakeTextField: UITextField!
    
    @IBOutlet weak var vehicleModelLabel: UILabel!
    @IBOutlet weak var vehicleModelTextField: UITextField!
    
    @IBOutlet weak var policyNumberLabel: UILabel!
    @IBOutlet weak var policyNumberTextField: UITextField!
    @IBOutlet weak var policyExpiryLabel: UILabel!
    @IBOutlet weak var policyExpiryTextField: UITextField!
    
    @IBOutlet weak var vehiclePhotosLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var insurancePhotosLabel: UILabel!
    @IBOutlet weak var insurancecollectionView: UICollectionView!

    @IBOutlet weak var lblEdit: UILabel!
    @IBOutlet weak var viewForPopup: UIView!
    @IBOutlet weak var ConstraintHeightLable: NSLayoutConstraint!
    
    
    var finalDate:String = ""
    var helper_id:String = ""
    var vehicleType = ""{
        didSet{
            vehicleTypeTextField.text = vehicleType
        }
    }
    
    var vehicleYear = Int(){
        didSet{
            vehicleYearTextField.text = String(vehicleYear)
            vehicleYearTextField.resignFirstResponder()
        }
    }
    
    var vehcicleTypeData = ["Pickup truck", "Cargo van", "Box truck", "Vehicle w/a trailer"]
    var yearData = [String]()
    
    var imagesArray = [UIImage]()
    var imageUrls = [String]()

    var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.uiConfigurationAfterStoryboard()
        self.setYearDataSource()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getProfileInfo()
    }
    
    
    func uiConfigurationAfterStoryboard() {
        setNavigationTitle("Vehicle Info")
        
        let leftBarButtonItem = StaticHelper.leftBarButtonWithImageNamed(imageName: "backward_arrow_icon", vc: self)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        vehicleTypeLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        vehicleYearLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        vehiclePlateLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        vehicleMakeLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        vehicleModelLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        vehiclePhotosLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        
        policyNumberLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        policyExpiryLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
            
        vehicleTypeTextField.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        vehicleYearTextField.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        vehiclePlateTextField.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        vehicleMakeTextField.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        vehicleModelTextField.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        
        policyNumberTextField.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        policyExpiryTextField.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        
        vehicleTypeTextField.delegate = self
        vehicleYearTextField.delegate = self
        vehiclePlateTextField.delegate = self
        vehicleMakeTextField.delegate = self
        vehicleModelTextField.delegate = self
        
        policyNumberTextField.delegate = self
        policyExpiryTextField.delegate = self

        pickerView = UIPickerView()
        pickerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 256)
        pickerView.delegate = self
        pickerView.dataSource = self
        
        vehicleYearTextField.inputView = pickerView

    }

    func reloadData() {
                
        vehicleType = profileInfo?.vehicleDetails?.type ?? ""
        vehicleYearTextField.text = (profileInfo?.vehicleDetails?.vehicle_year)!
        vehiclePlateTextField.text = (profileInfo?.vehicleDetails?.plate_num)!
        vehicleMakeTextField.text = (profileInfo?.vehicleDetails?.company_name)!
        vehicleModelTextField.text = (profileInfo?.vehicleDetails?.model)!
        
        policyNumberTextField.text = (profileInfo?.vehicleDetails?.insurance_number)!
        policyExpiryTextField.text = (profileInfo?.vehicleDetails?.insurance_policy_expiry)!
        
        self.collectionView.reloadData()
        self.insurancecollectionView.reloadData()
    }
    
    func showEditedRequestView(_ isComeFrom:String = "", _ message:String = "") {
       
        lblEdit.font = UIFont.josefinSansBoldFontWithSize(size: 12.0)
        lblEdit.backgroundColor = .clear
        viewForPopup.backgroundColor = UIColor.init(red: 246.0/255.0, green : 174.0/255.0, blue: 180.0/255.0, alpha: 0.1)
        viewForPopup.layer.borderWidth = 0.5
        viewForPopup.layer.borderColor = UIColor.gray.cgColor
                    
        
        let str1:String = "\nYour Edit Vehicle Info Request Is Pending."
        let str12:String = "\n\n"
        let str2:String = "Your vehicle information will be updated, once it approved\n"
        
        let str3:String = "\(message)\n"

        var attributedText = NSMutableAttributedString(string: str1, attributes: [NSAttributedString.Key.font: UIFont.josefinSansRegularFontWithSize(size: 13.0), NSAttributedString.Key.foregroundColor: UIColor.black])
        
        attributedText.append(NSAttributedString(string: str12, attributes: [NSAttributedString.Key.font: UIFont.josefinSansRegularFontWithSize(size: 6.0), NSAttributedString.Key.foregroundColor: UIColor.black]))
        
        let color2 = UIColor.init(_colorLiteralRed: 101/255.0, green: 113/255.0, blue: 142/255.0, alpha: 1.0)
        
        attributedText.append(NSAttributedString(string: str2, attributes: [NSAttributedString.Key.font: UIFont.josefinSansRegularFontWithSize(size: 11.0), NSAttributedString.Key.foregroundColor: color2]))
        
        switch isComeFrom {
        case vehicleInfoString.isComeFromBoth:
            ConstraintHeightLable.constant = 170.0
            attributedText.append(NSAttributedString(string: str3, attributes: [NSAttributedString.Key.font: UIFont.josefinSansRegularFontWithSize(size: 13.0), NSAttributedString.Key.foregroundColor: UIColor.black]))
            
            break;
        case vehicleInfoString.isComeFromPending:
            ConstraintHeightLable.constant = 85.0
            attributedText.append(NSAttributedString(string: "", attributes: [NSAttributedString.Key.font: UIFont.josefinSansRegularFontWithSize(size: 13.0), NSAttributedString.Key.foregroundColor: UIColor.black]))
            break;
        case vehicleInfoString.isComeFromInsuranceExpire:
            ConstraintHeightLable.constant = 95.0
            attributedText = NSMutableAttributedString(string: str3, attributes: [NSAttributedString.Key.font: UIFont.josefinSansRegularFontWithSize(size: 13.0), NSAttributedString.Key.foregroundColor: UIColor.black])


            break;
        default:
            break;

        }
        lblEdit.numberOfLines = 0
        lblEdit.attributedText = attributedText
        lblEdit.textAlignment = .center
        self.navigationItem.rightBarButtonItem = nil

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

    @objc func leftButtonPressed(_ selector: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func rightTextPressed(_ selector: Any){
        
        let editVehicleInfoVC = self.storyboard?.instantiateViewController(withIdentifier: "EditVehicleInfoViewController") as! EditVehicleInfoViewController
        self.navigationController?.pushViewController(editVehicleInfoVC, animated: true)
    }

    //MARK: - button actions
    @IBAction func editPhotosButtonClicked(_ sender: UIButton) {
        let vehicleVC = self.storyboard?.instantiateViewController(withIdentifier: "EditVehiclePhotoViewController") as! EditVehiclePhotoViewController
        self.navigationController?.pushViewController(vehicleVC, animated: true)
    }
    
    @IBAction func editInsuranceButtonClicked(_ sender: UIButton) {
        let vehicleVC = self.storyboard?.instantiateViewController(withIdentifier: "EditVehiclePhotoViewController") as! EditVehiclePhotoViewController
            vehicleVC.isInsurance = true
        self.navigationController?.pushViewController(vehicleVC, animated: true)
    }
    
    @IBAction func saveButtonCliecked() {
        self.updateInsuranceImage()
    }
    
    //MARK: - APIs
    
    @objc func getProfileInfo() {
        CommonAPIHelper.getProfile(VC: self) { (res, err, isExecuted) in
            if isExecuted{
                
                profileInfo =  HelperDetailsModel.init(profileDict: res!)
                print("profileInfo!.vehicleDetails!.is_vehicle_request = ", profileInfo!.vehicleDetails!.is_vehicle_request!)
                
                if(profileInfo!.vehicleDetails!.is_vehicle_request == "pending") {
                    self.showEditedRequestView(vehicleInfoString.isComeFromPending)
                    self.navigationItem.rightBarButtonItem = nil
                }else if(profileInfo!.vehicleDetails!.is_insurance_expire == "1") {
                    self.showEditedRequestView(vehicleInfoString.isComeFromInsuranceExpire, profileInfo!.vehicleDetails!.insurance_message!)
                    let rightBarTextButton =  StaticHelper.rightBarButtonWithText(text: "Edit", vc: self)
                    self.navigationItem.rightBarButtonItem = rightBarTextButton
                }else{//if(profileInfo!.vehicleDetails!.is_vehicle_request != "pending")
                    let rightBarTextButton =  StaticHelper.rightBarButtonWithText(text: "Edit", vc: self)
                    self.navigationItem.rightBarButtonItem = rightBarTextButton
                }
                
                self.reloadData()
            }
        }
    }

    func updateInsuranceImage() {
                
        let vehicleID = vehcicleTypeData.firstIndex(of: vehicleType)! + 1
        
        StaticHelper.shared.startLoader(self.view)

        let deviceToken = UserDefaults.standard.value(forKey: "UserToken") as? String ?? ""

        var parameters = [String: Any]()
        parameters["vehicle_type_id"] = vehicleID
        parameters["vehicle_year"] = self.vehicleYear
        parameters["plate_num"] = vehiclePlateTextField.text!
        parameters["company_name"] = vehicleMakeTextField.text!
        parameters["model"] = vehicleModelTextField.text!
        parameters["device_type"] = "I"
        parameters["device_token"] = deviceToken
        parameters["insurance_number"] = policyNumberTextField.text!
        parameters["insurance_policy_expiry"] = policyExpiryTextField.text!
        
        parameters["vehicle_photo_url"] = convertVehiclePhotosArrayToDictionaries(list: (profileInfo?.vehicleDetails!.vehicle_photo_url)!)
        
        parameters["insurance_photo"] = convertVehiclePhotosArrayToString(list: (profileInfo?.vehicleDetails!.vehicle_insurance_photo_url)!)
        
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!,"Content-Type":"application/json"]
        
        print(parameters,header)
                
        AF.request(baseURL + kAPIMethods.update_helper_vehicle_info_request, method: .post, parameters: parameters,encoding: JSONEncoding.default,headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
            switch response.result {
            case .success:
               StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200{

                    self.getProfileInfo()
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
}

extension VehicleInfoViewController: UIPickerViewDelegate,UIPickerViewDataSource{
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

extension VehicleInfoViewController: DateSelectedDelegate {
    func selectedDate(_ dateString: Date) {
        finalDate = dateString.stringDateWitHFormat("yyyy/MM/dd")
        self.policyExpiryTextField.text = dateString.stringDateWitHFormat("MM/dd/yyyy")
    }
}

extension VehicleInfoViewController: UITextFieldDelegate, PopUpDelegate{
    
//    func selectedDate(_ dateString: Date) {
//        finalDate = dateString.stringDateWitHFormat("yyyy/MM/dd")
//        self.policyExpiryTextField.text = dateString.stringDateWitHFormat("MM/dd/yyyy")
//    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == policyExpiryTextField {
            let datePickerVC = self.storyboard?.instantiateViewController(withIdentifier: "DatePickerViewController") as! DatePickerViewController
            datePickerVC.modalPresentationStyle = .overFullScreen
            datePickerVC.isExpiry = true
            datePickerVC.dateSelectedDelegate = self
            self.present(datePickerVC, animated: true, completion: nil)
            return false
        } else if textField == vehicleTypeTextField {
          
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
        } else if textField == vehicleYearTextField {
//            self.pickerBkView.isHidden = false
//            self.view.endEditing(true)
//            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if textField.tag == 1{
//            vehicleCompnayTextField.becomeFirstResponder()
//        }
//        else if textField.tag == 2{
//             vehicleModelTextField.becomeFirstResponder()
//        }
//        else{
//            textField.resignFirstResponder()
//        }
        
        return false
    }
    
    func selectedItems(_ index: Int) {
        callAnalyticsEvent(eventName: "moveit_vehicle_type", desc: ["description":vehcicleTypeData[index]])
        vehicleType = vehcicleTypeData[index]
    }
    
}

extension VehicleInfoViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(collectionView == self.collectionView) {
            return (profileInfo?.vehicleDetails?.vehicle_photo_url)?.count ?? 0
        } else {
            return (profileInfo?.vehicleDetails?.vehicle_insurance_photo_url)?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(collectionView == self.collectionView) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VehicleImg", for: indexPath)
            let imgview = cell.viewWithTag(5) as! UIImageView
            imgview.layer.cornerRadius = 5.0
            imgview.layer.borderColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1).cgColor
            imgview.layer.borderWidth = 1.0
            imgview.layer.masksToBounds = true
            
            let imgStr = (profileInfo?.vehicleDetails?.vehicle_photo_url[indexPath.item].photo_url ?? "")
            if let imgURL = URL.init(string: imgStr) {
                //imgview.af_setImage(withURL: imgURL)
                imgview.af.setImage(withURL: imgURL, placeholderImage: UIImage.init(named: "home_card_landscape_placeholder"), filter: nil, progress: nil, progressQueue: .main, imageTransition: .noTransition, runImageTransitionIfCached: .init()) { (_) in
                                  }
                
            } else{
                imgview.image = UIImage(named: "home_card_landscape_placeholder")
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VehicleImg", for: indexPath)
            let imgview = cell.viewWithTag(5) as! UIImageView
            imgview.layer.cornerRadius = 5.0
            imgview.layer.borderColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1).cgColor
            imgview.layer.borderWidth = 1.0
            imgview.layer.masksToBounds = true
            
            let imgStr = (profileInfo?.vehicleDetails?.vehicle_insurance_photo_url[indexPath.item].photo_url ?? "")
            if let imgURL = URL.init(string: imgStr) {
                //imgview.af_setImage(withURL: imgURL)
                imgview.af.setImage(withURL: imgURL, placeholderImage: UIImage.init(named: "home_card_landscape_placeholder"), filter: nil, progress: nil, progressQueue: .main, imageTransition: .noTransition, runImageTransitionIfCached: .init()) { (_) in
                    
                }
            } else {
                imgview.image = UIImage(named: "home_card_landscape_placeholder")
            }
            return cell

        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 60.0, height: 60.0)
        //return CGSize.init(width: 60.0 * screenHeightFactor, height: 60.0 * screenHeightFactor)
    }
}
