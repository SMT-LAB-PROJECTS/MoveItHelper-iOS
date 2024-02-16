//
//  ScheduledMoveViewController.swift
//  MoveIt
//
//  Created by Dushyant on 19/06/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class ScheduledMoveViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var placeholderImgView: UIImageView!
    @IBOutlet weak var noMessageLabel: UILabel!
    var moveType = MoveType.Scheduled
    @Published var countDic : [String: Any] = [:]

    var selectedMoveId = 0
    var isDeclineButtonClick = false
    var alertView :AlertPopupView?
    
    var arrScheduledMoveDict = [[String: Any]](){
        didSet{
            if arrScheduledMoveDict.count == 0{
                self.placeholderView.isHidden = false
            } else {
                 self.placeholderView.isHidden = true
            }
            self.tableView.reloadData()
        }
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                     #selector(getAllScheduledMoves),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = violetColor
        return refreshControl
    }()
    
    var pageIndex = 1
    var reasonViewListView :PopupReason?
    var manualReasonObject = [String:Any]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.addSubview(self.refreshControl)
        noMessageLabel.font = UIFont.josefinSansBoldFontWithSize(size: 17.0)
        noMessageLabel.text = "No Scheduled Moves Yet!"

        self.tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 45.0 * screenHeightFactor, right: 0)

        NotificationCenter.default.addObserver(self, selector: #selector(getAllScheduledMoves), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
        
    //MARK:- APIs
    @objc func getAllScheduledMoves(){
        
        if(SELECTED_TAB_INDEX != 1 || moveType != MoveType.Scheduled) {
            return
        } else if(appDelegate.homeVC?.scheduledViewController.selectedMenuIndex != 0) {
            return
        }

        callAnalyticsEvent(eventName: "moveit_check_scheduled", desc: ["description":"\(profileInfo?.helper_id ?? 0) cheked scheduled moves list"])
        CommonAPIHelper.getAllScheduledMoves(VC: self, page_index: pageIndex, completetionBlock: { (result, dicCount, error, isexecuted) in
            if error != nil{
                return
            } else{
                self.refreshControl.endRefreshing()
                self.arrScheduledMoveDict = result!
                self.countDic = dicCount ?? [:]
               // print(result)
            }
        })
    }
    func cancelMove(_ moveID: Int, _ helper_reason:String){
        callAnalyticsEvent(eventName: "moveit_cancel_move", desc: ["description":"\(profileInfo?.helper_id ?? 0) cancel the job"])
        CommonAPIHelper.cancelSavedMove(VC: self, request_id: moveID, helper_reason:helper_reason,completetionBlock: { (result, error, isexecuted) in
            if error != nil{
                return
            } else {
                self.getAllScheduledMoves()
            }
        })
    }
}

