//
//  OnGoingServiceViewController.swift
//  MoveIt
//
//  Created by Dushyant on 22/06/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit
import  AlamofireImage
import  CoreLocation

class OnGoingServiceViewController: UIViewController, CLLocationManagerDelegate, ShowRatingPopupDelegate, UploadPhotosViewControllerDelegate, MoveArrivalTimeDelegate {
  
    var moveInfo : MoveDetailsModel?
    var moveDict = [String: Any]()
    var moveType = MoveType.None
    var alertPermmisionView :AlertViewPermmision?
    var alertView :AlertPopupView?

    @IBOutlet weak var viewEdit: UIView!
    @IBOutlet weak var lblEdit: UILabel!
    
    //Customer Edit
    @IBOutlet weak var viewJobEdit: UIView!
    @IBOutlet weak var lblJobEdit: UILabel!
    @IBOutlet weak var btnDetailsJobEdit: UIButton!

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    
    @IBOutlet weak var gradientImgView: UIImageView!
    @IBOutlet weak var moveInfoLabel: UILabel!
    @IBOutlet weak var moveInfoButton: UIButton!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var directionButton: UIButton!
    @IBOutlet weak var pickUpPhotosLabel: UILabel!
    @IBOutlet weak var pickupPhotosButton: UIButton!
    @IBOutlet weak var dropOffPhotoLabel: UILabel!
    @IBOutlet weak var dropOffPhotoButton: UIButton!
    
    @IBOutlet weak var acceptServiceView: UIView!
    @IBOutlet weak var onWayView: UIView!
    @IBOutlet weak var startServiceView: UIView!
    @IBOutlet weak var completedView: UIView!
    
    @IBOutlet weak var acceptServiceLabel: UILabel!
    @IBOutlet weak var ontheWayLabel: UILabel!
    @IBOutlet weak var startServiceLabel: UILabel!
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var bottomButtonBkimgView: UIImageView!
    
    var moveID = 0
    
    @IBOutlet weak var layerView: UIView!
    @IBOutlet weak var acceptServiceImgView: UIImageView!
    @IBOutlet weak var getDirectionImgView: UIImageView!
    @IBOutlet weak var startServiceImgView: UIImageView!
    @IBOutlet weak var endServiceImgView: UIImageView!
    
    @IBOutlet weak var helperScheduleLabel: UILabel!
    @IBOutlet weak var helperScheduleImageView: UIImageView!
    
    @IBOutlet var helperView: UIView!
    @IBOutlet weak var helperBkView: UIView!
    @IBOutlet weak var helperImageView: UIImageView!
    @IBOutlet weak var helperNamelabel: UILabel!
    @IBOutlet weak var callHelperButton: UIButton!
    @IBOutlet weak var messageHelperButton: UIButton!
    @IBOutlet weak var helperNameBottomConst: NSLayoutConstraint!
    
    var isFromPending = false
    var otherHelperInfo = [[String: Any]]()
    
    @IBOutlet weak var moreHelperButton: UIButton!

    var currentLocation: CLLocation?
    
    var alert =  UIAlertController()
    
    let locManager = CLLocationManager()
    var isBottomClick = false
    
    var isVisible:Bool = true
    var isAPICalling:Bool = false
        
    var viewRatting:AppRattingViewView!
    
