//
//  HomeViewController.swift
//  MoveIt
//
//  Created by Dushyant on 19/06/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit
import Toast_Swift
import Alamofire
import  CoreLocation
import GooglePlaces

class HomeViewController: UIViewController {

    let rightButton = UIButton(type: .custom)
    let leftButton = UIButton(type: .custom)

    @IBOutlet weak var notificationCountView: UIView!
    @IBOutlet weak var messageCountView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var myMovesViewController = AllMovesViewController()
    var scheduledViewController = AllScheduledMoveViewController()
    var messagesViewController = MainMessagesViewController()
    var notificationViewController = NotificationsViewController()
    var moreViewController = MoreViewController()
    
    var isTokenUpdated:Bool = false
    var isComeFromChangeServiceAcceptNotification:Bool = false

    
    @IBOutlet weak var bottomTabView: UIView!
    
    @IBOutlet weak var myMovesLabel: UILabel!
    @IBOutlet weak var myMovesButton: UIButton!
    @IBOutlet weak var myMoveImgView: UIImageView!
    
    @IBOutlet weak var scheduleLabel: UILabel!
    @IBOutlet weak var schedultButton: UIButton!
    @IBOutlet weak var scheduleImgView: UIImageView!
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var messageImgView: UIImageView!
    
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var notificationImgView: UIImageView!
    
    @IBOutlet weak var moreLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var moreImgView: UIImageView!
    
    @IBOutlet weak var notificationCountLabel: UILabel!
    @IBOutlet weak var messageCountLabel: UILabel!
    
    @IBOutlet weak var viewAdmin: UIView!
    @IBOutlet weak var viewSub1Admin: UIView!
    @IBOutlet weak var viewSub2Admin: UIView!
    @IBOutlet weak var lblAdminMessage: UILabel!
    @IBOutlet weak var btnAdminAction: UIButton!
    
    //tutorial's lable....
    @IBOutlet weak var lblTitletTutorial: UILabel!
    @IBOutlet weak var lblBtnTitletTutorial: UILabel!

    var viewRatting:AppRattingViewView!
    var blockVC:InsuranceExpiredVC!
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    var alertPermmisionView :AlertViewPermmision?
    let locManager = CLLocationManager()

    //BlockUserViewController
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewAdmin.isHidden = true
        //Location
        appDelegate.locationSetup()
        
        self.navigationBarConfiguration()
        self.uiAdjudtmentAfterLoadingView()

        self.setupViewControllers()
        self.getProfileInfo()
        getDefaultValueCancelationFee()

