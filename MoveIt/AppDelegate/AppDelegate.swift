//
//  AppDelegate.swift
//  MoveIt
//
//  Created by Jyoti on 12/04/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
//import FirebaseInstanceID
import FirebaseMessaging
import Crashlytics
import GoogleMaps
import GooglePlaces
import Alamofire
import AdSupport
import IQKeyboardManagerSwift
import AppTrackingTransparency
//
public var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
}
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate, CLLocationManagerDelegate  {
   
    //Set Application mode, when isLiveMode is false------> STAGING url will be called. (OR) isLiveMode is true------> LIVE url will be called
    let isLiveMode:Bool = true
    
    var baseContentURL:String = "https://gomoveit.com/"
    var googleMapAPIKey:String = "AIzaSyBpix5fIryUOOxewaG6lmnyseg5r4ZUvuo"
    
    var locationUpdateStart = false
    var locationUpdateStop = false
    var currentLocation : CLLocation?
    
    var strLat = ""
    var strLng = ""
    
    var window: UIWindow?
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    let adminstoryBoard = UIStoryboard(name: "AdminChat", bundle: nil)
    
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    var locationManager: CLLocationManager?
    var dt: Date?
    var count = 0

    var moveInfoRequestID:Int = 0
    
    var homeVC:HomeViewController?
    var adminVC:AdminChatViewController?

    var lanchedViaAPNS:Bool = false
    var notification_type:String = ""
    var notification_flag:String = ""
    var userInfoAPNS: [AnyHashable : Any]!
    var wantToShow:Bool = true
    
    //For reject account
    var helperType:Int = HelperType.Pro
    var blockVC:BlockUserViewController!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Thread.sleep(forTimeInterval: 1.0)
//      HelperApplicationMode?.isStaging = true // Set true for staging false for the live mode
        IQKeyboardManager.shared.enable = true
        UITextField.appearance().tintColor = darkPinkColor
        UITextView.appearance().tintColor = darkPinkColor
        GMSPlacesClient.provideAPIKey("\(appDelegate.googleMapAPIKey)")
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(
          UIApplication.backgroundFetchIntervalMinimum)
        
        UIApplication.shared.applicationIconBadgeNumber = 0

        let remoteNotif = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification]
            
        if remoteNotif != nil {
            self.lanchedViaAPNS = true
            self.configureNotification(application)
            self.verifyUserStateAndNavigateToTheSpecificController()
            self.checkForAppVersionUpdate()
        } else {
            let completedStep =  Int(UserCache.shared.userInfo(forKey: kUserCache.completedStep)  as? Int ?? 0)
            if(completedStep > 0) {
                self.configureNotification(application)
                self.verifyUserStateAndNavigateToTheSpecificController()
                self.checkForAppVersionUpdate()
            } else {
                //Push notification
                self.requestNotificationAuthorization(application: application)
            }
        }
