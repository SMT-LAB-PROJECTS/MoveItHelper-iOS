//
//  UploadInformationViewController.swift
//  MoveIt
//
//  Created by RV on 11/06/21.
//  Copyright © 2021 Jyoti. All rights reserved.
//

import UIKit
import Alamofire

class UploadInformationViewController: UIViewController {
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
    @IBOutlet weak var ex1Label: UILabel!
    @IBOutlet weak var ex2Label: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var pickerBkView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    var selectedService: Int?
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
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle("Update Information")
        
        let leftBarButtonItem = StaticHelper.leftBarButtonWithImageNamed(imageName: "backward_arrow_icon", vc: self)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    
        vehicleYearLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        
        let label = UILabel()
        label.text = "Step 1/2"
        label.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        label.textColor = darkPinkColor
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: label)
    
        self.setupUI()
        self.setYearDataSource()
        self.pickerBkView.isHidden = true
        let tapgesture = UITapGestureRecognizer.init(target: self, action: #selector(hideKeyboard))
        self.tableView.addGestureRecognizer(tapgesture)
        vehicleTypeTextField.setLeftPaddingPoints(15.0)
        vehicleTypeTextField.setRightCaret(15.0, image: UIImage.init(named: "caret_down")!)
        vehicleYearTextField.setLeftPaddingPoints(15.0)
        vehicleYearTextField.setRightCaret(15.0, image: UIImage.init(named: "caret_down")!)
        topHeadLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        
        let tapgesture1 = UITapGestureRecognizer.init(target: self, action: #selector(hidePopup))
        self.pickerBkView.addGestureRecognizer(tapgesture1)
    }
    
    @objc func hidePopup(){
        self.pickerBkView.isHidden = true
      
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
        self.view.endEditing(true)
        //self.dismiss(animated: true, completion: nil)
    }
    @objc func leftButtonPressed(_ selector: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupUI(){
        headerView.frame.size.height = 544.0 * screenHeightFactor
        contentView.layer.cornerRadius = 10.0 * screenHeightFactor
        titleLabel.font = UIFont.josefinSansBoldFontWithSize(size: 12.0)
        subTitleLabel.font = UIFont.josefinSansRegularFontWithSize(size: 10.0)
        vehicleTypeTextField.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        vehicleYearTextField.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        vehiclePlateNumTextField.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        vehicleCompnayTextField.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        vehicleModelTextField.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        nextButton.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 13.0)
        nextButton.layer.cornerRadius = 20.0 * screenHeightFactor
        ex1Label.font = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        ex2Label.font = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        vehicleTypeTextField.setLeftPaddingPoints(15.0)
        vehicleYearTextField.setLeftPaddingPoints(15.0)
        vehiclePlateNumTextField.setLeftPaddingPoints(15.0)
        vehicleCompnayTextField.setLeftPaddingPoints(15.0)
        vehicleModelTextField.setLeftPaddingPoints(15.0)
        
        let attributes = [
            
            NSAttributedString.Key.font : UIFont.josefinSansRegularFontWithSize(size: 12.0),
            NSAttributedString.Key.foregroundColor: greyplaceholderColor
       
        ]
        
        vehiclePlateNumTextField.attributedPlaceholder = NSAttributedString(string: "VEHICLE PLATE NUMBER", attributes:attributes)
        vehicleCompnayTextField.attributedPlaceholder = NSAttributedString(string: "VEHICLE MAKE", attributes:attributes)
        vehicleModelTextField.attributedPlaceholder = NSAttributedString(string: "VEHICLE MODEL", attributes:attributes)
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
        else{
            saveVehicleInfo()
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

extension UploadInformationViewController: UITextFieldDelegate,PopUpDelegate{
   
  
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == vehicleTypeTextField{
          
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
        }
        else if textField == vehicleYearTextField{
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
        
        let vehicleID = (vehcicleTypeData.firstIndex(of: vehicleType) ?? 0) + 1
        
        
        let dict:[String : Any] = ["vehicle_type_id" : vehicleID, "vehicle_year" : self.vehicleYear,"plate_num" : vehiclePlateNumTextField.text!, "company_name" : vehicleCompnayTextField.text!,"model" : vehicleModelTextField.text!,"service_type":"\(selectedService ?? 1)"]
        
        print(dict)
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: self, completion: nil)
            return
        }
        
        let uploadVehicleImagesViewController = self.storyboard?.instantiateViewController(withIdentifier: "UploadVehicleImagesViewController") as! UploadVehicleImagesViewController
        uploadVehicleImagesViewController.dict = dict
        uploadVehicleImagesViewController.selectedService = self.selectedService
        self.navigationController?.pushViewController(uploadVehicleImagesViewController, animated: true)
        
    }
    
    
}
extension UploadInformationViewController: UIPickerViewDelegate,UIPickerViewDataSource{
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

