//
//  HelperDetailsModel.swift
//  MoveIt
//
//  Created by Dushyant on 18/07/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit



class HelperDetailsModel: NSObject {
    
    var helper_id          : Int?
    var first_name          : String?
    var last_name           : String?
    var email_id            : String?
    var phone_num           : String?
    var photo_url           : String?
    var is_verified         : Int?
    var is_active           : Bool?
    var is_blocked          : Int?
    var signup_step         : Int?
    var service_type        : Int?
    var is_available        : Int?
    var range               : Int?
    var max_range           : Int?
    var min_range           : Int?
    var vehicleDetails      : VehicleDetails?
    var notification_days   : [[String: Any]]?
    var available_slots     : [[String: Any]]?
    var avarage_rating      : Double?
    var is_payment_method_added : Int?
    var paypal_merchant_id  : String?

    var w9_form_status           : Int?
    var w9_form_verified           : Int?
    var is_new           : Int?
    var is_demo_completed    : Int?
    
    init?(profileDict: [String: Any]){
        
        helper_id        = (profileDict["helper_id"] as! Int)
        first_name       = (profileDict["first_name"] as! String)
        last_name        = (profileDict["last_name"] as! String)
        email_id         = (profileDict["email_id"] as! String)
        phone_num        = (profileDict["phone_num"] as! String)
        photo_url        = (profileDict["photo_url"] as! String)
        is_verified      = (profileDict["is_verified"] as! Int)
        is_active        = (profileDict["is_active"] as! Bool)
        signup_step      = (profileDict["signup_step"] as! Int)
        service_type     = (profileDict["service_type"] as! Int)
        is_available     = (profileDict["is_available"] as! Int)
        range            = (profileDict["range"] as? Int ?? 0)
        max_range        = (profileDict["max_range"] as? Int ?? 0)
        min_range        = (profileDict["min_range"] as? Int ?? 0)
        notification_days = (profileDict["notification_days"] as! [[String: Any]])
        available_slots = (profileDict["available_slots"] as! [[String: Any]])
        avarage_rating  = (profileDict["avarage_rating"] as! Double)
        paypal_merchant_id = (profileDict["paypal_merchant_id"] as! String)
        is_payment_method_added = (profileDict["is_payment_method_added"] as! Int)
                
        w9_form_status        = (profileDict["w9_form_status"] as? Int ?? 0)
        w9_form_verified        = (profileDict["w9_form_verified"] as? Int ?? 0)
        is_new              = (profileDict["is_new"] as? Int ?? 0)
        is_demo_completed   = (profileDict["is_demo_completed"] as? Int ?? 0)
        is_blocked          = (profileDict["is_blocked"] as? Int ?? 0)
        
        vehicleDetails = VehicleDetails.init(vehicleInfo: profileDict["vehicle_info"] as! [String : Any])
   
        
        
//        if service_type == 1 {
//            vehicleDetails = VehicleDetails.init(vehicleInfo: profileDict["vehicle_info"] as! [String : Any])
//        } else if service_type == 3{
//            vehicleDetails = VehicleDetails.init(vehicleInfo: profileDict["vehicle_info"] as! [String : Any])
//        }
    }
}

class VehicleDetails: NSObject{
    
    var vehicle_year : String?
    var plate_num    : String?
    var company_name : String?
    var model        : String?
    var type         : String?
    var vehicle_type_id: String?
    var insurance_number : String?
    var insurance_policy_expiry : String?
    
    var vehicle_photo_url = [VehiclePhotosModel]()
    var vehicle_insurance_photo_url = [VehiclePhotosModel]()

    var is_vehicle_request  : String?
    var message  : String?
    var is_insurance_expire : String?
    var insurance_expired : String?
    var insurance_message : String?
    var insurance_message_title : String?
    var is_insurance_request : String?
    var is_vehicle_insurance_request : String?
    
    init?(vehicleInfo: [String: Any]) {
        print(vehicleInfo)
        
         self.is_vehicle_request = (vehicleInfo["is_vehicle_request"] as? String ?? "")
         self.message = (vehicleInfo["message"] as? String ?? "")
        let temp = (vehicleInfo["vehicle_year"] as? String)
        
        self.vehicle_year = temp?.isEmpty == true ? "0" : temp
         self.plate_num = (vehicleInfo["plate_num"] as? String ?? "")
         self.company_name = (vehicleInfo["company_name"] as? String ?? "")
         self.model = (vehicleInfo["model"] as? String ?? "")
        self.type = (vehicleInfo["type"] as? String ?? "")

        self.vehicle_type_id = (vehicleInfo["vehicle_type_id"] as! String)
        self.insurance_number = (vehicleInfo["insurance_number"] as! String)
        self.insurance_policy_expiry = (vehicleInfo["insurance_policy_expiry"] as! String)
        
        self.is_insurance_request = String(vehicleInfo["is_insurance_request"] as? Int ?? 0)
        self.insurance_expired = String(vehicleInfo["insurance_expired"] as? Int ?? 0)
        self.is_insurance_expire = String(vehicleInfo["is_insurance_expire"] as? Int ?? 0)
        self.insurance_message = (vehicleInfo["insurance_message"] as? String ?? "")
        self.insurance_message_title = (vehicleInfo["insurance_message_title"] as? String ?? "")
        self.is_vehicle_insurance_request = (vehicleInfo["is_vehicle_insurance_request"] as? String ?? "")
        
        if((self.insurance_policy_expiry!.contains("0000")) == true) {
            self.insurance_policy_expiry = ""
        } 
        
         //self.vehicle_photo_url = (vehicleInfo["vehicle_photo_url"] as! [String])
        let vehicle_photo_urlDict = vehicleInfo["vehicle_photo_url"] as! [[String: Any]]
        for indvDict in vehicle_photo_urlDict{
            print(indvDict)
            let itemModel = VehiclePhotosModel.init(itemsDict: indvDict)
            self.vehicle_photo_url.append(itemModel!)   
        }
        
        let vehicle_insurance_photo_urlDict = vehicleInfo["vehicle_insurance_photo_url"] as! [[String: Any]]
        for indvDict in vehicle_insurance_photo_urlDict{
            print(indvDict)
            let itemModel = VehiclePhotosModel.init(itemsDict: indvDict)
            self.vehicle_insurance_photo_url.append(itemModel!)
        }
        
    }
}
class MoveItCity: NSObject{
    
    var city_id : Int?
    var name    : String?
    var status : Int?
    
    init?(cityInfo: [String: Any]) {
        
        city_id        = (cityInfo["city_id"] as! Int)
        name       = (cityInfo["name"] as! String)
        status        = (cityInfo["status"] as! Int)
    }
}
