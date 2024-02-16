//
//  Step4ViewController.swift
//  MoveIt
//
//  Created by Dushyant on 23/05/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit
import Alamofire

class Step4ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, PopUpDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var nextButton: UIButton!

    @IBOutlet weak var familyInfoView: UIView!
    @IBOutlet weak var familyInfoSUbView: UIView!
    @IBOutlet weak var enterDetailLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumTextField: UITextField!
    
    @IBOutlet weak var doneButton: UIButton!

    let zelleAccountTextField: UITextField = UITextField()
    
    var questionsDict = [String: Any]()
    
    var arrCities:[MoveItCity] = []
    
    var metropolitialArea:[String] = ["Las Vegas and Henderson", "San Diego California", "Tucson Arizona"]
    
    var tShirtSizes = ["Medium","Large","X-Large","XX-Large","XXX-Large"]
    var hereAboutOptions = ["Craigslist","Facebook","Ford Credit", "Referred By a Friend","Referred by a Move It Helper", "Public transit","Crowded","News", "Google","CrossFit","Flyer","Other (Please Specify)"]
    var questionsArray = ["Which metropolitan area do you want to work in?",
                          "Do you have an iPhone or Android smartphone with GPS that can support the Move It App?",
                          "Are you able to lift 80 lbs over your head, and are you willing to lift and carry large, bulky items such as couches and desks?",
                          "Are you able to be paid weekly via direct deposit into your Zelle account?\n\nZelle is the one and only way Move It pays helpers. You must have or get a Zelle account",
                          "Do you have a friend or family member who would like to work with you on two-person Moves?",
                          "What size t-shirt do you wear?",
                          "How did you hear about Move It?"]

    var selectedArea = "Select"{
        didSet{
            self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .none)
        }
    }
    var selectShirtSize = "Select"{
        didSet{
             self.tableView.reloadRows(at: [IndexPath.init(row: 5, section: 0)], with: .none)
        }
    }
    var selectedPosition = ""{
        didSet{
            self.tableView.reloadRows(at: [IndexPath.init(row: 6, section: 0)], with: .none)
        }
    }
    var additionalPositioInfo = ""
    
    var answer2 = ""{
        didSet{
            self.tableView.reloadRows(at: [IndexPath.init(row: 1, section: 0)], with: .none)
        }
    }
    
    var answer3 = ""{
        didSet{
            self.tableView.reloadRows(at: [IndexPath.init(row: 2, section: 0)], with: .none)
        }
    }
    
    var answer4 = ""{
        didSet{
            self.tableView.reloadRows(at: [IndexPath.init(row: 3, section: 0)], with: .none)
        }
    }
    var answer5 = ""{
        didSet{
            self.tableView.reloadRows(at: [IndexPath.init(row: 4, section: 0)], with: .none)
        }
    }
    
    var showOtherSpecifyCell = false{
        didSet{
            self.tableView.reloadRows(at: [IndexPath.init(row: 6, section: 0)], with: .none)
        }
    }
    
    var selectedquestion = Int()
    
    var additionInfo7 = ""{
        didSet{
            self.tableView.reloadRows(at: [IndexPath.init(row: 6, section: 0)], with: .none)
        }
    }
  
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle("Sign Up")
        self.getCitiesAPICall()
        self.uiConfigurationAfterStoryboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    func uiConfigurationAfterStoryboard() {

        let label = UILabel()
       
        let serviceType = Int(UserCache.shared.userInfo(forKey: kUserCache.service_type) as! Int)
        if serviceType == 2 {
             label.text = "Step 2/3"
            self.navigationItem.leftBarButtonItem = nil
//            self.navigationItem.leftBarButtonItems = nil
        } else {
             label.text = "Step 4/5"
            if let viewControllers = self.navigationController?.viewControllers {
                if(viewControllers.count > 1) {
                    let leftBarButtonItem = StaticHelper.leftBarButtonWithImageNamed(imageName: "backward_arrow_icon", vc: self)
                    self.navigationItem.leftBarButtonItems = [leftBarButtonItem]
                }
            }
        }
        
        label.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        label.textColor = darkPinkColor
        
//        if let viewControllers = self.navigationController?.viewControllers {
//            if(viewControllers.count > 1) {
//                let leftBarButtonItem = StaticHelper.leftBarButtonWithImageNamed(imageName: "backward_arrow_icon", vc: self)
//                self.navigationItem.leftBarButtonItems = [leftBarButtonItem]
//            }
//        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: label)
        
        nextButton.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 13.0)
        
        doneButton.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 13.0)
        
        enterDetailLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 13.0)
        emailTextField.font = UIFont.josefinSansSemiBoldFontWithSize(size: 13.0)
        nameTextField.font = UIFont.josefinSansSemiBoldFontWithSize(size: 13.0)
        phoneNumTextField.font = UIFont.josefinSansSemiBoldFontWithSize(size: 13.0)
        
        zelleAccountTextField.font = UIFont.josefinSansSemiBoldFontWithSize(size: 13.0)
        zelleAccountTextField.setLeftPaddingPoints(15.0)
        
        footerView.frame.size.height = 50.0 * screenHeightFactor
        
        self.familyInfoSUbView.layer.cornerRadius = 15.0 * screenHeightFactor
    }
    
    //MARK: - Actions
    @objc func leftButtonPressed(_ selector: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextAction(_ sender: Any) {
    
//        let completedStep =  Int(UserCache.shared.userInfo(forKey: kUserCache.completedStep)  as! Int)
//        if(completedStep > 3) {
//            let step5 = self.storyboard?.instantiateViewController(withIdentifier: "Step5ViewController") as! Step5ViewController
//            self.navigationController?.pushViewController(step5, animated: true)
//            return
//        }
        
        self.view.endEditing(true)
        
        if selectedArea == "Select"{
            self.view.makeToast("Please select working area.")
        } else if answer2.isEmpty{
            self.view.makeToast("Please select answer of question 2.")
        } else if answer3.isEmpty{
            self.view.makeToast("Please select answer of question 3.")
        } else if answer4.isEmpty{
            self.view.makeToast("Please select answer of question 4.")
        } else if answer5.isEmpty{
            self.view.makeToast("Please select answer of question 5.")
        } else if selectShirtSize == "Select"{
            self.view.makeToast("Please select your t-shirt size.")
        } else if selectedPosition == ""{
            if showOtherSpecifyCell {
                if additionInfo7.isEmpty {
                    self.view.makeToast("Please enter addition user info.")
                } else {
                    self.view.makeToast("Please select from where you hear about Move It.")
                }
            } else {
                self.view.makeToast("Please select from where you hear about Move It.")
            }
        } else if answer4 == "Yes" {
            if (zelleAccountTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!{
                 self.view.makeToast("Please enter zelle account ID.")
            } else {
                self.helperSignupStep4APICall()
            }
        } else {
            self.helperSignupStep4APICall()
        }
    }
    
    @IBAction func addDeatilDoneAction(_ sender: UIButton) {
        let emailRegEx: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        if (nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!{
            self.view.makeToast("Please enter name.")
        }
        else if (emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!{
             self.view.makeToast("Please enter email.")
        }else if emailTest.evaluate(with: emailTextField.text) == false {
            self.view.makeToast("Please enter valid email address.")
            return
        }else if (phoneNumTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!{
             self.view.makeToast("Please enter phone number.")
        }
        else {
            familyInfoView.isHidden = true
        }
    }
    @IBAction func addDeatilBackAction(_ sender: UIButton) {
        
        familyInfoView.isHidden = true
    }
    
    //MARK: - UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        switch indexPath.row {
            
        case 0:
            
            let listViewCell = tableView.dequeueReusableCell(withIdentifier: "ListQstnTableViewCell", for: indexPath) as! ListQstnTableViewCell
            listViewCell.listViewTextField.tag = indexPath.row
            listViewCell.listViewTextField.text = selectedArea
            listViewCell.setadditionalThings()
            listViewCell.questionLabel.text = questionsArray[indexPath.row]
            return listViewCell
            
        case 1:
            let radioViewCell = tableView.dequeueReusableCell(withIdentifier: "RadioQstnTableViewCell", for: indexPath) as! RadioQstnTableViewCell
            radioViewCell.qstnLabel.text = questionsArray[indexPath.row]
            radioViewCell.yesButton.tag = indexPath.row
            radioViewCell.noButton.tag = indexPath.row
            if !answer2.isEmpty{
                if answer2 == "Yes"{
                    radioViewCell.yesButton.isSelected = true
                    radioViewCell.noButton.isSelected = false
                }
                else{
                    radioViewCell.yesButton.isSelected = false
                    radioViewCell.noButton.isSelected = true
                }
            }
            radioViewCell.yesButton.addTarget(self, action: #selector(yesPressed(_:)), for: .touchUpInside)
            radioViewCell.noButton.addTarget(self, action: #selector(noPressed(_:)), for: .touchUpInside)
            return radioViewCell
        case 2:
            let radioViewCell = tableView.dequeueReusableCell(withIdentifier: "RadioQstnTableViewCell", for: indexPath) as! RadioQstnTableViewCell
            radioViewCell.qstnLabel.text = questionsArray[indexPath.row]
            radioViewCell.yesButton.tag = indexPath.row
            radioViewCell.noButton.tag = indexPath.row
            if !answer3.isEmpty{
                if answer3 == "Yes"{
                    radioViewCell.yesButton.isSelected = true
                    radioViewCell.noButton.isSelected = false
                }
                else{
                    radioViewCell.yesButton.isSelected = false
                    radioViewCell.noButton.isSelected = true
                }
            }
            radioViewCell.yesButton.addTarget(self, action: #selector(yesPressed(_:)), for: .touchUpInside)
            radioViewCell.noButton.addTarget(self, action: #selector(noPressed(_:)), for: .touchUpInside)
            return radioViewCell
        case 3:
            let radioViewCell = tableView.dequeueReusableCell(withIdentifier: "RadioQstnTableViewCell", for: indexPath) as! RadioQstnTableViewCell
            radioViewCell.qstnLabel.text = questionsArray[indexPath.row]
            radioViewCell.yesButton.tag = indexPath.row
            radioViewCell.noButton.tag = indexPath.row
            if !answer4.isEmpty{
                if answer4 == "Yes"{
                    radioViewCell.qstnLabel.text = questionsArray[indexPath.row]+"\n\n\n\n"
                    zelleAccountTextField.isHidden = false
                    zelleAccountTextField.frame = CGRect(x: 20, y: 125, width: radioViewCell.bkView.frame.size.width-40, height: 40)
                    zelleAccountTextField.placeholder = "Zelle Account Id"
                    zelleAccountTextField.layer.borderWidth = 0.5
                    zelleAccountTextField.layer.borderColor = UIColor.lightGray.cgColor
                    zelleAccountTextField.layer.cornerRadius = 10.0
                    radioViewCell.bkView.addSubview(zelleAccountTextField)
                    radioViewCell.yesButton.isSelected = true
                    radioViewCell.noButton.isSelected = false
                }
                else{
                    radioViewCell.qstnLabel.text = questionsArray[indexPath.row]
                    zelleAccountTextField.removeFromSuperview()
                    radioViewCell.yesButton.isSelected = false
                    radioViewCell.noButton.isSelected = true
                }
            }
            radioViewCell.yesButton.addTarget(self, action: #selector(yesPressed(_:)), for: .touchUpInside)
            radioViewCell.noButton.addTarget(self, action: #selector(noPressed(_:)), for: .touchUpInside)
            return radioViewCell
        case 4:
            let radioViewCell = tableView.dequeueReusableCell(withIdentifier: "RadioQstnTableViewCell", for: indexPath) as! RadioQstnTableViewCell
            radioViewCell.qstnLabel.text = questionsArray[indexPath.row]
            radioViewCell.yesButton.tag = indexPath.row
            radioViewCell.noButton.tag = indexPath.row
            if !answer5.isEmpty{
                if answer5 == "Yes"{
                    radioViewCell.yesButton.isSelected = true
                    radioViewCell.noButton.isSelected = false
                }
                else{
                    radioViewCell.yesButton.isSelected = false
                    radioViewCell.noButton.isSelected = true
                }
            }
            radioViewCell.yesButton.addTarget(self, action: #selector(yesPressed(_:)), for: .touchUpInside)
            radioViewCell.noButton.addTarget(self, action: #selector(noPressed(_:)), for: .touchUpInside)
            return radioViewCell
        case 5:
            let listViewCell = tableView.dequeueReusableCell(withIdentifier: "ListQstnTableViewCell", for: indexPath) as! ListQstnTableViewCell
            listViewCell.setadditionalThings()
            listViewCell.listViewTextField.tag = indexPath.row
            listViewCell.listViewTextField.text = selectShirtSize
            listViewCell.questionLabel.text = questionsArray[indexPath.row]
            return listViewCell
        case 6:
            let listViewCell = tableView.dequeueReusableCell(withIdentifier: "ListQstnTableViewCell", for: indexPath) as! ListQstnTableViewCell
            listViewCell.setplaceholderLabel()
            listViewCell.listViewTextField.tag = indexPath.row
            listViewCell.listViewTextField.tag = 1000
            listViewCell.listViewTextField.text = selectedPosition
            listViewCell.listViewTextField.placeholder = "Type Here"
            listViewCell.questionLabel.text = questionsArray[indexPath.row]
            return listViewCell
        default:
            break
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 6{
            if showOtherSpecifyCell{
                let h = questionsArray[indexPath.row].calculateHeightofText(260 * screenHeightFactor,font:  UIFont.josefinSansSemiBoldFontWithSize(size: 12.0))
                return (h + (120.0 * screenHeightFactor))
            } else {
                let h = questionsArray[indexPath.row].calculateHeightofText(260 * screenHeightFactor,font:  UIFont.josefinSansSemiBoldFontWithSize(size: 12.0))
                return (h + (70.0 * screenHeightFactor))
            }
        } else if indexPath.row == 3{
            
            if answer4 == "Yes"{
                let h = questionsArray[indexPath.row].calculateHeightofText(260 * screenHeightFactor,font:  UIFont.josefinSansSemiBoldFontWithSize(size: 12.0))
                return (h + (70.0 * screenHeightFactor)) + 70
            }
            let h = questionsArray[indexPath.row].calculateHeightofText(260 * screenHeightFactor,font:  UIFont.josefinSansSemiBoldFontWithSize(size: 12.0))
            return (h + (70.0 * screenHeightFactor))
        }
        else {
            let h = questionsArray[indexPath.row].calculateHeightofText(260 * screenHeightFactor,font:  UIFont.josefinSansSemiBoldFontWithSize(size: 12.0))
            return (h + (70.0 * screenHeightFactor))
        }
    }
    //MARK: - Table Actions
    @objc func yesPressed(_ selctor: UIButton){
    
        if selctor.tag == 1 {
              answer2 = "Yes"
        } else if selctor.tag == 2 {
              answer3 = "Yes"
        } else if selctor.tag == 3 {
              answer4 = "Yes"
            
        } else if selctor.tag == 4 {
              answer5 = "Yes"
            familyInfoView.isHidden = false
        }
    }
    
    @objc func noPressed(_ selctor: UIButton){
        if selctor.tag == 1 {
            answer2 = "No"
        } else if selctor.tag == 2 {
            answer3 = "No"
        } else if selctor.tag == 3 {
            answer4 = "No"
            
        } else if selctor.tag == 4 {
            answer5 = "No"
        }
    }
    
    
    //MARK: - PopUpDelegate
    func selectedItems(_ index: Int) {
        if selectedquestion == 0{
            self.selectedArea = self.metropolitialArea[index]
        } else if selectedquestion == 5 {
           self.selectShirtSize = self.tShirtSizes[index]
        } else if selectedquestion == 6 {
            self.selectedPosition = self.hereAboutOptions[index]
            if [3,4,9].contains(index) {
                showOtherSpecifyCell = true
            } else {
                showOtherSpecifyCell = false
            }
        }
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1000{
            selectedPosition = (textField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
        }
    }
   
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
      
        if textField.tag == 0{
           selectedquestion = 0
            let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "PopUpTableViewController") as! PopUpTableViewController
            popupVC.modalPresentationStyle = .overFullScreen
            popupVC.popUpDelegate = self
            popupVC.popUpTitle = "Select your area"
            
            popupVC.dataSourceArray = self.metropolitialArea
            
            if !selectedArea.isEmpty && (selectedArea != "Select"){
                let selectedIndex = self.metropolitialArea.lastIndex(of: selectedArea)!
                popupVC.selectedIndex = selectedIndex
            }
            
            self.present(popupVC, animated: true, completion: nil)
            return false
        }
        if textField.tag == 5{
           selectedquestion = 5
            let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "PopUpTableViewController") as! PopUpTableViewController
            popupVC.modalPresentationStyle = .overFullScreen
            popupVC.popUpDelegate = self
            popupVC.dataSourceArray = self.tShirtSizes
            popupVC.popUpTitle = "Select Your T-shirt Size"
            if !selectShirtSize.isEmpty && (selectShirtSize != "Select"){
                let selectedIndex = tShirtSizes.lastIndex(of: selectShirtSize)!
                popupVC.selectedIndex = selectedIndex
            }
            
            self.present(popupVC, animated: true, completion: nil)
            return false
        }
        if textField.tag == 6{
            return true
        }
        
        if  [15,16,17].contains(textField.tag){
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 1000{
            selectedPosition = (textField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
        }
        textField.resignFirstResponder()
        return false
    }
    
    //MARK: - APIs
    func helperSignupStep4APICall(){
        var step5AddInfo = ""
             
        if answer5 == "Yes" {
            let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let phonenum = phoneNumTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let additionalEmailInfo = ["email":email,"name":name,"phone":phonenum]
            guard let data = try? JSONSerialization.data(withJSONObject: additionalEmailInfo, options: []) else {
                   return
            }
            step5AddInfo = String(data: data, encoding: String.Encoding.utf8)!
        }
        
        var step4AddInfo = ""
        if answer4 == "Yes" {
            let zelleAccount = zelleAccountTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let additionalAccountInfo = ["zelle_account":zelleAccount]
            guard let data = try? JSONSerialization.data(withJSONObject: additionalAccountInfo, options: []) else {
                   return
            }
            step4AddInfo = String(data: data, encoding: String.Encoding.utf8)!
        }
        
        let parameter = ["question_data": [["question_id": 1,"addition_info":"","answer":selectedArea],["question_id": 2,"addition_info":"","answer":answer2],["question_id": 3,"addition_info":"","answer":answer3],["question_id": 4,"addition_info":step4AddInfo,"answer":answer4],["question_id": 5,"addition_info":step5AddInfo,"answer":answer5],["question_id": 6,"addition_info":"","answer":selectShirtSize],["question_id": 7,"addition_info":"","answer":selectedPosition]]] as Parameters
  
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: self, completion: nil)
            return
        }
              
        StaticHelper.shared.startLoader(self.view)
        let header : HTTPHeaders = ["Content-Type":"application/json","Auth-Token":UserCache.userToken()!]
        
        AF.request(baseURL + helper_signup_step4, method: .post, parameters: parameter,encoding: JSONEncoding.default,  headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
            switch response.result {
            case .success:
                if response.response?.statusCode == 200{
                    StaticHelper.shared.stopLoader()
                    let resposneDict = response.value as! [String: Any]
                    
                    if !resposneDict.isEmpty{
                        UserCache.shared.updateUserProperty(forKey: kUserCache.completedStep, withValue:  4 as AnyObject)
                        
                        let step5 = self.storyboard?.instantiateViewController(withIdentifier: "Step5ViewController") as! Step5ViewController
                        self.navigationController?.pushViewController(step5, animated: true)

//                        if let vcStep = StaticHelper.getViewControllerWithID("Step5ViewController") {
//                            self.navigationController?.pushViewController(vcStep, animated: true)
//                        }
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
    
    
    func getCitiesAPICall() {
        StaticHelper.shared.startLoader(self.view)
        CommonAPIHelper.getCitiesAPICall(VC: self, completetionBlock: { (resonse, error, isexecuted) in
            
            DispatchQueue.main.async {
                StaticHelper.shared.stopLoader()
                if error != nil{
                    return
                } else {
                    self.metropolitialArea.removeAll()
                    for cityDict in resonse! {
                        print(cityDict)
                        let cityObj:MoveItCity? = MoveItCity.init(cityInfo: cityDict)
                        if(cityObj != nil) {
                            self.arrCities.append(cityObj!)
                            self.metropolitialArea.append((cityObj?.name!)!)
                        }
                    }
                }
            }
        })
    }
    
}