        NotificationCenter.default.addObserver(self, selector: #selector(notificationApprovedW9), name: NSNotification.Name(rawValue: "W9_FORM_ACCEPT"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationRejectW9), name: NSNotification.Name(rawValue: "W9_FORM_REJECT"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getProfileInfoWhenServisTypeIsChange), name: NSNotification.Name(rawValue: "getProfileInfoHome"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getAdminChatCount), name: NSNotification.Name(rawValue: "ADMIN_CHAT_COUNT"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshAdminChatCount), name: NSNotification.Name(rawValue: "REFRESH_ADMIN_CHAT_COUNT"), object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        myMovesViewController.availableMovesVC.isVisible = true
        checkLocationPermissions()
        if(profileInfo?.is_demo_completed == 0) {
            self.getProfileInfo()
        } else {
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bottomTabView.roundCorners(corners: [.topLeft,.topRight], radius: 4)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if(appDelegate.lanchedViaAPNS == true) {
//            self.view.makeToast("TRUE")

            appDelegate.lanchedViaAPNS = false
            let notification_type = appDelegate.notification_type

            if(notification_type != "") {

                DispatchQueue.main.async {
                    if (notification_type == "ACCEPT_VEHICLE_REQUEST") {
//                        self.redirectToVehicleInfoAccept(notification_type)
                    } else if (notification_type == "REJECT_VEHICLE_REQUEST") {
                        self.redirectToVehicleInfoReject(notification_type)
//                        self.navigateToRejectionController(appDelegate.userInfoAPNS)
                    } else if (notification_type == "UPLOAD_INSURANCE_NOTIFICATION") {
                        self.redirectToVehicleInfoUpdate(notification_type)
                    } else if (notification_type == "PROMOTIONAL_NOTIFICATION") {
                        self.redirectToPromotionalNotification()
                    } else if (notification_type == "SIMPLE_NOTIFICATION") {
                        self.redirectToSimpleNotification(appDelegate.userInfoAPNS)
                    } else if (notification_type == "APP_UPDATE_NOTIFICATION") {
                        self.redirectToAppUpdate()
                    } else if (notification_type == "MESSAGE_NOTIFICATION") {
                        self.redirectToChatMessage(appDelegate.userInfoAPNS)
                    } else if (notification_type == "1") {
                        if appDelegate.userInfoAPNS[AnyHashable("request_id")] != nil {
                            self.redirectToMoveDetails(appDelegate.userInfoAPNS)
                        } else {//request_id
                            //thete is ia login in appDelegate for the type '"1" in else condition
                        }
                    } else if (notification_type == "3") {
                        print("\(appDelegate.userInfoAPNS[AnyHashable("notification_flag")])")
                        if appDelegate.userInfoAPNS[AnyHashable("notification_flag")] != nil {
                            self.redirectToVehicleInfoAccept(notification_type)
                        } else {//request_id
                            //thete is ia login in appDelegate for the type '"1" in else condition
                        }
                    } else {//notification_type
                        //
                    }
                }

            }
        } else {
//        self.view.makeToast("FALSE")
        }
//        showChangeRequestPopUp()
        
        self.refreshNotificationCount()

    }
    func checkLocationPermissions(){
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case  .restricted, .denied:
                self.showPermmisonAlert(AlertButtonTitle.alert,kStringPermission.locationTitle, kStringPermission.locationMessage)
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
    
    func navigateToRejectionController(_ userInfo: [AnyHashable : Any]){
        var isServiceFlag = "false"
        if let changeService = (userInfo[AnyHashable("change_service")] as? String){
            isServiceFlag = changeService
        }
        var is_insurance_request = "false"
        if let is_insurance_requestT = (userInfo[AnyHashable("is_insurance_request")] as? String){
            is_insurance_request = is_insurance_requestT
        }
        if (is_insurance_request != "false" && isServiceFlag == "false"){
                let changeServiceMessage = (userInfo[AnyHashable("message")] as? String) ?? ""
                let titleMessage = (userInfo[AnyHashable("insurance_message_title")] as? String) ?? ""
                self.redirectToInsuranceServiceReject((titleMessage), changeServiceMessage)
        }else if (is_insurance_request == "false" && isServiceFlag == "false"){
                self.redirectToVehicleInfoReject(appDelegate.notification_type)
        }else if (is_insurance_request == "false" && isServiceFlag != "false"){
                let changeService1 = (userInfo[AnyHashable("change_service")] as? String) ?? ""
                let changeServiceMessage = (userInfo[AnyHashable("message")] as? String) ?? ""
                self.redirectToChangeServiceReject(changeServiceMessage, changeService1)
        }
    }
    
    func showInsuranceExpiredMessage(_ message:String = "", _ titleMessage:String = "", _ isPendingRequestFlag:Bool = false, _ isRequestRejectedFlag:Bool = false) {
        
            let viVC = self.storyboard?.instantiateViewController(withIdentifier: "EditVehicleInfoViewController") as! EditVehicleInfoViewController
            viVC.isComeFromServiceStoped = true
            self.navigationController?.pushViewController(viVC, animated: true)

    }
    
    func hideInsuranceExpiredMessage() {
        if let viewController =  StaticHelper.mainWindow().rootViewController?.topMostViewController(), viewController is InsuranceExpiredVC {
            if viewController is InsuranceExpiredVC{
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: HomeViewController.self) {
                        _ =  self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            }
        }
    }
    
    
    func showW9AndTutorial(){
        DispatchQueue.main.async {
        if SELECTED_MOVE_UPER_TAB_INDEX == 0 && SELECTED_TAB_INDEX == 0{
            if(profileInfo?.is_new == 1) {
                if(profileInfo?.w9_form_status == 1) {
                    if(profileInfo?.w9_form_verified == 0) {//Pending
                        self.showPendingW9PopUp()
                        //Need to show New PopUp and tutorials
                        //self.gotoW9PendingVerificationVC()
                    } else if(profileInfo?.w9_form_verified == 1) {//Approve
                        if(profileInfo?.is_demo_completed == 1) {
                            //Do nothing already on home page
                            //appDelegate.gotoHomeVC()
//                            self.getHelperLastJobStatus()
                        } else {
                            self.showPendingTutorialPopUp()
                            //self.gotoTutorial()
                        }
                    } else if(profileInfo?.w9_form_verified == 2) {//Reject
                        appDelegate.gotoW9FormVC()
                    }
                }
            }else{
                self.viewAdmin.isHidden = true
            }
        }else{
            self.viewAdmin.isHidden = true
        }
        }
    }
    func rightSideBarButtonHideShowLogic(_ isNoMoves:Int = 0){
        if SELECTED_TAB_INDEX != 0{
            self.navigationItem.rightBarButtonItems = nil
        }else{
            
            self.navigationItem.rightBarButtonItems = nil
            if SELECTED_MOVE_UPER_TAB_INDEX == 0{
//                if isNoMoves != 0{
                if profileInfo?.is_new == 1{
                    if(profileInfo?.w9_form_status == 1 && profileInfo?.w9_form_verified == 1 && profileInfo?.is_demo_completed == 1 ) {
                        self.navigationItem.rightBarButtonItems = [StaticHelper.rightBarButtonWithImageNamed(imageName: "offer-icon-color", vc: self), self.rightBarButton()]
                    }else{
                        self.navigationItem.rightBarButtonItems = [StaticHelper.rightBarButtonWithImageNamed(imageName: "offer-icon-color", vc: self)]
                    }
                }else{
                    self.navigationItem.rightBarButtonItems = [StaticHelper.rightBarButtonWithImageNamed(imageName: "offer-icon-color", vc: self), self.rightBarButton()]
                }
//                }else{
//                    self.navigationItem.rightBarButtonItems = [StaticHelper.rightBarButtonWithImageNamed(imageName: "offer-icon-color", vc: self)]
//                }
            }else{
                self.navigationItem.rightBarButtonItems = [StaticHelper.rightBarButtonWithImageNamed(imageName: "offer-icon-color", vc: self)]
            }
        }
    }
    func showChangeRequestPopUp(_ isNoMoves:Int = 0){
        rightSideBarButtonHideShowLogic(isNoMoves)
        configureChangeRequestPopUp()
//        if profileInfo?.service_type == 2{
//            if profileInfo?.vehicleDetails?.is_vehicle_request == "pending" || profileInfo?.vehicleDetails?.is_vehicle_request == "Pending"{
//                if SELECTED_TAB_INDEX == 0 && SELECTED_MOVE_UPER_TAB_INDEX == 0{
//                    if isNoMoves > 0{
//                        self.viewAdmin.isHidden = true
//                    }else{
//                        configureChangeRequestPopUp()
//                        self.lblAdminMessage.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
//                        self.lblAdminMessage.text = "\(profileInfo?.vehicleDetails?.message ?? "")"
//                        self.view.bringSubviewToFront(self.viewAdmin)
//                    }
//                }else{
//                    self.viewAdmin.isHidden = true
//                }
//            }else{
//                self.viewAdmin.isHidden = true
//            }
//        }
    }
    func hideChangeRequestPopUpForCompleteCancel(){
        SELECTED_TAB_INDEX = 0
        rightSideBarButtonHideShowLogic()
        self.viewAdmin.isHidden = true

//        if profileInfo?.service_type == 2{
//            if profileInfo?.vehicleDetails?.is_vehicle_request == "pending" || profileInfo?.vehicleDetails?.is_vehicle_request == "Pending"{
//                self.viewAdmin.isHidden = true
//            }else{
//                self.viewAdmin.isHidden = true
//            }
//        }else{
//            self.viewAdmin.isHidden = true
//        }
    }
    func configureChangeRequestPopUp(){
//        self.viewAdmin.isHidden = false
        self.btnAdminAction.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        
        self.btnAdminAction.layer.cornerRadius = 15.0
        self.btnAdminAction.clipsToBounds = true

        self.viewSub1Admin.layer.cornerRadius = 5.0
        self.viewSub1Admin.layer.borderColor = UIColor.lightGray.cgColor
        self.viewSub1Admin.layer.borderWidth = 0.2
        self.viewSub1Admin.clipsToBounds = true

        self.viewSub2Admin.layer.cornerRadius = 15.0
        self.viewSub2Admin.layer.borderColor = UIColor.lightGray.cgColor
        self.viewSub2Admin.layer.borderWidth = 0.2
        self.viewSub2Admin.clipsToBounds = true

        btnAdminAction.addTarget(self, action: #selector(btnAdminActionMethod), for: .touchDown)
        showW9AndTutorial()
    }
    func navigationBarConfiguration()
    {
        let logo = UIImage(named: "home_logo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: violetColor,.font: UIFont.josefinSansSemiBoldFontWithSize(size: 15.0)]
        self.navigationItem.leftBarButtonItem = StaticHelper.leftBarButtonWithImageNamed(imageName: "menu_icon", vc: self)

        self.navigationItem.rightBarButtonItems = [StaticHelper.rightBarButtonWithImageNamed(imageName: "offer-icon-color", vc: self)]
    }
    
    func uiAdjudtmentAfterLoadingView()
    {
        self.collectionView.contentInsetAdjustmentBehavior = .automatic
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        
        notificationCountLabel.font = UIFont.josefinSansRegularFontWithSize(size: 8.0)
        messageCountLabel.font = UIFont.josefinSansRegularFontWithSize(size: 8.0)
        
        notificationCountView.layer.cornerRadius = 8
        messageCountView.layer.cornerRadius = 8
           
        myMovesLabel.font = UIFont.josefinSansRegularFontWithSize(size: 9.0)
        scheduleLabel.font = UIFont.josefinSansRegularFontWithSize(size: 9.0)
        messageLabel.font = UIFont.josefinSansRegularFontWithSize(size: 9.0)
        notificationLabel.font = UIFont.josefinSansRegularFontWithSize(size: 9.0)
        moreLabel.font = UIFont.josefinSansRegularFontWithSize(size: 9.0)
        lblTitletTutorial.font = UIFont.josefinSansSemiBoldFontWithSize(size: 13.0)
        lblBtnTitletTutorial.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        lblBtnTitletTutorial.adjustsFontSizeToFitWidth = true
    }

    //MARK: -    
    
        
    func NotificationCountTextReload() {
        if SELECTED_TAB_INDEX == 0{
            self.myMovesViewController.availableMovesVC.getAllAvailableMoves()
        }
            
        if SELECTED_TAB_INDEX != 0{
            self.navigationItem.rightBarButtonItems = nil
        }else{
            self.navigationItem.rightBarButtonItems = nil
            if SELECTED_MOVE_UPER_TAB_INDEX == 0{
//                if IS_AVAILABLE_MOVE_CONTAIN_DATA != 0{
                if profileInfo?.is_new == 1{
                    if(profileInfo?.w9_form_status == 1 && profileInfo?.w9_form_verified == 1 && profileInfo?.is_demo_completed == 1 ) {
                        self.navigationItem.rightBarButtonItems = [StaticHelper.rightBarButtonWithImageNamed(imageName: "offer-icon-color", vc: self), self.rightBarButton()]
                    }else{
                        self.navigationItem.rightBarButtonItems = [StaticHelper.rightBarButtonWithImageNamed(imageName: "offer-icon-color", vc: self)]
                    }
                }else{
                    self.navigationItem.rightBarButtonItems = [StaticHelper.rightBarButtonWithImageNamed(imageName: "offer-icon-color", vc: self), self.rightBarButton()]
                }
//                }else{
//                    self.navigationItem.rightBarButtonItems = [StaticHelper.rightBarButtonWithImageNamed(imageName: "offer-icon-color", vc: self)]
//                }
            }else{
                self.navigationItem.rightBarButtonItems = [StaticHelper.rightBarButtonWithImageNamed(imageName: "offer-icon-color", vc: self)]
            }
        }
    }

    func rightBarButton() -> UIBarButtonItem{
                
        rightButton.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 8.0)
        rightButton.setTitle("Map View", for: .normal)
        rightButton.setTitleColor(violetColor, for: .normal)
        rightButton.frame = CGRect(x: 0, y: 0, width: 60.0 * screenHeightFactor, height: 30)
        rightButton.layer.cornerRadius = 15.0
        rightButton.layer.borderColor = violetColor.cgColor
        rightButton.layer.borderWidth = 1.0
//        rightButton.setBackgroundImage(<#T##image: UIImage?##UIImage?#>, for: .normal)
        rightButton.addTarget(self, action: #selector(rightButtonMapPressed), for: .touchUpInside)
        
        let rightBarButton = UIBarButtonItem(customView: rightButton)
        return rightBarButton
    }
    func leftProfileBarButton() -> UIBarButtonItem{
                
        leftButton.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 8.0)
        leftButton.setTitle("", for: .normal)
        leftButton.setTitleColor(violetColor, for: .normal)
        leftButton.frame = CGRect(x: 0, y: 0, width: 30.0 * screenHeightFactor, height: 30)
        leftButton.layer.cornerRadius = 15.0
        leftButton.layer.borderColor = violetColor.cgColor
        leftButton.layer.borderWidth = 1.0
        leftButton.addTarget(self, action: #selector(rightButtonMapPressed), for: .touchUpInside)
        
        let rightBarButton = UIBarButtonItem(customView: rightButton)
        return rightBarButton
    }
    
    func setupViewControllers() {
        
        myMovesViewController = self.storyboard?.instantiateViewController(withIdentifier: "AllMovesViewController") as! AllMovesViewController
        messagesViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainMessagesViewController") as! MainMessagesViewController
        notificationViewController = self.storyboard?.instantiateViewController(withIdentifier: "NotificationsViewController") as! NotificationsViewController
        scheduledViewController = self.storyboard?.instantiateViewController(withIdentifier: "AllScheduledMoveViewController") as! AllScheduledMoveViewController
        moreViewController = self.storyboard?.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
        
        addChild(myMovesViewController)
        addChild(messagesViewController)
        addChild(notificationViewController)
        addChild(scheduledViewController)
        addChild(moreViewController)
        
        myMovesViewController.view.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64 - 40.0 * screenHeightFactor)
        messagesViewController.view.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64 - 40.0 * screenHeightFactor)
        notificationViewController.view.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64 - 40.0 * screenHeightFactor)
        scheduledViewController.view.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64 - 40.0 * screenHeightFactor)
        moreViewController.view.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64 - 40.0 * screenHeightFactor)
        
