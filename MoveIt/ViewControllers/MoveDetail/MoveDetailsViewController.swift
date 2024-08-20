//
//  MoveDetailsViewController.swift
//  MoveIt
//
//  Created by Dushyant on120: 20/06/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire

class MoveDetailsViewController: UIViewController,MoveArrivalTimeDelegate, ChooseServiceAlertDelegate {
    var A1: String = ""
    var A2: String = ""
    var moveDict = [String: Any]()
    var moveInfo : MoveDetailsModel?
    var adminReasonInfo : AdminReasonModel?
    
    var moveItems = [MoveItems]()
    var moveID = 0
    var acceptMoveId = 0
    var isConnectingToAnotherHelper = false
    var alertView :AlertPopupView?

    var isHideAcceptButton = false
    var isFromOngoing: Bool?

    var moveType = MoveType.None
    
    var addCells = 0
    
    var otherHelperInfo = [[String: Any]]()
    
    var isFromAccounting: Bool = false
    var isHideCallAndChatBtn: Bool = false
    var reasonViewListView :PopupReason?
    var manualReasonObject = [String:Any]()


    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var acceptedHelperInfoLabel: UILabel!
    @IBOutlet weak var lblMoveId: UILabel!
    @IBOutlet weak var moveInfoLabel: UILabel!
    
    @IBOutlet weak var noHelperView: UIView!
    
    @IBOutlet weak var helperInfoView: UIView!
    @IBOutlet weak var helperImgView: UIImageView!
    @IBOutlet weak var helperNameLabel: UILabel!
    @IBOutlet weak var helperTypeLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    
    @IBOutlet weak var helper2InfoView: UIView!
    @IBOutlet weak var helper2ImgView: UIImageView!
    @IBOutlet weak var helper2NameLabel: UILabel!
    @IBOutlet weak var helper2TypeLabel: UILabel!
    @IBOutlet weak var call2Button: UIButton!
    @IBOutlet weak var message2Button: UIButton!
    
    @IBOutlet weak var nohelperAvaialbleLabel: UILabel!
    @IBOutlet weak var customerBkView: UIView!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var customerBkView1: UIView!
    @IBOutlet weak var userImgView1: UIImageView!
    @IBOutlet weak var userNameLabel1: UILabel!
    @IBOutlet weak var serviceLabel1: UILabel!
    @IBOutlet weak var priceLabel1: UILabel!
    @IBOutlet weak var priceLabelBoth: UILabel!
    @IBOutlet weak var acceptTypeLabelTopView: UILabel!
    @IBOutlet weak var acceptTypeLabel: UILabel!
    @IBOutlet var lblEstimateHourMessage1: UILabel!

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblEstimateHourMessage: UILabel!

    @IBOutlet weak var headerView: UIView!
    @IBOutlet var oneHelperHeaderView: UIView!
    
    var helperStatus : Int?
    var IsLoaded = false
    var progressHud = MBProgressHUD()
    
    enum TableSection {
        static let address = 0
        static let date = 1
        static let item = 2
        static let locaton = 3
        static let photos = 4
    }

    var selectedMoveType:MoveTypeModel?

    
    @IBOutlet weak var viewJobEdit: UIView!
    @IBOutlet weak var lblJobEdit: UILabel!
    @IBOutlet weak var acceptJobEdit: UIButton!
    @IBOutlet weak var rejectJobEdit: UIButton!
    var slotVC:MoveArrivalTimeViewController!
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    
    //Outlet's for the cancelation reason....
    @IBOutlet weak var lblTitleMessageCancelationReason: PaddingLabel!
    @IBOutlet weak var lblFeeCancelationReason: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.getMoveTypeDetails()
        
        self.uiConfigurationAfterStoryboard()
        
        self.getMoveDetails()
//        self.conditionalUIConfiguration()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
//    func hideShowElements(valueis: Bool){
//        topView.isHidden = valueis
//
//        backButton.isHidden = valueis
//        acceptButton.isHidden = valueis
//        cancelButton.isHidden = valueis
//        tableView.isHidden = valueis
//        editButton.isHidden = valueis
//        acceptedHelperInfoLabel.isHidden = valueis
//        helperInfoView.isHidden = valueis
//        moveInfoLabel.isHidden = valueis
//        helperImgView.isHidden = valueis
//        helperNameLabel.isHidden = valueis
//        helperTypeLabel.isHidden = valueis
//        callButton.isHidden = valueis
//        messageButton.isHidden = valueis
//        noHelperView.isHidden = valueis
//        nohelperAvaialbleLabel.isHidden = valueis
//        customerBkView.isHidden = valueis
//        userImgView.isHidden = valueis
//        userNameLabel.isHidden = valueis
//        serviceLabel.isHidden = valueis
//        priceLabel.isHidden = valueis
//        customerBkView1.isHidden = valueis
//        userImgView1.isHidden = valueis
//        userNameLabel1.isHidden = valueis
//        serviceLabel1.isHidden = valueis
//        priceLabel1.isHidden = valueis
//        acceptTypeLabel.isHidden = valueis
//    }

    func uiConfigurationAfterStoryboard() {
        tableView.isHidden = true
        acceptButton.layer.cornerRadius = 15.0 //* screenHeightFactor
        self.acceptButton.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        
        editButton.layer.cornerRadius = 15.0 //* screenHeightFactor
        self.editButton.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        
        headerView.frame.size.height = 0.0 * screenHeightFactor
        headerView.isHidden = true
        acceptButton.isHidden = true
        
        userImgView.layer.cornerRadius = 20.0 //* screenHeightFactor
        userImgView1.layer.cornerRadius = 20.0 
        userNameLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        serviceLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        priceLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        userNameLabel1.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        serviceLabel1.font = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        priceLabel1.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        priceLabelBoth.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)

        customerBkView.layer.cornerRadius = 10.0 * screenHeightFactor
        customerBkView1.layer.cornerRadius = 10.0 * screenHeightFactor
        helperInfoView.layer.cornerRadius = 10.0 * screenHeightFactor
        noHelperView.layer.cornerRadius = 10.0 * screenHeightFactor
        helper2InfoView.layer.cornerRadius = 10.0 * screenHeightFactor

        helperNameLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        helperTypeLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        helper2NameLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        helper2TypeLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)

        nohelperAvaialbleLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 15.0)
        moveInfoLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 15.0)
        acceptedHelperInfoLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 15.0)
        isHideChatAndPhone(isHideCallAndChatBtn)
    }
    func isHideChatAndPhone(_ flag:Bool){
        self.callButton.isHidden = flag
        self.messageButton.isHidden = flag
        self.call2Button.isHidden = flag
        self.message2Button.isHidden = flag
    }
    func conditionalUIConfiguration() {
        
        self.viewJobEdit.isHidden = true
        self.topViewHeightConstraint.constant = 60.0
        lblMoveId.text = constantString.move_id + "\((moveInfo?.request_id) ?? 0)"
//      setNavigationTitle("Move Details")

        if(moveInfo?.is_reconfirm == 1) {
            self.topViewHeightConstraint.constant = 180.0
            editButton.isHidden = true
            self.lblTitle.isHidden = true
            
            viewJobEdit.isHidden = false
            
            acceptJobEdit.setTitle("", for: .normal)
            rejectJobEdit.setTitle("", for: .normal)
            
            acceptJobEdit.isHidden = false
            rejectJobEdit.isHidden = false
            lblJobEdit.text = "This job has been edited by the customer. Please review the changes and accept it again."
            lblJobEdit.textColor = .black
            lblJobEdit.font = UIFont.josefinSansRegularFontWithSize(size: 14.0)
            
            acceptJobEdit.backgroundColor = darkPinkColor
            acceptJobEdit.layer.cornerRadius = 15.0
//            acceptJobEdit.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
            
            rejectJobEdit.backgroundColor = darkPinkColor
            rejectJobEdit.layer.cornerRadius = 15.0
//            rejectJobEdit.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
            
        } else if(moveInfo?.helper_edited == 1) {
            self.lblTitle.text = "\n\n\n\n" + "Your Edit Move Request Is Pending"
            self.lblTitle.textAlignment = .center
            self.lblTitle.isHidden = false
            self.editButton.isHidden = true
            self.viewJobEdit.isHidden = true
        } else {
            
            self.lblTitle.isHidden = true
            
            if isFromOngoing != nil,isFromOngoing!{
                helperStatus = moveInfo?.helper_status!
                if helperStatus != nil && helperStatus! >= 2 && helperStatus! <= 3 {
                    editButton.isHidden = false
                } else{
                     editButton.isHidden = true
                }
            }
        }
        
        if moveType == MoveType.Complete || moveType == MoveType.Canceled {
            self.callButton.isHidden = true
            self.messageButton.isHidden = true
            self.call2Button.isHidden = true
            self.message2Button.isHidden = true
        } else if moveType == MoveType.Available {
            self.callButton.isHidden = true
            self.messageButton.isHidden = true
            self.call2Button.isHidden = true
            self.message2Button.isHidden = true
        }
//        else if isFromAccounting == true{
//            self.callButton.isHidden = true
//            sel  f.messageButton.isHidden = true
//        }
        
        if (isProgressShowForce) {
            progressHud = MBProgressHUD.showAdded(to: view, animated: true)
            UIActivityIndicatorView.appearance(whenContainedInInstancesOf: [MBProgressHUD.self]).color = UIColor.gray
            progressHud.bezelView.color = UIColor.clear
            progressHud.contentColor = darkPinkColor
            DispatchQueue.main.async {
//                print("**********************")
                self.progressHud.show(animated: true)
            }
            isProgressShowForce = false
        }
        tableView.isHidden = false

    }
    
    func setupData(){
        print("Move info :- \(String(describing: moveInfo?.customer_photo_url))")
        if moveInfo?.customer_photo_url != nil{
            self.userImgView.af.setImage(withURL: (moveInfo?.customer_photo_url)!, placeholderImage: UIImage.init(named: "User_placeholder"), filter: nil, progress: nil, progressQueue: .main, imageTransition: .noTransition, runImageTransitionIfCached: .init()) { (_) in
            }
            self.userImgView1.af.setImage(withURL: (moveInfo?.customer_photo_url)!, placeholderImage: UIImage.init(named: "User_placeholder"), filter: nil, progress: nil, progressQueue: .main, imageTransition: .noTransition, runImageTransitionIfCached: .init()) { (_) in
            }
        } else {
            self.userImgView.image = UIImage.init(named: "User_placeholder")
            self.userImgView1.image = UIImage.init(named: "User_placeholder")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.userImgView.layer.cornerRadius = 20.0 //* screenHeightFactor
            self.userImgView.layer.masksToBounds = true
        }
        userNameLabel.text = (moveInfo?.customer_name)!
                
        self.setPriceLabelText()
        
        
        serviceLabel.text = (moveInfo?.dropoff_service_name)!
        userNameLabel1.text = (moveInfo?.customer_name)!
        
        serviceLabel1.text = (moveInfo?.dropoff_service_name)!
   
        //userImgView.clipsToBounds = true
        moveItems = (moveInfo?.moveItems)!
        IsLoaded = true
        progressHud.hide(animated: true)
        if (moveInfo!.helping_service_required_pros! + moveInfo!.helping_service_required_muscle!) >= 2 {
            
            CommonAPIHelper.getAllotedHelperInfo(VC: self, move_id: moveInfo!.request_id!) { [self] (res, err, isExe) in
                if isExe {
                    self.otherHelperInfo = res!
                    self.headerView.frame.size.height = (self.otherHelperInfo.count > 1) ? 300 : 220
                    self.tableView.reloadData()
                    self.helper2InfoView.isHidden = (self.otherHelperInfo.count > 1) ? false : true
                    if self.otherHelperInfo.count > 0 {
                        let urlString = self.otherHelperInfo[0]["photo_url"] as! String
                        if(self.helperInfoView != nil) {
                            self.helperInfoView.isHidden = false
                        }
                        if(self.noHelperView != nil) {
                            self.noHelperView.isHidden = true
                        }
                        if let url = URL.init(string: urlString) {
                            if(self.helperImgView != nil) {
                                self.helperImgView.af.setImage(withURL: url, placeholderImage: UIImage.init(named: "User_placeholder"), filter: nil, progress: nil, progressQueue: .main, imageTransition: .noTransition, runImageTransitionIfCached: .init()) { (_) in
                                }
                                self.helperImgView.layer.cornerRadius = 20.0
                            }
                        }
                        if(self.helperNameLabel != nil) {
                            self.helperNameLabel.text = (self.otherHelperInfo[0]["first_name"] as! String) + " " + (self.otherHelperInfo[0]["last_name"] as! String)
                        }
                        if(self.helperTypeLabel != nil) {
                            if (self.otherHelperInfo[0]["helper_service_type"] as! Int) == 2{
                                self.helperTypeLabel.text = "Muscle"
                            }else if (self.otherHelperInfo[0]["helper_service_type"] as! Int) == 1{
                                self.helperTypeLabel.text = "Pro"
                            }else{
                                self.helperTypeLabel.text = "Pro & Muscle"
                            }
                        }
                        if moveInfo?.is_estimate_hour == 0 {
                            self.lblEstimateHourMessage1.text = ""
                        }else{
                            if moveInfo?.helper_status == 4 {
                                let time = secondsToHoursMinutesSeconds(seconds: Double(moveInfo?.total_working_minute ?? 0) * 60)
                                self.lblEstimateHourMessage1.text = kStringForMoveStatus.workingHours + time
                            }else {
                                self.lblEstimateHourMessage1.text = moveInfo?.estimate_hour_message
                            }
                        }
                        
                        // Second helper
                        if self.otherHelperInfo.count > 1 {
                            let url2String = self.otherHelperInfo[1]["photo_url"] as! String
                            if(self.helper2InfoView != nil) {
                                self.helper2InfoView.isHidden = false
                            }
                            if let url = URL.init(string: url2String) {
                                if(self.helper2ImgView != nil) {
                                    self.helper2ImgView.af.setImage(withURL: url, placeholderImage: UIImage.init(named: "User_placeholder"), filter: nil, progress: nil, progressQueue: .main, imageTransition: .noTransition, runImageTransitionIfCached: .init()) { (_) in
                                    }
                                    self.helper2ImgView.layer.cornerRadius = 20.0
                                }
                            }
                            if(self.helper2NameLabel != nil) {
                                self.helper2NameLabel.text = (self.otherHelperInfo[1]["first_name"] as! String) + " " + (self.otherHelperInfo[1]["last_name"] as! String)
                            }
                            print(self.otherHelperInfo)
                            if(self.helper2TypeLabel != nil) {
                                if (self.otherHelperInfo[1]["helper_service_type"] as! Int) == 2{
                                    self.helper2TypeLabel.text = "Muscle"
                                }else if (self.otherHelperInfo[1]["helper_service_type"] as! Int) == 1{
                                    self.helper2TypeLabel.text = "Pro"
                                }else{
                                    self.helper2TypeLabel.text = "Pro & Muscle"
                                }
                            }
                        }
                        
                    } else {
                        self.tableView.tableHeaderView = self.oneHelperHeaderView
                        if moveInfo?.is_estimate_hour == 0{
                            self.tableView.tableHeaderView?.frame.size.height = 90.0 //* screenHeightFactor
                            self.lblEstimateHourMessage.text = ""
                        }else{
                            self.tableView.tableHeaderView?.frame.size.height = 120.0 //* screenHeightFactor
                            if moveInfo?.helper_status == 4 {
                                let time = secondsToHoursMinutesSeconds(seconds: Double(moveInfo?.total_working_minute ?? 0) * 60)
                                self.lblEstimateHourMessage.text = kStringForMoveStatus.workingHours + time
                            }else {
                                self.lblEstimateHourMessage.text = moveInfo?.estimate_hour_message
                            }
                        }
                        if(self.helperInfoView != nil) {
                            self.helperInfoView.isHidden = true
                        }
                        if(self.noHelperView != nil) {
                            self.noHelperView.isHidden = false
                        }
                    }
                }
            }
        } else {
            self.tableView.tableHeaderView = oneHelperHeaderView
            if moveInfo?.is_estimate_hour == 0 {
                self.tableView.tableHeaderView?.frame.size.height = 90.0// * screenHeightFactor
                self.lblEstimateHourMessage.text = ""
            }else{
                self.tableView.tableHeaderView?.frame.size.height = 120.0 //* screenHeightFactor
                if moveInfo?.helper_status == 4 {
                    let time = secondsToHoursMinutesSeconds(seconds: Double(moveInfo?.total_working_minute ?? 0) * 60)
                    self.lblEstimateHourMessage.text = kStringForMoveStatus.workingHours + time
                }else {
                    self.lblEstimateHourMessage.text = moveInfo?.estimate_hour_message
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.userImgView.layer.cornerRadius = 20.0 //* screenHeightFactor
        }
        self.tableView.reloadData()
    }
    func secondsToHoursMinutesSeconds(seconds: Double) -> String {
      let (hr,  minf) = modf(seconds / 3600)
      let (min, secf) = modf(60 * minf)
      
        var string = ""
        
        let hour = Int(hr)
        let minuts = Int(min)

        if hour > 1 {
            string = "\(hour) hours"
        }else {
            string = "\(hour) hour"
        }
        
        if minuts >= 1 {
            if minuts > 1 {
                string = string + ", \(minuts) minutes"
            }else {
                string = string + ", \(minuts) minute"
            }
        }
        return string
     }
    func makeEmptyLable(){
        acceptTypeLabel.text = ""
        acceptTypeLabelTopView.text = ""
        priceLabel.text = ""
        priceLabel1.text = ""
        priceLabelBoth.text = ""
    }
    func setPriceLabelText() {
        makeEmptyLable()
        let userDefault = UserDefaults.standard
        let helper_service_type:Int = userDefault.value(forKey: kUserCache.service_type) as! Int
        let helping_service_required_pros:Int = moveInfo?.helping_service_required_pros ?? 0
        let helping_service_required_muscle:Int = moveInfo?.helping_service_required_muscle ?? 0
        print(moveInfo?.other_helper_service_type)
        let other_helper_service_type:Int = moveInfo?.other_helper_service_type ?? 0
         
        if(helper_service_type == 3 && helping_service_required_pros > 0 && helping_service_required_muscle > 0) {
            if let total_amount = moveInfo?.total_amount  {
                if moveInfo?.is_estimate_hour == 0 {
                    priceLabel.text = "$" + String.init(format: "%0.2f", total_amount)
                    priceLabel1.text = "$" + String.init(format: "%0.2f", total_amount)
                }else {
                    priceLabel.text = "$" + String.init(format: "%0.2f/hr", total_amount)
                    priceLabel1.text = "$" + String.init(format: "%0.2f/hr", total_amount)
                }
            }
            if let musleamount = (moveInfo?.total_muscle_amount) {
                if moveInfo?.is_estimate_hour == 0 {
                    A1 = "$" + String.init(format: "%0.2f", musleamount)
                }else {
                    A1 = "$" + String.init(format: "%0.2f/hr", musleamount)
                }
            }
            if let proamount = (moveInfo?.total_pros_amount){
                if moveInfo?.is_estimate_hour == 0 {
                    A2 = "$" + String.init(format: "%0.2f", proamount)
                }else {
                    A2 = "$" + String.init(format: "%0.2f/hr", proamount)
                }
            }
            
            let helper_accept_service_type:Int = moveInfo?.helper_accept_service_type ?? 0
            
            if helper_accept_service_type == HelperType.Pro {
                if let amount = moveInfo?.total_pros_amount {
                    //"Pro"
                    self.setTotalProAmount(amount: amount)
                    return
                }
            }
            if helper_accept_service_type == HelperType.Muscle {
                if let amount = moveInfo?.total_muscle_amount{
                    //"Muscle"
                    self.setTotalMuscleAmount(amount: amount)
                    return
                }
            }
            
            
//            if helper_accept_service_type == HelperType.None &&
//                other_helper_service_type == HelperType.None && (A1 != "") && (A2 != "") {
//                    self.setBothPrice(amount1: A1, amount2: A2)
//                if self.moveType == MoveType.Available{
//                    self.setBothPrice(amount1: A1, amount2: A2)
//                }else if other_helper_service_type != 1{
//                    self.setBothPrice(amount1: A1, amount2: A2)
//                }
//            }
            
            if(other_helper_service_type == HelperType.None) {
                self.setBothPrice(amount1: A1, amount2: A2)
//                acceptTypeLabel.text = ""
//                acceptTypeLabelTopView.text = ""
//                if(helper_accept_service_type == HelperType.Muscle) {
//                    if let amount = moveInfo?.total_muscle_amount{
//                        self.setTotalMuscleAmount(amount: amount)
//                    }
//                } else if(helper_accept_service_type == HelperType.Pro) {
//                    if let amount = moveInfo?.total_pros_amount {
//                        self.setTotalProAmount(amount: amount)
//                    }
//                }else{
//                    if (helper_service_type == HelperType.Pro) {
//                        acceptTypeLabel.text = "Pro"
//                        acceptTypeLabelTopView.text = "Pro"
//                    }else{
//                        acceptTypeLabel.text = "Muscle"
//                        acceptTypeLabelTopView.text = "Muscle"
//                    }
//                }
            } else if(other_helper_service_type == HelperType.Muscle) {
                if let amount = moveInfo?.total_pros_amount {
                    //"Pro"
                    self.setTotalProAmount(amount: amount)
                }
            } else if(other_helper_service_type == HelperType.Pro) {
                if let amount = moveInfo?.total_muscle_amount{
                    //"Muscle"
                    self.setTotalMuscleAmount(amount: amount)
                }
            }
        }
        
        if (helper_service_type == 1 && helping_service_required_pros > 0){
            if let total_amount = moveInfo?.total_amount {
                self.setTotalProAmount(amount: total_amount)
            }
            if let amount = moveInfo?.total_pros_amount {
                self.setTotalProAmount(amount: amount)
            }
        }
        
        if (helper_service_type == 2 && helping_service_required_muscle > 0){
            if let total_amount = moveInfo?.total_amount {
                self.setTotalMuscleAmount(amount: total_amount)
            }
            if let amount = moveInfo?.total_muscle_amount {
                self.setTotalMuscleAmount(amount: amount)
            }
        }
    }
    
    
    
    private func setTotalProAmount(amount: Double) {
        makeEmptyLable()
        acceptTypeLabel.text = "Pro"
        acceptTypeLabelTopView.text = "Pro"
        if (moveInfo?.is_estimate_hour as? Int) == 0 {
            priceLabel.text = "$" + String.init(format: "%0.2f", amount)
            priceLabel1.text = "$" + String.init(format: "%0.2f", amount)
        }else {
            priceLabel.text = "$" + String.init(format: "%0.2f/hr", amount)
            priceLabel1.text = "$" + String.init(format: "%0.2f/hr", amount)
        }
    }
    
    private func setTotalMuscleAmount(amount: Double) {
        makeEmptyLable()
        acceptTypeLabel.text = "Muscle"
        acceptTypeLabelTopView.text = "Muscle"
        if moveInfo?.is_estimate_hour == 0{
            priceLabel.text = "$" + String.init(format: "%0.2f", amount)
            priceLabel1.text = "$" + String.init(format: "%0.2f", amount)
        }else {
            priceLabel.text = "$" + String.init(format: "%0.2f/hr", amount)
            priceLabel1.text = "$" + String.init(format: "%0.2f/hr", amount)
        }
    }
    
    private func setBothPrice(amount1: String, amount2: String) {
        makeEmptyLable()
        self.tableView.tableHeaderView = oneHelperHeaderView
        let finalSt1 = "Muscle " + amount1
        let finalSt2 = "\n" + "Pro " + amount2
        priceLabelBoth.numberOfLines = 0
        priceLabelBoth.textAlignment = .right
        priceLabelBoth.text = finalSt1 + finalSt2
        priceLabelBoth.halfTextColorChange(fullText: priceLabelBoth.text!, changeText: "Muscle", changeText1: "Pro")
    }
    
    //MARK: - APIs
    
    func getMoveTypeDetails() {
        
        DispatchQueue.main.async {
            StaticHelper.shared.startLoader(self.view)
        }

        let move_type_id:Int = moveDict[keysForBookMoves.move_type_id] as! Int
        
        let strURL = baseURL+kAPIMethods.get_move_type_by_id+String(move_type_id)
        //AF.request(baseURL+APIMethods.get_all_move_type).responseJSON { (response) in
        AF.request(strURL).responseJSON { (response) in

            DispatchQueue.main.async { [self] in
                switch response.result {
                case .success:
                    StaticHelper.shared.stopLoader()
                    if response.response?.statusCode == 200 {
                        let reponseDict = response.value as! [String: Any]
                        
                        let objMoveType:MoveTypeModel = MoveTypeModel.init(itemsDict: reponseDict)!
                        self.selectedMoveType = objMoveType
                        print("reponseDict = ", reponseDict)
                        self.setupData()
                    }
                case .failure(let error):
                    StaticHelper.shared.stopLoader()
                    if(response.response?.statusCode == 401) {
                        //StaticHelper.logout()
                    }else{
                        self.view.makeToast(error.localizedDescription)
                    }
                }
            }
        }
    }

    func getMoveDetails() {

        var screen_type = ""
        if  moveType == MoveType.Canceled{
            screen_type = "canceled"
        }
        CommonAPIHelper.getMoveDetailByID(VC: self, move_id: moveID, screen_type: screen_type, completetionBlock: { [self] (result, error, isexecuted) in
            
            DispatchQueue.main.async {
                if error != nil{
                    self.progressHud.hide(animated: true)
                    return
                } else {
                    
                    
                    self.headerView.isHidden = false
                    self.headerView.frame.size.height = 300
                    self.addCells = 4
                    //Added this for crash on edit solve
                    print("Result of move details screen's = \(result!)")
                    self.moveDict = result!
                    self.moveInfo = MoveDetailsModel.init(moveDict: result!)
                    print(self.moveInfo?.other_helper_service_type)
                    self.conditionalUIConfiguration()
                    if (self.isHideAcceptButton == true) {
                        self.acceptButton.isHidden = true
                    } else {
                        if(self.moveInfo!.helper_accept_service_type! > 0) {
                            self.acceptButton.isHidden = true
                        } else {
                            self.acceptButton.isHidden = false
                        }
                    }
                    self.getMoveTypeDetails()
                    if let reason = result!["admin_reason"]{
                        self.adminReasonInfo = AdminReasonModel.init(adminReasonDict: reason as! [String : Any])
                        
                        let color = UIColor.init(red: 246.0/255.0, green : 174.0/255.0, blue: 180.0/255.0, alpha: 0.1)
                        self.lblTitleMessageCancelationReason.font = UIFont.josefinSansBoldFontWithSize(size: 13.0)
                        self.lblTitleMessageCancelationReason.backgroundColor = color
                        self.lblTitleMessageCancelationReason.layer.borderWidth = 0.5
                        self.lblTitleMessageCancelationReason.layer.cornerRadius = 10
                        self.lblTitleMessageCancelationReason.layer.borderColor = UIColor.lightGray.cgColor
                        self.lblTitleMessageCancelationReason.layer.masksToBounds = true
                                    
                        let str1:String = "\n" + (adminReasonInfo?.reason_title! ?? "")//\nYour Change Service Request Is Pending.
                        let str12:String = "\n\n"
                        let str2:String = "\(adminReasonInfo?.reason_message! ?? "")\n"
                        
                        let attributedText = NSMutableAttributedString(string: str1, attributes: [NSAttributedString.Key.font: UIFont.josefinSansSemiBoldFontWithSize(size: 13.0), NSAttributedString.Key.foregroundColor: UIColor.black])
                        
                        attributedText.append(NSAttributedString(string: str12, attributes: [NSAttributedString.Key.font: UIFont.josefinSansRegularFontWithSize(size: 6.0), NSAttributedString.Key.foregroundColor: UIColor.black]))
                        
                        attributedText.append(NSAttributedString(string: str2, attributes: [NSAttributedString.Key.font: UIFont.josefinSansRegularFontWithSize(size: 12.0), NSAttributedString.Key.foregroundColor: UIColor.black]))
                        
                        self.lblTitleMessageCancelationReason.numberOfLines = 0
                        self.lblTitleMessageCancelationReason.attributedText = attributedText
                        self.lblTitleMessageCancelationReason.textAlignment = .left
                        self.lblFeeCancelationReason.font = UIFont.josefinSansSemiBoldFontWithSize(size: 15.0)
                        self.lblFeeCancelationReason.text = "\n- \((adminReasonInfo?.cancellation_fee! ?? ""))"
                        self.lblFeeCancelationReason.textColor = redColor
                        
                    }else{
                        self.lblTitleMessageCancelationReason.text = ""
                        self.lblFeeCancelationReason.text = ""
                    }
                }
            }
        })
        
        if isHideAcceptButton {
            acceptButton.isHidden = true
        }
    }
    func showInsuranceExpiredMessage(_ message:String = "", _ titleMessage:String = "", _ isPendingRequestFlag:Bool = false, _ isRequestRejectedFlag:Bool = false) {

//            let viVC = self.storyboard?.instantiateViewController(withIdentifier: "InsuranceExpiredVC") as! InsuranceExpiredVC
//            viVC.message = message
//            viVC.titleMessage = titleMessage
//            viVC.isPendingRequest = isPendingRequestFlag
//            viVC.isRequestRejected = isRequestRejectedFlag
//            self.navigationController?.isNavigationBarHidden = true
//            self.navigationController?.pushViewController(viVC, animated: true)
        
            let viVC = self.storyboard?.instantiateViewController(withIdentifier: "EditVehicleInfoViewController") as! EditVehicleInfoViewController
            viVC.isComeFromServiceStoped = true
            self.navigationController?.pushViewController(viVC, animated: true)
    }
    
    //MARK: - Actions
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func acceptAction(_ sender: Any) {
        if checkCombineJobStatus((moveInfo?.request_id)!){
        }else{
          showPopupInsurance((moveInfo?.request_id)!)
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
    }
    
    @IBAction func messageAction(_ sender: Any) {
        let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        chatVC.customerName = (self.otherHelperInfo[0]["first_name"] as! String) + " " + (self.otherHelperInfo[0]["last_name"] as! String)
        chatVC.customerImgUrl = self.otherHelperInfo[0]["photo_url"] as! String
        chatVC.isHelperChat = true
        chatVC.customer_ID = self.otherHelperInfo[0]["helper_id"] as! Int
        chatVC.Tohelper_ID = self.otherHelperInfo[0]["helper_id"] as! Int
        
        if let reqId = self.otherHelperInfo[0]["request_id"] as? Int {
            chatVC.requestId =  reqId.description
        }
        if let reqId = self.otherHelperInfo[0]["request_id"] as? String {
            chatVC.requestId =  reqId
        }
        

        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    @IBAction func message2Action(_ sender: Any) {
        let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        chatVC.customerName = (self.otherHelperInfo[1]["first_name"] as! String) + " " + (self.otherHelperInfo[1]["last_name"] as! String)
        chatVC.customerImgUrl = self.otherHelperInfo[1]["photo_url"] as! String
        chatVC.isHelperChat = true
        chatVC.customer_ID = self.otherHelperInfo[1]["helper_id"] as! Int
        chatVC.Tohelper_ID = self.otherHelperInfo[1]["helper_id"] as! Int
        
        if let reqId = self.otherHelperInfo[1]["request_id"] as? Int {
            chatVC.requestId =  reqId.description
        }
        if let reqId = self.otherHelperInfo[1]["request_id"] as? String {
            chatVC.requestId =  reqId
        }
        

        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    @IBAction func callButtonAction(_ sender: UIButton) {
        
        let num = (self.otherHelperInfo[0]["phone_num"] as! String).replacingOccurrences(of: " ", with: "")
        if(num.isEmpty) {
            self.view.makeToast("call detail not available.")
            return
        }
        self.dialNumber(number: num)
    }
  
    @IBAction func call2ButtonAction(_ sender: Any) {
        let num = (self.otherHelperInfo[1]["phone_num"] as! String).replacingOccurrences(of: " ", with: "")
        if(num.isEmpty) {
            self.view.makeToast("call detail not available.")
            return
        }
        self.dialNumber(number: num)
    }
    
    @IBAction func editButtonAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AdditionalLocationDetailsViewController") as! AdditionalLocationDetailsViewController
        vc.selectedMoveType = self.selectedMoveType
        vc.moveDict = self.moveDict
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func dialNumber(number : String) {
         
         if let url = URL(string: "tel://\(number)"),
             UIApplication.shared.canOpenURL(url) {
             if #available(iOS 10, *) {
                 UIApplication.shared.open(url, options: [:], completionHandler:nil)
             } else {
                 UIApplication.shared.openURL(url)
             }
         } else {
             // add error message here
         }
     }
    func checkCombineJobStatus(_ requestID: Int )->Bool{
        let Iam = UserCache.shared.userInfo(forKey: kUserCache.service_type) as! Int
        
        if (moveInfo!.helping_service_required_pros! + moveInfo!.helping_service_required_muscle!) >= 2
        {
            if moveInfo!.meeting_slot!.isEmpty {//JOB NOT ACCEPTED By ANY HELPER
                if(Iam == HelperType.ProMuscle) {
                    if moveInfo!.helping_service_required_pros! >= 1, moveInfo!.helping_service_required_muscle! >= 1 {
                        self.askServiceType(requestID)
                        return true
                    }
                }
            }else {//JOB ACCEPTED By OTHER HELPER
                //Need to show by default selected time slotif(Iam == HelperType.ProMuscle) {
                if moveInfo!.helping_service_required_pros! >= 1, moveInfo!.helping_service_required_muscle! >= 1 {
                    self.askServiceType(requestID)
                    return true
                }
            }
        }else if moveInfo!.helping_service_required_muscle! >= 1{
            print(moveInfo)
            if moveInfo?.is_estimate_hour == 1{
                self.acceptMoveId = (moveInfo?.request_id)!
                self.showAlertPopupView(AlertButtonTitle.alert, "\(self.moveInfo?.estimate_hour_confirmation_message! ?? "")", AlertButtonTitle.no, AlertButtonTitle.yes)
            }else{
                self.acceptMove((moveInfo?.request_id)!)
            }
            return true
        }
        return false
    }
    func showPopupInsurance(_ requestID: Int ){
        if(profileInfo!.vehicleDetails!.insurance_expired == "1") && (profileInfo!.vehicleDetails!.is_insurance_request == "0") {
            InsuranceExpiryView.instance.shwoDataWithClosures(profileInfo!.vehicleDetails!.insurance_message_title!, profileInfo!.vehicleDetails!.insurance_message!, "", "", "Update Info"){ status in
                if status{
                    print("Okay")
                    self.showInsuranceExpiredMessage(profileInfo!.vehicleDetails!.insurance_message!, profileInfo!.vehicleDetails!.insurance_message_title!)
                }else{
                    print("NO/Cancel")
                }
            }
        }else if(profileInfo!.vehicleDetails!.is_vehicle_insurance_request == "pending") && (profileInfo!.vehicleDetails!.is_insurance_request == "1"){
            InsuranceExpiryView.instance.shwoDataWithClosures(profileInfo!.vehicleDetails!.insurance_message_title!, profileInfo!.vehicleDetails!.insurance_message!, "", "", AlertButtonTitle.ok){ status in
                if status{
                }else{
                }
            }
        }else if(profileInfo!.vehicleDetails!.is_vehicle_insurance_request == "reject") && (profileInfo!.vehicleDetails!.is_insurance_request == "1") {
            InsuranceExpiryView.instance.shwoDataWithClosures(profileInfo!.vehicleDetails!.insurance_message_title!, profileInfo!.vehicleDetails!.insurance_message!, "", "", "Re-update Info"){ status in
                if status{
                    print("Okay")
                        self.showInsuranceExpiredMessage(profileInfo!.vehicleDetails!.insurance_message!, profileInfo!.vehicleDetails!.insurance_message_title!, false, true)
                }else{
                    print("NO/Cancel")
                }
            }
        }else{
            if moveInfo?.is_estimate_hour == 1{
                self.acceptMoveId = (moveInfo?.request_id)!
                self.showAlertPopupView(AlertButtonTitle.alert, "\(self.moveInfo?.estimate_hour_confirmation_message! ?? "")", AlertButtonTitle.no, AlertButtonTitle.yes)
            }else{
                self.acceptMove((moveInfo?.request_id)!)
            }
        }
    }
    //MARK: - Accept Logic            
    func acceptMove(_ requestID: Int ){

        if(profileInfo?.is_new == 1) {
            if(profileInfo?.w9_form_status == 0 || profileInfo?.w9_form_verified == 0) {
                self.navigationController?.popToRootViewController(animated: true)
                return
            }
        }
        
        let Iam = UserCache.shared.userInfo(forKey: kUserCache.service_type) as! Int

        if (moveInfo!.helping_service_required_pros! + moveInfo!.helping_service_required_muscle!) >= 2
        {
            //JOB NOT ACCEPTED By ANY HELPER
            if moveInfo!.meeting_slot!.isEmpty {
                
                if(Iam == HelperType.Pro) {
                    if moveInfo!.helping_service_required_pros! == 0 {
                        //Pro can not accept muscle job
                    } else if moveInfo!.helping_service_required_muscle! == 0 {
                        self.showArrivalTimeView(requestID, HelperType.Pro)
                    } else if moveInfo!.helping_service_required_pros! >= 1, moveInfo!.helping_service_required_muscle! >= 1 {
                        self.showArrivalTimeView(requestID, HelperType.Pro)
                    }
                } else if(Iam == HelperType.Muscle) {
                    if moveInfo!.helping_service_required_pros! == 0 {
                        self.showArrivalTimeView(requestID, HelperType.Muscle)
                    } else if moveInfo!.helping_service_required_muscle! == 0 {
                        //Muscle can not accept pro job
                    } else if moveInfo!.helping_service_required_pros! >= 1, moveInfo!.helping_service_required_muscle! >= 1 {
                        self.callAcceptMoveAPI(requestID, HelperType.Muscle)
                    }
                } else if(Iam == HelperType.ProMuscle) {
                    if moveInfo!.helping_service_required_pros! == 0 {
                        self.showArrivalTimeView(requestID, HelperType.Muscle)
                    } else if moveInfo!.helping_service_required_muscle! == 0 {
                        self.showArrivalTimeView(requestID, HelperType.Pro)
                    } else if moveInfo!.helping_service_required_pros! >= 1, moveInfo!.helping_service_required_muscle! >= 1 {
                        self.askServiceType(requestID)
                    }
                }
            }
            //JOB ACCEPTED By OTHER HELPER
            else {
                //Need to show by default selected time slot
                if(Iam == HelperType.Pro) {
                    if moveInfo!.helping_service_required_pros! == 0 {
                        //Pro can not accept muscle job
                    } else if moveInfo!.helping_service_required_muscle! == 0 {
                        self.showArrivalTimeView(requestID, HelperType.Pro)
                    } else if moveInfo!.helping_service_required_pros! >= 1, moveInfo!.helping_service_required_muscle! >= 1 {
                        self.showArrivalTimeView(requestID, HelperType.Pro)
                    }
                } else if(Iam == HelperType.Muscle) {
                    if moveInfo!.helping_service_required_pros! == 0 {
                        self.showArrivalTimeView(requestID, HelperType.Muscle)
                    } else if moveInfo!.helping_service_required_muscle! == 0 {
                        //Muscle can not accept pro job
                    } else if moveInfo!.helping_service_required_pros! >= 1, moveInfo!.helping_service_required_muscle! >= 1 {
                        self.callAcceptMoveAPI(requestID, HelperType.Muscle)
                    }
                } else if(Iam == HelperType.ProMuscle) {
                    if moveInfo!.helping_service_required_pros! == 0 {
                        self.showArrivalTimeView(requestID, HelperType.Muscle)
                    } else if moveInfo!.helping_service_required_muscle! == 0 {
                        self.showArrivalTimeView(requestID, HelperType.Pro)
                    } else if moveInfo!.helping_service_required_pros! >= 1, moveInfo!.helping_service_required_muscle! >= 1 {
                        self.askServiceType(requestID)
                    }
                }
            }
        }
        //SINGLE JOB TO ACCEPT
        else {
            if(Iam == HelperType.Pro) {
                self.showArrivalTimeView(requestID, HelperType.Pro)
            } else if(Iam == HelperType.Muscle) {
                self.showArrivalTimeView(requestID, HelperType.Muscle)
            } else if(Iam == HelperType.ProMuscle) {
                if moveInfo!.helping_service_required_pros! == 0 {
                    self.showArrivalTimeView(requestID, HelperType.Muscle)
                } else if moveInfo!.helping_service_required_muscle! == 0 {
                    self.showArrivalTimeView(requestID, HelperType.Pro)
                }
            }
        }
    }
  

    func callAcceptMoveAPI(_ requestID:Int, _ helperType: Int)
    {
        CommonAPIHelper.acceptMoves(VC: self, request_id: requestID, helperType: helperType, completetionBlock: { (result, error, statusCode) in
            if error != nil {
                return
            } else {

                if(statusCode == 201) {
                    self.isConnectingToAnotherHelper = true
                    self.showAlertPopupView(AlertButtonTitle.alert, kStringPermission.connectingToAnotherHelper, "", "", AlertButtonTitle.ok)

//                    let alert = UIAlertController.init(title: "", message: "We are connecting another helper to accept this move. We'll notify you once this job is confirmed.", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: {_ in
//                        appDelegate.homeVC?.redirectToScheduledTab(section: 1)
//                    }))
//                    self.present(alert, animated: true, completion: nil)

                } else {
                    appDelegate.homeVC?.redirectToScheduledTab(section: 0)
                }
            }
        })
    }
    func showArrivalTimeEditView(_ requestID:Int, _ helperType:Int)
    {
        if helperType == 2{
            self.helperUpdatePendingMoveStatusAPICall(confirm_status: "1", meeting_slot: "", helper_reason: "")
        }else{
            slotVC = (self.storyboard?.instantiateViewController(withIdentifier: "MoveArrivalTimeViewController") as! MoveArrivalTimeViewController)
            slotVC.modalPresentationStyle = .overFullScreen
            slotVC.moveInfo = moveInfo
            slotVC.startTime = moveInfo!.pickup_start_time!
            slotVC.endTime = moveInfo!.pickup_end_time!
            slotVC.moveRequestID = requestID
            slotVC.selectedHelperType = helperType
            slotVC.delegate = self
            self.navigationController?.present(slotVC, animated: true, completion: nil)
        }
    }
    func showArrivalTimeView(_ requestID:Int, _ helperType:Int)
    {
        slotVC = (self.storyboard?.instantiateViewController(withIdentifier: "MoveArrivalTimeViewController") as! MoveArrivalTimeViewController)
        slotVC.modalPresentationStyle = .overFullScreen
        slotVC.moveInfo = moveInfo
        slotVC.startTime = moveInfo!.pickup_start_time!
        slotVC.endTime = moveInfo!.pickup_end_time!
        slotVC.moveRequestID = requestID
        slotVC.selectedHelperType = helperType
        slotVC.delegate = self
        self.navigationController?.present(slotVC, animated: true, completion: nil)
    }
    
    @objc func timeSlotFinalizeFor(_ requestID: Int, _ helperType: Int) {
        if(moveInfo?.is_reconfirm == 1) {
            let slots:String = slotVC.timeSlotArray[slotVC.selectedIndex!]
            self.helperUpdatePendingMoveStatusAPICall(confirm_status: "1", meeting_slot: slots, helper_reason: "")
        } else {
            self.callAcceptMoveAPI(requestID, helperType)
        }
    }
    
    @objc func dismissOnlyFromSlot(){
    }

    //MARK: - Service Type Logic
    func askServiceType(_ requestID:Int) {

        let serviceVC = self.storyboard?.instantiateViewController(withIdentifier: "ChooseServiceAlert") as! ChooseServiceAlert
        serviceVC.modalPresentationStyle = .overFullScreen
        serviceVC.requestID = requestID
        serviceVC.delegate = self
        serviceVC.otherHelperServiceType = moveInfo?.other_helper_service_type ?? 0
        serviceVC.totalProsAmount = moveInfo?.total_pros_amount ?? 0.0
        serviceVC.totalMuscleAmount = moveInfo?.total_muscle_amount ?? 0.0
        self.present(serviceVC, animated: true, completion: nil)
    }
    
    @objc func serviceTypeSelected(_ requestID: Int,_ isProSelect: Bool)
    {
        if(isProSelect == true) {
            if(profileInfo!.vehicleDetails!.insurance_expired == "1") && (profileInfo!.vehicleDetails!.is_insurance_request == "0") {
                InsuranceExpiryView.instance.shwoDataWithClosures(profileInfo!.vehicleDetails!.insurance_message_title!, profileInfo!.vehicleDetails!.insurance_message!, "", "", "Update Info"){ status in
                    if status{
                        print("Okay")
                        self.showInsuranceExpiredMessage(profileInfo!.vehicleDetails!.insurance_message!, profileInfo!.vehicleDetails!.insurance_message_title!)
                    }else{
                        print("NO/Cancel")
                    }
                }
            }else if(profileInfo!.vehicleDetails!.is_vehicle_insurance_request == "pending") && (profileInfo!.vehicleDetails!.is_insurance_request == "1"){
                InsuranceExpiryView.instance.shwoDataWithClosures(profileInfo!.vehicleDetails!.insurance_message_title!, profileInfo!.vehicleDetails!.insurance_message!, "", "", AlertButtonTitle.ok){ status in
                    if status{
                    }else{
                    }
                }
            }else if(profileInfo!.vehicleDetails!.is_vehicle_insurance_request == "reject") && (profileInfo!.vehicleDetails!.is_insurance_request == "1") {
                InsuranceExpiryView.instance.shwoDataWithClosures(profileInfo!.vehicleDetails!.insurance_message_title!, profileInfo!.vehicleDetails!.insurance_message!, "", "", "Re-update Info"){ status in
                    if status{
                        print("Okay")
                            self.showInsuranceExpiredMessage(profileInfo!.vehicleDetails!.insurance_message!, profileInfo!.vehicleDetails!.insurance_message_title!, false, true)
                    }else{
                        print("NO/Cancel")
                    }
                }
            }else{
//                if moveInfo?.is_estimate_hour != 1{
                    self.showArrivalTimeView(requestID, HelperType.Pro)
//                }
            }
        } else {
            self.callAcceptMoveAPI(requestID, HelperType.Muscle)
        }
    }
    
    @objc func dismissOnlyFromChooseService() {
        
    }
    
    //MARK: - Customer Edit Job
    @IBAction func rejectJobEditAction(_ sender: UIButton) {
        showPopUpList(indexOfMoveId: 0)
    }
    
    @IBAction func acceptJobEditAction(_ sender: UIButton) {

        let Iam = UserCache.shared.userInfo(forKey: kUserCache.service_type) as! Int
        let reqId = self.moveInfo?.request_id ?? 0

        if(Iam == HelperType.Pro) {
            self.showArrivalTimeEditView(reqId, HelperType.Pro)
        } else if(Iam == HelperType.Muscle) {
            self.showArrivalTimeEditView(reqId, HelperType.Muscle)
        } else if(Iam == HelperType.ProMuscle) {
            if self.moveInfo!.helping_service_required_pros! == 0 {
                self.showArrivalTimeEditView(reqId, HelperType.Muscle)
            } else if self.moveInfo!.helping_service_required_muscle! == 0 {
                self.showArrivalTimeEditView(reqId, HelperType.Pro)
            } else {
                if(moveInfo?.other_helper_service_type == HelperType.None) {
                    if(moveInfo?.helper_accept_service_type == HelperType.Pro) {
                        self.showArrivalTimeEditView(reqId, HelperType.Pro)
                    } else {
                        self.showArrivalTimeEditView(reqId, HelperType.Muscle)
                    }
                } else {
                    if(moveInfo?.other_helper_service_type == HelperType.Muscle) {
                        self.showArrivalTimeEditView(reqId, HelperType.Pro)
                    } else {
                        self.showArrivalTimeEditView(reqId, HelperType.Muscle)
                    }
                }
            }
        }

    }
    
    func helperUpdatePendingMoveStatusAPICall(confirm_status:String, meeting_slot:String, helper_reason:String) {
        
        StaticHelper.shared.startLoader(self.view)
        let param :[String:Any] = ["request_id": (moveInfo?.request_id)!,
                                   "confirm_status":confirm_status,
                                   "meeting_slot": meeting_slot,
                                   "helper_reason": helper_reason
                            ]
        CommonAPIHelper.helperUpdatePendingMoveStatusAPICall(VC: self, params: param, completetionBlock: { (result, error, isexecuted) in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                StaticHelper.shared.stopLoader()
                
                if error != nil {
                    
                    return
                } else {
                    self.moveInfo?.is_reconfirm = Int(confirm_status)
                    self.viewJobEdit.isHidden = true
                    
                    if(confirm_status == "0") {
                        appDelegate.homeVC?.redirectToMyMoveTab(section: 0)
                    } else {
                        isPendingScheduled = true
                        appDelegate.homeVC?.redirectToScheduledTab(section: 1)
                    }
                    return
                }
            }
        })
    }

}

extension MoveDetailsViewController: UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return addCells
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(section == TableSection.address) {//Address
            if(self.selectedMoveType?.is_dropoff_address == 0) {
                return 1
            }
            return 2
        } else if(section == TableSection.date) {//date
            //Scheduled time helper app me nahi show karna
            return 1
        } else if(section == TableSection.item) {//Item
            return moveItems.count
        } else if(section == TableSection.locaton) {//locaton
            if(self.selectedMoveType?.is_dropoff_address == 0) {
                return 1
            }
            return 2
        } else if(section == TableSection.photos) {//Photos
            return 2
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == TableSection.item) {
            return 30
        }
        else if(section == TableSection.date) {
            return 10
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let viewHeader = UIView()

        if(section == TableSection.item) {
            viewHeader.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40)
            viewHeader.backgroundColor = .clear

            let lblHeader = UILabel()
            lblHeader.frame = CGRect(x: 0, y: 6, width: viewHeader.frame.size.width, height: 24)
            lblHeader.text = "Move Items"
            lblHeader.backgroundColor = .clear
            lblHeader.textColor = .black
            lblHeader.textAlignment = .center
            lblHeader.font = UIFont.josefinSansRegularFontWithSize(size: 15.0)
            viewHeader.addSubview(lblHeader)

        }
        return viewHeader
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(indexPath.section == TableSection.address) {//Address
            return  UITableView.automaticDimension
        } else if(indexPath.section == TableSection.date) {//date
            return  UITableView.automaticDimension
        } else if(indexPath.section == TableSection.item) {//service & Item
            return 54.0 * screenHeightFactor
        } else if(indexPath.section == TableSection.locaton || indexPath.section == TableSection.photos) {//Item
            return 100.0 * screenHeightFactor
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case TableSection.address://Address
            let addressCell = tableView.dequeueReusableCell(withIdentifier: "AddressInfoTableViewCell", for: indexPath) as! AddressInfoTableViewCell
                        
            if(indexPath.row == 0) {
                
                addressCell.fromImageView.image = UIImage.init(named: "from_icon")
                if(self.selectedMoveType?.is_dropoff_address == 0) {
                    addressCell.fromLabel.text = "Pickup address"
                } else {
                    addressCell.fromLabel.text = "From"
                }
                
                
                //                if self.moveInfo!.pickup_apartment ?? "" == "" {
                //                    addressCell.fromAddressLabel.text = self.moveInfo!.pickup_address ?? ""
                //                } else {
                //                    addressCell.fromAddressLabel.text =  (self.moveInfo!.pickup_apartment ?? "") + " " +  (self.moveInfo!.pickup_address ?? "")
                //                }
                if (self.moveInfo!.pickup_apartment ?? "") != "" && (self.moveInfo!.pickup_gate_code ?? "") != ""{
                    var stringAddressType = ""
                    if self.moveInfo!.pickup_address_type == 1{
                        stringAddressType = LabelsString.label_unit_number
                    }else if self.moveInfo!.pickup_address_type == 2{
                        stringAddressType = LabelsString.label_apartment_number
                    }
                    var stringGetCode = LabelsString.label_gate_code
                    stringGetCode = stringGetCode + (self.moveInfo!.pickup_gate_code ?? "")
                    
                    stringAddressType = stringAddressType + (self.moveInfo!.pickup_apartment ?? "")
                    addressCell.fromAddressLabel.text =  (self.moveInfo!.pickup_address ?? "") +  "\n" + stringAddressType + "\n" + stringGetCode
                    
                }else if (self.moveInfo!.pickup_apartment ?? "") != ""{
                    var stringAddressType = ""
                    if self.moveInfo!.pickup_address_type == 1{
                        stringAddressType = LabelsString.label_unit_number
                    }else if self.moveInfo!.pickup_address_type == 2{
                        stringAddressType = LabelsString.label_apartment_number
                    }
                    stringAddressType = stringAddressType + (self.moveInfo!.pickup_apartment ?? "")
                    addressCell.fromAddressLabel.text = (self.moveInfo!.pickup_address ?? "") + "\n"  + stringAddressType
                }else if (self.moveInfo!.pickup_gate_code ?? "") != ""{
                    var stringGetCode = LabelsString.label_gate_code
                    stringGetCode = stringGetCode + (self.moveInfo!.pickup_gate_code ?? "")
                    addressCell.fromAddressLabel.text = (self.moveInfo!.pickup_address ?? "") + "\n"  + stringGetCode
                }else{
                    addressCell.fromAddressLabel.text = (self.moveInfo!.pickup_address ?? "")
                }
                addressCell.fromAddressLabel.numberOfLines = 0

            } else {
                addressCell.fromImageView.image = UIImage.init(named: "to_location_icon")
                addressCell.fromLabel.text = "To"
                
//                if self.moveInfo!.dropoff_apartment ?? "" == "" {
//                    addressCell.fromAddressLabel.text = self.moveInfo!.dropoff_address ?? ""
//                } else {
//                    addressCell.fromAddressLabel.text =  (self.moveInfo!.dropoff_apartment ?? "") + " " +  (self.moveInfo!.dropoff_address ?? "")
//                }
                
                if (self.moveInfo!.dropoff_apartment ?? "") != "" && (self.moveInfo!.dropoff_gate_code ?? "") != ""{
                    var stringAddressType = ""
                    if self.moveInfo!.dropoff_address_type == 1{
                        stringAddressType = LabelsString.label_unit_number
                    }else if self.moveInfo!.dropoff_address_type == 2{
                        stringAddressType = LabelsString.label_apartment_number
                    }
                    var stringGetCode = LabelsString.label_gate_code
                    stringGetCode = stringGetCode + (self.moveInfo!.dropoff_gate_code ?? "")
                    
                    stringAddressType = stringAddressType + (self.moveInfo!.dropoff_apartment ?? "")
                    addressCell.fromAddressLabel.text = (self.moveInfo!.dropoff_address ?? "") + "\n" + stringAddressType + "\n" + stringGetCode
                    
                }else if (self.moveInfo!.dropoff_apartment ?? "") != ""{
                    var stringAddressType = ""
                    if self.moveInfo!.dropoff_address_type == 1{
                        stringAddressType = LabelsString.label_unit_number
                    }else if self.moveInfo!.dropoff_address_type == 2{
                        stringAddressType = LabelsString.label_apartment_number
                    }
                    stringAddressType = stringAddressType + (self.moveInfo!.dropoff_apartment ?? "")
                    addressCell.fromAddressLabel.text = (self.moveInfo!.dropoff_address ?? "") + "\n" + stringAddressType
                    
                }else if (self.moveInfo!.dropoff_gate_code ?? "") != ""{
                    var stringGetCode = LabelsString.label_gate_code
                    stringGetCode = stringGetCode + (self.moveInfo!.dropoff_gate_code ?? "")
                    addressCell.fromAddressLabel.text = (self.moveInfo!.dropoff_address ?? "") + "\n" + stringGetCode
                }else{
                    addressCell.fromAddressLabel.text = (self.moveInfo!.dropoff_address ?? "")
                }
                addressCell.fromAddressLabel.numberOfLines = 0

            }
            
            return addressCell
        
        case TableSection.date://Date
            let dateInfoCell = tableView.dequeueReusableCell(withIdentifier: "DateInfoTableViewCell", for: indexPath) as! DateInfoTableViewCell
            //scheduled_unslct_icon
            dateInfoCell.imgViewIcon.image = UIImage.init(named: "scheduled_unslct_icon")

            if moveInfo != nil{
                    dateInfoCell.dateLabel.text = (moveInfo?.pickup_date)! + ", " + ((moveInfo?.pickup_start_time)!) + " - " + ((moveInfo?.pickup_end_time)!)
            }
            return dateInfoCell

        case TableSection.item://Items
            let moveInfoCell = tableView.dequeueReusableCell(withIdentifier: "MoveItemInfoTableViewCell", for: indexPath) as! MoveItemInfoTableViewCell
            
            moveInfoCell.itemDetailsLabel.isHidden = false
            let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key : Any]
            
            let underlineAttributedString = NSAttributedString(string: moveItems[indexPath.row].item_name!, attributes: underlineAttribute)
            
                    print(underlineAttributedString)
            moveInfoCell.itemNameLabel.attributedText = underlineAttributedString
            moveInfoCell.itemUnitLabel.text = String((moveItems[indexPath.row].quantity)!)
            return moveInfoCell

        case TableSection.locaton://Location Details

            let cell = tableView.dequeueReusableCell(withIdentifier: "AdditionalLocationTableViewCell", for: indexPath) as! AdditionalLocationTableViewCell
            
            if(indexPath.row == 0) {
                //cell.backgroundColor = .red
                cell.additionalPickupDetails.text = "Pickup Location Details"
                cell.staitLabel.text = "Need to use Stairs"
                cell.elevatorLabel.text = "Need to use Elevator"
                if moveInfo?.use_pickup_elevator == false {
                    cell.elevatorCountLabel.text = "No"
                } else {
                    cell.elevatorCountLabel.text = "Yes"
                }
            
                if moveInfo?.pickup_stairs == 0 {
                    cell.staitrsCoundLabel.text = "No"
                } else {
                    cell.staitrsCoundLabel.text = String(moveInfo!.pickup_stairs!) + " flight(s)"
                }
            } else {
                //cell.backgroundColor = .blue
                cell.additionalPickupDetails.text = "Dropoff Location Details"
                cell.staitLabel.text = "Need to use Stairs"
                cell.elevatorLabel.text = "Need to use Elevator"
                if moveInfo?.use_dropoff_elevator == false{
                    cell.elevatorCountLabel.text = "No"
                } else {
                    cell.elevatorCountLabel.text = "Yes"
                }
              
                if moveInfo?.drop_off_stairs == 0{
                    cell.staitrsCoundLabel.text = "No"
                } else {
                    cell.staitrsCoundLabel.text = String(moveInfo!.drop_off_stairs!) + " flight(s)"
                }
            }
            return cell

        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "basicStyle", for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if(section == TableSection.locaton) {
            return 50
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let viewFooter = UIView()
        viewFooter.backgroundColor = .clear
        return viewFooter
    }
       
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(indexPath.section == TableSection.item) {//Items
            let itemInfoVc = self.storyboard?.instantiateViewController(withIdentifier: "ItemDetailViewController") as! ItemDetailViewController
            itemInfoVc.selectedMoveType = self.selectedMoveType
            itemInfoVc.itemDetails = moveItems[indexPath.row]
            itemInfoVc.move_type_id = moveInfo?.move_type_id ?? 0
            self.navigationController?.pushViewController(itemInfoVc, animated: true)
        }
    }
}

