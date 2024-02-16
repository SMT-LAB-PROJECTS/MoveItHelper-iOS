//
//  Step5ViewController.swift
//  MoveIt
//
//  Created by Dushyant on 23/05/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import Alamofire

class Step5ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    
    
    var questionArray = ["Each Move It job typically takes anywhere from 30 minutes to a couple hours. How many Move It jobs are you hoping to do each week?","Have you served in the US Armed Forces?","In a few short sentences, tell us why you will be a great Move It Pro or Muscle","We want our customers to have a comfortable experience. What can we put on your profile about you?(Optional)"]
    
    var answer2 = ""{
        didSet{
            self.tableView.reloadRows(at: [IndexPath.init(row: 1, section: 0)], with: .none)
        }
    }
    
    var answer1 = ""
    var answer3 = ""
    var answer4 = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle("Sign Up")
        if let viewControllers = self.navigationController?.viewControllers {
            if(viewControllers.count > 1) {
                let leftBarButtonItem = StaticHelper.leftBarButtonWithImageNamed(imageName: "backward_arrow_icon", vc: self)
                self.navigationItem.leftBarButtonItems = [leftBarButtonItem]
            }
        }
        
        let label = UILabel()
        let serviceType = Int(UserCache.shared.userInfo(forKey: kUserCache.service_type) as! Int)
        if serviceType == 2{
            label.text = "Step 3/3"
            questionArray[2] = "In a few short sentences, tell us why you will be a great Move It Muscle"
        }
        else{
            label.text = "Step 5/5"
            questionArray[2] = "In a few short sentences, tell us why you will be a great Move It Pro"
        }
        label.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        label.textColor = darkPinkColor
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: label)
        
        nextButton.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 13.0)
        footerView.frame.size.height = 50.0 * screenHeightFactor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc func leftButtonPressed(_ selector: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextAction(_ sender: Any) {
        
        self.view.endEditing(true)
        
        if answer1.isEmpty{
            self.view.makeToast("Please select days move number.")
        }
        else if answer2.isEmpty{
             self.view.makeToast("Please select answer of question 2.")
        }
        else if answer3.isEmpty{
             self.view.makeToast("Please fill all mandatory field.")
        }
        else if answer1 == "0"{
             self.view.makeToast("Number of moves should be greater than 1.")
        }
        else{
            saveAnswer()
        }
        
    }
    
    func saveAnswer(){
        

        
        let parameter = ["question_data": [["question_id": 1,"addition_info":"","answer":answer1],["question_id": 2,"addition_info":"","answer":answer2],["question_id": 3,"addition_info":"","answer":answer3],["question_id": 4,"addition_info":"","answer":answer4]]] as! Parameters
     
        
        let header : HTTPHeaders = ["Content-Type":"application/json","Auth-Token":UserCache.userToken()!]
        
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: self, completion: nil)
            return
        }
           StaticHelper.shared.startLoader(self.view)
        AF.request(baseURL + helper_signup_step5, method: .post, parameters: parameter,encoding: JSONEncoding.default,  headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
            switch response.result {
            case .success:
                if response.response?.statusCode == 200{
                    StaticHelper.shared.stopLoader()
                    let resposneDict = response.value as! [String: Any]
                    
                    if !resposneDict.isEmpty{
                        UserCache.shared.updateUserProperty(forKey: kUserCache.completedStep, withValue:  5 as AnyObject)
                        
                        let uploadPhotoVC = self.storyboard?.instantiateViewController(withIdentifier: "UploadPhotoViewController") as! UploadPhotoViewController
                        self.navigationController?.pushViewController(uploadPhotoVC, animated: true)
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
    
}

extension Step5ViewController: UITableViewDelegate,UITableViewDataSource{
  
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let listCell = tableView.dequeueReusableCell(withIdentifier: "ListQstnTableViewCell", for: indexPath) as! ListQstnTableViewCell
            listCell.questionLabel.text = questionArray[indexPath.row]
            listCell.listViewTextField.text = answer1
            listCell.listViewTextField.placeholder = "Type your estimate"
            listCell.listViewTextField.setLeftPaddingPoints(15.0)
            listCell.listViewTextField.keyboardType = .numberPad
            //listCell.listViewTextField.addDoneButtonOnKeyboard()
            listCell.listViewTextField.tag = 0
            return listCell
        case 1:
            let radioViewCell = tableView.dequeueReusableCell(withIdentifier: "RadioQstnTableViewCell", for: indexPath) as! RadioQstnTableViewCell
            radioViewCell.qstnLabel.text = questionArray[indexPath.row]
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
            let txtViewCell = tableView.dequeueReusableCell(withIdentifier: "TextViewQstnTableViewCell", for: indexPath) as! TextViewQstnTableViewCell
           
            txtViewCell.textView.setPlaceholder("Type answer here..", floatingTitle: "")
            txtViewCell.textView.text = answer3
            txtViewCell.textView.tag = indexPath.row
            txtViewCell.textView.layer.borderColor = UIColor.lightGray.cgColor
            txtViewCell.textView.layer.borderWidth = 0.5
            txtViewCell.textView.clipsToBounds = true
            //txtViewCell.textView.addDoneButtonOnKeyboard()
            txtViewCell.qstnLabel.text = questionArray[indexPath.row]
            return txtViewCell
        case 3:
            let txtViewCell = tableView.dequeueReusableCell(withIdentifier: "TextViewQstnTableViewCell", for: indexPath) as! TextViewQstnTableViewCell
            txtViewCell.textView.setPlaceholder("Favorite type of music, sports, food, season, etc. :", floatingTitle: "")
           // txtViewCell.textView.placeholder = "Favorite type of music, sports, food, season, etc."
            txtViewCell.textView.text = answer4
            txtViewCell.textView.tag = indexPath.row
            txtViewCell.textView.layer.borderColor = UIColor.lightGray.cgColor
            txtViewCell.textView.layer.borderWidth = 0.5
            txtViewCell.textView.clipsToBounds = true
            //txtViewCell.textView.addDoneButtonOnKeyboard()
            txtViewCell.qstnLabel.text = questionArray[indexPath.row]
            return txtViewCell
        default:
            break
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
        switch indexPath.row {
        case 0,1:
            let h = questionArray[indexPath.row].calculateHeightofText(260 * screenHeightFactor,font:  UIFont.josefinSansSemiBoldFontWithSize(size: 12.0))
            return (h + (70.0 * screenHeightFactor))
        case 2,3:
            let h = questionArray[indexPath.row].calculateHeightofText(260 * screenHeightFactor,font:  UIFont.josefinSansSemiBoldFontWithSize(size: 12.0))
            return (h + (90.0 * screenHeightFactor))
        default:
            return 0.0
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
    
    
    @objc func yesPressed(_ selctor: UIButton){
        
        if selctor.tag == 1{
            answer2 = "Yes"
        }
    }
    
    @objc func noPressed(_ selctor: UIButton){
       
        if selctor.tag == 1{
            answer2 = "No"
        }
    }
}

extension Step5ViewController: UITextFieldDelegate,UITextViewDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0{
            answer1 = textField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.tag == 2{
            answer3 = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if textView.tag == 3{
            answer4 = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        
    
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 2
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let edgeInsets: UIEdgeInsets? = UIEdgeInsets(top:0, left: 0, bottom: 250.0 * screenHeightFactor, right: 0)
        self.tableView.contentInset = edgeInsets!
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset
        if textView.tag == 2{
                    self.tableView.scrollToRow(at: IndexPath.init(row: 1, section: 0), at: .top, animated: true)
        }
        else{
                    self.tableView.scrollToRow(at: IndexPath.init(row: 2, section: 0), at: .top, animated: true)
        }
        

    }
 
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        let edgeInsets: UIEdgeInsets? = UIEdgeInsets(top:0, left: 0, bottom:0, right: 0)
        self.tableView.contentInset = edgeInsets!
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset
        return true
    }
}