        myMovesViewController.didMove(toParent: self)
        messagesViewController.didMove(toParent: self)
        notificationViewController.didMove(toParent: self)
        scheduledViewController.didMove(toParent: self)
        moreViewController.didMove(toParent: self)
    }
    
    //MARK: - Nabbar Actions
    @objc func leftButtonPressed(_ selector: UIButton){

        self.myMovesViewController.availableMovesVC.isVisible = false
        self.gotoProfileVC()
    }
    
    @objc func rightButtonPressed(_ selector: Any) {
        self.myMovesViewController.availableMovesVC.isVisible = false
        self.gotoDiscountofferVC()
    }
    @objc func rightButtonMapPressed(){
        self.myMovesViewController.availableMovesVC.isVisible = false
        self.gotoMapViewVC()
    }

    //MARK: - Tab Actions
    @IBAction func myMoveAction(_ sender: Any) {
                
        if(viewAdmin.isHidden == false) {
            self.view.bringSubviewToFront(viewAdmin)
        }
        SELECTED_TAB_INDEX = 0

        self.myMovesLabel.textColor = violetColor
        self.scheduleLabel.textColor = dullColor
        self.messageLabel.textColor = dullColor
        self.notificationLabel.textColor = dullColor
        self.moreLabel.textColor = dullColor
        
        self.myMoveImgView.image = UIImage.init(named: "my_move_slct_icon")
        self.scheduleImgView.image = UIImage.init(named: "scheduled_unslct_icon")
        self.messageImgView.image = UIImage.init(named: "message_unslct_icon")
        self.notificationImgView.image = UIImage.init(named: "notification_unslct_icon")
        self.moreImgView.image = UIImage.init(named: "more_unslct_icon")
        
        self.collectionView.delegate = self
        self.collectionView.reloadData()
        self.collectionView.layoutIfNeeded()
        self.collectionView.scrollToItem(at: IndexPath.init(item: 0, section: 0), at: .centeredHorizontally, animated: false)
        
        
        if(myMovesViewController.selectedMenuIndex == 0) {
            myMovesViewController.availableMovesVC.reloadWhenrequired()
        } else if(myMovesViewController.selectedMenuIndex == 1) {
            myMovesViewController.completedMovesVC.reloadWhenrequired()
        } else if(myMovesViewController.selectedMenuIndex == 2) {
            myMovesViewController.cancelledMovesVC.reloadWhenrequired()
        }
        showChangeRequestPopUp(0)

    }
    
    @IBAction func scheduleMoveAction(_ sender: Any) {
        
        if(viewAdmin.isHidden == false) {
            self.view.bringSubviewToFront(viewAdmin)
        }
        SELECTED_TAB_INDEX = 1
        showChangeRequestPopUp(0)

        self.navigationItem.rightBarButtonItem = nil
        self.myMovesLabel.textColor = dullColor
        self.scheduleLabel.textColor = violetColor
        self.messageLabel.textColor = dullColor
        self.notificationLabel.textColor = dullColor
        self.moreLabel.textColor = dullColor
        
        self.myMoveImgView.image = UIImage.init(named: "my_move_unslct_icon")
        self.scheduleImgView.image = UIImage.init(named: "scheduled_slct_icon")
        self.messageImgView.image = UIImage.init(named: "message_unslct_icon")
        self.notificationImgView.image = UIImage.init(named: "notification_unslct_icon")
        self.moreImgView.image = UIImage.init(named: "more_unslct_icon")
        
        self.collectionView.delegate = self
        self.collectionView.reloadData()
        self.collectionView.layoutIfNeeded()
        self.collectionView.scrollToItem(at: IndexPath.init(item: 1, section: 0), at: .centeredHorizontally, animated: false)

        if(scheduledViewController.selectedMenuIndex == 0) {
            self.scheduledViewController.scheduledMovesVC.getAllScheduledMoves()
        } else if(scheduledViewController.selectedMenuIndex == 1) {
            self.scheduledViewController.pendingMovesVC.getAllPendingScheduledMoves()
        }
    }
    
    @IBAction func messageAction(_ sender: Any) {
        if(viewAdmin.isHidden == false) {
            self.view.bringSubviewToFront(viewAdmin)
        }
        SELECTED_TAB_INDEX = 2
        showChangeRequestPopUp(0)
        messageNotificationCount = 0
        if adminChatNotificationCount == 0{
            self.messageCountView.isHidden = true
        }
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.rightBarButtonItems = nil
        self.myMovesLabel.textColor = dullColor
        self.scheduleLabel.textColor = dullColor
        self.messageLabel.textColor = violetColor
        self.notificationLabel.textColor = dullColor
        self.moreLabel.textColor = dullColor
        
        self.myMoveImgView.image = UIImage.init(named: "my_move_unslct_icon")
        self.scheduleImgView.image = UIImage.init(named: "scheduled_unslct_icon")
        self.messageImgView.image = UIImage.init(named: "message_slct_icon")
        self.notificationImgView.image = UIImage.init(named: "notification_unslct_icon")
        self.moreImgView.image = UIImage.init(named: "more_unslct_icon")
        
        self.collectionView.delegate = self
        self.collectionView.reloadData()
        self.collectionView.layoutIfNeeded()
        self.collectionView.scrollToItem(at: IndexPath.init(item: 2, section: 0), at: .centeredHorizontally, animated: false)
        
        if(messagesViewController.selectedMenuIndex == 0) {
            messagesViewController.customerChatVC.getChats()
        } else if(messagesViewController.selectedMenuIndex == 1) {
            messagesViewController.helperChatVC.getChats()
        }
    }
    
    @IBAction func notificationAction(_ sender: Any) {
        if(viewAdmin.isHidden == false) {
            self.view.bringSubviewToFront(viewAdmin)
        }
        SELECTED_TAB_INDEX = 3
        showChangeRequestPopUp(0)

        self.notificationCountView.isHidden = true
        self.myMovesLabel.textColor = dullColor
        self.scheduleLabel.textColor = dullColor
        self.messageLabel.textColor = dullColor
        self.notificationLabel.textColor = violetColor
        self.moreLabel.textColor = dullColor
        
        self.myMoveImgView.image = UIImage.init(named: "my_move_unslct_icon")
        self.scheduleImgView.image = UIImage.init(named: "scheduled_unslct_icon")
        self.messageImgView.image = UIImage.init(named: "message_unslct_icon")
        self.notificationImgView.image = UIImage.init(named: "notification_slct_icon")
        self.moreImgView.image = UIImage.init(named: "more_unslct_icon")
        
        self.collectionView.delegate = self
        self.collectionView.reloadData()
        self.collectionView.layoutIfNeeded()
        self.collectionView.scrollToItem(at: IndexPath.init(item: 3, section: 0), at: .centeredHorizontally, animated: false)
        
        notificationViewController.getNotifications()
    }
    
    @IBAction func moreAction(_ sender: Any) {
        if(viewAdmin.isHidden == false) {
            self.view.bringSubviewToFront(collectionView)
            self.view.bringSubviewToFront(bottomTabView)
            self.view.bringSubviewToFront(viewAdmin)

        }
        SELECTED_TAB_INDEX = 4
        showChangeRequestPopUp(0)

        self.myMovesLabel.textColor = dullColor
        self.scheduleLabel.textColor = dullColor
        self.messageLabel.textColor = dullColor
        self.notificationLabel.textColor = dullColor
        self.moreLabel.textColor = violetColor
        
        self.myMoveImgView.image = UIImage.init(named: "my_move_unslct_icon")
        self.scheduleImgView.image = UIImage.init(named: "scheduled_unslct_icon")
        self.messageImgView.image = UIImage.init(named: "message_unslct_icon")
        self.notificationImgView.image = UIImage.init(named: "notification_unslct_icon")
        self.moreImgView.image = UIImage.init(named: "more_slct_icon")
        
        self.collectionView.delegate = self
        self.collectionView.reloadData()
        self.collectionView.layoutIfNeeded()
        self.collectionView.scrollToItem(at: IndexPath.init(item: 4, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    //MARK: - APIs
    func callUpdateDeviceTokenAPI() {
        
        let deviceToken = UserDefaults.standard.value(forKey: "UserToken") as? String ?? ""

        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken() ?? ""]
        
        let parameters: Parameters = ["device_type":"I", "device_token" : deviceToken, "app_version": appVersion as Any, "device_name": modelName, "device_version": systemVersion]
        
        print("helper_update_device_token = ", parameters)
        AF.request(baseURL + kAPIMethods.helper_update_device_token, method: .post, parameters: parameters, headers: header).responseJSON { (response) in
            DispatchQueue.main.async {

            switch response.result {
            case .success:
                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200{
                    print("updateDevice Successfully")
                    self.isTokenUpdated = true
                }
            case .failure(let error):
                StaticHelper.shared.stopLoader()
                print("updateDevice \(error)")
                if response.response?.statusCode == 401{
                    CommonAPIHelper.clearData(VC: self)
                } else {
                    self.isTokenUpdated = true
                    self.callUpdateDeviceTokenAPI()
                }
            }
            }
        }
    }
    
    @objc func refreshNotificationCount() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if adminChatNotificationCount == 0{
                self.messageCountView.isHidden = true
            }
            self.notificationCountView.isHidden = true
            self.messageCountLabel.text = ""
            self.notificationCountLabel.text = "0"
            CommonAPIHelper.getHelperNotificationCount(VC: self) { (result, error, status) in
                if (status == true) {
                    if let app_notification_count = result?["app_notification_count"] as? Int {
                        print(app_notification_count)
                        //if app_notification_count != 0 {
                        appNotificationCount = app_notification_count
                        self.NotificationCountTextReload()
                        //}
                    }
                    if let message_notification_count = result?["message_notification_count"] as? Int {
                        if message_notification_count != 0 {
                            self.messageCountLabel.text = "\(message_notification_count)"
                            self.messageCountView.isHidden = false
                            messageNotificationCount = message_notification_count
                        }
                    }
                    if let move_notification_count = result?["move_notification_count"] as? Int {
                        if move_notification_count != 0 {
                            self.notificationCountLabel.text = "\(move_notification_count)"
                            self.notificationCountView.isHidden = false
                        }
                    }
                    if let admin_chat_count = result?["admin_chat_count"] as? Int {
                        var count = admin_chat_count
                        adminChatNotificationCount = count
                        if let message_notification_count = result?["message_notification_count"] as? Int {
                            count = count + message_notification_count
                        }
                        if admin_chat_count != 0 {
                            self.messageCountLabel.text = "\(count)"
                            self.messageCountView.isHidden = false
                            if adminChatNotificationCount != 0{
                                self.navigationItem.leftBarButtonItem!.setBadge(text: "\(adminChatNotificationCount)")
                            }
                        }
                    }
                }
            }
        }
    }
    @objc func refreshAdminChatCount(){
        DispatchQueue.main.async {
            self.navigationItem.leftBarButtonItem!.setBadge(text: "")
        }
    }
    @objc func getAdminChatCount(){
        CommonAPIHelper.getHelperNotificationCount(true, VC: self) { (result, error, status) in
            if (status == true){
                messageNotificationCount = 0
                adminChatNotificationCount = 0

                if let message_notification_count = result?["message_notification_count"] as? Int {
                    if message_notification_count != 0 {
                        self.messageCountLabel.text = "\(message_notification_count)"
                        self.messageCountView.isHidden = false
                        messageNotificationCount = message_notification_count
                    }
                }
                
                if let message_notification_count = result?["admin_chat_count"] as? Int {
                    self.collectionView.reloadData()
                    adminChatNotificationCount = message_notification_count
                    if adminChatNotificationCount != 0{
                        self.navigationItem.leftBarButtonItem!.setBadge(text: "\(adminChatNotificationCount)")
                        self.messageCountLabel.text = "\(adminChatNotificationCount+messageNotificationCount)"
                        self.messageCountView.isHidden = false
                    }
                }
                self.messagesViewController.menuCollectionView.reloadData()
            }
        }
    }
    func getHelperLastJobStatus() {
        
//        if UserCache.userToken() == nil{
//            CommonAPIHelper.clearData(VC: self)
//            return
//        }
        //self.rightButton.isHidden = false
        
        viewAdmin.isHidden = true
        CommonAPIHelper.getHelperLastJobStatus(VC: self) { (res, err, isExecuted) in
            if isExecuted {
                DispatchQueue.main.async {

//                    UserCache.saveW9UserData(w9_form_status: profileInfo?.w9_form_status ?? 0, w9_form_verified: profileInfo?.w9_form_verified ?? 0)
                    
                    let app_rating:Int = res?["app_rating"] as? Int ?? 0
                    let customer_rating:Int = res?["customer_rating"] as? Int ?? 0
                    let request_id:Int = res?["request_id"] as? Int ?? 0
                    
//                    self.showAppRatingPop(request_id)
                    
                    if(request_id > 0) {
                        if(customer_rating == 0) {
                            self.getMoveDetails(request_id)
                        } else if(app_rating == 0) {
                            self.showAppRatingPop(request_id)
                        }
                    }
                }
            }
        }
    }
    
    @objc func getMoveDetails(_ moveID:Int) {
        
        CommonAPIHelper.getMoveDetailByID(VC: self, move_id: moveID, completetionBlock: { (result, error, isexecuted) in
            StaticHelper.shared.stopLoader()
            if error != nil {
                return
            } else {
                if let result = result {
                    let moveInfo:MoveDetailsModel = MoveDetailsModel.init(moveDict: result)!
                    self.gotoRatePopUpVC(moveInfo)
                }
            }
        })
    }
    
    func gotoRatePopUpVC(_ moveInfo:MoveDetailsModel) {
        //self.getCustomerRatingsStatus()
        DispatchQueue.main.async {
            let ratingVc = self.storyboard?.instantiateViewController(withIdentifier: "RatePopUpViewController") as! RatePopUpViewController
            ratingVc.moveInfo = moveInfo
            ratingVc.modalPresentationStyle = .overFullScreen
            self.present(ratingVc, animated: true, completion: nil)
        }
    }
    
    func showAppRatingPop(_ request_id:Int) {
        if(self.viewRatting == nil) {
            self.viewRatting = AppRattingViewView.init(frame: .zero)
            self.viewRatting.selfVC = self
            self.viewRatting.request_id = request_id
            self.view?.addSubview(self.viewRatting)
        }
    }
    
    //MARK: - W9-Form FLow
    func getProfileInfo(){
//        if UserCache.userToken() == nil{
//            CommonAPIHelper.clearData(VC: self)
//            return
//        }
        //self.rightButton.isHidden = false
        viewAdmin.isHidden = true
        CommonAPIHelper.getProfile(VC: self) { (res, err, isExecuted) in

            if isExecuted {
                DispatchQueue.main.async { [self] in
                    profileInfo =  HelperDetailsModel.init(profileDict: res!)
                    UserCache.saveW9UserData(w9_form_status: profileInfo?.w9_form_status ?? 0, w9_form_verified: profileInfo?.w9_form_verified ?? 0)
                    
                    if(profileInfo?.is_new == 1 || profileInfo?.is_new == 0) {
                        if SELECTED_MOVE_UPER_TAB_INDEX == 0 && SELECTED_TAB_INDEX == 0{
                            if(profileInfo?.w9_form_status == 1) {
                                if(profileInfo?.w9_form_verified == 0) {//Pending
                                    self.showPendingW9PopUp()
                                    //Need to show New PopUp and tutorials
                                    //self.gotoW9PendingVerificationVC()
                                } else if(profileInfo?.w9_form_verified == 1) {//Approve
                                    if(profileInfo?.is_demo_completed == 1) {
                                        //Do nothing already on home page
                                        //appDelegate.gotoHomeVC()
                                        self.getHelperLastJobStatus()
                                    } else {
                                        self.showPendingTutorialPopUp()
                                        //self.gotoTutorial()
                                    }
                                } else if(profileInfo?.w9_form_verified == 2) {//Reject
                                    appDelegate.gotoW9FormVC()
                                }
                            }else{
                                appDelegate.gotoW9FormVC()
                            }
                        }
                    } else {
                        if let photoURL = profileInfo?.photo_url,!photoURL.isEmpty{
                            //self.gotoUploadPhotoVC()
                            if(profileInfo?.is_demo_completed == 1) {
                                self.getHelperLastJobStatus()
                            }
                        } else {
                            self.myMovesViewController.availableMovesVC.isVisible = false
                            self.gotoUploadPhotoVC()
                        }
                    }
                    if(profileInfo!.vehicleDetails!.insurance_expired == "1") && (profileInfo!.vehicleDetails!.is_insurance_request == "0") {
                        InsuranceExpiryView.instance.shwoDataWithClosures(profileInfo!.vehicleDetails!.insurance_message_title!, profileInfo!.vehicleDetails!.insurance_message!, "", "", "Update Info"){ status in
                            if status{
                                print("Okay")
                                self.showInsuranceExpiredMessage(profileInfo!.vehicleDetails!.insurance_message!, profileInfo!.vehicleDetails!.insurance_message_title!)
                            }else{
                                print("NO/Cancel")
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
                    }
                    
                    hideInsuranceExpiredMessage()

                    self.callUpdateDeviceTokenAPI()
                }
            }
        }
    }
    
    func showPendingW9PopUp() {
                
        self.viewAdmin.isHidden = false
        self.viewSub1Admin.isHidden = false
        self.viewSub2Admin.isHidden = false
        configureChangeRequestPopUp()
    }
    
    func showPendingTutorialPopUp() {
        
        self.viewAdmin.isHidden = false
        self.viewSub1Admin.isHidden = true
        self.viewSub2Admin.isHidden = false
        
        self.btnAdminAction.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        
        self.btnAdminAction.layer.cornerRadius = 15.0
        self.btnAdminAction.clipsToBounds = true

        self.viewSub1Admin.layer.cornerRadius = 5.0
        self.viewSub1Admin.layer.borderColor = UIColor.lightGray.cgColor
        self.viewSub1Admin.layer.borderWidth = 0.2
        
        self.viewSub2Admin.layer.cornerRadius = 15.0
        self.viewSub2Admin.layer.borderColor = UIColor.lightGray.cgColor
        self.viewSub2Admin.layer.borderWidth = 0.2
        
        btnAdminAction.addTarget(self, action: #selector(btnAdminActionMethod), for: .touchDown)
    }
    @IBAction func btnAdminActionMethod() {
        self.gotoTutorial()
    }
    @objc func getProfileInfoWhenServisTypeIsChange(){
         CommonAPIHelper.getProfile(VC: self) { (res, err, isExecuted) in
             if isExecuted{
                 DispatchQueue.main.async {
                     profileInfo =  HelperDetailsModel.init(profileDict: res!)
//                     self.setupData()
                 }
             }
         }
     }
    @objc func notificationApprovedW9() {
//        DispatchQueue.main.sync {
            self.navigationController?.popToViewController(self, animated: false)
            self.getProfileInfo()
//        }
    }
    
    @objc func notificationRejectW9() {
//        DispatchQueue.main.sync{
            self.navigationController?.popToViewController(self, animated: false)
            self.getProfileInfo()
//        }
    }
    
    //MARK: - Navigation
     func gotoUploadPhotoVC() {
        let uploadPhotoVC = self.storyboard?.instantiateViewController(withIdentifier: "UploadPhotoViewController") as! UploadPhotoViewController
        uploadPhotoVC.isFromHome = true
        uploadPhotoVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(uploadPhotoVC, animated: true)
    }
    
    func gotoMapViewVC() {
        if (profileInfo?.is_new == 0){
            let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "MapViewViewController") as! MapViewViewController
            self.navigationController?.pushViewController(mapVC, animated: true)
        }else if(profileInfo?.w9_form_status == 1 && profileInfo?.w9_form_verified == 1 && profileInfo?.is_demo_completed == 1 ) {
            let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "MapViewViewController") as! MapViewViewController
            self.navigationController?.pushViewController(mapVC, animated: true)
        }else{
            
//            self.btnAdminAction.blink()
//            //show alert....
            let alertController = UIAlertController.init(title: "", message: "Please wait for w-9 form approval, and complete your tutorial first", preferredStyle: .alert)

            let yesButton = UIAlertAction.init(title: "Ok", style: .default) { (_) in
            }

//            let cancelButton = UIAlertAction.init(title: "No", style: .cancel, handler: nil)

            alertController.addAction(yesButton)
//            alertController.addAction(cancelButton)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }

    func gotoProfileVC() {
        let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.navigationController?.pushViewController(profileVC, animated: false)
    }
    
    func gotoDiscountofferVC() {
        let nvc:DiscountofferViewController = self.storyboard?.instantiateViewController(withIdentifier: "DiscountofferViewController") as! DiscountofferViewController
        nvc.delegate = self
        self.navigationController!.pushViewController(nvc, animated: true)
    }
    
    func gotoTutorial() {
        let tutorialVC = TutorialViewController()
        self.navigationController?.pushViewController(tutorialVC, animated: false)
    }
    
    func refreshForgroundNotification() {
        
        let notification_type = appDelegate.notification_type

        if(notification_type != "") {

            DispatchQueue.main.async {
                if (notification_type == "ACCEPT_VEHICLE_REQUEST") {
                    
                } else if (notification_type == "REJECT_VEHICLE_REQUEST") {
                    
                } else if (notification_type == "UPLOAD_INSURANCE_NOTIFICATION") {
                    
                } else if (notification_type == "PROMOTIONAL_NOTIFICATION") {
                    
                } else if (notification_type == "SIMPLE_NOTIFICATION") {
                    
                } else if (notification_type == "APP_UPDATE_NOTIFICATION") {
                    
                } else if (notification_type == "MESSAGE_NOTIFICATION") {
                    
                } else if (notification_type == "1") {
                    
                    if (appDelegate.notification_flag == "CUSTOMER_EDIT_JOB") {
                        self.redirectToMoveDetails(appDelegate.userInfoAPNS)
                    } else {
                    
                        self.myMovesViewController.availableMovesVC.getAllAvailableMoves()
                        self.myMovesViewController.completedMovesVC.getAllCompletedMoves()
                        self.myMovesViewController.cancelledMovesVC.getAllCancelledMoves()
                        
                        self.scheduledViewController.scheduledMovesVC.getAllScheduledMoves()
                        self.scheduledViewController.pendingMovesVC.getAllPendingScheduledMoves()
                        
                        if appDelegate.userInfoAPNS[AnyHashable("request_id")] != nil {
                            self.redirectToMoveDetails(appDelegate.userInfoAPNS)
                        } else {
                            //OUTSIDE request_is
                                //ZOMBIE(27/11/2021):YE WALA MUJHE CHECK KARNA HAI YE KAUN SI CONDITION HAI
    //                            redirectMove = true
    //                            redirectMoveType = 0
    //                            if let helperStatus = userInfoAPNS["status"] as? String{
    //                                if (helperStatus == "2") {//
    //                                    redirectMoveType = 1
    //                                    isPendingScheduled = strBody.contains("cancel")
    //                                    if(homeVC == nil) {
    //                                        //
    //                                    } else {
    //                                        if(isPendingScheduled) {
    //                                            self.redirectToScheduledTab(section: 1)
    //                                        } else {
    //                                            self.redirectToScheduledTab(section: 0)
    //                                        }
    //                                    }
    //                                } else if (helperStatus == "10") {
    //                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OngoingService"), object: nil)
    //                                }
    //                            }
                        }
                    }
                }
            }

        }
    }
    
    //MARK: - Redirection
    func redirectToMyMoveTab(section:Int) {
        myMovesViewController.selectedMenuIndex = section
        SELECTED_TAB_INDEX = 0
        showChangeRequestPopUp(0)

        self.navigationController?.popToViewController(self, animated: true)
        
        self.myMovesLabel.textColor = violetColor
        self.scheduleLabel.textColor = dullColor
        self.messageLabel.textColor = dullColor
        self.notificationLabel.textColor = dullColor
        self.moreLabel.textColor = dullColor
        
        self.myMoveImgView.image = UIImage.init(named: "my_move_slct_icon")
        self.scheduleImgView.image = UIImage.init(named: "scheduled_unslct_icon")
        self.messageImgView.image = UIImage.init(named: "message_unslct_icon")
        self.notificationImgView.image = UIImage.init(named: "notification_unslct_icon")
        self.moreImgView.image = UIImage.init(named: "more_unslct_icon")
        
        self.collectionView.delegate = self
        self.collectionView.reloadData()
        self.collectionView.layoutIfNeeded()
        self.collectionView.scrollToItem(at: IndexPath.init(item: 0, section: 0), at: .centeredHorizontally, animated: false)
        
        
        if(myMovesViewController.selectedMenuIndex == 0) {
            myMovesViewController.availableMovesVC.reloadWhenrequired()
        } else if(myMovesViewController.selectedMenuIndex == 1) {
            myMovesViewController.completedMovesVC.reloadWhenrequired()
        } else if(myMovesViewController.selectedMenuIndex == 2) {
            myMovesViewController.cancelledMovesVC.reloadWhenrequired()
        }

    }
    func redirectToScheduledTab(section:Int) {
        SELECTED_TAB_INDEX = 1
        showChangeRequestPopUp(0)

        self.navigationController?.popToViewController(self, animated: true)
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.rightBarButtonItems = nil
        self.myMovesLabel.textColor = dullColor
        self.scheduleLabel.textColor = violetColor
        self.messageLabel.textColor = dullColor
        self.notificationLabel.textColor = dullColor
        self.moreLabel.textColor = dullColor
        self.myMoveImgView.image = UIImage.init(named: "my_move_unslct_icon")
        self.scheduleImgView.image = UIImage.init(named: "scheduled_slct_icon")
        self.messageImgView.image = UIImage.init(named: "message_unslct_icon")
        self.notificationImgView.image = UIImage.init(named: "notification_unslct_icon")
        self.moreImgView.image = UIImage.init(named: "more_unslct_icon")
        
        self.collectionView.delegate = self
        self.collectionView.reloadData()
        self.collectionView.layoutIfNeeded()

        self.collectionView.scrollToItem(at: IndexPath.init(item: 1, section: 0), at: .centeredHorizontally, animated: false)
        self.scheduledViewController.refreshSelectedSection(section: section)
    }
    func showChangeRequestServicePopup(_ isNoMoves:Int = 0){
        SELECTED_TAB_INDEX = 0
        showChangeRequestPopUp(isNoMoves)
    }
    func redirectToVehicleInfoUpdate(_ notification_type:String) {
        self.navigationController?.popToViewController(self, animated: false)
        let offerVC:DiscountofferViewController = self.storyboard?.instantiateViewController(withIdentifier: "DiscountofferViewController") as! DiscountofferViewController
        offerVC.notification_type = notification_type
        offerVC.delegate = self
        self.navigationController?.pushViewController(offerVC, animated: true)
    }

    func redirectToVehicleInfoAccept(_ notification_type:String) {
        self.navigationController?.popToViewController(self, animated: false)
        let vehicleVC = self.storyboard?.instantiateViewController(withIdentifier: "VehicleInfoViewController") as! VehicleInfoViewController
        self.navigationController?.pushViewController(vehicleVC, animated: true)
    }

    func redirectToVehicleInfoReject(_ notification_type:String) {
        self.navigationController?.popToViewController(self, animated: false)
        let vehicleVC = self.storyboard?.instantiateViewController(withIdentifier: "VehicleInfoViewController") as! VehicleInfoViewController
        self.navigationController?.pushViewController(vehicleVC, animated: true)
    }
    func redirectToChangeServiceReject(_ message:String, _ serviceType:String) {
        let changeServiceVC = self.storyboard?.instantiateViewController(withIdentifier: "ChangeServiceViewController") as! ChangeServiceViewController
        changeServiceVC.isComeFromNotification = true
        changeServiceVC.messageRejections = message
        changeServiceVC.selectService = profileInfo?.service_type
        self.navigationController?.pushViewController(changeServiceVC, animated: true)
        
    }
    func redirectToInsuranceServiceReject(_ titleMessage:String, _ message:String) {
//        self.showInsuranceExpiredMessage(message, titleMessage, false, true)
    }
    func redirectToChangeServiceAccept(_ message:String, _ serviceType:String) {
            if SELECTED_TAB_INDEX == 0{
                self.myMovesViewController.availableMovesVC.getAllAvailableMoves ()
            }
    }
    
    func redirectToPromotionalNotification() {
        self.navigationController?.popToViewController(self, animated: false)
        let offerVC:DiscountofferViewController = self.storyboard?.instantiateViewController(withIdentifier: "DiscountofferViewController") as! DiscountofferViewController
        offerVC.delegate = self
        self.navigationController?.pushViewController(offerVC, animated: true)
    }
    
    func redirectToSimpleNotification(_ userInfo: [AnyHashable : Any]) {
        self.navigationController?.popToViewController(self, animated: false)
        let offerVC:DiscountofferViewController = self.storyboard?.instantiateViewController(withIdentifier: "DiscountofferViewController") as! DiscountofferViewController
        offerVC.delegate = self
        self.navigationController?.pushViewController(offerVC, animated: true)
        
        let pramotionalVC = self.storyboard?.instantiateViewController(withIdentifier: "SimpleNotificationsAlertViewController") as! SimpleNotificationsAlertViewController
        pramotionalVC.modalPresentationStyle = .overFullScreen
        pramotionalVC.titleText = (userInfo[AnyHashable("gcm.notification.notification_title")] as! NSString) as String
        pramotionalVC.desc = (userInfo[AnyHashable("gcm.notification.notification_text")] as! NSString) as String
        StaticHelper.mainWindow().rootViewController?.topMostViewController().navigationController?.present(pramotionalVC, animated: true, completion: nil)
    }
    
    func redirectToAppUpdate() {
        discountOfferTab = 1
        self.navigationController?.popToViewController(self, animated: false)
        let offerVC:DiscountofferViewController = self.storyboard?.instantiateViewController(withIdentifier: "DiscountofferViewController") as! DiscountofferViewController
        offerVC.delegate = self
        self.navigationController?.pushViewController(offerVC, animated: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            appDelegate.isUpdateAvailable() { hasUpdates in
                print("is update available: \(hasUpdates)")
                if(hasUpdates == true) {
                    appDelegate.updateAppAlert()
                } else{
                    StaticHelper.mainWindow().rootViewController?.topMostViewController().view.makeToast("You are using the latest app version")
                }
            }
        }
        return
    }
    
    func redirectToChatMessage(_ userInfo: [AnyHashable : Any]) {
        
        SELECTED_TAB_INDEX = 2
        showChangeRequestPopUp(0)

        self.navigationController?.popToViewController(self, animated: true)
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.rightBarButtonItems = nil
        self.myMovesLabel.textColor = dullColor
        self.scheduleLabel.textColor = dullColor
        self.messageLabel.textColor = violetColor
        self.notificationLabel.textColor = dullColor
        self.moreLabel.textColor = dullColor
        self.myMoveImgView.image = UIImage.init(named: "my_move_unslct_icon")
        self.scheduleImgView.image = UIImage.init(named: "scheduled_unslct_icon")
        self.messageImgView.image = UIImage.init(named: "message_slct_icon")
        self.notificationImgView.image = UIImage.init(named: "notification_unslct_icon")
        self.moreImgView.image = UIImage.init(named: "more_unslct_icon")
        
        self.collectionView.delegate = self
        self.collectionView.reloadData()
        self.collectionView.layoutIfNeeded()

        self.collectionView.scrollToItem(at: IndexPath.init(item: 2, section: 0), at: .centeredHorizontally, animated: false)
        self.messagesViewController.redirectToTheMessage(userInfo)
    }
    
    
    //NOTIFICATION_TYPE 1
    func redirectToMoveDetails(_ userInfo: [AnyHashable : Any]) {
        if let request_id = userInfo[AnyHashable("request_id")] {

            if (appDelegate.notification_flag == "CUSTOMER_EDIT_JOB") {
                let moveDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "MoveDetailsViewController") as! MoveDetailsViewController
                moveDetailsVC.moveID = Int(request_id as? String ?? "") ?? 0
                moveDetailsVC.isHideAcceptButton = true
                self.navigationController?.pushViewController(moveDetailsVC, animated: true)

            } else if (appDelegate.notification_flag == "HELPER_REMINDER"){
                let ongoingVC = self.storyboard?.instantiateViewController(withIdentifier: "OnGoingServiceViewController") as! OnGoingServiceViewController
                ongoingVC.isFromPending = false
                //let itemDict = (arrScheduledMoveDict[indexPath.row])
                ongoingVC.moveID = Int(request_id as? String ?? "") ?? 0
                //ongoingVC.moveType = MoveType.Scheduled
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HELPER_REMINDER"), object: nil)

                self.navigationController?.pushViewController(ongoingVC, animated: true)
            }else {
                if let helperStatus = userInfo["status"] as? String {
                    if (helperStatus == "1") {//when any customer book move get status 1
                        self.redirectToMyMoveTab(section: 0)
//                        isProgressShowForce = true
//                        let moveDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "MoveDetailsViewController") as! MoveDetailsViewController
//                        moveDetailsVC.moveID = Int(request_id as? String ?? "") ?? 0
//                        moveDetailsVC.isHideAcceptButton = false
//                        moveDetailsVC.isHideCallAndChatBtn = true
//                        self.navigationController?.pushViewController(moveDetailsVC, animated: true)
                    } else if (helperStatus == "10") {
                        isProgressShowForce = true
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OngoingService"), object: nil)
                        let moveDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "MoveDetailsViewController") as! MoveDetailsViewController
                        moveDetailsVC.isFromOngoing = true
                        moveDetailsVC.isHideAcceptButton = true
                        moveDetailsVC.moveID = Int(request_id as? String ?? "") ?? 0
                        self.navigationController?.pushViewController(moveDetailsVC, animated: true)
                        return
                    }
                }
            }
        }
    }
    func redirectToTheMoveDetailsScreen(_ userInfo: [AnyHashable : Any]) {
        if let request_id = userInfo[AnyHashable("request_id")] {
            let moveDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "MoveDetailsViewController") as! MoveDetailsViewController
            moveDetailsVC.isHideAcceptButton = true
            moveDetailsVC.moveID = Int(request_id as? String ?? "") ?? 0
            moveDetailsVC.moveType = MoveType.Complete
            self.navigationController?.pushViewController(moveDetailsVC, animated: true)
            
        }
    }
}

