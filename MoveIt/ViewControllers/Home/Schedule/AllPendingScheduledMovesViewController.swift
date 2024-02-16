

//
//  AllPendingScheduledMovesViewController.swift
//  MoveIt
//
//  Created by Dushyant on 28/12/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class AllPendingScheduledMovesViewController: UIViewController {
        
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var placeholderImgView: UIImageView!
    @IBOutlet weak var noMessageLabel: UILabel!

    var scheduledMoveDict = [[String: Any]](){
        didSet{
            if scheduledMoveDict.count == 0 {
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
                     #selector(getAllPendingScheduledMoves),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = violetColor
        return refreshControl
    }()
        
    var pageIndex = 1
    var moveType = MoveType.Pending
    var reasonViewListView :PopupReason?
    var manualReasonObject = [String:Any]()
    
    var selectedMoveId = 0
    var isDeclineButtonClick = false
    var alertView :AlertPopupView?


    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.addSubview(self.refreshControl)
        noMessageLabel.font = UIFont.josefinSansBoldFontWithSize(size: 17.0)
        noMessageLabel.text = "No Pending Moves Yet!"
            
        self.tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 45.0 * screenHeightFactor, right: 0)

        NotificationCenter.default.addObserver(self, selector: #selector(getAllPendingScheduledMoves), name: UIApplication.didBecomeActiveNotification, object: nil)
        self.checkIfMoveEditeedByCustomer()
    }
   
    func getDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: "2015-04-01T11:42:00") // replace Date String
    }
    
    func showEditJobPopUp(moveDict: [String: Any], infoMove:MoveDetailsModel) {
        let viewUpdateBG = UIView()
        viewUpdateBG.frame = appDelegate.window!.bounds
        viewUpdateBG.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        
        var width:CGFloat = 320
        let space:CGFloat = 20
        
        if(appDelegate.window!.bounds.size.width < 500) {
            width = appDelegate.window!.bounds.size.width-40.0
        }
        
        let viewUpdate = UIView()
        viewUpdate.layer.cornerRadius = 10.0
        viewUpdate.clipsToBounds = true
        viewUpdate.frame = CGRect(x: (appDelegate.window!.bounds.size.width-width)/2.0, y: (appDelegate.window!.bounds.size.height-280)/2.0, width: width, height: 280)
        viewUpdate.backgroundColor = .white
        viewUpdateBG.addSubview(viewUpdate)
        

        let lblTitle = UILabel()
        lblTitle.frame = CGRect(x: 20, y: 20, width: width-space-space, height: 50)
        lblTitle.text = ""
        lblTitle.textAlignment = .center
        lblTitle.font = UIFont.josefinSansBoldFontWithSize(size: 20.0)
        viewUpdate.addSubview(lblTitle)
        
        let lblDesc = UILabel()
        lblDesc.frame = CGRect(x: 20, y: 70, width: width-space-space, height: 90)
        lblDesc.numberOfLines = 0
        lblDesc.textColor = .darkGray
        lblDesc.textAlignment = .center
        lblDesc.font = UIFont.josefinSansRegularFontWithSize(size: 15.0)
        lblDesc.text = "This job has been edited by the customer. Please review the changes and accept it again."
        viewUpdate.addSubview(lblDesc)

        let btnUpdate = UIButton()
        btnUpdate.setBackgroundImage(UIImage.init(named: "btn_gradient"), for: .normal)
        btnUpdate.frame = CGRect(x:20, y: 200, width: width-space-space, height: 60)
        btnUpdate.setTitle("View Detail", for: .normal)
        btnUpdate.titleLabel?.font = UIFont.josefinSansRegularFontWithSize(size: 17.0)
        btnUpdate.setTitleColor(.black, for: .normal)
//        btnUpdate.addTarget(self, action: #selector(self.btnUpdateClicked), for: .touchDown)
//        btnUpdate.addTarget(viewUpdateBG, action: #selector(viewUpdateBG.removeFromSuperview), for: .touchDown)
        viewUpdate.addSubview(btnUpdate)
        
        let wh:CGFloat = 30
        let btnSkip = UIButton()
        
        btnSkip.frame = CGRect(x:(viewUpdate.frame.origin.x+viewUpdate.frame.size.width)-(wh/2.0), y: viewUpdate.frame.origin.y-(wh/2.0), width: wh, height: wh)
        btnSkip.backgroundColor = .clear
        btnSkip.setImage(UIImage.init(named: "ic_close"), for: .normal)
        btnSkip.titleLabel?.font = UIFont.josefinSansRegularFontWithSize(size: 17.0)
        btnSkip.setTitleColor(.black, for: .normal)
        btnSkip.addTarget(viewUpdateBG, action: #selector(viewUpdateBG.removeFromSuperview), for: .touchDown)
        viewUpdateBG.addSubview(btnSkip)

        appDelegate.window?.addSubview(viewUpdateBG)
        
        
        btnUpdate.actionHandler(controlEvents: .touchUpInside, ForAction: {
            
            viewUpdateBG.removeFromSuperview()
            
            let moveDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "MoveDetailsViewController") as! MoveDetailsViewController
            moveDetailsVC.isFromOngoing = true
            moveDetailsVC.isHideAcceptButton = true
            moveDetailsVC.moveDict = moveDict
            moveDetailsVC.moveInfo = infoMove
            moveDetailsVC.moveID = infoMove.request_id!
            moveDetailsVC.moveType = MoveType.Pending
            self.navigationController?.pushViewController(moveDetailsVC, animated: true)
        })
        
//        btnUpdate.actionHandle(controlEvents: .touchUpInside,
//        ForAction:{() -> Void in
//            print("Touch")
//            viewUpdateBG.removeFromSuperview()
//            
//            let moveDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "MoveDetailsViewController") as! MoveDetailsViewController
//            moveDetailsVC.isFromOngoing = true
//            moveDetailsVC.isHideAcceptButton = true
//            moveDetailsVC.moveDict = moveDict
//            moveDetailsVC.moveInfo = infoMove
//            moveDetailsVC.moveID = infoMove.request_id
//            moveDetailsVC.moveType = MoveType.Pending
//            self.navigationController?.pushViewController(moveDetailsVC, animated: true)
//
//            
//        })

    }

       
    //MARK: - APIs
    
    @objc func checkIfMoveEditeedByCustomer() {
        
        CommonAPIHelper.getAllPendingScheduledMoves(VC: self, page_index: 1, completetionBlock: { (result, error, isexecuted) in
            
            DispatchQueue.main.async {
                if error != nil {
                    return
                } else {
                    self.scheduledMoveDict = result!
                    for moveDict in self.scheduledMoveDict {
                        let objMoveInfo:MoveDetailsModel? = MoveDetailsModel.init(moveDictFromList: moveDict)
                        if(objMoveInfo?.is_reconfirm == 1) {
                            self.showEditJobPopUp(moveDict: moveDict, infoMove: objMoveInfo!)
                            break;
                        }
                    }
                }
            }
        })
    }

    @objc func getAllPendingScheduledMoves() {
        
        if(SELECTED_TAB_INDEX != 1 || moveType != MoveType.Pending) {
            return
        } else if(appDelegate.homeVC?.scheduledViewController.selectedMenuIndex != 1) {
            return
        }

        CommonAPIHelper.getAllPendingScheduledMoves(VC: self, page_index: pageIndex, completetionBlock: { (result, error, isexecuted) in
            
            if error != nil {
                return
            } else {
                self.refreshControl.endRefreshing()
                self.scheduledMoveDict = result!
            }
        })
    }
    func cancelMove(_ moveID: Int, _ helper_reason:String){
        
        CommonAPIHelper.cancelSavedMove(VC: self, request_id: moveID, helper_reason:helper_reason, completetionBlock: { (result, error, isexecuted) in
            
            if error != nil{
                return
            } else {
                self.getAllPendingScheduledMoves()
            }
        })
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
        // && (dateCurrent < dateServer)
        if (dateEarly <= dateCurrent){
            //... 10% fee and 2 hour ago...
            return true
        }else{
            //
            return false
        }
        
    }
}


