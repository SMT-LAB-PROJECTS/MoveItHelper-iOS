
import Foundation
import UIKit
import SocketIO


var SELECTED_TAB_INDEX:Int = 0
var SELECTED_MOVE_UPER_TAB_INDEX:Int = 0
var IS_AVAILABLE_MOVE_CONTAIN_DATA:Int = 0

let baseURL      = AddURL().baseURL()
//let signatureUrl = AddURL().signatureUrl()
let Socket_URL   = AddURL().Socket_URL()
//let basePath     = AddURL().basePath
//let agreement_URL = AddURL().agreement_URL()

struct AddURL{
    
//    var basePath = "https://gomoveit.com/"
        
    func baseURL()-> String{
        if appDelegate.isLiveMode{return "https://api.gomoveit.com/api/helper/v5/"}
        return "https://devapi.gomoveit.com/api/helper/v5/"
    }
    
//    func signatureUrl()-> String{
//        if appDelegate.isLiveMode{return "https://gomoveit.com/signature-pad/"}
//        return "https://dev.gomoveit.com/signature-pad/"
//    }
    
    func Socket_URL()-> String{
        if appDelegate.isLiveMode{return "https://gomoveit.com:3007/"}
        return "https://dev.gomoveit.com:3008/"
    }
//    func agreement_URL()-> String{
//        if appDelegate.isLiveMode{return "https://gomoveit.com/"}
//        return "https://dev.gomoveit.com/"
//    }
}
//https://dev.gomoveit.com/agreement-mobile?download=1

//ENUMs
enum `HelperType` {
    static let None = 0
    static let Pro = 1
    static let Muscle = 2
    static let ProMuscle = 3
}

enum `ChatUserType` {
    static let Customer = 1
    static let Helper = 2
    static let Admin = 3
}

enum `MoveType` {
    static let None = 0
    static let Available = 1
    static let Complete = 2
    static let Canceled = 3
    static let Scheduled = 4
    static let Pending = 5
}

//Did not use need to use
enum `APNSStatusType` {
    static let None = "0"
    static let NEW_MOVE = "1"
    static let HELPER_ACCEPTED_MOVE = "2"
    static let HELPER_CANCELLED_MOVE = "6"
    static let ACCEPT_REJECT_MOVE_EDIT_REQUEST = "10"
}

//-----------------Constants-----------------//

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let redColor     =  UIColor.init(red: 221.0/255.0, green: 54.0/255.0, blue: 42.0/255.0, alpha: 1.0)
let greenColor     =  UIColor.init(red: 46.0/255.0, green: 204.0/255.0, blue: 113.0/255.0, alpha: 1.0)
let violetColor     =  UIColor.init(red: 47.0/255.0, green: 44.0/255.0, blue: 61.0/255.0, alpha: 1.0)
let lightPinkColor  =  UIColor.init(red: 223.0/255.0, green: 211.0/255.0, blue: 234.0/255.0, alpha: 1.0)
let darkPinkColor   =  UIColor.init(red: 246.0/255.0, green : 174.0/255.0, blue: 180.0/255.0, alpha: 1.0)

let dullColor = UIColor.init(red: 168.0/255.0, green: 175.0/255.0, blue: 186.0/255.0, alpha: 1.0)
let lightBlueColor = UIColor.init(red: 50/255.0, green: 50/255.0, blue: 255/255.0, alpha: 1.0)

let greyplaceholderColor = UIColor.init(red: 152.0/255.0, green: 151.0/255.0, blue: 157.0/255.0, alpha: 1.0)
let otpFiledBgColor = UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.9)

var appNotificationCount = 0
var adminChatNotificationCount = 0
var messageNotificationCount = 0

var redirectMove = false
var redirectMoveType = 0
var isPendingScheduled = false
var discountOfferTab = 0

let modelName = UIDevice.modelName
var systemVersion = UIDevice.current.systemVersion
let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String


var screenHeightFactor = SCREEN_HEIGHT / 568.0
var screenWidthFactor = SCREEN_WIDTH / 320.0

let helper_sign_in          =    "helper-sign-in"
let helper_signup_step1     =    "helper-signup-step1"
let helper_signup_step2     =    "helper-signup-step2"
let helper_signup_step3     =    "helper-signup-step3"
let helper_signup_step4     =    "helper-signup-step4"
let helper_signup_step5     =    "helper-signup-step5"

