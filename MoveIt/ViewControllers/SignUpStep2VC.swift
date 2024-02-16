//
//  SignUpStep2VC.swift
//  MoveIt
//
//  Created by Jyoti on 02/05/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit
import Alamofire
import Toast_Swift

class SignUpStep2VC: UIViewController,UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
  
    @IBOutlet weak var signUpStep2HeaderLabel: UILabel!
    
    @IBOutlet weak var step2Label: UILabel!
    @IBOutlet weak var signStep2TableView: UITableView!
    @IBOutlet weak var signStep2ContentView: UIView!
    @IBOutlet weak var outerViewStep2: UIView!
    
    @IBOutlet weak var yearMakeModelLabel: UILabel!
    @IBOutlet weak var pickUpTruckLabel: UILabel!
  
    @IBOutlet weak var vehicleTypeView: UIView!
    @IBOutlet weak var vehicleTypeLabel: UILabel!
   
    @IBOutlet weak var vehicleYearView: UIView!
    @IBOutlet weak var vehicleYearLabel: UILabel!
    
    @IBOutlet weak var vehicleNumberView: UIView!
    @IBOutlet weak var vehiclePlateNumberTF: UITextField!
    
    @IBOutlet weak var vehicleCompanyNameView: UIView!
    @IBOutlet weak var vehicleCompanyNameTF: UITextField!
   
    
    @IBOutlet weak var vehicleModelView: UIView!
    @IBOutlet weak var vehicleModelTF: UITextField!
    @IBOutlet weak var nextStep2ButtonOutlet: UIButton!
    
    
    @IBOutlet weak var signStep2TransParentView: UIView!
    @IBOutlet weak var step2ContainerView: UIView!
    @IBOutlet weak var transviewHeaderLabel: UILabel!
    @IBOutlet weak var Step2PopUpTableView: UITableView!
    
    @IBOutlet weak var selectYearTransView: UIView!
    @IBOutlet weak var selectYearPickerView: UIPickerView!
    
    var popUpArray:NSMutableArray!
    var yearValuesArray:NSMutableArray!
    var typeOfVehicle:NSInteger!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setSignStep2UI()
        

    }
    
    func setSignStep2UI(){
       
        signUpStep2HeaderLabel.font = UIFont.josefinSansRegularFontWithSize(size: 14.0)
        step2Label.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        yearMakeModelLabel.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        pickUpTruckLabel.font = UIFont.josefinSansRegularFontWithSize(size: 10.0)
        vehicleTypeLabel.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        vehicleYearLabel.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        nextStep2ButtonOutlet.titleLabel?.font = UIFont.josefinSansRegularFontWithSize(size: 14.0)
        signUpStep2HeaderLabel.font = UIFont.josefinSansRegularFontWithSize(size: 14.0)
        
        
        var plateNumberstring = NSMutableAttributedString()
        let plateNumber = "VEHICLE PLATE NUMBER"
        plateNumberstring = NSMutableAttributedString(string:plateNumber, attributes: [NSAttributedString.Key.font:UIFont.josefinSansRegularFontWithSize(size: 12.0)])
        plateNumberstring.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 152/255, green: 150/255, blue: 158/255, alpha: 1), range:NSMakeRange(0,plateNumber.count))
        
        vehiclePlateNumberTF.attributedPlaceholder = plateNumberstring
        vehiclePlateNumberTF.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        
        var companyNamestring = NSMutableAttributedString()
        let companyName = "VEHICLE MAKE"
        companyNamestring = NSMutableAttributedString(string:companyName, attributes: [NSAttributedString.Key.font:UIFont.josefinSansRegularFontWithSize(size: 12.0)])
        companyNamestring.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 152/255, green: 150/255, blue: 158/255, alpha: 1), range:NSMakeRange(0,companyName.count))
        
        vehicleCompanyNameTF.attributedPlaceholder = companyNamestring
        vehicleCompanyNameTF.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        
        var vehicleModelString = NSMutableAttributedString()
        let model = "VEHICLE MODEL"
        vehicleModelString = NSMutableAttributedString(string:model, attributes: [NSAttributedString.Key.font:UIFont.josefinSansRegularFontWithSize(size: 12.0)])
        vehicleModelString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 152/255, green: 150/255, blue: 158/255, alpha: 1), range:NSMakeRange(0,model.count))
        
        vehicleModelTF.attributedPlaceholder = vehicleModelString
        vehicleModelTF.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        
        popUpArray = ["Pickup truck", "Cargo van", "Box truck", "Vehicle w/trailer"]
        
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(hideKeyboard))
        self.signStep2TableView.addGestureRecognizer(tapGesture)
        