extension ScheduledMoveViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrScheduledMoveDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleMoveTableViewCell", for: indexPath) as! ScheduleMoveTableViewCell
        cell.setupInfo(arrScheduledMoveDict[indexPath.row])

        cell.cancelledButtton.addTarget(self, action: #selector(cancelPressed(_:)), for: .touchUpInside)
        cell.cancelledButtton.tag = indexPath.row
        cell.cancelledButtton.layer.cornerRadius = 17.0

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let ongoingVC = self.storyboard?.instantiateViewController(withIdentifier: "OnGoingServiceViewController") as! OnGoingServiceViewController
        ongoingVC.isFromPending = false
        let itemDict = (arrScheduledMoveDict[indexPath.row])
        ongoingVC.moveID = (itemDict["request_id"] as! Int)
        ongoingVC.moveType = MoveType.Scheduled
        self.navigationController?.pushViewController(ongoingVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return  UITableView.automaticDimension
    }
    func showDeclinePopUp(){
        
            self.isDeclineButtonClick = true
            self.showAlertPopupView(AlertButtonTitle.alert, kStringPermission.pleaseMakeSureYouArriveOnTime, "", "", AlertButtonTitle.ok)

//        let alertcontroller = UIAlertController.init(title: "", message: "Please make sure you arrive to your job on time. Failure to show up or be late to job may suspend your Move It account." , preferredStyle: .alert)
//      
//        let yeButton = UIAlertAction.init(title: "Ok", style: .default) { (_) in
//        }
//        alertcontroller.addAction(yeButton)
//        self.present(alertcontroller, animated: true, completion: nil)
    }
    @objc func cancelPressed(_ selector: UIButton){
        let itemDict = (arrScheduledMoveDict[selector.tag] )
        let strStartDateTime = (itemDict["pickup_date"] as! String) + " " + (itemDict["pickup_start_time"] as! String)
        print(strStartDateTime)
        var cancelationFeeText =  String(UserCache.shared.userInfo(forKey: kUserCache.cancalationFeeText)  as? String ?? "There will be 10% cancellation fee for cancelling the job before 2 hours of start time")

        if calculateTimeWith10PerFee(strStartDateTime){
            
            cancelationFeeText = kStringPermission.are_you_sure_you_want_to_cancel_move + "\n" + cancelationFeeText
            
            self.selectedMoveId = selector.tag
            self.showAlertPopupView(AlertButtonTitle.alert, cancelationFeeText, AlertButtonTitle.decline, AlertButtonTitle.accept, "")

//            let alertcontroller = UIAlertController.init(title: "Are you sure you want to cancel move?", message: cancelationFeeText , preferredStyle: .alert)
//            let cancelButton = UIAlertAction.init(title: "Decline", style: .default) { (_) in
//                self.showDeclinePopUp()
//            }
//            let yeButton = UIAlertAction.init(title: "Accept", style: .default) { (_) in
//                self.showPopUpList(indexOfMoveId: selector.tag)
//            }
//            alertcontroller.addAction(yeButton)
//            alertcontroller.addAction(cancelButton)
//            self.present(alertcontroller, animated: true, completion: nil)
        }else{
            self.selectedMoveId = selector.tag
            self.showAlertPopupView(AlertButtonTitle.alert, kStringPermission.are_you_sure_you_want_to_cancel_move, AlertButtonTitle.no, AlertButtonTitle.yes, "")

            
//            let alertcontroller = UIAlertController.init(title: "", message: "Are you sure you want to cancel move?" , preferredStyle: .alert)
//            let cancelButton = UIAlertAction.init(title: "No", style: .cancel) { (_) in
//            }
//            let yeButton = UIAlertAction.init(title: "Yes", style: .default) { (_) in
//                self.showPopUpList(indexOfMoveId: selector.tag)
//            }
//            alertcontroller.addAction(cancelButton)
//            alertcontroller.addAction(yeButton)
//            self.present(alertcontroller, animated: true, completion: nil)
        }
    }
    
    func getCurrentDateStr()->String{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MMMM dd yyyy hh:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        let dateString = formatter.string(from: Date())
        print("current :- \(dateString)")
        return dateString
    }
    func calculateTimeWith10PerFee(_ serverTime:String = "")->Bool{
        let strDate = serverTime

        let dateString = getCurrentDateStr()
        let cancelationFeeHour =  String(UserCache.shared.userInfo(forKey: kUserCache.cancalationFeeHour)  as? String ?? "2")

        let dateCurrent = "\(dateString)".toDate()
        let dateServer = strDate.toDate1()
        let dateEarly = dateServer.getEarlyTime(hour: Int(cancelationFeeHour)!)
        
        print("Current date := \(String(describing: dateCurrent))")
        print("Server date := \(String(describing: dateServer))")
        print("Early server date := \(String(describing: dateEarly))")
//&& (dateCurrent < dateServer)
        if (dateEarly <= dateCurrent){//... 10% fee and 2 hour ago...
            return true
        }else{ // Normal..
            return false
        }
        
    }
}

extension ScheduledMoveViewController: PopupReasonListVCDelegateT{
    func getIndxList(isSubmit: Bool, indexOfMoveId: Int, strReason: String) {
        reasonViewListView!.removeFromSuperview()
        reasonViewListView = nil
        if isSubmit{
            self.callScheduleCancelService(index:indexOfMoveId, strReason: strReason)
        }
    }
    
    func callScheduleCancelService(index:Int, strReason:String){
        let itemDict = (arrScheduledMoveDict[index] )
        self.cancelMove((itemDict["request_id"] as! Int), strReason)
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


extension ScheduledMoveViewController{
    //Alert...
    func showAlertPopupView(_ popUpTitleMsg:String = "", _ message:String,  _ cancelButtonTitle:String = "",  _ okButtonTitle:String = "", _ centerOkButtonTitle:String = ""){
        self.view.endEditing(true)
        AlertPopupView.instance.shwoDataWithClosures(popUpTitleMsg, message, cancelButtonTitle, okButtonTitle, centerOkButtonTitle){ status in
            if status{
                print("Okay")
                    if !self.isDeclineButtonClick{
                        self.showPopUpList(indexOfMoveId: self.selectedMoveId)
                    }else{
                        self.isDeclineButtonClick = false
                    }
            }else{
                print("NO/Cancel")
                //
                if !self.isDeclineButtonClick{
                    self.showDeclinePopUp()
                }
            }
        }
    }
}


