//
//  TipsViewController.swift
//  MoveIt
//
//  Created by RV on 11/05/21.
//  Copyright © 2021 Jyoti. All rights reserved.
//

import UIKit

class TipsViewController: UIViewController {
    
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
        setNavigationTitle("Tip Payment Info")
        
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
        CommonAPIHelper.getHelperTipPaymentInfo(VC: self, page_index: 1) { (res, err, isExe) in
            if isExe{
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
    
    @objc func getMoveDetails(moveID:Int) {
        
        let moveDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "MoveDetailsViewController") as! MoveDetailsViewController
        moveDetailsVC.moveID = moveID
      //  moveDetailsVC.isFromAccounting = true
        
        moveDetailsVC.isFromOngoing = false
        moveDetailsVC.isHideAcceptButton = true
        moveDetailsVC.isHideCallAndChatBtn = true
        self.navigationController?.pushViewController(moveDetailsVC, animated: true)
    }
}

extension TipsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isPaidPressed{
            return 1//paidInfo.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isPaidPressed {
            return paidInfo.count
        } else {
            return unpaidInfo.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isPaidPressed{
            return UIView()
        } else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountingMovesTableViewCell", for: indexPath) as! AccountingMovesTableViewCell
        
        if isPaidPressed {
//            let url = URL.init(string: (paidInfo[indexPath.row]["photo_url"] as! String))
//
//            if url != nil {
//                cell.userImgView.af.setImage(withURL: url!)
//            } else {
//                cell.userImgView.image = UIImage.init(named: "User_placeholder")
//            }
            
            if let moveId = (paidInfo[indexPath.row]["request_id"] as? Int){
                cell.nameLabel.text = constantString.move_id + "\(moveId )"
            }else if let moveId = (paidInfo[indexPath.row]["request_id"] as? String){//"customer_name"
                cell.nameLabel.text = constantString.move_id + moveId
            }
            
//            cell.nameLabel.text = (paidInfo[indexPath.row]["customer_name"] as! String)
            if let dt = paidInfo[indexPath.row]["created_datetime"] as? String{
                cell.dateTimeLAbel.text = dt.formattedDateFromString("MM-dd-yyyy HH:mm:ss")
            } else{
                cell.dateTimeLAbel.text = ""
            }
            
            if let am = paidInfo[indexPath.row]["total_amount"] as? Double{
                cell.amountLabel.text = "$" + String.init(format: "%0.2f", am)
            } else{
                cell.amountLabel.text = ""
            }
            // cell.amountLabel.text = ""//"$" + String.init(format: "%0.2f", (paidInfo[indexPath.row]["total_amount"] as! Double))
        }
        else{
        
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
            if let amuont = (unpaidInfo[indexPath.row]["total_amount"] as? Double) {
                cell.amountLabel.text = "$" + String.init(format: "%0.2f", amuont)
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
