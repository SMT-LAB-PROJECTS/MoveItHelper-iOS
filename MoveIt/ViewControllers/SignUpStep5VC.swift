//
//  SignUpStep5VC.swift
//  MoveIt
//
//  Created by Jyoti on 06/05/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class SignUpStep5VC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var headerStep5Label: UILabel!
    @IBOutlet weak var step5Label: UILabel!
    @IBOutlet weak var step5TableView: UITableView!
    
    @IBOutlet weak var nextstep5ButtonOutlet: UIButton!
    var step5QuestionArray:NSMutableArray!
    var question1Str:String!
    var question2Str:String!
    var question3Str:String!
    var optionalQuestionStr:String!
    var questionArray:NSMutableArray!
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       self.setUpStep5UI()
        
    }
    
    func setUpStep5UI(){
       
        headerStep5Label.font = UIFont.josefinSansRegularFontWithSize(size: 14.0)
        step5Label.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        step5QuestionArray  = ["Each Move It job typically takes 1-2 hours to perform.How many Moves are you hoping to do each week?",
                          "Have you served in the US Armed Forces?",
                          "In a few short sentences,tell us why you will be a great Move It Pros Helper: ",]
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(hideKeyboard))
        self.step5TableView.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardDidShow),name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardDidHide), name:UIResponder.keyboardDidHideNotification, object: nil)
        
        questionArray = []
        
    }
    
    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
       // loginContentView.frame.size.height = 504 * UIScreen.main.bounds.size.height/568
        nextstep5ButtonOutlet.layer.cornerRadius = (nextstep5ButtonOutlet.frame.size.height/2.0)
        nextstep5ButtonOutlet.layer.masksToBounds = true
    }
    

    @IBAction func step5BackButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func step5NextButtonPressed(_ sender: Any) {
        //socketConnection()
         let pendingObj = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
         self.navigationController?.pushViewController(pendingObj, animated: true)
    }
    
    //#MARK:- UITableviewDataSource & Delegates
    
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0){
            return 180
        }else{
           return 180
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(section == 0){
          return step5QuestionArray.count
        }else{
          return 1;
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
            let cell = tableView.dequeueReusableCell(withIdentifier: "OptionalQuestionCell") as! Step5OptionalQuestionCell
        
        if(indexPath.section == 0){
        
            cell.questionLabel.text = (step5QuestionArray[indexPath.row] as! String)
            cell.radioButtonOuterView.isHidden = true
            cell.textFieldOuterView.isHidden = true
            cell.outerViewOtTxtview.isHidden = true
            cell.textfield.tag =  indexPath.row
            
            switch (indexPath.row) {
            case 0:
                cell.radioButtonOuterView.isHidden = true
                cell.textFieldOuterView.isHidden = false
                cell.outerViewOtTxtview.isHidden = true
                cell.textfield.text = question1Str
                break;
            case 1:
                cell.radioButtonOuterView.isHidden = false
                cell.textFieldOuterView.isHidden = true
                cell.outerViewOtTxtview.isHidden = true
                break;
            case 2:
                cell.radioButtonOuterView.isHidden = true
                cell.textFieldOuterView.isHidden = true
                cell.outerViewOtTxtview.isHidden = false
                cell.textView.text = question3Str
                break;
            default:
                break;
        }
        
            cell.yesbuttonOutlet.tag = indexPath.row
            cell.yesbuttonOutlet.addTarget(self,action:#selector(yesNoButtonPressed(sender:)), for: .touchUpInside)
            
            cell.noButtonOutlet.tag = indexPath.row
            cell.noButtonOutlet.addTarget(self,action:#selector(yesNoButtonPressed(sender:)), for: .touchUpInside)
            
            return cell
        }else{
            cell.questionLabel.text = "We want our customers to have a comfortable experience.What can we put on your profile about you?"
            cell.radioButtonOuterView.isHidden = true
            cell.textFieldOuterView.isHidden = false
            cell.outerViewOtTxtview.isHidden = true
            
            var textString = NSMutableAttributedString()
            let placeholderText = "Favorite type of music, sports, food, season"
            textString = NSMutableAttributedString(string:placeholderText, attributes: [NSAttributedString.Key.font:UIFont.josefinSansRegularFontWithSize(size: 12.0)])
            textString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 47/255, green: 44/255, blue: 61/255, alpha: 1), range:NSMakeRange(0,placeholderText.count))
            
            cell.textfield.attributedPlaceholder = textString
            cell.textfield.text = optionalQuestionStr
            
        }
      return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("You tapped cell number \(indexPath.row).")
        //let cell:Step5OptionalQuestionCell = step5TableView.cellForRow(at: indexPath) as! Step5OptionalQuestionCell
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1{
             return 50
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {

        // This changes the header background
         view.tintColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)

        // Gets the header view as a UITableViewHeaderFooterView and changes the text colour
        let headerView: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        headerView.textLabel!.textColor = UIColor(red: 47/255, green: 44/255, blue: 61/255, alpha: 1)
        headerView.textLabel?.text = "Optional Questions"
        headerView.textLabel?.textAlignment = NSTextAlignment.center
        headerView.textLabel?.font = UIFont.josefinSansRegularFontWithSize(size: 14.0)

    }
   
    
    @objc func yesNoButtonPressed(sender:UIButton) {
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.step5TableView)
        let indexPath = self.step5TableView.indexPathForRow(at: buttonPosition)
        let cell:Step5OptionalQuestionCell = self.step5TableView.cellForRow(at:indexPath! ) as! Step5OptionalQuestionCell
      
        
        if sender == cell.yesbuttonOutlet {
            
            cell.yesbuttonOutlet.isSelected = true
            cell.yesbuttonOutlet.setImage(UIImage(named: "check_square"), for: .normal)
            
            cell.noButtonOutlet.isSelected = false
            cell.noButtonOutlet.setImage(UIImage(named: "check_square_outline"), for: .normal)
            
            question3Str = "YES"
            
            
        } else if sender == cell.noButtonOutlet{
            
            cell.yesbuttonOutlet.isSelected = false
            cell.yesbuttonOutlet.setImage(UIImage(named: "check_square_outline"), for: .normal)
            
            cell.noButtonOutlet.isSelected = true
            cell.noButtonOutlet.setImage(UIImage(named: "check_square"), for: .normal)
            
            question3Str = "NO"
        }
        
        
    }
    
    
    //#MARK : - UIKeyBoard Hide End Show
    @objc func keyboardDidShow(notify : NSNotification){
        
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        
        let userInfo: NSDictionary = notify.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        
        step5TableView.contentInset = contentInsets
        step5TableView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardDidHide(notify: NSNotification) {
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0 , right: 0)
        step5TableView.contentInset = contentInsets
        step5TableView.scrollIndicatorInsets = contentInsets
        
    }        

    //#Mark:- UITextField Delegates
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    
    
    //Mark:- Hide Keyboard
    
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
    
}
