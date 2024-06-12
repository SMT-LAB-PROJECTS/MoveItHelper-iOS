//
//  AllMovesChildViewController.swift
//  Move It Customer
//
//  Created by Dushyant on 02/05/19.
//  Copyright © 2019 Agicent Technologies. All rights reserved.
//

import UIKit

class AllMovesChildViewController: UIViewController, MoveArrivalTimeDelegate, ChooseServiceAlertDelegate {
    
    var moveInfo : MoveDetailsModel?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var placeholderImgView: UIImageView!
    @IBOutlet weak var noMovesLabel: UILabel!
    
    var moveDictArray = [[String: Any]]() {
        didSet {
                self.tableView.reloadData()
        }
    }
    @Published var countDic : [String: Any] = [:]

    var moveDictArrayModel : [MoveDetailsModel]?

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                     #selector(reloadWhenrequired),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = violetColor
        return refreshControl
    }()
    
    var pageIndex = 1
    var moveType = MoveType.None
    var isVisible:Bool = true
    
    var acceptMoveId = 0
    var isConnectingToAnotherHelper = false
    var alertView :AlertPopupView?

    //MARK: - Methods Start
    override func viewDidLoad() {
        super.viewDidLoad()

        noMovesLabel.font = UIFont.josefinSansBoldFontWithSize(size: 17.0)
        self.tableView.addSubview(self.refreshControl)
        
        self.reloadWhenrequired()
        
        if moveType == MoveType.Available {
            NotificationCenter.default.addObserver(self, selector: #selector(getAllAvailableMovesNotifie), name: UIApplication.didBecomeActiveNotification, object: nil)
        } else if moveType == MoveType.Complete {
            NotificationCenter.default.addObserver(self, selector: #selector(getAllCompletedMoves), name: UIApplication.didBecomeActiveNotification, object: nil)
        } else if moveType == MoveType.Canceled {
            NotificationCenter.default.addObserver(self, selector: #selector(getAllCancelledMoves), name: UIApplication.didBecomeActiveNotification, object: nil)
        } else {
            
        }
        if UIDevice.current.hasNotch {
            self.tableView.contentInset = UIEdgeInsets.init(top: 20, left: 0, bottom: 45.0 * screenHeightFactor, right: 0)
        } else{
            self.tableView.contentInset = UIEdgeInsets.init(top: 15, left: 0, bottom: 45.0 * screenHeightFactor, right: 0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isVisible = true
    }
    
    func presentMissingImageUpload(dic: [String: Any]) {
        let profileImage = dic["is_profile_img"] as? Bool ?? false
        let signatureImage = dic["is_signature_img"] as? Bool ?? false
        let vehicleImage = dic["is_vehicle_img"] as? Bool ?? false
//        if signatureImage {
//            StaticHelper.moveToViewController("PdfViewerViewController", animated: false)
//        }else {
            if profileImage || signatureImage || vehicleImage {
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "UploadMissingImagesVC") as? UploadMissingImagesVC {
                    let title = dic["title_for_img"] as? String ?? ""
                    let url = dic["signature_web_view_url"] as? String ?? ""
                    
                    vc.modalPresentationStyle = .overFullScreen
                    vc.profile = profileImage
                    vc.signature = signatureImage
                    vc.vehicle = vehicleImage
                    vc.titleText = title
                    
                    vc.onCompletionProfile = {
                        let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                        self.navigationController?.pushViewController(profileVC, animated: false)
                        profileVC.rightTextPressed(UIButton())
                    }
                    
                    vc.onCompletionVehicle = {
                        callAnalyticsEvent(eventName: "moveit_vehicle_type", desc: ["description":"\(profileInfo?.helper_id ?? 0) checked vehicle info"])
                        let vehicleVC = self.storyboard?.instantiateViewController(withIdentifier: "VehicleInfoViewController") as! VehicleInfoViewController
                        self.navigationController?.pushViewController(vehicleVC, animated: true)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            vehicleVC.rightTextPressed(UIButton())
                        }
                    }
                    
                    vc.onCompletionSignature = {
                        StaticHelper.moveToViewController("PdfViewerViewController", animated: false)
                    }
                    self.present(vc, animated: true)
                }
//            }
        }
    }
    
    @objc func reloadWhenrequired(){
        
        if moveType == MoveType.Available {
            self.getAllAvailableMoves()
        } else if moveType == MoveType.Complete {
            self.getAllCompletedMoves()
        } else if moveType == MoveType.Canceled {
            self.getAllCancelledMoves()
        }
    }
    @objc func getAllAvailableMovesNotifie(){
        getAllAvailableMoves()
    }
    //MARK: - APIs
    func getAllAvailableMoves() {
       self.placeholderView.isHidden = false

    //We put this check to stop unnessassory calling this API if this screen is not visible
    //SELECTED_MOVE_UPER_TAB_INDEX = 0
        if(SELECTED_TAB_INDEX != 0 || moveType != MoveType.Available){
            return
        } else if(appDelegate.homeVC?.myMovesViewController.selectedMenuIndex != 0) {
            return
        }
     
    callAnalyticsEvent(eventName: "moveit_check_available", desc: ["description":"\(profileInfo?.helper_id ?? 0) fetch available move list"])
       CommonAPIHelper.getAllAvailableMoves(VC: self, page_index: pageIndex, completetionBlock: { (result, countDic, error, isexecuted, res) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                if error != nil{
                    return
                }else{
                    self.moveDictArray = result!
                    self.countDic = countDic ?? [:]
                    self.refreshControl.endRefreshing()
                    if self.moveDictArray.count == 0{
                      self.placeholderView.isHidden = false
                      IS_AVAILABLE_MOVE_CONTAIN_DATA = 0
                    }else{
                        IS_AVAILABLE_MOVE_CONTAIN_DATA = 1
                        self.placeholderView.isHidden = true
                    }
                    appDelegate.homeVC?.showChangeRequestServicePopup(self.moveDictArray.count)
                    self.tableView.reloadData()
                    if let data = res {
                        self.presentMissingImageUpload(dic: data)
                    }
                }
            }
        })
    }
    
    @objc func getAllCompletedMoves() {
//        SELECTED_MOVE_UPER_TAB_INDEX = 1
        self.placeholderView.isHidden = false

        //We put this check to stop unnessassory calling this API if this screen is not visible
        if(SELECTED_TAB_INDEX != 0 || moveType != MoveType.Complete) {
            return
        } else if(appDelegate.homeVC?.myMovesViewController.selectedMenuIndex != 1) {
            return
        }
        callAnalyticsEvent(eventName: "moveit_check_complete_move", desc: ["description":"\(profileInfo?.helper_id ?? 0) check list (fetch list ) of completed moves"])
        CommonAPIHelper.getAllCompletedMoves(VC: self, page_index: pageIndex, completetionBlock: { (result, error, isexecuted) in
            if error != nil{
                return
            } else{
                self.refreshControl.endRefreshing()
                self.moveDictArray = result!
                if self.moveDictArray.count == 0{
                    self.placeholderView.isHidden = false
                }
                else{
                    self.placeholderView.isHidden = true
                }
            }
        })
    }
    
   @objc func getAllCancelledMoves() {
//       SELECTED_MOVE_UPER_TAB_INDEX = 2
       self.placeholderView.isHidden = false

       //We put this check to stop unnessassory calling this API if this screen is not visible
       if(SELECTED_TAB_INDEX != 0 || moveType != MoveType.Canceled) {
           return
       } else if(appDelegate.homeVC?.myMovesViewController.selectedMenuIndex != 2) {
           return
       }
       callAnalyticsEvent(eventName: "moveit_check_canceled", desc: ["description":"\(profileInfo?.helper_id ?? 0) check list (fetch list ) of canceled moves"])
        CommonAPIHelper.getAllCancelledMoves(VC: self, page_index: pageIndex, completetionBlock: { (result, error, isexecuted) in
            if error != nil{
                return
            } else {
                self.refreshControl.endRefreshing()
                self.moveDictArray = result!
                if self.moveDictArray.count == 0{
                    self.placeholderView.isHidden = false
                }
                else{
                    self.placeholderView.isHidden = true
                }
            }
        })
    }
    
    func callAcceptMoveAPI(_ requestID:Int, _ helperType: Int)
    {
        CommonAPIHelper.acceptMoves(VC: self, request_id: requestID, helperType: helperType, completetionBlock: { (result, error, statusCode) in
            if error != nil{
                return
            } else{
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
    //MARK: - Accept Logic
    @objc func cancelPressed(_ selector: UIButton){
        
    }
    
    @objc func acceptPressed(_ selector: UIButton){
        let itemDict = moveDictArray[selector.tag]
        moveInfo = MoveDetailsModel.init(moveDictFromList: itemDict)
        if checkCombineJobStatus((moveInfo?.request_id)!){
        }else{
          showPopupInsurance((moveInfo?.request_id)!)
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
           print(moveInfo?.is_estimate_hour)
           if moveInfo!.is_estimate_hour == 1{
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
    func acceptMove(_ requestID: Int ){

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
      
    func showArrivalTimeView(_ requestID:Int, _ helperType:Int)
    {
        isVisible = false
        let slotVC = self.storyboard?.instantiateViewController(withIdentifier: "MoveArrivalTimeViewController") as! MoveArrivalTimeViewController
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
        isVisible = true
        self.callAcceptMoveAPI(requestID, helperType)                
    }
    
    @objc func dismissOnlyFromSlot(){
        isVisible = true
    }

    //MARK: - Service Type Logic
    func askServiceType(_ requestID:Int) {
        isVisible = false

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
        isVisible = true
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
                self.showArrivalTimeView(requestID, HelperType.Pro)
            }
        } else {
            self.callAcceptMoveAPI(requestID, HelperType.Muscle)
        }
    }
    
    @objc func dismissOnlyFromChooseService(){
        isVisible = true
    }
}

extension AllMovesChildViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return moveDictArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movecell = tableView.dequeueReusableCell(withIdentifier: "MoveTableViewCell", for: indexPath) as! MoveTableViewCell
        
        if moveType == MoveType.Available {
            movecell.setupInfoAvailableCancel(moveDictArray[indexPath.row], isCompleted: false, isCanceled: false)
                    let urlString = moveDictArray[indexPath.row]["photo_url"] as! String
                    let uRL = URL.init(string: urlString)
                    movecell.userImgView.image = UIImage.init(named: "User_placeholder")
                    if uRL != nil{
                        movecell.userImgView.af.setImage(withURL: uRL!)
                    }
            
            movecell.acceptButton.addTarget(self, action: #selector(acceptPressed(_:)), for: .touchUpInside)
            movecell.cancelledButtton.addTarget(self, action: #selector(cancelPressed(_:)), for: .touchUpInside)
            movecell.acceptButton.tag = indexPath.row
            movecell.cancelledButtton.tag = indexPath.row
        } else if moveType == MoveType.Complete {
            movecell.setupInfoCompleted(moveDictArray[indexPath.row], isCompleted: true, isCanceled: false)
            movecell.acceptButton.isHidden = true
            movecell.cancelledButtton.isHidden = true
        } else if moveType == MoveType.Canceled {
            movecell.setupInfoAvailableCancel(moveDictArray[indexPath.row], isCompleted: false, isCanceled: true)
            movecell.acceptButton.isHidden = true
            movecell.cancelledButtton.isHidden = true
        }
        
        return movecell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        //return 260.0 * screenHeightFactor
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if moveType == MoveType.Available {
            let moveDict = moveDictArray[indexPath.row]
            
            let moveDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "MoveDetailsViewController") as! MoveDetailsViewController
            moveDetailsVC.moveDict = moveDict
            moveDetailsVC.moveID = (moveDict["request_id"] as! Int)
            moveDetailsVC.moveType = MoveType.Available
            isVisible = false
            self.navigationController?.pushViewController(moveDetailsVC, animated: true)
        } else if moveType == MoveType.Complete {
            let ongoingVC = self.storyboard?.instantiateViewController(withIdentifier: "OnGoingServiceViewController") as! OnGoingServiceViewController
            let itemDict = (moveDictArray[indexPath.row])
            ongoingVC.moveID = (itemDict["request_id"] as! Int)
            ongoingVC.moveType = MoveType.Complete
            self.navigationController?.pushViewController(ongoingVC, animated: true)
        } else if moveType == MoveType.Canceled {
            
            let moveDict = moveDictArray[indexPath.row]
            
            let moveDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "MoveDetailsViewController") as! MoveDetailsViewController
            moveDetailsVC.moveDict = moveDict
            moveDetailsVC.isHideAcceptButton = true
            moveDetailsVC.moveID = (moveDict["request_id"] as! Int)
            moveDetailsVC.moveType = MoveType.Canceled
            self.navigationController?.pushViewController(moveDetailsVC, animated: true)
        }
    }
}
extension AllMovesChildViewController{
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