let messageError            =     "Something went wrong. please try again later."
let Internet_Error          =     "Internet is offline. Please check Internet Connection."

var profileInfo : HelperDetailsModel?

struct OnboardService{
    static let isPrintLog                       =   true
}
struct APIMessages {
    static let internetError  = "Oops, your connection seems off… Keep calm, check your signal, and try again."
}
struct constantString{
    static let move_id                       =   "Move ID #"
}
struct vehicleInfoString{
    static let isComeFromPending                    =   "1"
    static let isComeFromInsuranceExpire            =   "2"
    static let isComeFromBoth                       =   "3"
}
struct keysForBookMoves{

    static let move_type_id                       =   "move_type_id"
    static let is_draft                           =   "is_draft"
    static let request_id                         =   "request_id"
    static let pickup_address                     =   "pickup_address"
    static let dropoff_address                    =   "dropoff_address"
    static let pickup_lat                         =   "pickup_lat"
    static let pickup_long                        =   "pickup_long"
    static let dropoff_lat                        =   "dropoff_lat"
    static let dropoff_long                       =   "dropoff_long"
    static let pickup_stairs                      =   "pickup_stairs"
    static let drop_off_stairs                    =   "drop_off_stairs"
    static let pickup_apartment                   =   "pickup_apartment"
    static let dropoff_apartment                  =   "dropoff_apartment"
    static let use_pickup_elevator                =   "use_pickup_elevator"
    static let use_dropoff_elevator               =   "use_dropoff_elevator"
    static let ride_with_helper                   =   "ride_with_helper"
    static let num_of_rider                       =   "num_of_rider"
    static let pickup_date                        =   "pickup_date"
    static let pickup_start_time                  =   "pickup_start_time"
    static let pickup_end_time                    =   "pickup_end_time"
    static let helping_service_id                 =   "helping_service_id"
    static let required_pros                      =   "required_pros"
    static let required_muscle                    =   "required_muscle"
    static let dropoff_service_id                 =   "dropoff_service_id"
    static let total_miles_distance               =   "total_miles_distance"
    static let is_promocode_applied               =   "is_promocode_applied"
    static let promocode                          =   "promocode"
    static let total_amount                       =   "total_amount"
    static let final_price                        =   "final_price"
    static let item_name                          =   "item_name"
    static let item_price                         =   "item_price"
    static let can_assamble                       =   "can_assamble"
    static let is_assamble                        =   "is_assamble"
    static let is_carry_with_people               =   "is_carry_with_people"
    static let item_width                         =   "item_width"
    static let item_height                        =   "item_height"
    static let item_depth                         =   "item_depth"
    static let item_weight                        =   "item_weight"
    static let additional_info                    =   "additional_info"
    static let item_photos                        =   "item_photo"
    static let is_custom_item                     =   "is_custom_item"
    static let quantity                           =   "quantity"
    static let muscle_price                       =   "muscle_price"
    static let pros_price                         =   "pros_price"
    static let insurance_charge                   =   "insurance_charge"
    static let helping_service_price              =   "helping_service_price"
    static let helping_service_required_pros      =   "helping_service_required_pros"
    static let helping_service_required_muscle    =   "helping_service_required_muscle"
    static let get_dropoff_services               =   "get-dropoff-services"
    static let helper_edited                      =   "helper_edited"
    static let promocode_discount                 =   "promocode_discount"
    static let service_discount                   =   "service_discount"
    static let discount_amount                    =   "discount_amount"
    static let estimate_hour                      =   "estimate_hour"
    static let estimate_hour_price                =   "estimate_hour_price"
}

struct kAPIMethods {
    