extension AllPendingScheduledMovesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduledMoveDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let scheduleMove = tableView.dequeueReusableCell(withIdentifier: "ScheduleMoveTableViewCell", for: indexPath) as! ScheduleMoveTableViewCell
        scheduleMove.setupInfo(scheduledMoveDict[indexPath.row])

        scheduleMove.cancelledButtton.addTarget(self, action: #selector(cancelPressed(_:)), for: .touchUpInside)
        scheduleMove.cancelledButtton.tag = indexPath.row
        scheduleMove.cancelledButtton.layer.cornerRadius = 17.0
        return scheduleMove
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        let ongoingVC = self.storyboard?.instantiateViewController(withIdentifier: "OnGoingServiceViewController") as! OnGoingServiceViewController
        ongoingVC.isFromPending = true
        let itemDict = (scheduledMoveDict[indexPath.row])
        ongoingVC.moveID = (itemDict["request_id"] as! Int)
        ongoingVC.moveType = MoveType.Pending
        self.navigationController?.pushViewController(ongoingVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension

//        return 210 * screenHeightFactor
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
        let itemDict = (scheduledMoveDict[selector.tag])
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
//
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
}
extension UIButton {
    private func actionHandler(action:(() -> Void)? = nil) {
        struct __ { static var action :(() -> Void)? }
        if action != nil { __.action = action }
        else { __.action?() }
    }
    @objc private func triggerActionHandler() {
        self.actionHandler()
    }
    func actionHandler(controlEvents control :UIControl.Event, ForAction action:@escaping () -> Void) {
        self.actionHandler(action: action)
        self.addTarget(self, action: #selector(triggerActionHandler), for: control)
    }
}


extension String {
    func toDate(withFormat format: String = "MMM dd yyyy hh:mm a")-> Date{
        let dateFormatter = DateFormatter()
        //dateFormatter.timeZone = TimeZone(identifier: "Asia/Kolkata")
        dateFormatter.dateFormat = format
//        dateFormatter.locale = NSLocale.current
        dateFormatter.locale = Locale(identifier: "en")

        let date = dateFormatter.date(from: self)
        return date!
    }
    func toDate1(withFormat format: String = "MMM dd yyyy hh:mm a")-> Date{
        let dateFormatter1 = DateFormatter()
        //dateFormatter.timeZone = TimeZone(identifier: "Asia/Kolkata")
        dateFormatter1.dateFormat = format
        dateFormatter1.locale = Locale(identifier: "en")
//        dateFormatter1.locale = NSLocale.current
        let date = dateFormatter1.date(from: self)
        return date!
    }
}

extension Date {
    func getEarlyTime(withFormat format: String = "MMM dd yyyy hh:mm a", hour:Int)->Date{
        let formatter = DateFormatter()
        formatter.dateFormat = format // "a" prints "pm" or "am"
        //formatter.timeZone = TimeZone(identifier: "Asia/Kolkata")
        let earlyDate = formatter.calendar.date(byAdding: .hour, value: -hour, to: self)
        return earlyDate!
    }

    
    func toString(withFormat format: String = "MMM dd yyyy hh:mm a") -> String {

        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en")
//        dateFormatter.timeZone = TimeZone(identifier: "Asia/Kolkata")
//        dateFormatter.calendar = Calendar(identifier: .persian)
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)
        return str
    }
}
extension Date {
    public var removeTimeStamp : Date? {
       guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
        return nil
       }
       return date
   }
}

extension AllPendingScheduledMovesViewController: PopupReasonListVCDelegateT{
    func getIndxList(isSubmit: Bool, indexOfMoveId: Int, strReason: String) {
        reasonViewListView!.removeFromSuperview()
        reasonViewListView = nil
        if isSubmit{
            self.callScheduleCancelService(index:indexOfMoveId, strReason: strReason)
        }
    }
    
    func callScheduleCancelService(index:Int, strReason:String){
        let itemDict = (scheduledMoveDict[index] )
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

extension AllPendingScheduledMovesViewController{
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
                if !self.isDeclineButtonClick{
                    self.showDeclinePopUp()
                }
            }
        }
    }
}