    var slotVC:MoveArrivalTimeViewController!
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.isHidden = true
        self.viewJobEdit.isHidden = true
        self.navigationBarConfiguration()
        self.notificationCenterConfiguration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        isVisible = true
        self.getMoveDetails()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let layersAr =  layerView.layer.sublayers
        for l in layersAr!{
            if l is CAShapeLayer{
                l.removeFromSuperlayer()
            }
        }
        self.drawLines()
    }
    
    //MARK: -
    
    func navigationBarConfiguration() {
        setNavigationTitle("Move Details")        
        self.navigationItem.leftBarButtonItem = StaticHelper.leftBarButton(withImageNamed: "backward_arrow_icon", forVC: self)
    }
    func showPopupWhenDropupAdrIsZeero(){
        if (self.moveInfo?.is_dropoff_address == 0 && self.moveInfo?.helper_status == 3){
            let strHelperStartServisPoupText =  String(UserCache.shared.userInfo(forKey: kUserCache.helperStartServisPoupText)  as? String ?? "")
            StaticHelper.showAlertViewWithTitle(AlertButtonTitle.alert, message: strHelperStartServisPoupText, buttonTitles: ["OK"], viewController: self, completion: nil)
//            return
        }
    }
    func notificationCenterConfiguration() {
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(getMoveDetails), name: NSNotification.Name(rawValue: "HELPER_REMINDER"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getMoveDetails), name: NSNotification.Name(rawValue: "OngoingService"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(getMoveDetails), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        if isFromPending{
            NotificationCenter.default.addObserver(self, selector: #selector(getAllotedHelperInfoAPICall), name: UIApplication.didBecomeActiveNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(getAllotedHelperInfoAPICall), name: NSNotification.Name(rawValue: "ReloadPendingHelper"), object: nil)
        }
    }
    
    func uiConfigurationAfterStoryboard() {
        
        self.viewEdit.layer.masksToBounds = false
        self.viewEdit.layer.shadowColor = UIColor.lightGray.cgColor
        self.viewEdit.layer.shadowOpacity = 1.0
        self.viewEdit.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.viewEdit.layer.shadowRadius = 1
        
        if ((moveInfo?.helping_service_required_pros ?? 0) + (moveInfo?.helping_service_required_muscle ?? 0)) >= 2 {
            self.moreHelperButton.isHidden = false
        } else {
            self.moreHelperButton.isHidden = true
        }
        //job_edited
        if(moveInfo?.helper_edited == 1) {
            self.viewEdit.isHidden = false
            self.lblEdit.isHidden = false
            self.viewJobEdit.isHidden = true
        } else if(moveInfo?.is_reconfirm == 1) {
            self.viewEdit.isHidden = true
            self.lblEdit.isHidden = true
        
            self.viewJobEdit.layer.cornerRadius = 5.0
            self.viewJobEdit.layer.borderWidth = 0.3
            self.viewJobEdit.layer.borderColor = UIColor.gray.cgColor
//            self.viewJobEdit.dropShadow()
            self.viewJobEdit.isHidden = false
            
            lblJobEdit.text = "This job has been edited by the customer"
            lblJobEdit.textColor = .black
            lblJobEdit.font = UIFont.josefinSansRegularFontWithSize(size: 14.0)
            
            btnDetailsJobEdit.setTitle("", for: .normal)
            btnDetailsJobEdit.backgroundColor = darkPinkColor
            btnDetailsJobEdit.layer.cornerRadius = 15.0
            btnDetailsJobEdit.titleLabel?.font = UIFont.josefinSansBoldFontWithSize(size: 14.0)
            
            
        } else {
            self.viewEdit.isHidden = true
            self.lblEdit.isHidden = true
            self.viewJobEdit.isHidden = true
        }

        acceptServiceView.clipsToBounds = true
        onWayView.clipsToBounds = true
        startServiceView.clipsToBounds = true
        completedView.clipsToBounds = true
        
        userImgView.layer.cornerRadius = userImgView.frame.size.width/2.0
        let w = acceptServiceView.frame.size.width/2.0
        
        acceptServiceView.layer.cornerRadius = w
        onWayView.layer.cornerRadius = w
        startServiceView.layer.cornerRadius = w
        completedView.layer.cornerRadius = w
    }
    
    func setupData(){
        
        self.tableView.isHidden = false
        if moveInfo!.meeting_slot!.isEmpty {
            helperScheduleLabel.isHidden = true
            helperScheduleImageView.isHidden = true
        } else {
            helperScheduleLabel.text = moveInfo!.meeting_slot!
        }
        
        let urlString = moveInfo?.customer_photo_url
        if urlString != nil {
            userImgView.af.setImage(withURL: urlString!)
        } else {
            userImgView.image = UIImage(named: "User_placeholder")
        }
        
        if !isFromPending {
            if (moveInfo!.helping_service_required_pros! + moveInfo!.helping_service_required_muscle!) >= 2 {
                self.getAllotedHelperInfoAPICall2()
            }
        }
        
        userNameLabel.text = moveInfo?.customer_name
        addressLabel.text = (moveInfo?.pickup_address)!// + (moveInfo?.pickup_address)!
        
        let miles:Double = moveInfo?.total_miles_distance ?? 0.0
        milesLabel.text = String.init(format: "%0.2f", miles) + " Miles"
        //milesLabel.text = String((moveInfo?.total_miles_distance)!) + " Miles"
        self.showPopupWhenDropupAdrIsZeero()

    }
    
    func setupLoadingInfo() {
        
        self.moreHelperButton.isHidden = true
        
        if isFromPending {
            if((StaticHelper.mainWindow().rootViewController?.topMostViewController().isKind(of: OnGoingServiceViewController.self)) == true) {
                self.showAlertPopupView(AlertButtonTitle.alert, kStringPermission.connectingToAnotherHelper, "", "", AlertButtonTitle.ok)

//                alert = UIAlertController.init(title: "", message: "We are connecting another helper to accept this move. We'll notify you once this job is confirmed.", preferredStyle: .alert)
//                alert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
//                self.present(alert, animated: true, completion: {
//                    self.btnDetailsJobEdit.titleLabel?.font = UIFont.josefinSansBoldFontWithSize(size: 14.0)
//                })
            }

            self.bottomButton.isHidden = true
            self.bottomButtonBkimgView.isHidden = true
        } else{
            if(moveInfo?.is_reconfirm == 1) {
                self.bottomButton.isHidden = true
                self.bottomButtonBkimgView.isHidden = true
            } else {
                self.bottomButton.isHidden = false
                self.bottomButtonBkimgView.isHidden = false
            }
        }
        
        self.helperBkView.layer.cornerRadius = 15.0 * screenHeightFactor
        helperScheduleLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 17.0)
        
        self.setupUI()
        self.drawLines()
    }
    
    func setupUI(){
        
        headerView.frame.size.height = 504 * screenHeightFactor
        
        userImgView.layer.cornerRadius = 37.5 * screenWidthFactor
        userNameLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        addressLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        milesLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        
        acceptServiceLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 9.0)
        ontheWayLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 9.0)
        startServiceLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 9.0)
        completedLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 9.0)
        
        
        moveInfoLabel.adjustsFontSizeToFitWidth = true
        moveInfoLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 9.0)
        directionLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 9.0)
        pickUpPhotosLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 9.0)
        dropOffPhotoLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 9.0)
        
        bottomButton.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        
        acceptServiceView.layer.cornerRadius = 7.5 * screenWidthFactor
        onWayView.layer.cornerRadius = 7.5 * screenWidthFactor
        startServiceView.layer.cornerRadius = 7.5 * screenWidthFactor
        completedView.layer.cornerRadius = 7.5 * screenWidthFactor
    }
    
    func drawLines() {
        
        let midHeight = onWayView.frame.origin.y +  (onWayView.frame.size.height / 2)
        callButton.isHidden = false
        messageButton.isHidden = false
        callHelperButton.isHidden = false
        messageHelperButton.isHidden = false
        helperNameBottomConst.constant = 82
        if moveInfo?.helper_status == 1{
            
            acceptServiceView.backgroundColor = darkPinkColor
            onWayView.backgroundColor = dullColor
            startServiceView.backgroundColor = dullColor
            completedView.backgroundColor = dullColor
            acceptServiceImgView.image = UIImage.init(named: "info_icon_slct")
            StaticHelper.drawDashesLine(p0: CGPoint.init(x: (acceptServiceView.frame.origin.x + acceptServiceView.frame.size.width), y: midHeight), p1: CGPoint.init(x: onWayView.frame.origin.x, y: midHeight), view: layerView, color: dullColor)
            StaticHelper.drawDashesLine(p0: CGPoint.init(x: (onWayView.frame.origin.x + onWayView.frame.size.width), y: midHeight), p1: CGPoint.init(x: startServiceView.frame.origin.x, y: midHeight), view: layerView, color: dullColor)
            
            StaticHelper.drawDashesLine(p0: CGPoint.init(x: (startServiceView.frame.origin.x + startServiceView.frame.size.width), y: midHeight), p1: CGPoint.init(x: completedView.frame.origin.x, y: midHeight), view: layerView, color: dullColor)
            bottomButton.setTitle("On The Way", for: .normal)
            directionButton.isEnabled = false
            pickupPhotosButton.isEnabled = false
            dropOffPhotoButton.isEnabled = false
        }
        else if moveInfo?.helper_status == 2{
            
            acceptServiceView.backgroundColor = darkPinkColor
            onWayView.backgroundColor = darkPinkColor
            startServiceView.backgroundColor = dullColor
            completedView.backgroundColor = dullColor
            acceptServiceImgView.image = UIImage.init(named: "info_icon_slct")
            getDirectionImgView.image = UIImage.init(named: "direction_icon_slct")
            startServiceImgView.image = UIImage.init(named: "pickup_icon_slct")
            StaticHelper.drawDashesLine(p0: CGPoint.init(x: (acceptServiceView.frame.origin.x + acceptServiceView.frame.size.width), y: midHeight), p1: CGPoint.init(x: onWayView.frame.origin.x, y: midHeight), view: layerView, color: darkPinkColor)
            StaticHelper.drawDashesLine(p0: CGPoint.init(x: (onWayView.frame.origin.x + onWayView.frame.size.width), y: midHeight), p1: CGPoint.init(x: startServiceView.frame.origin.x, y: midHeight), view: layerView, color: dullColor)
            
            StaticHelper.drawDashesLine(p0: CGPoint.init(x: (startServiceView.frame.origin.x + startServiceView.frame.size.width), y: midHeight), p1: CGPoint.init(x: completedView.frame.origin.x, y: midHeight), view: layerView, color: dullColor)
            bottomButton.setTitle("Start Service", for: .normal)
            directionButton.isEnabled = true
            pickupPhotosButton.isEnabled = true
            dropOffPhotoButton.isEnabled = false
        }
        else if moveInfo?.helper_status == 3{
            
            acceptServiceView.backgroundColor = darkPinkColor
            onWayView.backgroundColor = darkPinkColor
            startServiceView.backgroundColor = darkPinkColor
            completedView.backgroundColor = dullColor
            acceptServiceImgView.image = UIImage.init(named: "info_icon_slct")
            getDirectionImgView.image = UIImage.init(named: "direction_icon_slct")
            startServiceImgView.image = UIImage.init(named: "pickup_icon_slct")
            endServiceImgView.image = UIImage.init(named: "dropoff_icon_slct")
            StaticHelper.drawDashesLine(p0: CGPoint.init(x: (acceptServiceView.frame.origin.x + acceptServiceView.frame.size.width), y: midHeight), p1: CGPoint.init(x: onWayView.frame.origin.x, y: midHeight), view: layerView, color: darkPinkColor)
            StaticHelper.drawDashesLine(p0: CGPoint.init(x: (onWayView.frame.origin.x + onWayView.frame.size.width), y: midHeight), p1: CGPoint.init(x: startServiceView.frame.origin.x, y: midHeight), view: layerView, color: darkPinkColor)
            
            StaticHelper.drawDashesLine(p0: CGPoint.init(x: (startServiceView.frame.origin.x + startServiceView.frame.size.width), y: midHeight), p1: CGPoint.init(x: completedView.frame.origin.x, y: midHeight), view: layerView, color: dullColor)
            bottomButton.setTitle("End Service", for: .normal)
            directionButton.isEnabled = true
            pickupPhotosButton.isEnabled = true
            dropOffPhotoButton.isEnabled = true
        }
        else if moveInfo?.helper_status == 4{
            
            acceptServiceView.backgroundColor = darkPinkColor
            onWayView.backgroundColor = darkPinkColor
            startServiceView.backgroundColor = darkPinkColor
            completedView.backgroundColor = darkPinkColor
            acceptServiceImgView.image = UIImage.init(named: "info_icon_slct")
            getDirectionImgView.image = UIImage.init(named: "direction_icon_slct")
            startServiceImgView.image = UIImage.init(named: "pickup_icon_slct")
            endServiceImgView.image = UIImage.init(named: "dropoff_icon_slct")
            StaticHelper.drawDashesLine(p0: CGPoint.init(x: (acceptServiceView.frame.origin.x + acceptServiceView.frame.size.width), y: midHeight), p1: CGPoint.init(x: onWayView.frame.origin.x, y: midHeight), view: layerView, color: darkPinkColor)
            StaticHelper.drawDashesLine(p0: CGPoint.init(x: (onWayView.frame.origin.x + onWayView.frame.size.width), y: midHeight), p1: CGPoint.init(x: startServiceView.frame.origin.x, y: midHeight), view: layerView, color: darkPinkColor)
            
            StaticHelper.drawDashesLine(p0: CGPoint.init(x: (startServiceView.frame.origin.x + startServiceView.frame.size.width), y: midHeight), p1: CGPoint.init(x: completedView.frame.origin.x, y: midHeight), view: layerView, color: darkPinkColor)
            bottomButton.isHidden = true
            directionButton.isEnabled = false
            gradientImgView.isHidden = true
            callButton.isHidden = true
            messageButton.isHidden = true
            callHelperButton.isHidden = true
            messageHelperButton.isHidden = true
            helperNameBottomConst.constant = 25
        }
    }
    
    //MARK: - Actions
    @objc func leftPressed(_ selector: Any){
        if(self.isAPICalling == false) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func callButtonAction(_ sender: UIButton) {
        hidehelperView()
        let num = (self.otherHelperInfo[0]["phone_num"] as! String).replacingOccurrences(of: " ", with: "")
        if(num.isEmpty) {
            self.view.makeToast("call detail not available.")
            return
        }
        self.dialNumber(number: num)
    }
    
    @IBAction func messageButtonAction(_ sender: UIButton) {
        hidehelperView()
        
        if (self.otherHelperInfo[0]["helper_id"] as? Int) == nil {
            return
        }
        if (self.otherHelperInfo[0]["helper_id"] as? Int) == nil {
                    return
                }
        
        let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        chatVC.customerName = ((self.otherHelperInfo[0]["first_name"] as? String) ?? "") + " " + ((self.otherHelperInfo[0]["last_name"] as? String) ?? "")
        chatVC.customerImgUrl = (self.otherHelperInfo[0]["photo_url"] as? String) ?? ""
        chatVC.isHelperChat = true
        chatVC.customer_ID = self.otherHelperInfo[0]["helper_id"] as! Int
        chatVC.Tohelper_ID = self.otherHelperInfo[0]["helper_id"] as! Int
        print(self.otherHelperInfo)
        if let reqId = self.otherHelperInfo[0]["request_id"] as? Int {
            chatVC.requestId =  reqId.description
        }
        if let reqId = self.otherHelperInfo[0]["request_id"] as? String {
            chatVC.requestId =  reqId
        }
        
        isVisible = false
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    @objc func rightButtonPressed(_ selector: UIButton){

        let urlString = self.otherHelperInfo[0]["photo_url"] as! String
        
        self.helperImageView.layer.cornerRadius = 40.0
        
        if let url = URL.init(string: urlString){
            self.helperImageView.af.setImage(withURL: url, placeholderImage: UIImage.init(named: "User_placeholder"), filter: nil, progress: nil, progressQueue: .main, imageTransition: .noTransition, runImageTransitionIfCached: .init()) { (_) in
            }
        }
        var type = ""
        if (self.otherHelperInfo[0]["service_type"] as! Int) == 2{
            type = "Muscle"
        } else if (self.otherHelperInfo[0]["service_type"] as! Int) == 1{
            type = "Pro"
        } else{
            type = "Pro & Muscle"
        }
        self.helperNamelabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 15.0)
        
        self.helperNamelabel.text = (self.otherHelperInfo[0]["first_name"] as! String) + " " + (self.otherHelperInfo[0]["last_name"] as! String) + "\n" + type
        self.helperView.frame = UIScreen.main.bounds
        
        let tapgesture = UITapGestureRecognizer.init(target: self, action: #selector(hidehelperView))
        self.helperView.addGestureRecognizer(tapgesture)
        self.navigationController?.view.addSubview(self.helperView)
        
    }
    
    @IBAction func moveInfoAction(_ sender: Any) {
         
        let moveDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "MoveDetailsViewController") as! MoveDetailsViewController
        moveDetailsVC.isFromOngoing = true
        moveDetailsVC.isHideAcceptButton = true
        moveDetailsVC.moveDict = self.moveDict
        moveDetailsVC.moveInfo = moveInfo
        moveDetailsVC.moveID = self.moveID
        moveDetailsVC.moveType = self.moveType
        self.navigationController?.pushViewController(moveDetailsVC, animated: true)
    }
    
    @IBAction func moreHelperAction(_ sender: UIButton) {
        self.rightButtonPressed(sender)
    }
    
    @IBAction func directionAction(_ sender: Any) {
        if moveInfo == nil || moveInfo?.helper_status == nil {
            return
        }
        
        let helperStatus = moveInfo!.helper_status!
        var pickUpLat = 0.0
        var pickUpLong = 0.0
        var dropOffLat = 0.0
        var dropOffLong = 0.0
        
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() ==  .authorizedAlways){
            currentLocation = locManager.location
            pickUpLat = currentLocation?.coordinate.latitude ?? 0.0
            pickUpLong = currentLocation?.coordinate.longitude ?? 0.0
        }
        if helperStatus == 2{
             dropOffLat = moveInfo!.pickup_lat!
             dropOffLong = moveInfo!.pickup_long!
        }
        else{
             dropOffLat = moveInfo!.dropoff_lat!
             dropOffLong = moveInfo!.dropoff_long!
        }
        
        let strLat1 = pickUpLat == 0.0 ? "" : "\(pickUpLat)"
        let strLong2 = pickUpLong == 0.0 ? "" : "\(pickUpLong)"
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) { UIApplication.shared.openURL(URL(string:"comgooglemaps://?saddr=\(dropOffLat),\(dropOffLong)&daddr=\(strLat1),\(strLong2)&directionsmode=driving&zoom=14&views=traffic")!)
        } else{
            let directionVC = self.storyboard?.instantiateViewController(withIdentifier: "GPSDirectionViewController") as! GPSDirectionViewController
            directionVC.modalPresentationStyle = .overFullScreen
            directionVC.modalTransitionStyle = .crossDissolve
            directionVC.moveInfo = moveInfo
            self.present(directionVC, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func pickUpPhotoAction(_ sender: Any) {
        if (moveInfo?.request_id != nil) {
            let uploadPhotoVC = self.storyboard?.instantiateViewController(withIdentifier: "UploadPhotosViewController") as! UploadPhotosViewController
            uploadPhotoVC.folder_name = "move_pickup_photo"
            uploadPhotoVC.delegate = self
            uploadPhotoVC.moveInfo = self.moveInfo
            uploadPhotoVC.isFromDropoff = false
            uploadPhotoVC.modalPresentationStyle = .overFullScreen
            uploadPhotoVC.modalTransitionStyle = .crossDissolve
            uploadPhotoVC.moveID = (moveInfo?.request_id)!
            self.present(uploadPhotoVC, animated: true, completion: nil)
        }
    }
    
    func pickUpPhotosUploaded(_ urlPhotos: [URL]) {
        self.moveInfo?.pickup_photo_url = urlPhotos
    }
    
    @IBAction func droOffPhotoAction(_ sender: Any) {
        if (moveInfo?.request_id != nil) {
            let uploadPhotoVC = self.storyboard?.instantiateViewController(withIdentifier: "UploadPhotosViewController") as! UploadPhotosViewController
            uploadPhotoVC.folder_name = "move_dropoff_photo"
            uploadPhotoVC.delegate = self
            uploadPhotoVC.moveInfo = self.moveInfo
            uploadPhotoVC.isFromDropoff = true
            uploadPhotoVC.modalPresentationStyle = .overFullScreen
            uploadPhotoVC.modalTransitionStyle = .crossDissolve
            uploadPhotoVC.moveID = (moveInfo?.request_id)!
            self.present(uploadPhotoVC, animated: true, completion: nil)
        }
    }
    
    func dropOffPhotosUploaded(_ urlPhotos: [URL]) {
        self.moveInfo?.dropoff_photo_url = urlPhotos
    }
    
    @IBAction func callAction(_ sender: Any) {
        callAnalyticsEvent(eventName: "moveit_call_customer", desc: ["description":"\(profileInfo?.helper_id ?? 0) call to customer related to Job"])
        if let call = moveInfo?.customer_phone {
            let num = (call).replacingOccurrences(of: " ", with: "")
            if(num.isEmpty) {
                self.view.makeToast("call detail not available.")
                return
            }
            self.dialNumber(number: num)
        } else{
            self.view.makeToast("call detail not available.")
        }
    }
    
    func dialNumber(number : String) {
        if let url = URL(string: "tel://\(number)"),
           UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else{
            // add error message here
        }
    }
    
    @IBAction func messageAction(_ sender: Any) {
        if moveInfo!.request_id != nil {
            if (moveInfo?.customer_id) == nil {
                return
            }
            if (moveInfo?.chat_id) == nil {
                return
            }
            callAnalyticsEvent(eventName: "moveit_message_customer", desc: ["description":"Request Id -  \(moveInfo!.request_id ?? 0)"])
            
            let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            chatVC.customer_ID = (moveInfo?.customer_id)!
            chatVC.customerName = moveInfo?.customer_name ?? ""
            chatVC.helper_ID = (UserCache.shared.userInfo(forKey: kUserCache.helper_id) as? Int) ?? 0
            chatVC.chat_ID = (moveInfo?.chat_id)!
            chatVC.phoneNum = (moveInfo?.customer_phone ?? "")
            
            if let reqId = moveInfo?.request_id as? Int {
                chatVC.requestId =  reqId.description
            }
            
            isVisible = false
            self.navigationController?.pushViewController(chatVC, animated: true)
        }
    }
    
    @IBAction func bottomButtomAction(_ sender: Any) {
                
        if (isBottomClick) {
            return
        }
        
        if (isBottomClick == false) {
            isBottomClick = true
        }
        
        if ((moveInfo?.helper_status) != nil) {
            if ((moveInfo?.helper_status)! + 1) == 2 {
                callAnalyticsEvent(eventName: "moveit_on_the_way", desc: ["description":"Request Id -  \(moveInfo!.request_id!)"])
                self.updateMoveStatusAPICall()
            } else if ((moveInfo?.helper_status)! + 1) == 3 {
                self.getCurrentPickUpLatandLong()
            } else if ((moveInfo?.helper_status)! + 1) == 4 {
                self.getCurrentDropoffLatandLong()
            } else {
                self.updateMoveStatusAPICall()
            }
        } else {
            self.isBottomClick = false
        }
    }
    
    @IBAction func btnDetailsJobEditAction(_ sender: UIButton) {
        let moveDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "MoveDetailsViewController") as! MoveDetailsViewController
        moveDetailsVC.isFromOngoing = true
        moveDetailsVC.isHideAcceptButton = true
        moveDetailsVC.moveDict = self.moveDict
        moveDetailsVC.moveInfo = moveInfo
        moveDetailsVC.moveID = self.moveID
        moveDetailsVC.moveType = self.moveType
        self.navigationController?.pushViewController(moveDetailsVC, animated: true)
    }
    
    func showArrivalTimeView(_ requestID:Int, _ helperType:Int)
    {
        slotVC = (self.storyboard?.instantiateViewController(withIdentifier: "MoveArrivalTimeViewController") as! MoveArrivalTimeViewController)
        slotVC.isForJobEdit = true
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
        let slots:String = slotVC.timeSlotArray[slotVC.selectedIndex!]
        self.helperUpdatePendingMoveStatusAPICall(confirm_status: "1", meeting_slot: slots)
    }
    
    @objc func dismissOnlyFromSlot(){
        isVisible = true
    }

    @objc func hidehelperView(){
        self.helperView.removeFromSuperview()
    }
    
    //MARK: -
    func getCurrentPickUpLatandLong(){
        checkLocationPermissions()
        locManager.requestAlwaysAuthorization()
        locManager.delegate = self
        locManager.startUpdatingLocation()
        print(Date())
        
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() ==  .authorizedAlways){
            
            currentLocation = locManager.location
            currentLocation = appDelegate.currentLocation
            let startLocation = CLLocation.init(latitude: moveInfo!.pickup_lat!, longitude: moveInfo!.pickup_long!)

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                let distanceInMeters = self.currentLocation?.distance(from: startLocation) // result is in meters
                
                if distanceInMeters ?? 1000 <= 500{
                    callAnalyticsEvent(eventName: "moveit_start_service", desc: ["description":"Request Id -  \(self.moveInfo!.request_id!)"])
                    callAnalyticsEvent(eventName: "verify_location", desc: ["description":"Request Id - \(self.moveInfo!.request_id!), Type - pickup Location \(self.moveInfo!.pickup_lat!) \(self.moveInfo!.pickup_long!), Helper Location \(self.currentLocation?.coordinate.latitude ?? 0) \(self.currentLocation?.coordinate.longitude ?? 0) difference: \(distanceInMeters ?? 0) Meters"])
                    self.updateMoveStatusAPICall()
                }
                else{
                    self.view.makeToast("You can start the move only at customer pickup address.")
                    self.isBottomClick = false
                }
            }
        } else{
            self.isBottomClick = false
        }
    }
    
    
    func getCurrentDropoffLatandLong(){
        checkLocationPermissions()
        
        locManager.requestAlwaysAuthorization()
        locManager.delegate = self
        locManager.startUpdatingLocation()
        
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() ==  .authorizedAlways){
            
            currentLocation = locManager.location
            
            let startLocation = CLLocation.init(latitude: moveInfo!.dropoff_lat!, longitude: moveInfo!.dropoff_long!)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                let distanceInMeters = self.currentLocation?.distance(from: startLocation) ?? 0.0 // result is in meters
                print(distanceInMeters)
                
                if distanceInMeters <= 500{
                    callAnalyticsEvent(eventName: "moveit_end_service", desc: ["description":"\(profileInfo?.helper_id ?? 0) end the service"])
                    callAnalyticsEvent(eventName: "verify_location", desc: ["description":"Request Id - \(self.moveInfo!.request_id!), Type - dropoff Location \(self.moveInfo!.pickup_lat!) \(self.moveInfo!.pickup_long!), Helper Location \(self.currentLocation?.coordinate.latitude ?? 0) \(self.currentLocation?.coordinate.longitude ?? 0) difference: \(distanceInMeters) Meters"])
                    LocationUpdateGlobal.shared.stopUpdatingLocation()
                    self.updateMoveStatusAPICall()
                } else{
                    self.view.makeToast("You can complete the move only at customer dropoff address.")
                    self.isBottomClick = false
                }
            }
        } else{
            self.isBottomClick = false
        }
    }
