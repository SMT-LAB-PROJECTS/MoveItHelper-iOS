//
//  AlccountingInfoViewController.swift
//  MoveIt
//
//  Created by Dushyant on 11/01/20.
//  Copyright © 2020 Jyoti. All rights reserved.
//

import UIKit

class AccountingInfoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var segmentView: UISegmentedControl!
    @IBOutlet var footerView: UIView!
    @IBOutlet weak var footerLabelView: UILabel!
        
    var paidInfo = [[String: Any]](){
           didSet{
               
           }
       }
    
    var unpaidInfo = [[String: Any]](){
        didSet{
            
        }
    }
    
    var isPaidPressed = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle("Accounting Info")
        
//        let leftBarButtonItem = StaticHelper.leftBarButtonWithImageNamed(imageName: "backward_arrow_icon", vc: self)
        self.navigationItem.leftBarButtonItem = StaticHelper.leftBarButton(withImageNamed: "backward_arrow_icon", forVC: self)

        headerView.frame.size.height = 40.0 * screenHeightFactor
        footerLabelView.font = UIFont.josefinSansRegularFontWithSize(size: 17.0)
        self.getAccoutingInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    func getAccoutingInfo(){
        CommonAPIHelper.getHelperAccountingInfo(VC: self, page_index: 1) { (res, err, isExe) in
            if isExe{
                print("AccountingInfo = ", res as Any)
                self.unpaidInfo =  res!["un_paid"] as! [[String: Any]]
                self.paidInfo =   ((res!["paid"] as! [String: Any])["info"] as! [[String: Any]])
                if self.isPaidPressed{
                    
                       if  self.paidInfo.count == 0{
                           self.tableView.tableFooterView =  self.footerView
                           self.tableView.tableFooterView?.frame.size.height = 400.0 * screenHeightFactor
                       }
                       else{
                           self.tableView.tableFooterView =  UIView()
                           self.tableView.tableFooterView?.frame.size.height = 0.0 * screenHeightFactor
                       }
                    }
                    else{
                        
                       if  self.unpaidInfo.count == 0{
                           self.tableView.tableFooterView =  self.footerView
                           self.tableView.tableFooterView?.frame.size.height = 400.0 * screenHeightFactor
                       }
                       else{
                           self.tableView.tableFooterView =  UIView()
                           self.tableView.tableFooterView?.frame.size.height = 0.0 * screenHeightFactor
                       }

                }
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func leftPressed(_ selector: Any){
           self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func segmentPressed(_ sender: Any) {

        if (sender as! UISegmentedControl).selectedSegmentIndex == 0{
            isPaidPressed = true
          
        }
        else{
            isPaidPressed = false
        }
        
            if self.isPaidPressed{
            
               if  self.paidInfo.count == 0{
                   self.tableView.tableFooterView =  self.footerView
                   self.tableView.tableFooterView?.frame.size.height = 400.0 * screenHeightFactor
               }
               else{
                   self.tableView.tableFooterView =  UIView()
                   self.tableView.tableFooterView?.frame.size.height = 0.0 * screenHeightFactor
               }
            }
            else{
                
               if  self.unpaidInfo.count == 0{
                   self.tableView.tableFooterView =  self.footerView
                   self.tableView.tableFooterView?.frame.size.height = 400.0 * screenHeightFactor
               }
               else{
                   self.tableView.tableFooterView =  UIView()
                   self.tableView.tableFooterView?.frame.size.height = 0.0 * screenHeightFactor
               }

        }
        
        self.tableView.reloadData()
    }
    
    @objc func getMoveDetails(moveID:Int){

        let moveDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "MoveDetailsViewController") as! MoveDetailsViewController
        moveDetailsVC.isFromOngoing = false
        //moveDetailsVC.isFromAccounting = true
        moveDetailsVC.isHideAcceptButton = true
        moveDetailsVC.moveID = moveID
        moveDetailsVC.isHideCallAndChatBtn = true
        moveDetailsVC.moveType = MoveType.Canceled
        self.navigationController?.pushViewController(moveDetailsVC, animated: true)
    }
}

extension AccountingInfoViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isPaidPressed{
            
            return 1//paidInfo.count
        }
        else{
            
            return 1
        }
      
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isPaidPressed{
        
            return paidInfo.count
        }
        else{
        
            return unpaidInfo.count
        }
        
     
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
       if isPaidPressed{
        return UIView()
//            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountingheaderTableViewCell") as! AccountingheaderTableViewCell
//            return cell
       }
       else{
           return UIView()
       }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountingMovesTableViewCell", for: indexPath) as! AccountingMovesTableViewCell
        
        if isPaidPressed {
//            let url = URL.init(string: (paidInfo[indexPath.row]["photo_url"] as! String))
//
//            if url != nil{
//             cell.userImgView.af.setImage(withURL: url!)
//            }
//            else{
//                cell.userImgView.image = UIImage.init(named: "User_placeholder")
//            }
           
            if let moveId = (paidInfo[indexPath.row]["request_id"] as? Int){
                cell.nameLabel.text = constantString.move_id + "\(moveId )"
            }else if let moveId = (paidInfo[indexPath.row]["request_id"] as? String){//"customer_name"
                cell.nameLabel.text = constantString.move_id + moveId
            }
            
         if let dt = paidInfo[indexPath.row]["created_datetime"] as? String{
                cell.dateTimeLAbel.text = (paidInfo[indexPath.row]["created_datetime"] as! String).formattedDateFromString("MM-dd-yyyy HH:mm:ss")
         }
         else{
            cell.dateTimeLAbel.text = ""
         }
         
           if let am = paidInfo[indexPath.row]["total_amount"] as? Double{
               cell.amountLabel.text = "+ $" + String.init(format: "%0.2f", am)
               cell.amountLabel.textColor = greenColor

               if let strType = paidInfo[indexPath.row]["type"] as? String{
                   if strType != "credit"{
                       cell.amountLabel.text = "- $" + String.init(format: "%0.2f", am)
                       cell.amountLabel.textColor = redColor
                   }
               }
         }
           else{
             cell.amountLabel.text = ""
         }
     } else {
        
//            let url = URL.init(string: (unpaidInfo[indexPath.row]["photo_url"] as! String))
//            
//            if url != nil{
//                cell.userImgView.af.setImage(withURL: url!)
//            }
//            else{
//                cell.userImgView.image = UIImage.init(named: "User_placeholder")
//            }
         
          if let moveId = (unpaidInfo[indexPath.row]["request_id"] as? Int){
              cell.nameLabel.text = constantString.move_id + "\(moveId )"
          }else if let moveId = (unpaidInfo[indexPath.row]["request_id"] as? String){//"customer_name"
              cell.nameLabel.text = constantString.move_id + moveId
          }
            cell.dateTimeLAbel.text = (unpaidInfo[indexPath.row]["created_datetime"] as! String).formattedDateFromString("MM-dd-yyyy HH:mm:ss")
        
            if let amount = (unpaidInfo[indexPath.row]["total_amount"] as? Double) {
                cell.amountLabel.text = "+ $" + String.init(format: "%0.2f", amount)
                cell.amountLabel.textColor = greenColor

                if let strType = unpaidInfo[indexPath.row]["type"] as? String{
                    if strType != "credit"{
                        cell.amountLabel.text = "- $" + String.init(format: "%0.2f", amount)
                        cell.amountLabel.textColor = redColor
                    }
                }
            } else {
                cell.amountLabel.text = "$$$$"
            }
        }
        
     
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
          if isPaidPressed{
              return 0.1 * screenHeightFactor
            // return 65.0 * screenHeightFactor
          }
          else{
             return 0.1 * screenHeightFactor
          }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0 * screenHeightFactor
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isPaidPressed{
            let requestId = (paidInfo[indexPath.row]["request_id"] as! Int)
            self.getMoveDetails(moveID: requestId)
        }
        else{
            let requestId = (unpaidInfo[indexPath.row]["request_id"] as! Int)
            self.getMoveDetails(moveID: requestId)
        }
    }
}