//        self.showBlockedMessage()
        return true
    }
    func registerForRemoteNotification() {
            if #available(iOS 10.0, *) {
                let center  = UNUserNotificationCenter.current()

                center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                    if error == nil{
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }

            }
            else {
                UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    func verifyUserStateAndNavigateToTheSpecificController() {
        
        if UserCache.userToken() != nil {
            let completedStep =  Int(UserCache.shared.userInfo(forKey: kUserCache.completedStep) as? Int ?? 0)
            let serviceType = Int(UserCache.shared.userInfo(forKey: kUserCache.service_type) as? Int ?? 0)
            let isAgree = Int(UserCache.shared.userInfo(forKey: kUserCache.is_agree) as? Int ?? 0)
            let isVerifiedAccount = Int(UserCache.shared.userInfo(forKey: kUserCache.is_verified) as? Int ?? 0)
            let isSecurityAdded = Int(UserCache.shared.userInfo(forKey: kUserCache.is_security_key_added) as? Int ?? 0)
//          let w9_form_status = Int(UserCache.shared.userInfo(forKey: kUserCache.w9_form_status) as? Int ?? 0)
//          let w9_form_verified = Int(UserCache.shared.userInfo(forKey: kUserCache.w9_form_verified) as? Int ?? 0)
            
            switch completedStep{
            case 1:
                if serviceType == HelperType.Pro || serviceType == HelperType.ProMuscle {
                    StaticHelper.moveToViewController("Step2ViewController", animated: false)
                } else {
                    StaticHelper.moveToViewController("Step4ViewController", animated: false)
                }
            case 2:
                StaticHelper.moveToViewController("Step3ViewController", animated: false)
            case 3:
                StaticHelper.moveToViewController("Step4ViewController", animated: false)
            case 4:
                StaticHelper.moveToViewController("Step5ViewController", animated: false)
            case 5:
                if isAgree == 0 {
                    StaticHelper.moveToViewController("PdfViewerViewController", animated: false)
                } else if isSecurityAdded == 0 {
                    StaticHelper.moveToViewController("SocialSecurityViewController", animated: false)
                } else {
                    if isVerifiedAccount == 1 {
                        self.gotoHomeVC()
//                        if(w9_form_status == 1 && w9_form_verified == 1) {
//                            self.gotoHomeVC()
//                        } if(w9_form_status == 0 && w9_form_verified == 0) {
//                            self.gotoW9FormVC()
//                        } else if(w9_form_status == 1 && w9_form_verified == 0) {
//                            self.gotoHomeVC()
//                        }
                    } else {
                        StaticHelper.moveToViewController("PendingVerificationVC", animated: false)
                    }
                }
            default:
                break
            }
        }
    }
    
    //MARK: - Notification Methods
    
    func requestNotificationAuthorization(application: UIApplication) {
        
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {bool, error in
                
                DispatchQueue.main.async {
                
                    self.configureNotification(application)
                    self.verifyUserStateAndNavigateToTheSpecificController()
                    self.checkForAppVersionUpdate()
                }
            })
    }
    
    func codeForTrayMessage(){
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {bool, error in
                
                DispatchQueue.main.async {
                
                }
            })
    }
    func configureNotification(_ application:UIApplication) {
        self.codeForTrayMessage()
        // For iOS 10 data message (sent via FCM
            Messaging.messaging().delegate = self
            application.registerForRemoteNotifications()
            
            FirebaseApp.configure()
            Messaging.messaging().isAutoInitEnabled = true
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotification), name: .MessagingRegistrationTokenRefreshed, object: nil)
        
//        registerForRemoteNotification()
    }
    
    func application(received remoteMessage: MessagingDelegate) {
        print(remoteMessage.description)
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingDelegate) {
        print("Received data message: \(remoteMessage.description)")
    }
    
    @objc func tokenRefreshNotification(_ notification: Notification) {
      
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
            print("FCM refresh token: \(token)")
            UserDefaults.standard.set(token, forKey: "UserToken")
          }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
            print("FCM registration token: \(token)")
            UserDefaults.standard.set(token, forKey: "UserToken")
          }
        }
    }
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        UserDefaults.standard.set(fcmToken, forKey: "UserToken")
    }
    
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        NSLog("[RemoteNotification] didRefreshRegistrationToken: \(fcmToken)")
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //use for update notificaiton status isDeliverd but not read...
        if let is_updateT = userInfo[AnyHashable("is_update")] {
            if let is_update = is_updateT as? String{
                if is_update == "1"{
                    if let notification_idT = userInfo[AnyHashable("notification_id")] {
                        if let notification_id = notification_idT as? String{
                            self.updateNotificationStatusAPIBackground(parameters: ["notification_id":"\(notification_id)", "is_delivered" : "1", "is_read": "0"])
                        }
                    }
                }
            }
        }
        //Calling in background also
        if let request_id = userInfo[AnyHashable("request_id")] {
            if let requestId = request_id as? String {
                self.updateHelperNotification(requestId: requestId)
            }
        }
//      (notification_type"): ADMIN_CHAT
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if let viewController =  StaticHelper.mainWindow().rootViewController?.topMostViewController(), viewController is HomeViewController {
                if let homeVCT = viewController as? HomeViewController{
                    homeVCT.refreshNotificationCount()
                }
            }
        }

        Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print(userInfo)
        Messaging.messaging().appDidReceiveMessage(userInfo)
    }
        
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadPendingHelper"), object: nil)

        self.notificationLogic(response.notification.request.content.userInfo)
        