    static let upload_helper_vehicle_image          =    "upload-helper-vehicle-image"
    static let get_helper_available_move            =    "get-helper-available-move"
    static let helper_accept_move_request           =    "helper-accept-move-request"
    static let get_helper_scheduled_move            =    "get-helper-scheduled-move"
    static let get_helper_scheduled_pendding_move   =    "get-helper-scheduled-pendding-move"
    static let get_move_detail_by_id                =    "get-move-detail-by-id"
    static let get_helper_cancel_move               =    "get-helper-cancel-move"
    static let get_helper_completed_move            =    "get-helper-completed-move"
    static let update_helper_move_status            =    "update-helper-move-status"
    static let update_helper_location               =    "update-helper-location"
    static let helper_save_cancel_move              =    "helper-save-cancel-move"
    static let upload_pickup_photo                  =    "upload-pickup-photo"
    static let upload_dropoff_photo                 =    "upload-dropoff-photo"
    static let get_chat_message                     =    "get-chat-message"
    static let get_all_chat                         =    "get-all-chat"
    static let get_all_helper_chat                  =    "get-all-helper-chat"
    static let send_message                         =    "send-message"
    static let helper_to_helper_send_message        =    "helper-to-helper-send-message"
    static let get_helper_chat_message              =    "get-helper-chat-message"
    static let get_helper_info                      =    "get-helper-info"
    static let save_range                           =    "save-range"
    static let set_notification_days                =    "set-notification-days"
    static let set_helper_availability_slot         =    "set-helper-availability-slot"
    static let helper_time_slot                     =    "helper-time-slot"
    static let reset_helper_password                =    "reset-helper-password"
    static let send_helper_reset_password_code      =    "send-helper-reset-password-code"
    static let validate_helper_reset_password_code  =    "validate-helper-reset-password-code"
    static let save_helper_query                    =    "save-helper-query"
    static let save_helper_agreement                =    "save-helper-agreement"
    static let get_helper_notification              =    "get-helper-notification"
    static let update_helper_profile                =    "update-helper-profile"
    static let create_merchant_url                  =    "create-merchant-url"
    static let add_helper_security_key              =    "add-helper-security-key"
    static let submit_customer_review               =    "submit-customer-review"
    static let get_allotment_helper_info            =    "get-allotment-helper-info"
    static let helper_edit_move                     =    "helper-edit-move"
    static let search_items                         =    "search_items"
    static let get_helper_accounting_info           =    "get-helper-accounting-info"
    static let get_helper_tip_accounting_info       =    "get-helper-tip-accounting-info"
    static let set_helper_meettinng_slot            =    "set-helper-meettinng-slot"
    static let save_helper_paypal_id                =    "save-helper-paypal-id"
    static let helper_report                        =    "helper-report"
    static let helper_update_device_token           =    "helper-update-device-token"
    static let update_helper_notification           =    "update-helper-notification"
    static let update_helper_vehicle_image          =    "update-helper-vehicle-image"
    static let customer_detail_by_helper            =    "customer-detail-by-helper?customer_id="
    static let get_helper_detail_by_id              =    "get-helper-detail-by-id"
    static let get_helper_job_status                =    "get-helper-job-status"
    static let update_helper_service_type           =    "update-helper-service-type"
    static let get_helper_notification_list         =    "get-helper-notification-list"
    static let save_helper_job_location             =    "save-helper-job-location"
    static let get_helper_notification_count        =    "get-helper-notification-count"
    static let get_cities                           =    "get-cities"
    static let get_dropoff_services                 =    "get-dropoff-services"
    static let validate_promocode                   =    "validate-promocode"
    static let get_items_category                   =    "get-items-category"
    static let get_items_sub_category               =    "get-items-sub-category"
    static let get_helper_app_rating                =    "get-helper-app-rating"
    static let helper_app_rating                    =    "helper-app-rating"
    static let update_helper_vehicle_info_request   =    "update-helper-vehicle-info-request"
    static let helper_rejection_message             =    "helper-rejection-message"
    static let get_move_type_by_id                  =    "get-move-type-by-id?move_type_id="
    static let helper_update_pending_move_status    =    "helper-update-pending-move-status"
    static let save_helper_w9_form_detail           =    "save-helper-w9-form-detail"
    static let get_helper_w9_form_detail            =    "get-helper-w9-form-detail"
    static let final_submission_w9_form             =    "final-submission-w9-form"
    static let update_helper_demo_status            =    "update-helper-demo-status"
    static let get_helper_last_job_status           =    "get-helper-last-job-status"
    static let get_admin_chat_msg                   =    "get-admin-chat"
    static let helper_to_admin_send_message         =    "send-message-to-admin"
    static let get_admin_chat_count_message         =    "get-admin-chat-count"
    static let get_default_value                    =    "get-default-value"
    static let update_notification_status           =    "update-notification-status"
    static let get_confirm_reason                   =    "get-confirm-reason"
    static let get_agreement_mobile                 =    "agreement-mobile"
    static let download_agreement_mobile            =    "agreement-mobile?download=1"
    static let account_deleted                      =    "delete-account"
    static let signature_pad                        =    "signature-pad/"
    
}