extension MoveDetailsViewController: PopupReasonListVCDelegateT{
    func getIndxList(isSubmit: Bool, indexOfMoveId: Int, strReason: String) {
        reasonViewListView!.removeFromSuperview()
        reasonViewListView = nil
        if isSubmit{
            self.helperUpdatePendingMoveStatusAPICall(confirm_status: "0", meeting_slot: "", helper_reason: strReason)
        }
    }
    func showPopUpList(indexOfMoveId:Int){
        self.view.endEditing(true)
        if self.manualReasonObject.count > 0{
            showPopupAfterCallingAPI(index:indexOfMoveId)
        }else{
            callAPIGetReason(indexOfMoveId:indexOfMoveId)
        }
    }
    func showPopupAfterCallingAPI(index:Int){
        reasonViewListView = PopupReason(frame: appDelegate.window!.bounds)
        reasonViewListView!.delegate = self
        reasonViewListView!.indexOfMoveId = index
        reasonViewListView!.manualReasonObject = self.manualReasonObject
        appDelegate.window?.addSubview(reasonViewListView!)
    }
    func callAPIGetReason(indexOfMoveId:Int){
        CommonAPIHelper.getHelperConfirmationReason(VC: self) { (result, error, hasNextPage) in
            if error != nil {
                return
            } else {
                if result != nil{
                    self.manualReasonObject = (result?["menual_reason"] as? [String:Any])!
                    print("Array value of reason \(result!)")
                    self.showPopupAfterCallingAPI(index:indexOfMoveId)
                }
            }
        }
    }
}

extension MoveDetailsViewController{
    //Alert...
    func showAlertPopupView(_ popUpTitleMsg:String = "", _ message:String,  _ cancelButtonTitle:String = "",  _ okButtonTitle:String = "", _ centerOkButtonTitle:String = ""){
        self.view.endEditing(true)
        AlertPopupView.instance.shwoDataWithClosures(popUpTitleMsg, message, cancelButtonTitle, okButtonTitle, centerOkButtonTitle){ status in
            if status{
                print("Okay")
                if self.isConnectingToAnotherHelper{
                    appDelegate.homeVC?.redirectToScheduledTab(section: 1)
                }else{
                    self.acceptMove(self.acceptMoveId)
                }
            }else{
                print("NO/Cancel")
            }
        }
    }
}


