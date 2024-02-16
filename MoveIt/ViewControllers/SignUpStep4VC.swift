//
//  SignUpStep4VC.swift
//  MoveIt
//
//  Created by Jyoti on 26/04/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class SignUpStep4VC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var signupHeaderLabel: UILabel!
    @IBOutlet weak var step4Label: UILabel!
    @IBOutlet weak var signStep4TableView: UITableView!
    
    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var popUpTableView: UITableView!
    
    var questionArray:NSMutableArray!
    var popUpTableArray:NSMutableArray!
    var sizeArray:NSMutableArray!
    var hearAboutArray:NSMutableArray!
    
    let cellReuseIdentifier = "cell"
    var areaString:String!
    var sizeString:String!
    var hearAboutString:String!
    var isExpand:Bool!
    var isOtherFieldExpand:Bool!
    var quest1Str:NSString!
    var quest2Str:NSString!
    var quest3Str:NSString!
    var quest4Str:NSString!
    var quest5Str:NSString!
    var quest6Str:NSString!
    var quest7Str:NSString!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setSignUpStep4UI()
        
    }
    
    func setSignUpStep4UI(){
        
        isExpand = false
        isOtherFieldExpand = false
        
        self.navigationController?.isNavigationBarHidden = true
        signupHeaderLabel.font = UIFont.josefinSansBoldFontWithSize(size: 14.0)
        step4Label.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        headerLabel.font = UIFont.josefinSansRegularFontWithSize(size: 14.0)
        questionArray  = ["Which metropolitan area do you want to work in?",
                          "Do you have an iPhone or Android smartphone with GPS that can support the Move It App?",
                          "Are you able to lift 75 lbs over your head, and are you willing to lift and carry large, bulky items such as couches and desks?",
                          "Are you able to be paid weekly via direct deposit into your Zelle account?",
                          "Do you have a friend or family member who would like to work with you on two-person Moves?",
                          "What size t-shirt do you wear?",
                          "How did you hear about the Move It?"]
        popUpTableArray = ["Boston, MA", "Chicago, IL", "Denver, CO", "Los Angeles, CA", "Orange County, CA","Philadelphia, PA","Portlant, OR","San Diego, CA","San Francisco, CA","Seattle, WA","Washington, DC"]
        
        
        self.popUpTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func signStep4BackButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func step4NextButtonPressed(_ sender: Any) {
        let signStep5 = self.storyboard?.instantiateViewController(withIdentifier: "SignUpStep5VC") as! SignUpStep5VC
        self.navigationController?.pushViewController(signStep5, animated: true)
    }
    
    //# MARK:-UITableView Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(tableView == signStep4TableView){
        
          if ( indexPath.row == 4 ) {
            if (isExpand == true){
                return (340/504.0) * SCREEN_HEIGHT
            }else{
                return (160/504.0) * SCREEN_HEIGHT
            }
         }else if(indexPath.row == 6){
            if(isOtherFieldExpand == true){
                return 220 //(220/504.0) * SCREEN_HEIGHT
            }else{
                return (160/504.0) * SCREEN_HEIGHT
            }
        }
       else{
            return (160/504.0) * SCREEN_HEIGHT
        }
      }
    else{
            return 44.0
      }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == signStep4TableView{
            return questionArray.count
        }else if tableView == popUpTableView{
            if(popUpTableArray!.count > 0){
                return popUpTableArray.count
            }else if (sizeArray!.count > 0){
                return sizeArray.count
            }else if (hearAboutArray!.count > 0){
                return hearAboutArray.count
            }
            else{
                return 0
            }
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        //  let expandCell = tableView.dequeueReusableCell(withIdentifier: "expandCell") as! FamilyMemberExpandCell
        
        if tableView == signStep4TableView{
            
            if(indexPath.row == 4){
                if isExpand == true{
                    let expandCell = tableView.dequeueReusableCell(withIdentifier: "expandCell") as! FamilyMemberExpandCell
                    
                    expandCell.questLabel.text = (questionArray[indexPath.row] as! String)
                    expandCell.yesbuttonOutlet.tag = indexPath.row
                 expandCell.yesbuttonOutlet.addTarget(self,action:#selector(yesNoExpandCellButtonPressed(sender:)), for: .touchUpInside)
                    
                    expandCell.noButonOutlet.tag = indexPath.row
                expandCell.noButonOutlet.addTarget(self,action:#selector(yesNoExpandCellButtonPressed(sender:)), for: .touchUpInside)
                    
                    expandCell.yesbuttonOutlet.setImage(UIImage(named: "check_square"), for: .normal)
                    expandCell.noButonOutlet.setImage(UIImage(named: "check_square_outline"), for: .normal)
                    
                    
                    
                    return expandCell
                    
                }
                else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell") as! Step4QuestionCell
                    cell.questionLabel.text = (questionArray[indexPath.row] as! String)

                    cell.radioButtonView.isHidden = false
                    cell.dropDownView.isHidden = true
                    
                    
                    cell.dropDownButtonOutlet.tag = indexPath.row
                    cell.dropDownButtonOutlet.addTarget(self,action:#selector(dropDownButtonPressed(sender:)), for: .touchUpInside)
                    
                    cell.yesButtonOutlet.tag = indexPath.row
                    cell.yesButtonOutlet.addTarget(self,action:#selector(yesNoButtonPressed(sender:)), for: .touchUpInside)
                    
                    cell.noButtonOutlet.tag = indexPath.row
                    cell.noButtonOutlet.addTarget(self,action:#selector(yesNoButtonPressed(sender:)), for: .touchUpInside)
                    cell.yesButtonOutlet.setImage(UIImage(named: "check_square_outline"), for: .normal)
                    cell.noButtonOutlet.setImage(UIImage(named: "check_square"), for: .normal)
                    
                    return cell
                }
            }
            else if(indexPath.row == 6){
                if isOtherFieldExpand == true{
                   
                    let otherExpandCell = tableView.dequeueReusableCell(withIdentifier: "SecondExpandableTableViewCell") as! SecondExpandableTableViewCell
                    
                    if hearAboutString != nil{
                        otherExpandCell.selectLabel.text = hearAboutString
                    }else{
                        otherExpandCell.selectLabel.text = "Select:"
                    }
                    
                    otherExpandCell.queryLabel.text = (questionArray[indexPath.row] as! String)
                    otherExpandCell.selectButtonOutlet.tag = indexPath.row
                otherExpandCell.selectButtonOutlet.addTarget(self,action:#selector(otherFieldButtonPressed(sender:)), for: .touchUpInside)
                    return otherExpandCell
                }
                else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell") as! Step4QuestionCell
                    cell.questionLabel.text = (questionArray[indexPath.row] as! String)
                    
                    cell.radioButtonView.isHidden = true
                    cell.dropDownView.isHidden = false
                    if hearAboutString != nil{
                        cell.selectAreaLabel.text = hearAboutString
                    }else{
                        cell.selectAreaLabel.text = "Select:"
                    }
                    
                    cell.dropDownButtonOutlet.tag = indexPath.row
                    cell.dropDownButtonOutlet.addTarget(self,action:#selector(dropDownButtonPressed(sender:)), for: .touchUpInside)
                    
                    cell.yesButtonOutlet.tag = indexPath.row
                    cell.yesButtonOutlet.addTarget(self,action:#selector(yesNoButtonPressed(sender:)), for: .touchUpInside)
                    
                    cell.noButtonOutlet.tag = indexPath.row
                    cell.noButtonOutlet.addTarget(self,action:#selector(yesNoButtonPressed(sender:)), for: .touchUpInside)
                   
                    
                    return cell
                }
            }
            else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell") as! Step4QuestionCell
                cell.questionLabel.text = (questionArray[indexPath.row] as! String)
                cell.radioButtonView.isHidden = true
                cell.dropDownView.isHidden = false
                
            
                switch (indexPath.row) {
                case 0:
                    cell.radioButtonView.isHidden = true
                    cell.dropDownView.isHidden = false
                    if areaString != nil{
                        cell.selectAreaLabel.text = areaString
                    }else{
                        cell.selectAreaLabel.text = "Select:"
                    }
                    break;
                case 1:
                    cell.radioButtonView.isHidden = false
                    cell.dropDownView.isHidden = true
                    break;
                case 2:
                    cell.radioButtonView.isHidden = false
                    cell.dropDownView.isHidden = true
                    break;
                case 3:
                    cell.radioButtonView.isHidden = false
                    cell.dropDownView.isHidden = true
                    break;
                case 5:
                    cell.radioButtonView.isHidden = true
                    cell.dropDownView.isHidden = false
                    if sizeString != nil{
                        cell.selectAreaLabel.text = sizeString
                    }else{
                        cell.selectAreaLabel.text = "Select:"
                    }
                    break;
//                case 6:
//                    cell.radioButtonView.isHidden = true
//                    cell.dropDownView.isHidden = false
//                    if hearAboutString != nil{
//                        cell.selectAreaLabel.text = hearAboutString
//                    }else{
//                        cell.selectAreaLabel.text = "Select:"
//                    }
//                    break;
                default:
                    break;
                }
                cell.dropDownButtonOutlet.tag = indexPath.row
                cell.dropDownButtonOutlet.addTarget(self,action:#selector(dropDownButtonPressed(sender:)), for: .touchUpInside)
                
                cell.yesButtonOutlet.tag = indexPath.row
                cell.yesButtonOutlet.addTarget(self,action:#selector(yesNoButtonPressed(sender:)), for: .touchUpInside)
                
                cell.noButtonOutlet.tag = indexPath.row
                cell.noButtonOutlet.addTarget(self,action:#selector(yesNoButtonPressed(sender:)), for: .touchUpInside)
                
                
                return cell
            }
        }else{
            
            let cell:UITableViewCell = (self.popUpTableView.dequeueReusableCell(withIdentifier:cellReuseIdentifier))!
            // set the text from the data model
            cell.textLabel?.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
            if(popUpTableArray!.count > 0){
                cell.textLabel?.text = popUpTableArray[indexPath.row] as? String
            }else if(sizeArray!.count > 0){
                cell.textLabel?.text = sizeArray[indexPath.row] as? String
            }else if(hearAboutArray!.count > 0){
                cell.textLabel?.text = hearAboutArray[indexPath.row] as? String
            }
            
            return cell
        }
        return UITableViewCell()
        
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("You tapped cell number \(indexPath.row).")
        if(tableView == popUpTableView){
            if popUpTableArray.count > 0 {
                areaString = (popUpTableArray[indexPath.row] as! String)
            }else if sizeArray.count > 0 {
                sizeString = (sizeArray[indexPath.row] as! String)
            }else if hearAboutArray.count > 0{
                hearAboutString = (hearAboutArray[indexPath.row] as! String)
                if(hearAboutString == "Other(please specify)"){
                 isOtherFieldExpand = true
                }else{
                 isOtherFieldExpand = false
                }
            }
        }
        self.signStep4TableView.reloadData()
        transparentView.isHidden = true
        
    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return (70/568.0) *  SCREEN_HEIGHT
//    }
    
    @objc func dropDownButtonPressed(sender:UIButton) {
        
        containerView.layer.cornerRadius = 5.0
        containerView.layer.masksToBounds = true
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.signStep4TableView)
        let indexPath = self.signStep4TableView.indexPathForRow(at: buttonPosition)
        //       let cell:Step4QuestionCell = self.signStep4TableView.cellForRow(at:indexPath! ) as! Step4QuestionCell
        
        if (indexPath?.row == 0){
            transparentView.isHidden = false
            sizeArray = []
            hearAboutArray = []
            popUpTableArray = ["Boston, MA", "Chicago, IL", "Denver, CO", "Los Angeles, CA", "Orange County, CA","Philadelphia, PA","Portlant, OR","San Diego, CA","San Francisco, CA","Seattle, WA","Washington, DC"]
            
        }else if(indexPath?.row == 5){
            transparentView.isHidden = false
            popUpTableArray = []
            hearAboutArray = []
            sizeArray = ["Small", "Medium", "Large", "X-Large", "XX-Large","XXX-Large"]
        }else if(indexPath?.row == 6){
            transparentView.isHidden = false
            popUpTableArray = []
            sizeArray = []
            hearAboutArray = ["Craigslist", "Facebook", "Ford Credit", "Referred by a friend", "Refferred by a Dolly Helper","Public transit","Crowded","News","Google","CrossFit","Flyer","Other(please specify)"]
           
        }
        popUpTableView.reloadData()
    }
    
    @objc func yesNoButtonPressed(sender:UIButton) {
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.signStep4TableView)
        let indexPath = self.signStep4TableView.indexPathForRow(at: buttonPosition)
        let cell:Step4QuestionCell = self.signStep4TableView.cellForRow(at:indexPath! ) as! Step4QuestionCell
        
        if sender == cell.yesButtonOutlet {
            
            cell.yesButtonOutlet.isSelected = true
            cell.yesButtonOutlet.setImage(UIImage(named: "check_square"), for: .normal)
            
            cell.noButtonOutlet.isSelected = false
            cell.noButtonOutlet.setImage(UIImage(named: "check_square_outline"), for: .normal)
            
            if(indexPath?.row == 4){
                isExpand = true
                signStep4TableView.reloadData()
            }
            
            
        } else if sender == cell.noButtonOutlet{
            
            cell.yesButtonOutlet.isSelected = false
            cell.yesButtonOutlet.setImage(UIImage(named: "check_square_outline"), for: .normal)
            
            cell.noButtonOutlet.isSelected = true
            cell.noButtonOutlet.setImage(UIImage(named: "check_square"), for: .normal)
            
            if(indexPath?.row == 4){
                isExpand = false
                signStep4TableView.reloadData()
            }
            
        }
    }
    
    
    //#MARK:-Expandcell Button Pressed
    
    @objc func yesNoExpandCellButtonPressed(sender:UIButton) {
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.signStep4TableView)
        let indexPath = self.signStep4TableView.indexPathForRow(at: buttonPosition)
        let cell:FamilyMemberExpandCell = self.signStep4TableView.cellForRow(at:indexPath! ) as! FamilyMemberExpandCell
        
        if sender == cell.yesbuttonOutlet {
            
            cell.yesbuttonOutlet.isSelected = true
            cell.yesbuttonOutlet.setImage(UIImage(named: "check_square"), for: .normal)
            
            cell.noButonOutlet.isSelected = false
            cell.noButonOutlet.setImage(UIImage(named: "check_square_outline"), for: .normal)
           // isExpand = true
          //  signStep4TableView.reloadData()
            
            
        } else if sender == cell.noButonOutlet{
            
            
            cell.yesbuttonOutlet.isSelected = false
            cell.yesbuttonOutlet.setImage(UIImage(named: "check_square_outline"), for: .normal)
            
            cell.noButonOutlet.isSelected = true
            cell.noButonOutlet.setImage(UIImage(named: "check_square"), for: .normal)
           isExpand = false
           signStep4TableView.reloadData()
            
            
        }
        
    }
    
    //#MARK:-OtherExpandcell Button Pressed
    
    @objc func otherFieldButtonPressed(sender:UIButton) {
        
        containerView.layer.cornerRadius = 5.0
        containerView.layer.masksToBounds = true
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.signStep4TableView)
        let indexPath = self.signStep4TableView.indexPathForRow(at: buttonPosition)
        //       let cell:Step4QuestionCell = self.signStep4TableView.cellForRow(at:indexPath! ) as! Step4QuestionCell
        
//        if (indexPath?.row == 0){
//            transparentView.isHidden = false
//            sizeArray = []
//            hearAboutArray = []
//            popUpTableArray = ["Boston, MA", "Chicago, IL", "Denver, CO", "Los Angeles, CA", "Orange County, CA","Philadelphia, PA","Portlant, OR","San Diego, CA","San Francisco, CA","Seattle, WA","Washington, DC"]
//
//        }else if(indexPath?.row == 5){
//            transparentView.isHidden = false
//            popUpTableArray = []
//            hearAboutArray = []
//            sizeArray = ["Small", "Medium", "Large", "X-Large", "XX-Large","XXX-Large"]
//        }else
        if(indexPath?.row == 6){
            transparentView.isHidden = false
            popUpTableArray = []
            sizeArray = []
            hearAboutArray = ["Craigslist", "Facebook", "Ford Credit", "Referred by a friend", "Refferred by a Dolly Helper","Public transit","Crowded","News","Google","CrossFit","Flyer","Other(Please Specify)"]
        }
        popUpTableView.reloadData()
    }
    
}