extension HomeViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let vcContainerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeVCContainerCollectionViewCell", for: indexPath) as! HomeVCContainerCollectionViewCell
        
        if indexPath.item == 0{
            if !vcContainerCell.subviews.contains(myMovesViewController.view){
             vcContainerCell.addSubview(myMovesViewController.view)
            }
        }
        else if indexPath.item == 1{
            if !vcContainerCell.subviews.contains(scheduledViewController.view){
                vcContainerCell.addSubview(scheduledViewController.view)
            }
        }
        else if indexPath.item == 2{
            if !vcContainerCell.subviews.contains(messagesViewController.view){
                vcContainerCell.addSubview(messagesViewController.view)
            }
        }
        else if indexPath.item == 3{
            if !vcContainerCell.subviews.contains(notificationViewController.view){
                vcContainerCell.addSubview(notificationViewController.view)
                self.notificationViewController.getNotifications()
            }
        }
        else{
            if !vcContainerCell.subviews.contains(moreViewController.view){
                vcContainerCell.addSubview(moreViewController.view)
            }
        }
        return vcContainerCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.hasNotch {
            return  CGSize.init(width: SCREEN_WIDTH, height: SCREEN_HEIGHT  - 64 - 40 * screenHeightFactor)
        } else{
            return  CGSize.init(width: SCREEN_WIDTH, height: SCREEN_HEIGHT  - 64 * screenHeightFactor)
        }
    }
}
extension HomeViewController{
    func getDefaultValueCancelationFee() {
          
            let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
            AF.request(baseURL + kAPIMethods.get_default_value, method: .get, headers: header).responseJSON { (response) in
                switch response.result {
                case .success:
                    //StaticHelper.shared.stopLoader()
                    if response.response?.statusCode == 200{
                        let res = response.value as! [String: Any]
                        print(response)
                        print("getDefaultValueCancelationFee Response res \(res)")
                        UserCache.shared.updateUserProperty(forKey: kUserCache.cancalationFeeText, withValue:  res["HELPER_CANCELLATION_TEXT"] as AnyObject)
                        UserCache.shared.updateUserProperty(forKey: kUserCache.cancalationFeeHour, withValue:  res["HELPER_CANCELLATION_HOUR"] as AnyObject)
                        UserCache.shared.updateUserProperty(forKey: kUserCache.helperStartServisPoupText, withValue:  res["HELPER_START_SERVICE_POPUP_TEXT"] as AnyObject)
                        if let text = res["WEB_VIEW_DOMAIN"]{
                            appDelegate.baseContentURL = "\(text)"
                        }
                        if let text = res["GOOGLE_MAP_API_KEY"]{
                            appDelegate.googleMapAPIKey = "\(text)"
                        }
                        GMSPlacesClient.provideAPIKey("\(appDelegate.googleMapAPIKey)")

                    }
                    else if response.response?.statusCode == 401{
                        //StaticHelper.shared.stopLoader()
//                        print("updateDevice Error \(response.response?.statusCode)")
                    }
                case .failure(let error):
                    //StaticHelper.shared.stopLoader()
                    print("getDefaultValueCancelationFee error :-  \(error)")
                }
            }
    }
}
extension UIButton{
     func blink() {
         self.alpha = 0.2
         UIButton.animate(withDuration: 0.5, delay: -0.5, options: [.curveLinear, .repeat, .autoreverse], animations: {self.alpha = 1.0}, completion: nil)
     }
}
extension HomeViewController:RefreshNotifcationBagCount {
    func reloadNotificationCount() {
        if appNotificationCount != 0{
            DispatchQueue.main.async {
                self.navigationItem.leftBarButtonItem!.setBadge(text: "")
            }
        }
    }
}
// MARK: - ALert Permmison method's ....
extension HomeViewController:AlertViewPermmisionDelegate{
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