//MARK: - delegate
    func showRatingMethod() {
                 
        self.gotoRatePopUpVC()
    }
    
    func gotoRatePopUpVC() {
        //self.getCustomerRatingsStatus()
        DispatchQueue.main.async {
            let ratingVc = self.storyboard?.instantiateViewController(withIdentifier: "RatePopUpViewController") as! RatePopUpViewController
            ratingVc.moveInfo = self.moveInfo
            ratingVc.modalPresentationStyle = .overFullScreen
            self.present(ratingVc, animated: true, completion: nil)
        }
    }
    
    func compareDate(){
        updateMoveStatusAPICall()
    }
    
    func checkLocationPermissions(){
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case  .restricted, .denied:
                showPermmisonAlert(AlertButtonTitle.alert,kStringPermission.locationTitle, kStringPermission.locationMessage)
                return
            case .notDetermined:
                
                locManager.requestAlwaysAuthorization()
            case .authorizedAlways, .authorizedWhenInUse:
                break
            @unknown default:
                break
            }
        } else {
            print("Location services are not enabled")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location
            print(Date())
            locManager.stopUpdatingLocation()
        }
    }
    
    //MARK: - APIs
    @objc func getMoveDetails() {
        if(isAPICalling == true) {
            return
        }
        isAPICalling = true
        
        CommonAPIHelper.getMoveDetailByID(VC: self, move_id: moveID, completetionBlock: { (result, error, isexecuted) in
            StaticHelper.shared.stopLoader()
            if error != nil {
                self.isAPICalling = false
                return
            } else {
                if let result = result {
                    self.moveInfo = MoveDetailsModel.init(moveDict: result)
                    self.moveDict = result
                    print("self.moveDict = ", self.moveDict)
                    if self.isFromPending {
                        self.getAllotedHelperInfoAPICall()
                    } else if self.moveInfo?.helper_status == 4 {
                        self.getCustomerRatingsStatus()
                    }
                    
                    DispatchQueue.main.async {
                        self.isAPICalling = false
                        self.uiConfigurationAfterStoryboard()
                        self.setupData()
                        self.checkLocationPermissions()
                        let estimateHourMessage = self.moveInfo?.estimate_hour_mgs ?? ""
                        if (self.moveInfo?.estimate_hour ?? 0) > 0 && estimateHourMessage.isEmpty == false {
                            self.showAlertPopupView(AlertButtonTitle.alert, self.moveInfo?.estimate_hour_mgs ?? "", "", "", AlertButtonTitle.ok)
                        }
                        if let message = self.moveInfo?.msg_for_labor_move, message.isEmpty == false {
                            self.showAlertPopupView(AlertButtonTitle.alert, message, "", "", AlertButtonTitle.ok)
                        }
                    }
                } else {
                    self.isAPICalling = false
                }
            }
        })
    }
    func currentAddress(_ coordinate:CLLocationCoordinate2D) -> String
    {
        let loc = LocationManager()
        var addr = ""
        
        loc.getPlace(for: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { [] (placemark) in
            if let name = placemark?.name {
                addr = name
            }
            if let subLocality = placemark?.subLocality {
                if addr == "" {
                    addr = subLocality
                } else{
                    addr = addr + ", " + subLocality
                }
            }
            if let locality = placemark?.locality {
                if addr == "" {
                    addr = locality
                } else{
                    addr = addr + ", " + locality
                }
            }
            if let administrativeArea = placemark?.administrativeArea {
                if addr == "" {
                    addr = administrativeArea
                } else{
                    addr = addr + ", " + administrativeArea
                }
            }
            if let subAdministrativeArea = placemark?.subAdministrativeArea {
                if addr == "" {
                    addr = subAdministrativeArea
                } else{
                    addr = addr + ", " + subAdministrativeArea
                }
            }
            if let postalCode = placemark?.postalCode {
                if addr == "" {
                    addr = postalCode
                } else{
                    addr = addr + ", " + postalCode
                }
            }
            print("addr : ", addr)
        }
        return "\(addr)"
    }
    func updateMoveStatusAPICall(){
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        print((moveInfo?.helper_status)! )
        if ((moveInfo?.helper_status)! + 1) == 3, moveInfo?.pickup_photo_url.count == 0 {
            
            StaticHelper.showAlertViewWithTitle("", message: "Please upload items photos from pickup location", buttonTitles: ["OK"], viewController: self, completion: nil)
            self.isBottomClick = false
            return
        }
        if ((moveInfo?.helper_status)! + 1) == 4, moveInfo?.dropoff_photo_url.count == 0{
            StaticHelper.showAlertViewWithTitle("", message: "Please upload items photos from Dropoff location", buttonTitles: ["OK"], viewController: self, completion: nil)
            self.isBottomClick = false
            return
        }
        
        StaticHelper.shared.startLoader(self.headerView)
        
        //let statusID = ((moveInfo?.helper_status)! == 0) ? 1 : ((moveInfo?.helper_status)! == 1) ? 2 : ((moveInfo?.helper_status)! == 2) ? 3 : ((moveInfo?.helper_status)! == 3) ? 4 : 4
        let statusID = (moveInfo?.helper_status)! + 1
        if statusID > 6 {
            return
        }
        let param = [
                     "request_id":(moveInfo?.request_id)!,
                     "helper_status": statusID,
                     "timezone": TimeZone.current.identifier,
                     "helper_lat": currentLocation?.coordinate.latitude ?? 0.0,
                     "helper_long": currentLocation?.coordinate.longitude ?? 0.0,
                     "helper_address": "" //currentAddress(currentLocation!.coordinate)
                    ] as [String: Any]
        
        CommonAPIHelper.updateMoveStatus(VC: self, dict: param, completetionBlock: { (result, error, isexecuted) in
            if error != nil {
                self.isBottomClick = false
                return
            }
            else{
                self.isBottomClick = false
                if(isexecuted == false) {
                    return
                }
                if ((self.moveInfo?.helper_status)! + 1) == 4 {
                        appDelegate.locationUpdateStop = true
                        appDelegate.locationUpdateStart = false
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SuccessMoveCompleteViewController") as! SuccessMoveCompleteViewController
                        vc.modalPresentationStyle = .overFullScreen
                        vc.showRatingPopupDelegate = self
                        UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
                }
                let serviceType = UserCache.shared.userInfo(forKey: kUserCache.service_type) as? Int ?? 1
                if (serviceType == 2 || serviceType == 3) {
                    if ((self.moveInfo?.helper_status)! + 1) == 3 {
                      
                        appDelegate.moveInfoRequestID = self.moveInfo?.request_id ?? 0
                        appDelegate.locationUpdateStart = true
                        appDelegate.locationUpdateStop = false
                        appDelegate.locationSetup()
                    }
                }
                
                self.moveInfo?.helper_status = ((self.moveInfo?.helper_status)! + 1)
                self.drawLines()
                self.view.layoutIfNeeded()
                self.view.layoutSubviews()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    
                    self.setupData()
                    self.drawLines()
                    self.view.layoutIfNeeded()
                    self.view.layoutSubviews()
                    
                    if self.moveInfo?.helper_status == 2 {
                        LocationUpdateGlobal.shared.startUpdateingLocation(self.moveInfo!.request_id!)
                    }
                    StaticHelper.shared.stopLoader()
                }
                if (self.moveInfo?.is_dropoff_address == 0 && self.moveInfo?.helper_status == 3){
                    let strHelperStartServisPoupText =  String(UserCache.shared.userInfo(forKey: kUserCache.helperStartServisPoupText)  as? String ?? "")
                    StaticHelper.showAlertViewWithTitle("", message: strHelperStartServisPoupText, buttonTitles: ["OK"], viewController: self, completion: nil)
                    return
                }
            }
        })
    }
    
    @objc func getAllotedHelperInfoAPICall() {
        
        if moveInfo != nil {
            if ((moveInfo!.helping_service_required_pros ?? 0) + (moveInfo!.helping_service_required_muscle ?? 0)) >= 2{
                CommonAPIHelper.getAllotedHelperInfo(VC: self, move_id: moveInfo!.request_id!) { (res, err, isExe) in
                    if isExe{
                        DispatchQueue.main.async {
                            self.otherHelperInfo = res!
                            if self.otherHelperInfo.count == 1 {
                                self.alert.dismiss(animated: true, completion: nil)
                                self.isFromPending = false
                                self.setupLoadingInfo()
                            } else {
                                self.isFromPending = true
                                self.setupLoadingInfo()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getAllotedHelperInfoAPICall2() {
        
        CommonAPIHelper.getAllotedHelperInfo(VC: self, move_id: moveInfo!.request_id!) { (res, err, isExe) in
            if isExe{
                self.otherHelperInfo = res!
                if self.otherHelperInfo.count > 0{
                    let img = UIImageView.init(image: UIImage.init(named: "User_placeholder"))
                    let urlString = self.otherHelperInfo[0]["photo_url"] as! String
                    if let url = URL.init(string: urlString){
                        img.af.setImage(withURL: url, placeholderImage: UIImage.init(named: "User_placeholder"), filter: nil, progress: nil, progressQueue: .main, imageTransition: .noTransition, runImageTransitionIfCached: .init()) { (_) in
                            if(self.moveInfo?.is_reconfirm == 0) {
                                self.moreHelperButton.isHidden = false
                            }
                        }
                    }
                } else{
                }
            }
        }
    }
    
    func getCustomerRatingsStatus(){
        CommonAPIHelper.getHelperAppRating(VC: self, move_id: (moveInfo?.request_id)!, completetionBlock: { (result, error, isexecuted) in
                     
            DispatchQueue.main.async {
                if error != nil{
                    return
                }
                else {
                    let is_rated:Int = result!["is_rated"] as? Int ?? 0
                    
                    if(is_rated == 0) {
                        if(self.viewRatting == nil) {
                            self.viewRatting = AppRattingViewView.init(frame: .zero)
                            self.viewRatting.selfVC = self
                            self.viewRatting.request_id = (self.moveInfo?.request_id)!
                            self.view?.addSubview(self.viewRatting)
                        }
                    } else {
                    }
                }
            }
        })
    }
    
    func helperUpdatePendingMoveStatusAPICall(confirm_status:String, meeting_slot:String) {
        
        StaticHelper.shared.startLoader(self.headerView)

        CommonAPIHelper.helperUpdatePendingMoveStatusAPICall(VC: self, params: ["request_id": (moveInfo?.request_id)!, "confirm_status":confirm_status, "meeting_slot": meeting_slot], completetionBlock: { (result, error, isexecuted) in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                StaticHelper.shared.stopLoader()
                
                if error != nil {
                    
                    return
                } else {
                    self.viewJobEdit.isHidden = true
                    return
                }
            }
        })
    }

}

// MARK: - ALert Permmison method's ....
extension OnGoingServiceViewController:AlertViewPermmisionDelegate{
    func alertViewPermmisionCLick(isOk: Bool) {
        alertPermmisionView!.removeFromSuperview()
        alertPermmisionView = nil
        if isOk {
            DispatchQueue.main.async() {
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    } else {
                        // Fallback on earlier versions
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            UIApplication.shared.openURL(settingsUrl)
                        }
                    }
                }
            }
        }
    }
    
    func showPermmisonAlert(_ popUpTitleMsg:String, _ titleMsg:String, _ message:String) {
       self.view.endEditing(true)
        alertPermmisionView = AlertViewPermmision(frame: appDelegate.window!.bounds)
        alertPermmisionView!.delegate = self
        alertPermmisionView!.strPopupTitle = popUpTitleMsg
        alertPermmisionView!.strTitleMessage = titleMsg
        alertPermmisionView!.strMessage = message
       appDelegate.window?.addSubview(alertPermmisionView!)
    }
}

extension OnGoingServiceViewController{
    //Alert...
    func showAlertPopupView(_ popUpTitleMsg:String = "", _ message:String,  _ cancelButtonTitle:String = "",  _ okButtonTitle:String = "", _ centerOkButtonTitle:String = ""){
        self.view.endEditing(true)
        AlertPopupView.instance.shwoDataWithClosures(popUpTitleMsg, message, cancelButtonTitle, okButtonTitle, centerOkButtonTitle){ status in
            if status{
                print("Okay")
                self.btnDetailsJobEdit.titleLabel?.font = UIFont.josefinSansBoldFontWithSize(size: 14.0)
            }else{
                print("NO/Cancel")
            }
        }
    }
}