struct kUserCache {

    static let helper_id                = "helper_id"
    static let first_name               = "first_name"
    static let last_name                = "last_name"
    static let email_id                 = "email_id"
    static let phone_num                = "phone_num"
    static let photo_url                = "photo_url"
    static let auth_key                 = "auth_key"
    static let is_verified              = "is_verified"
    static let is_active                = "is_active"
    static let is_blocked               = "is_blocked"
    static let completedStep            = "signup_step"
    static let service_type            = "service_type"
    static let is_agree                 = "is_agree"
    static let is_security_key_added    = "is_security_key_added"
    static let is_payment_method_added  = "is_payment_method_added"
    static let paypal_merchant_id       = "paypal_merchant_id"
    static let w9_form_status           = "w9_form_status"
    static let w9_form_verified         = "w9_form_verified"
    static let cancalationFeeText         = "cancalation_fee_text"
    static let cancalationFeeHour         = "cancalation_fee_hour"
    static let helperStartServisPoupText   = "helper_start_servis_poup_ext"
    
}
struct kStringForMoveStatus {
    static let workingHours            = "Total working hours: "
}
struct AlertButtonTitle {
    static let cancel   = "Cancel"
    static let yes   = "Yes"
    static let no   = "No"
    static let ok   = "Ok"
    static let alert   = "Alert!"
    static let decline   = "Decline"
    static let accept   = "Accept"
    
}
struct XIBNibNamed {
    static let AlertViewPermmision   = "AlertViewPermmision"
    static let popupReason   = "PopupReason"
    static let AlertPopupView   = "AlertPopupView"
    static let InsuranceExpiryView   = "InsuranceExpiryView"
    
}
struct PlaceHolderMessages{
    static let txtViewReasonMessage   = "Enter Reason"
}
struct AssetsNames {
    static let uncheckIcon   = "circle-uncheck"
    static let checkIcon     = "circle-check"
    
}
struct LabelsString{
    static let label_unit_number   = "Unit # "
    static let label_apartment_number   = "Apt. # "
    static let label_gate_code   = "Gate Code: # "
}

struct AlertMessages{
    static let pleaseSelectReasonMessage   = "Please select reason"
    static let pleaseEnterReasonMessage   = "Please enter reason"
}
struct CancellationReasonItemLits {
    static let listItem0   = "Helpers did not accept job within customer timeframe"
    static let listItem1   = "Service is no longer needed"
    static let listItem2   = "Other"
}
struct kStringPermission{
    //camera or gallary actions sheet's
    static let pickAnOption   = "Pick an option"
    static let takePhoto      = "Take Photo"
    static let choosePhoto    = "Choose Photo"
    static let warning        = "Warning"
    static let youDontHaveCamera = "You don't have camera"
    
    static let popupTitleText   = "Cancellation Reason"
    static let goToSetting   = "Go to settings"
    static let locationTitle   = ""//"Allow Move It to access your location."
    static let locationMessage   = "Allow Move It to access your location."//"we need access to your location to provide you an enhanced service experience."

    static let cameraGalaryMessageTitle   = ""//"Allow Move It to access your Camera & Gallery"
    static let cameraMessageTitle   = ""//"Allow Move It to access your Camera"
    static let galaryMessageTitle   = ""//"Allow Move It to access your Gallery"
   
    static let photosItemMessage   = "Allow Move It to access your photos."//"Move It required your permission to capture/upload pictures."
    static let photos1ItemMessage   = "Allow Move It to access your photos."//"Move It required your permission to capture/upload pictures."
    
   
    static let photosProfileMessage   = "Allow Move It to access your photos."//"This will enable you to change your profile photo."
    static let photosHelperSupportMessage   = "Allow Move It to access your photos."//"This will enable you to send images to Move It customer support."
    