//        if wantToShow {
//                 completionHandler([.alert, .sound])
//        } else {
//                 completionHandler([])
//        }
        
        completionHandler()
    }
    
    func notificationLogic(_ userInfo: [AnyHashable : Any]) {
        
        let deviceToken = UserDefaults.standard.value(forKey: "UserToken") as! String
        //use for update notificaiton status isDeliverd & isRead...
        if let is_update = userInfo["is_update"] as? String{
            if is_update == "1"{
                if let notification_id = userInfo["notification_id"] as? String{
                    CommonAPIHelper.updateNotificationStatusAPI(parameters: ["notification_id":"\(notification_id)", "is_delivered" : "1", "is_read": "1"])
                    
                }
            }
        }
        if (deviceToken).count > 0 {
            userInfoAPNS = userInfo
            print("userInfo = ", userInfo)
            
            self.notification_type = (userInfo[AnyHashable("notification_type")] as? String) ?? ""
            self.notification_flag = (userInfo[AnyHashable("notification_flag")] as? String) ?? ""
            print(self.notification_type)
            print(self.notification_flag)
            //HELPER_REMINDER
            if(notification_type != "") {
                
                if ((notification_type == "ACCEPT_VEHICLE_REQUEST")) {
                    gotoHomeVC()
                    return
                }else if (notification_type == "REJECT_VEHICLE_REQUEST") {
                    var isServiceFlag = "false"
                    if let changeService = (userInfo[AnyHashable("change_service")] as? String){
                        isServiceFlag = changeService
                    }
                    var is_insurance_request = "false"
                    if let is_insurance_requestT = (userInfo[AnyHashable("is_insurance_request")] as? String){
                        is_insurance_request = is_insurance_requestT
                    }
                    if (is_insurance_request != "false" && isServiceFlag == "false"){
                        if(homeVC != nil) {
                            let changeServiceMessage = (userInfo[AnyHashable("message")] as? String) ?? ""
                            let titleMessage = (userInfo[AnyHashable("insurance_message_title")] as? String) ?? ""
                            self.homeVC?.redirectToInsuranceServiceReject((titleMessage ?? "Vehicle Insurance Update Request Rejected"), changeServiceMessage)
                        }
                    }else if (is_insurance_request == "false" && isServiceFlag == "false"){
//                        if(homeVC != nil) {
//                            if(self.lanchedViaAPNS == false) {
//                                self.homeVC?.redirectToVehicleInfoReject(notification_type)
//                            }
//                        }
                        DispatchQueue.main.async {
                            let VehicleInfoVC = self.storyBoard.instantiateViewController(withIdentifier: "VehicleInfoViewController") as! VehicleInfoViewController
                            StaticHelper.mainWindow().rootViewController?.topMostViewController().navigationController?.pushViewController(VehicleInfoVC, animated: true)
                        }
                    }else if (is_insurance_request == "false" && isServiceFlag != "false"){
                        DispatchQueue.main.async {
                            let changeServiceMessage = (userInfo[AnyHashable("message")] as? String) ?? ""

                            let changeServiceVC = self.storyBoard.instantiateViewController(withIdentifier: "ChangeServiceViewController") as! ChangeServiceViewController
                            changeServiceVC.isComeFromNotification = true
                            changeServiceVC.messageRejections = changeServiceMessage
                            changeServiceVC.selectService = profileInfo?.service_type
                            StaticHelper.mainWindow().rootViewController?.topMostViewController().navigationController?.pushViewController(changeServiceVC, animated: true)
                        }
                    }
//                    if(homeVC != nil) {
//                        if let changeService = (userInfo[AnyHashable("change_service")] as? String){
//                            let changeService1 = (userInfo[AnyHashable("change_service")] as? String) ?? ""
//                            let changeServiceMessage = (userInfo[AnyHashable("message")] as? String) ?? ""
//                            self.homeVC?.redirectToChangeServiceReject(changeServiceMessage, changeService1)
//                        }else{
//                            if(self.lanchedViaAPNS == false) {
//                                self.homeVC?.redirectToVehicleInfoReject(notification_type)
//                            }
//                        }
//                    }
                    return
                }else if (notification_flag == "COMPLETE_YOUR_MOVE"){
                    
                    DispatchQueue.main.async {
                        if StaticHelper.mainWindow().rootViewController?.topMostViewController() is OnGoingServiceViewController {
                            let ongoingServiceVC:OnGoingServiceViewController? = StaticHelper.mainWindow().rootViewController?.topMostViewController() as? OnGoingServiceViewController
                            if(ongoingServiceVC != nil) {
                                //Update admin batch count
                                return
                            }
                        }
                        
                        let ongoingServiceVC = self.storyBoard.instantiateViewController(withIdentifier: "OnGoingServiceViewController") as! OnGoingServiceViewController
                        ongoingServiceVC.moveID = Int((userInfo[AnyHashable("request_id")] as? String) ?? "0")!
                        StaticHelper.mainWindow().rootViewController?.topMostViewController().navigationController?.pushViewController(ongoingServiceVC, animated: true)
                    }
                }else if (notification_type == "W-9_FORM_REMINDER"){
                    let window = StaticHelper.mainWindow()
                    if let navController: UINavigationController = window.rootViewController as? UINavigationController{
                        let w9FormVC = W9FormViewController()
                        w9FormVC.isFromProfile = true
                        w9FormVC.isReminder = true
                        
                        navController.pushViewController(w9FormVC, animated: false)
                    }
                }else if (notification_type == "ADMIN_CHAT"){
                    DispatchQueue.main.async {
                        let adminChatVC = self.adminstoryBoard.instantiateViewController(withIdentifier: "AdminChatViewController") as! AdminChatViewController
                        adminChatVC.helperName = "Move It Support"
                        adminChatVC.socketConnection()
                        StaticHelper.mainWindow().rootViewController?.topMostViewController().navigationController?.pushViewController(adminChatVC, animated: true)
                    }
                } else if (notification_type == "UPLOAD_INSURANCE_NOTIFICATION") {
                    if(homeVC != nil) {
                        if(self.lanchedViaAPNS == false) {
                            self.homeVC?.redirectToVehicleInfoUpdate(notification_type)
                        }
                    }
                    return
                } else if (notification_type == "PROMOTIONAL_NOTIFICATION") {
                    if(homeVC != nil) {
                        if(self.lanchedViaAPNS == false) {
                            self.homeVC?.redirectToPromotionalNotification()
                        }
                    }
                    return
                } else if (notification_type == "SIMPLE_NOTIFICATION") {
                    if(homeVC != nil) {
                        if(self.lanchedViaAPNS == false) {
                            self.homeVC?.redirectToSimpleNotification(userInfo)
                        }
                    }
                    return
                } else if (notification_type == "APP_UPDATE_NOTIFICATION") {
                    if(homeVC != nil) {
                        if(self.lanchedViaAPNS == false) {
                            self.homeVC?.redirectToAppUpdate()
                        }
                    }
                    return
                } else if (notification_type == "MESSAGE_NOTIFICATION") {
                    if(homeVC != nil) {
                        if(self.lanchedViaAPNS == false) {
                            self.homeVC?.redirectToChatMessage(userInfo)
                        }
                    }
                    return
                } else if (notification_type == "1") {
                    
                    //                    Notification type 1 (New Job)
                    //                    status
                    //                    2 - HELPER_ACCEPTED_MOVE
                    //                    6 - HELPER_CANCELLED_MOVE
                    //                    10 -  Helper Edited Request
                    
                    if (notification_flag == "HELPER_BLOCKED") {
                        if(homeVC != nil) {
                            self.showBlockedMessage()
                        }
                    } else if (notification_flag == "HELPER_UNBLOCK") {
                        if(homeVC != nil) {
                            self.hideBlockedMessage()
                        }
                    } else if (notification_flag == "CUSTOMER_EDIT_JOB") {
                        if(homeVC != nil) {
                            homeVC?.redirectToMoveDetails(userInfo)
                        }
                    }else if (notification_flag == "HELPER_REMINDER") {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HELPER_REMINDER"), object: nil)
                        homeVC?.redirectToMoveDetails(userInfo)
                    } else if (notification_flag == "W9_FORM_REJECT") {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "W9_FORM_REJECT"), object: nil)
                    } else {
                        if(homeVC != nil) {
                            if(self.lanchedViaAPNS == false) {
                                
                                //INSIDE request_id
                                if let request_id = userInfo[AnyHashable("request_id")] {
                                    
                                    if let requestId = request_id as? String {
                                        self.updateHelperNotification(requestId: requestId)
                                    }
                                    self.homeVC?.redirectToMoveDetails(userInfo)
                                } else { //OUTSIDE request_is
                                    
                                    //ZOMBIE(27/11/2021):YE WALA MUJHE CHECK KARNA HAI YE KAUN SI CONDITION HAI
                                    redirectMove = true
                                    redirectMoveType = 0
                                    if let helperStatus = userInfo["status"] as? String{
                                        if (helperStatus == "2") {//
                                            redirectMoveType = 1
                                            isPendingScheduled = false
                                            if(homeVC != nil) {
                                                homeVC?.redirectToScheduledTab(section: 0)
                                            }
                                        } else if (helperStatus == "6") {
                                            redirectMoveType = 1
                                            isPendingScheduled = true
                                            if(homeVC != nil) {
                                                homeVC?.redirectToScheduledTab(section: 1)
                                            }
                                        } else if (helperStatus == "10") {
                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OngoingService"), object: nil)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    return
                } else if (notification_type == "3") && notification_flag == "INSURANCE_EXPIRE_REMINDER" {
                    if(homeVC != nil) {
                            if(self.lanchedViaAPNS == false) {
                                self.homeVC?.redirectToVehicleInfoReject(notification_type)
                            }
                    }
                    return
                }else if (notification_type == "CANCELLATION_CHARGE"){
                    if(homeVC != nil) {
                        homeVC?.redirectToTheMoveDetailsScreen(userInfo)
                    }
                }else { //notification_type 1
                    //else
                }
            }//notification_type
        }//deviceToken
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo

        let deviceToken = UserDefaults.standard.value(forKey: "UserToken") as! String
        //use for update notificaiton status isDeliverd but not read...
        if let is_update = userInfo["is_update"] as? String{
            if is_update == "1"{
                if let notification_id = userInfo["notification_id"] as? String{
                    CommonAPIHelper.updateNotificationStatusAPI(parameters: ["notification_id":"\(notification_id)", "is_delivered" : "1", "is_read": "0"])
                    
                }
            }
        }
        if (deviceToken).count > 0 {
            userInfoAPNS = userInfo
            print("userInfo = ", userInfo)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ADMIN_CHAT_COUNT"), object: nil)

            self.notification_type = (userInfo[AnyHashable("notification_type")] as? String) ?? ""
            self.notification_flag = (userInfo[AnyHashable("notification_flag")] as? String) ?? ""
            if(notification_type != "") {
                 if (notification_type == "ADMIN_CHAT") {

                    if StaticHelper.mainWindow().rootViewController?.topMostViewController() is AdminChatViewController {
                        let chatVC:AdminChatViewController? = StaticHelper.mainWindow().rootViewController?.topMostViewController() as? AdminChatViewController
                        if(chatVC != nil) {
                            //Update admin batch count
                            return
                        }
                    }
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ADMIN_CHAT_COUNT"), object: nil)
                    completionHandler(.alert)
                }else if (notification_type == "ACCOUNT_REJECTED") {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ACCOUNT_REJECTED"), object: nil)
                } else if (notification_flag == "W9_FORM_ACCEPT") {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "W9_FORM_ACCEPT"), object: nil)
                    UserCache.saveW9UserData(w9_form_status: 1, w9_form_verified: 1)
                } else if (notification_flag == "W9_FORM_REJECT") {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "W9_FORM_REJECT"), object: nil)
                }else if (notification_type == "W-9_FORM_REMINDER"){
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "W9_FORM_REMINDER"), object: nil)
//                    let window = StaticHelper.mainWindow()
//                    if let navController: UINavigationController = window.rootViewController as? UINavigationController{
//                    let w9FormVC = W9FormViewController()
//                    w9FormVC.isFromProfile = true
//                    navController.pushViewController(w9FormVC, animated: false)
                    
                } else if (notification_type == "MESSAGE_NOTIFICATION") {
                    if(homeVC != nil) {
                        
                        if let customer_id = userInfo[AnyHashable("customer_id")] as? String{
                            let chatVC:ChatViewController? = homeVC?.messagesViewController.customerChatVC.chatVC
                            if let requestId = userInfo[AnyHashable("request_id")] as? String {
                                chatVC?.requestId = requestId
                            }
                            if(chatVC != nil) {
                                if "\(customer_id)" == "\(chatVC!.customer_ID)"{
                                    return
                                }
                            }
                            completionHandler(.alert)
                        } else if let helper_id = userInfo[AnyHashable("helper_id")] {
                            let chatVC:ChatViewController? = homeVC?.messagesViewController.customerChatVC.chatVC
                            guard let requestId = userInfo[AnyHashable("request_id")] as? String else {return}
                            chatVC?.requestId = requestId
                            if(chatVC != nil) {
                                if "\(helper_id)" == "\(chatVC!.customer_ID)"{
                                    return
                                }
                            }
                            completionHandler(.alert)
                        }
                    }
                    return
                } else if (notification_type == "2") { //Profile virification approved
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "profileVerifiedByAdmin"), object: nil)
                    completionHandler(.alert)
                    return
                } else if (notification_flag == "HELPER_BLOCKED") {
                    self.showBlockedMessage()
                } else if (notification_flag == "HELPER_UNBLOCK") {
                    self.hideBlockedMessage()
                } else if(homeVC != nil) {
                    self.homeVC?.refreshForgroundNotification()
                }
                completionHandler(.alert)
                return;
            }
                        
            if let nType = userInfo[AnyHashable("notification_type")] {
                if let notiType = nType as? NSString {
                    if (notiType == "ADMIN_CHAT") {

                       if StaticHelper.mainWindow().rootViewController?.topMostViewController() is AdminChatViewController {
                           let chatVC:AdminChatViewController? = StaticHelper.mainWindow().rootViewController?.topMostViewController() as? AdminChatViewController
                           if(chatVC != nil) {
                               //Update admin batch count
                               return
                           }
                       }

//                       NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ADMIN_CHAT_COUNT"), object: nil)

                       completionHandler(.alert)
                   }else if (notiType == "MESSAGE_NOTIFICATION") {
                        
                        if StaticHelper.mainWindow().rootViewController?.topMostViewController() is ChatViewController {
                            
                            if let cID = userInfo[AnyHashable("customer_id")] {
                                let chatVC:ChatViewController? = StaticHelper.mainWindow().rootViewController?.topMostViewController() as? ChatViewController
                                guard let requestId = userInfo[AnyHashable("request_id")] as? String else {return}
                                chatVC?.requestId = requestId 
                                if(chatVC != nil) {
                                    if "\(cID)" == "\(chatVC!.customer_ID)"{
                                        return
                                    }
                                }
                            }
                        }
                        completionHandler(.alert)
                    }else if (notiType == "2") {
                        //This is when aproved account after signUp
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "profileVerifiedByAdmin"), object: nil)
                        completionHandler(.alert)
                        return
                    } else {
                        completionHandler(.alert)
                        return
                    }
                } else {
                    completionHandler(.alert)
                    return
                }
            } else {
                completionHandler(.alert)
                return
            }
            completionHandler(.alert)
            return
        }
    }
    
    func updateHelperNotification(requestId : String) {
        if requestId != "" {
            if(UserCache.userToken() == nil) {
                return
            }
            
            let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
            let parameters: Parameters = ["request_id" : requestId]
            AF.request(baseURL + kAPIMethods.update_helper_notification, method: .post, parameters: parameters,headers: header).responseJSON { (response) in
                switch response.result {
                case .success:
                    //StaticHelper.shared.stopLoader()
                    if response.response?.statusCode == 200{
                        //let res = response.value as! [String: Any]
                        //    let nextPageAvailable = (res["next_page"] as! Bool)
                        print("updateDevice Successfully")
                    }
                    else if response.response?.statusCode == 401{
                        //StaticHelper.shared.stopLoader()
//                        print("updateDevice Error \(response.response?.statusCode)")
                    }
                case .failure(let error):
                    //StaticHelper.shared.stopLoader()
                    print("updateDevice \(error)")
                }
            }
        }
    }
    func updateNotificationStatusAPIBackground(parameters:[String:Any]){
            if(UserCache.userToken() == nil) {
                return
            }
            
//       let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!,"Content-Type":"application/json"]
        let queue = DispatchQueue(label: "com.test.api", qos: .background, attributes: .concurrent)

        print(parameters,header)
        AF.request(baseURL + kAPIMethods.update_notification_status, method: .post, parameters: parameters,headers: header).responseJSON(queue:queue) { (response) in
                switch response.result {
                case .success:
                    //StaticHelper.shared.stopLoader()
                    if response.response?.statusCode == 200{
                        //let res = response.value as! [String: Any]
                        //    let nextPageAvailable = (res["next_page"] as! Bool)
                        print("updateDevice Successfully")
                    }
                    else if response.response?.statusCode == 401{
                        //StaticHelper.shared.stopLoader()
//                        print("updateDevice Error \(response.response?.statusCode)")
                    }
                case .failure(let error):
                    //StaticHelper.shared.stopLoader()
                    print("updateDevice \(error)")
                }
            }
    }
    //MARK: - Location Methods
    func locationSetup() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.distanceFilter = 10
        locationManager?.startUpdatingLocation()
        locationManager?.startMonitoringSignificantLocationChanges()
        locationManager?.allowsBackgroundLocationUpdates = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)
        if let location = locations.first {
            strLat = String(location.coordinate.latitude)
            strLng = String(location.coordinate.longitude)
            
            if dt == nil {
                dt = Date()
            }
            if locationUpdateStop == true {
                print("Location Update Stop")
                manager.stopUpdatingLocation()
                return
            }
            if Date().interval(ofComponent: .second, fromDate: dt ?? Date()) > 6 {
                //scheduleNotification(location: location)
                count = count+1
                dt = Date()
                print("Found user's location: \(location)")
                print("location update count: \(count)")
                currentLocation = location
                currentAddress(location.coordinate)
            }
        }
    }
    
    func currentAddress(_ coordinate:CLLocationCoordinate2D) -> Void
    {
        let loc = LocationManager()
        var addr = ""
        
        loc.getPlace(for: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { [self] (placemark) in
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
            if locationUpdateStart == true {
                if (moveInfoRequestID) != 0 {
                    self.driverSetLocation(requestId: moveInfoRequestID, lat: String(coordinate.latitude), long: String(coordinate.longitude), location: addr)
                }
            } else{
                locationUpdateStop = true
            }
        }
    }

    func driverSetLocation(requestId:Int?,lat:String?,long:String?,location:String?) {
        if requestId != nil {
            let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
            let parameters: Parameters = ["lat": lat ?? "","lng": long ?? "","address": location ?? "","request_id": requestId ?? 0]
            AF.request(baseURL + kAPIMethods.save_helper_job_location, method: .post, parameters: parameters,headers: header).responseJSON { (response) in
                switch response.result {
                case .success:
                    //StaticHelper.shared.stopLoader()
                    if response.response?.statusCode == 200{
                        //let res = response.value as! [String: Any]
                        //    let nextPageAvailable = (res["next_page"] as! Bool)
                        print("update Location Successfully")
                    }
                    else if response.response?.statusCode == 401{
                        //StaticHelper.shared.stopLoader()
                    }
                case .failure(let error):
                    //StaticHelper.shared.stopLoader()
                    print("update Location \(error)")
                }
            }
        }
    }

    //MARK: - App Version Update
    
    func checkForAppVersionUpdate()
    {
        if baseURL != "https://devapi.gomoveit.com/api/helper/v5/"{
            self.isUpdateAvailable() { hasUpdates in
              print("is update available: \(hasUpdates)")
                
                if(hasUpdates == true) {
                    self.updateAppAlert()
                }
            }
        }

    }
    
    func updateAppAlert() {
        let viewUpdateBG = UIView()
        viewUpdateBG.frame = self.window!.bounds
        viewUpdateBG.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        
        
        var width:CGFloat = 320
        let space:CGFloat = 20
        
        if(self.window!.bounds.size.width < 500) {
            width = self.window!.bounds.size.width-40.0
        }
        
        let viewUpdate = UIView()
        viewUpdate.layer.cornerRadius = 10.0
        viewUpdate.clipsToBounds = true
        viewUpdate.frame = CGRect(x: (self.window!.bounds.size.width-width)/2.0, y: (self.window!.bounds.size.height-280)/2.0, width: width, height: 280)
        viewUpdate.backgroundColor = .white
        viewUpdateBG.addSubview(viewUpdate)
        

        let lblTitle = UILabel()
        lblTitle.frame = CGRect(x: 20, y: 20, width: width-space-space, height: 50)
        lblTitle.text = "Move It Update"
        lblTitle.textAlignment = .center
        lblTitle.font = UIFont.josefinSansBoldFontWithSize(size: 20.0)
        viewUpdate.addSubview(lblTitle)
        
        let lblDesc = UILabel()
        lblDesc.frame = CGRect(x: 20, y: 70, width: width-space-space, height: 60)
        lblDesc.numberOfLines = 0
        lblDesc.textColor = .darkGray
        lblDesc.textAlignment = .center
        lblDesc.font = UIFont.josefinSansRegularFontWithSize(size: 15.0)
        lblDesc.text = "We have a new release of the app with new features. Please update the app."
        viewUpdate.addSubview(lblDesc)

        let btnUpdate = UIButton()
        btnUpdate.setBackgroundImage(UIImage.init(named: "btn_gradient"), for: .normal)
        btnUpdate.frame = CGRect(x:20, y: 140+30, width: width-space-space, height: 60)
        btnUpdate.setTitle("Update Now", for: .normal)
        btnUpdate.titleLabel?.font = UIFont.josefinSansRegularFontWithSize(size: 17.0)
        btnUpdate.setTitleColor(.black, for: .normal)
        btnUpdate.addTarget(self, action: #selector(self.btnUpdateClicked), for: .touchDown)
        viewUpdate.addSubview(btnUpdate)
        self.window?.addSubview(viewUpdateBG)
    }
    
    @objc func btnUpdateClicked()
    {
        if let url = URL(string: "itms-apps://apple.com/app/1488199360") {
            UIApplication.shared.open(url)
        }
    }

    func isUpdateAvailable(callback: @escaping (Bool)->Void) {
        let bundleId = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
        AF.request("https://itunes.apple.com/lookup?bundleId=\(bundleId)").responseJSON { response in
          
            DispatchQueue.main.async {
                if let json = response.value as? NSDictionary, let results = json["results"] as? NSArray, let entry = results.firstObject as? NSDictionary, let versionStore = entry["version"] as? String, let versionLocal = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                  //print(json)
                  let arrayStore = versionStore.split(separator: ".")
                  let arrayLocal = versionLocal.split(separator: ".")

                  if Int(arrayStore[0]) ?? 0 > Int(arrayLocal[0]) ?? 0 {
                      callback(true) // different versioning system
                        return
                  } else if Int(arrayStore[0]) ?? 0 < Int(arrayLocal[0]) ?? 0 {
                      callback(false) // different versioning system
                        return
                  } else {
                      if Int(arrayStore[1]) ?? 0 > Int(arrayLocal[1]) ?? 0 {
                          callback(true) // different versioning system
                          return
                      } else if Int(arrayStore[1]) ?? 0 < Int(arrayLocal[1]) ?? 0 {
                          callback(false) // different versioning system
                          return
                      } else {
                          if Int(arrayStore[2]) ?? 0 > Int(arrayLocal[2]) ?? 0 {
                              callback(true) // different versioning system
                              return
                          } else if Int(arrayStore[2]) ?? 0 < Int(arrayLocal[2]) ?? 0 {
                              callback(false) // different versioning system
                              return
                          }
                      }
                  }
                }
                callback(false) // no new version or failed to fetch app store version
            }
        }
    }
    
    //MARK: -
    func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        assert(backgroundTask != .invalid)
    }
    
    func endBackgroundTask() {
        print("Background task ended.")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = .invalid
    }
    
    func gotoHomeVC() {
        let window = StaticHelper.mainWindow()
        
        if let navController: UINavigationController = window.rootViewController as? UINavigationController{
            
            if #available(iOS 13.0, *) {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                navController.navigationBar.standardAppearance = appearance;
                navController.navigationBar.scrollEdgeAppearance = appearance
            }
            navController.popToRootViewController(animated: false)
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            
            if(homeVC == nil) {
                self.homeVC = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                navController.pushViewController(homeVC!, animated: false)
            } else {
                homeVC = nil
                self.homeVC = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                navController.pushViewController(homeVC!, animated: false)
            }
            return
        }

    }
    
    func gotoW9FormVC() {
        let window = StaticHelper.mainWindow()
        
        if let navController: UINavigationController = window.rootViewController as? UINavigationController{
            
            if #available(iOS 13.0, *) {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                navController.navigationBar.standardAppearance = appearance;
                navController.navigationBar.scrollEdgeAppearance = appearance
            }
            navController.popToRootViewController(animated: false)
            let w9FormVC = W9FormViewController()
            w9FormVC.isFromProfile = false
            navController.pushViewController(w9FormVC, animated: false)
            return
        }

    }

    func showBlockedMessage() {
        self.blockVC = storyBoard.instantiateViewController(withIdentifier: "BlockUserViewController") as? BlockUserViewController
        self.window?.addSubview(self.blockVC.view)
    }
    
    func hideBlockedMessage() {
        if(self.blockVC != nil) {
            self.blockVC.view.removeFromSuperview()
            self.blockVC = nil
        }
    }
    
    //MARK: - App Life Cycle