//        let tapGesture1 = UITapGestureRecognizer.init(target: self, action: #selector(hideTransparentView))
//        self.signStep2TransParentView.addGestureRecognizer(tapGesture1)
        
        let tapGesture2 = UITapGestureRecognizer.init(target: self, action: #selector(hideYearTransparentView))
        self.selectYearTransView.addGestureRecognizer(tapGesture2)
        
        yearValuesArray = ["2019", "2018", "2016","2015","2014","2013","2012","2011","2010","2009","2008","2007","2006","2005","2004","2003","2002","2001","2000"]
        
       
    }
    
    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        
        
        signStep2ContentView.frame.size.height = 630 * UIScreen.main.bounds.size.height/568
        
        nextStep2ButtonOutlet.layer.cornerRadius = (nextStep2ButtonOutlet.frame.size.height/2.0)
        nextStep2ButtonOutlet.layer.masksToBounds = true
       
        outerViewStep2.layer.cornerRadius = 10.0
        outerViewStep2.layer.masksToBounds = true
        
        vehicleTypeView.layer.cornerRadius = 5.0
        vehicleTypeView.layer.borderColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1).cgColor
        vehicleTypeView.layer.borderWidth = 1.0;
        vehicleTypeView.layer.masksToBounds = true
        
        vehicleYearView.layer.cornerRadius = 5.0
        vehicleYearView.layer.borderColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1).cgColor
        vehicleYearView.layer.borderWidth = 1.0;
        vehicleYearView.layer.masksToBounds = true
        
        vehicleNumberView.layer.cornerRadius = 5.0
        vehicleNumberView.layer.borderColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1).cgColor
        vehicleNumberView.layer.borderWidth = 1.0;
        vehicleNumberView.layer.masksToBounds = true
        
        vehicleCompanyNameView.layer.cornerRadius = 5.0
        vehicleCompanyNameView.layer.borderColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1).cgColor
        vehicleCompanyNameView.layer.borderWidth = 1.0;
        vehicleCompanyNameView.layer.masksToBounds = true
        
        vehicleModelView.layer.cornerRadius = 5.0
        vehicleModelView.layer.borderColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1).cgColor
        vehicleModelView.layer.borderWidth = 1.0;
        vehicleModelView.layer.masksToBounds = true
        
        signStep2TransParentView.layer.cornerRadius = 10.0
        signStep2TransParentView.layer.masksToBounds = true
    }
    
    @IBAction func signUpBackButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func vehicleTypeButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        signStep2TransParentView.isHidden = false
        selectYearTransView.isHidden = true
        step2ContainerView.layer.cornerRadius = 5.0
        step2ContainerView.layer.masksToBounds = true
    }
   
    @IBAction func vehicleYearButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        selectYearTransView.isHidden = false
       
    }
    
    @IBAction func nextStep2ButtonPressed(_ sender: Any) {
       self.signUpStep2APIMethod()
    }
    
    //# MARK:-UITableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return popUpArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        
        let cell:Step2PopUpCell = (self.Step2PopUpTableView.dequeueReusableCell(withIdentifier:"popUpCell") as! Step2PopUpCell)
        cell.placeLabel?.text = popUpArray[indexPath.row] as? String
       
        return cell
        
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        vehicleTypeLabel.text = (popUpArray[indexPath.row] as! String)
        typeOfVehicle = indexPath.row + 1
        signStep2TransParentView.isHidden = true
    }
    
    //MARK:- UIPickerView Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return yearValuesArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return yearValuesArray![row] as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        vehicleYearLabel.text = yearValuesArray[row] as? String
         self.selectYearTransView.isHidden = true
    }
    
    //#MARK:- UITextField Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
    }
    
    
    //#MARK:-- API Method Implementation
   
    func signUpStep2APIMethod(){
       
        view.endEditing(true)
        let vehicleType = vehicleTypeLabel.text
        let vehicleYear = vehicleYearLabel.text
        let plateNumber = vehiclePlateNumberTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let vehicleMake = vehicleCompanyNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let model = vehicleModelTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if vehicleType!.isEmpty {
            self.view.makeToast("Please select vehicle type.")
            return
        }
        else if vehicleYear!.isEmpty{
            self.view.makeToast("Please select vehicle year.")
            return
        }
        else if plateNumber!.isEmpty{
            self.view.makeToast("Please enter vehicle plate number.")
            return
        }
        else if vehicleMake!.isEmpty{
            self.view.makeToast("Please enter vehicle make.")
            return
        }
        else if model!.isEmpty{
            self.view.makeToast("Please enter vehicle model.")
            return
        }
        else{
                if !StaticHelper.Connectivity.isConnectedToInternet {
                    self.view.makeToast("Please check your Internet Connection.")
                    return
                }
            
            let dict:[String : Any] = [ "vehicle_type_id" : typeOfVehicle!, "model" : model!,"vehicle_year": vehicleYear!,"plate_num": plateNumber!, "company_name": vehicleMake!,"device_type" : "I", "device_token" : "jfkfk121kkvfdkkd"]
            
            let authToken = UserDefaults.standard.value(forKey: "auth_token") as? String
            let headers : HTTPHeaders = ["Auth-Token":authToken!]
                    
                    StaticHelper.shared.startLoader(self.view)
                    
                    AF.request(baseURL + helper_signup_step2, method: .post, parameters: dict, headers: headers  ).responseJSON { (response) in
                        switch response.result {
                        case .success:
                            if response.response?.statusCode == 200{
                                StaticHelper.shared.stopLoader()
                                print(response.value!)
                                let resposneDict = response.value as! [String: Any]
                                
                                if !resposneDict.isEmpty{
                                    let signStep3 = self.storyboard?.instantiateViewController(withIdentifier: "SignUpStep3VC") as! SignUpStep3VC
                                    UserDefaults.standard.set((resposneDict["auth_key"] as! String), forKey: "auth_token")
                                    UserDefaults.standard.set((resposneDict), forKey: "User_Data_Dict")
                                    UserDefaults.standard.synchronize()
                                    self.navigationController?.pushViewController(signStep3, animated: true)
                                }
                            }
                            else if response.response?.statusCode == 201{
                                StaticHelper.shared.stopLoader()
                                let responseJson = response.value as! [String: AnyObject]
                                self.view.makeToast(responseJson["message"] as? String)
                            }else if response.response?.statusCode == 409{
                                StaticHelper.shared.stopLoader()
                                let responseJson = response.value as! [String: AnyObject]
                                self.view.makeToast(responseJson["message"] as? String)
                                StaticHelper.moveToViewController("LoginVC", animated: true)
                                print(responseJson)
                                
                            }else if response.response?.statusCode == 500{
                                StaticHelper.shared.stopLoader()
                                let responseJson = response.value as! [String: AnyObject]
                                self.view.makeToast(responseJson["message"] as? String)
                                
                            }else if response.response?.statusCode == 400{
                                StaticHelper.shared.stopLoader()
                                let responseJson = response.value as! [String: AnyObject]
                                self.view.makeToast(responseJson["message"] as? String)
                                
                            }else if response.response?.statusCode == 403{
                                StaticHelper.shared.stopLoader()
                                UserDefaults.standard.removeObject(forKey: "auth_token")
                                UserDefaults.standard.removeObject(forKey: "User_Data_Dict")
                                UserDefaults.standard.synchronize()
                            }
                            else if response.response?.statusCode == 401{
                                StaticHelper.shared.stopLoader()
                                let responseJson = response.value as! [String: AnyObject]
                                self.view.makeToast(responseJson["message"] as? String)
                            }
                        
                        case .failure(let error):
                            StaticHelper.shared.stopLoader()
                            self.view.makeToast(message)
                            print (error.localizedDescription)
                        }
                   }
             }
      }

    //#Mark:-Hide Keyboard and TransparentView
  
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }

// / c func hideTransparentView(){
//        self.view.endEditing(true)
//        self.signStep2TransParentView.isHidden = true
//    }
    
   @objc func hideYearTransparentView(){
    self.view.endEditing(true)
    self.selectYearTransView.isHidden = true
   }

}