    static let logout        = "Are you sure you want to log out?"
    static let mobileVerification        = "Mobile Verification"
    static let mobileVerificationMessage        = "Your mobile number has been successfully verified."
    static let connectingToAnotherHelper        = "We are connecting another helper to accept this move. We'll notify you once this job is confirmed."
    static let pleaseMakeSureYouArriveOnTime        =  "Please make sure you arrive to your job on time. Failure to show up or be late to job may suspend your Move It account."
    static let are_you_sure_you_want_to_cancel_move        =  "Are you sure you want to cancel move?"
}

func json(from object:Any) -> String? {
    guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
        return nil
    }
    return String(data: data, encoding: String.Encoding.utf8)
}

////MARK: -Socker
//let manager = SocketManager(socketURL: URL(string: Socket_URL)!, config: [.log(true), .compress])
//var socket = manager.defaultSocket
//var resetAck: SocketAckEmitter?
//let UserNotification = NotificationCenter.default
//
//var isSocketConnected = false
//var isAppInBackground = false
//
//var static_activated = ""
//let SM = "message"
//
//let Noti_UserConnected = "Noti_UserConnected"
//
//
////MARK: - Socket Connection
//
//func socketConnection()
//{
//    addHandlers()
//    socket.connect()
//    manager.reconnects = false
//}
//
//func socketDisconnected()
//{
//    socket.disconnect()
//}
//
//
//func addHandlers() {
//    socket.on("message") {data, ack in
//        print("socket.on message")
//        print(data)
//        return
//    }
//
//    socket.on("connect") {data, ack in
//        print("socket.on connect")
//        isSocketConnected = true
//        UserNotification.post(name: NSNotification.Name(rawValue: Noti_UserConnected), object: nil)
//    }
//
//    socket.on("disconnect") {data, ack in
//        print("socket.on disconnect")
//        isSocketConnected = false
//        socket.removeAllHandlers()
//        socketConnection()
//    }
//
//    socket.onAny {
//        print("Got event: \($0.event), with items: \($0.items!)")
//        getEvent(event: $0.items)
//    }
//}
//
//func getEvent(event : [Any]?) {
//    if let array = event,array.count > 0 {
//        if let obj = array[0] as? NSDictionary {
//            print("Your data ---->",event)
//            if let obd = obj as? [String : Any] {
//                if let _ = obd["customer_id"] as? String {
//                    getMessage(dict: obd)
//                }
//            }
//        }
//    }
//}
//
//func sendMessage(chat_id: String,msg_type: String,created_datetime: String,message: String,helper_read_flag: String,customer_read_flag: String,sent_by: String,customer_id: String,helper_id: String,image_url: String,name: String,photo_url: String,chat_type: String,sender_id: String,receiver_id: String) {
//    let dictMain = NSMutableDictionary()
//    dictMain.setValue(chat_id, forKey: "chat_id")
//    dictMain.setValue(msg_type, forKey: "msg_type")
//    dictMain.setValue(created_datetime, forKey: "created_datetime")
//    dictMain.setValue(message, forKey: "message")
//    dictMain.setValue(helper_read_flag, forKey: "helper_read_flag")
//    dictMain.setValue(customer_read_flag, forKey: "customer_read_flag")
//    dictMain.setValue(sent_by, forKey: "sent_by")
//    dictMain.setValue(customer_id, forKey: "customer_id")
//    dictMain.setValue(helper_id, forKey: "helper_id")
//    dictMain.setValue(image_url, forKey: "image_url")
//    dictMain.setValue(name, forKey: "name")
//    dictMain.setValue(photo_url, forKey: "photo_url")
//    dictMain.setValue(chat_type, forKey: "chat_type")
//    dictMain.setValue(sender_id, forKey: "sender_id")
//    dictMain.setValue(receiver_id, forKey: "receiver_id")
//    socket.emit("message", dictMain)
//}
//
//
//func getMessage(dict : [String : Any]) {
//    UserNotification.post(name: NSNotification.Name(rawValue: SM), object: dict, userInfo: dict as? [AnyHashable : Any])
//}