//    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        // fetch data from internet now
//        guard let data = fetchSomeData() else {
//            // data download failed
//            completionHandler(.failed)
//            return
//        }
//
//        if data.isNew {
//            // data download succeeded and is new
//            completionHandler(.newData)
//        } else {
//            // data downloaded succeeded and is not new
//            completionHandler(.noData)
//        }
//    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        NotificationCenter.default.post(name: .braintreeConnectedRedirectNotification, object: url)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
//        if let view = UIApplication.topViewController() as? ChatViewController{
//        }
//        socketDisconnected()
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        self.askPermission()
//        if let view = UIApplication.topViewController() as? ChatViewController{
//        }
//        socketConnection()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func askPermission() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization { (status) in
                    //handled
                    print(status)
                }
            } else {
                // Fallback on earlier versions
            }
        })
    }

}

extension UIViewController {
    func topMostViewController() -> UIViewController {
        
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        
        return self
    }
    
    func setNavigationTitle(_ strTitle:String) {
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = UIColor.white
        
        let lblTitle = UILabel()
        let titleAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: violetColor, NSAttributedString.Key.font: UIFont.josefinSansSemiBoldFontWithSize(size: 15.0)]
        let attributeString = NSMutableAttributedString(string: strTitle, attributes: titleAttribute)
        lblTitle.attributedText = attributeString
        lblTitle.sizeToFit()
        navigationItem.titleView = lblTitle
    }

    func topNavigationViewController() -> UIViewController {
                
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        return self
    }
}
extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
//extension AppDelegate: UNUserNotificationCenterDelegate{
//
//  // This function will be called right after user tap on the notification
//  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//
//    // tell the app that we have finished processing the user’s action / response
//    completionHandler()
//  }
//}
//
