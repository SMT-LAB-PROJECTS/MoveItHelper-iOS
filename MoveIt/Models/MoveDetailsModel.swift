//
//  MoveDetailsModel.swift
//  MoveIt
//
//  Created by Dushyant on 26/06/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit


class MoveDetailsModel {
    
    var request_id : Int?
    var move_type_id : Int?
    var pickup_address : String?
    var pickup_lat : Double?
    var pickup_long : Double?
    var dropoff_address : String?
    var dropoff_lat : Double?
    var dropoff_long : Double?
    var helping_service_id: Int?
    var pickup_date: String?
    var pickup_start_time: String?
    var pickup_end_time: String?
    var dropoff_service_id: Int?
    var pickup_stairs: Int?
    var drop_off_stairs: Int?
    var use_pickup_elevator: Bool?
    var use_dropoff_elevator: Bool?
    var ride_with_helper: Bool?
    var num_of_rider: Int?
    var required_pros: Int?
    var required_muscle: Int?
    var total_miles_distance: Double?
    var is_promocode_applied: Bool?
    var promocode: String?
    var total_amount: Double?
    var discount_amount: Double?
    var dropoff_service_name: String?
    var final_price: Double?
    var pickup_apartment: String?
    var dropoff_apartment: String?
    var customer_id: Int?
    var customer_name: String?
    var customer_photo_url: URL?
    var moveItems = [MoveItems]()
    var helper_status : Int?
    var customer_phone : String?
    var dropoff_photo_url = [URL]()
    var pickup_photo_url = [URL]()
    var chat_id : Int?
    var item_weight     : Double?
    var meeting_slot  : String?
    var helping_service_name : String?
    var helping_service_required_pros : Int?
    var helping_service_required_muscle : Int?
    var other_helper_service_type : Int?
    var total_pros_amount : Double?
    var total_muscle_amount : Double?
    
    var helper_accept_service_type : Int?
    var helper_edited : Int?
    
    var job_edited:Int?
    var is_reconfirm:Int?
    var estimate_hour: Int?
    var estimate_hour_mgs: String?
    var msg_for_labor_move: String?
    var is_pickup_address     : Int?
    var is_dropoff_address     : Int?
    var is_estimate_hour : Int?
    var estimate_hour_confirmation_message : String?
    var estimate_hour_message : String?
    var valid_customer_name : String?
    var valid_customer_photo_url : URL?
    var total_working_minute : Int = 0

    
    var dropoff_address_type : Int!
    var pickup_address_type : Int!
    var dropoff_gate_code : String!
    var pickup_gate_code : String!

    init?(moveDict: [String: Any])
    {
        is_pickup_address = (moveDict["is_pickup_address"] as? Int ?? 0)
        is_dropoff_address = (moveDict["is_dropoff_address"] as? Int ?? 0)
        total_working_minute =  (moveDict["total_working_minute"] as? Int ?? 0)

        request_id           =  (moveDict["request_id"] as! Int)
        move_type_id         =  (moveDict["move_type_id"] as! Int)
        pickup_address       =  (moveDict["pickup_address"] as! String)
        pickup_lat           =  (moveDict["pickup_lat"] as! Double)
        pickup_long          =  (moveDict["pickup_long"] as! Double)
        dropoff_address      =  (moveDict["dropoff_address"] as! String)
        dropoff_lat          =  Double(moveDict["dropoff_lat"] as? String ?? "0")
        dropoff_long         =  Double(moveDict["dropoff_long"] as? String ?? "0")
        dropoff_service_name = (moveDict["dropoff_service_name"] as! String)
        helping_service_id   =  moveDict["helping_service_id"] as? Int ?? 0
        pickup_date          =  (moveDict["pickup_date"] as! String)
        pickup_start_time    =  (moveDict["pickup_start_time"] as! String)
        pickup_end_time      =  (moveDict["pickup_end_time"] as! String)
        dropoff_service_id   =  moveDict["dropoff_service_id"] as? Int ?? 0
        pickup_stairs        =  Int(moveDict["pickup_stairs"] as? String ?? "0")
        drop_off_stairs      =  Int(moveDict["drop_off_stairs"] as? String ?? "0")
        
        helping_service_required_pros   =  (moveDict["helping_service_required_pros"] as! Int)
        helping_service_required_muscle   =  (moveDict["helping_service_required_muscle"] as! Int)
        is_estimate_hour =  (moveDict["is_estimate_hour"] as! Int )
        estimate_hour_confirmation_message       =  (moveDict["estimate_hour_confirmation_message"] as? String ?? "")
        estimate_hour_message                    =  (moveDict["estimate_hour_message"] as? String ?? "")

        valid_customer_name                    =  (moveDict["valid_customer_name"] as? String ?? "")
        
        dropoff_gate_code       =  (moveDict["dropoff_gate_code"] as? String ?? "")
        pickup_gate_code       =  (moveDict["pickup_gate_code"] as? String ?? "")
        dropoff_address_type           =  (moveDict["dropoff_address_type"] as? Int ?? 0)
        pickup_address_type           =  (moveDict["pickup_address_type"] as? Int ?? 0)
        
        if moveDict["use_pickup_elevator"] as? String ?? "0" == "0"{
            use_pickup_elevator  =  false
        } else{
            use_pickup_elevator  =  true
        }
        
        if moveDict["use_dropoff_elevator"] as? String ?? "0" == "0"{
            use_dropoff_elevator = false
        } else{
            use_dropoff_elevator = true
        }
        
        print(Double(moveDict["discount_amount"] as! Double))
        
        ride_with_helper     =  Bool(moveDict["ride_with_helper"] as! String)
        num_of_rider         =  moveDict["num_of_rider"] as? Int ?? 0
        required_pros        =  (moveDict["required_pros"] as! Int)
        required_muscle      =  Int(moveDict["required_muscle"] as! Int)
        total_miles_distance =  Double(moveDict["total_miles_distance"] as! Double)
        is_promocode_applied =  (moveDict["is_promocode_applied"] as! Bool)
        promocode            =  (moveDict["promocode"] as? String)
        if let amount = moveDict["total_amount"] as? Double {
            total_amount     =  Double(amount)
        }
        discount_amount      =  Double(moveDict["discount_amount"] as! Double)
        final_price          =  Double(moveDict["final_price"] as! Double)
        pickup_apartment     =  (moveDict["pickup_apartment"] as? String)
        dropoff_apartment    =  (moveDict["dropoff_apartment"] as? String)
        customer_id          =  (moveDict["customer_id"] as! Int)
        customer_name        =  (moveDict["customer_name"] as! String)
        helper_status        =  (moveDict["helper_status"] as? Int)
        chat_id              =  (moveDict["chat_id"] as! Int)
        meeting_slot         =  (moveDict["meeting_slot"] as? String ?? "")
        
        total_pros_amount     =  (moveDict["total_pros_amount"] as? Double)
        total_muscle_amount   =  (moveDict["total_muscle_amount"] as? Double)
        
        for imgString in ((moveDict["dropoff_photo_url"] as? [String])!){
            dropoff_photo_url.append(URL.init(string: imgString)!)
        }
        
        for imgString in ((moveDict["pickup_photo_url"] as? [String])!){
            pickup_photo_url.append(URL.init(string: imgString)!)
        }
        
        if let phone = moveDict["customer_phone"] as? String{
            customer_phone   =  phone//(moveDict["customer_phone"] as! String)
        }
        

        if let url = moveDict["valid_customer_photo_url"] as? String{
            valid_customer_photo_url = URL.init(string: url)
        }
        if let url = moveDict["customer_photo_url"] as? String{
             customer_photo_url = URL.init(string: url)
        }
        let moveItemsDict = moveDict["items"] as! [[String: Any]]
 
        for indvDict in moveItemsDict{
            print(indvDict)
            let itemModel = MoveItems.init(itemsDict: indvDict)
            self.moveItems.append(itemModel!)
        }
        
        helper_edited =  (moveDict["helper_edited"] as! Int)
        job_edited =  (moveDict["job_edited"] as? Int) ?? 0
        is_reconfirm =  (moveDict["is_reconfirm"] as? Int) ?? 0
        
        helper_accept_service_type = (moveDict["helper_accept_service_type"] as? Int) ?? 0
        if(helper_accept_service_type == 0) {
            let ggg:String = moveDict["helper_accept_service_type"] as? String ?? "0"
            helper_accept_service_type = Int(ggg)!
        }

        other_helper_service_type = (moveDict["other_helper_service_type"] as? Int) ?? -1
        if(other_helper_service_type == -1) {
            let type:String = moveDict["other_helper_service_type"] as? String ?? "0"
            other_helper_service_type = Int(type) ?? 0
        }
        
        estimate_hour = (moveDict["estimate_hour"] as? Int) ?? 0
        estimate_hour_mgs = moveDict["estimate_hour_mgs"] as? String ?? ""
        msg_for_labor_move = moveDict["msg_for_labor_move"] as? String ?? ""
    }
    
    init?(moveDictFromList: [String: Any])
    {
        request_id           =  (moveDictFromList["request_id"] as! Int)
        is_pickup_address = (moveDictFromList["is_pickup_address"] as? Int ?? 0)
        is_dropoff_address = (moveDictFromList["is_dropoff_address"] as? Int ?? 0)
        move_type_id         =  (moveDictFromList["move_type_id"] as! Int)
        pickup_address       =  (moveDictFromList["pickup_address"] as! String)
        pickup_lat           =  (moveDictFromList["pickup_lat"] as? Double) ?? 0.0
        pickup_long          =  (moveDictFromList["pickup_long"] as? Double) ?? 0.0
        dropoff_address      =  (moveDictFromList["dropoff_address"] as! String)
        is_estimate_hour =  (moveDictFromList["is_estimate_hour"] as! Int )
        estimate_hour_confirmation_message       =  (moveDictFromList["estimate_hour_confirmation_message"] as? String ?? "")

        dropoff_service_name = (moveDictFromList["dropoff_service_name"] as! String)
        pickup_date          =  (moveDictFromList["pickup_date"] as! String)
        pickup_start_time    =  (moveDictFromList["pickup_start_time"] as! String)
        pickup_end_time      =  (moveDictFromList["pickup_end_time"] as! String)
        dropoff_service_id   =  moveDictFromList["dropoff_service_id"] as? Int ?? 0
        pickup_stairs        =  Int(moveDictFromList["pickup_stairs"] as? String ?? "0")
        helping_service_required_pros   =  (moveDictFromList["helping_service_required_pros"] as! Int)
        helping_service_required_muscle   =  (moveDictFromList["helping_service_required_muscle"] as! Int)
      
        
        if moveDictFromList["use_pickup_elevator"] as? String ?? "0" == "0"{
            use_pickup_elevator  =  false
        } else{
            use_pickup_elevator  =  true
        }
            
        total_miles_distance =  Double(moveDictFromList["total_miles_distance"] as! Double)
        if let amount = moveDictFromList["total_amount"] as? Double {
            total_amount     =  Double(amount)
        }
        customer_name        =  (moveDictFromList["customer_name"] as! String)
        meeting_slot         =  moveDictFromList["meeting_slot"] as? String ?? ""
        
        total_pros_amount     =  (moveDictFromList["total_pros_amount"] as? Double)
        total_muscle_amount   =  (moveDictFromList["total_muscle_amount"] as? Double)
                
        helper_edited   =  (moveDictFromList["helper_edited"] as? Int)
        job_edited   =  (moveDictFromList["job_edited"] as? Int) ?? 0
        is_reconfirm =  (moveDictFromList["is_reconfirm"] as? Int) ?? 0
        
        //helper_accept_service_type = (moveDictFromList["helper_accept_service_type"] as? Int) ?? 0
        let ggg:String = moveDictFromList["helper_accept_service_type"] as? String ?? "0"
        helper_accept_service_type = Int(ggg)!
        
        other_helper_service_type = (moveDictFromList["other_helper_service_type"] as? Int) ?? 0
        if(other_helper_service_type == 0) {
            let ggg:String = moveDictFromList["other_helper_service_type"] as? String ?? "0"
            other_helper_service_type = Int(ggg)!
        }

    }
}

class MoveItems {
    
    
    var move_item_id    : Int?
    var item_name       : String?
    var quantity        : Int?
    var total_amount    : Double?
    var can_assamble    : Bool?
    var is_assamble    : Bool?
    var item_width      : Double?
    var item_height     : Double?
    var item_depth      : Double?
    var item_weight      : Double?
    var additional_info : String?
    var item_price      : Double?
    var category_id     : Int?
    var category_name   : String?
    var category_photo_url : URL?
    var subcategory_name : String?
    var subcategory_photo_url : URL?
    var item_photo : [String]?
        
    init?(itemsDict: [String: Any])
    {
        move_item_id = (itemsDict["move_item_id"] as! Int)
        item_name = (itemsDict["item_name"] as! String)
        quantity = (itemsDict["quantity"] as? Int)
     //   total_amount = Double(itemsDict["total_amount"] as? String)
        can_assamble = false
        if (itemsDict["can_assamble"] as! Int) == 1{
             can_assamble = true
        }
        is_assamble = false
        if (itemsDict["is_assamble"] as! Int) == 1{
            is_assamble = true
        }
        item_width = (itemsDict["item_width"] as? Double)
        item_height = (itemsDict["item_height"] as? Double)
        item_depth = (itemsDict["item_depth"] as? Double)
        item_weight = (itemsDict["item_weight"] as? Double)
        additional_info = (itemsDict["additional_info"] as? String)
        item_price = (itemsDict["item_price"] as? Double)
        category_id = (itemsDict["category_id"] as! Int)
        category_name = (itemsDict["category_name"] as? String)
        if let itemPhotoUrl = itemsDict["subcategory_photo_url"] as? String{
            subcategory_photo_url = URL.init(string: itemPhotoUrl)
        }
      
        item_photo = itemsDict["item_photo"] as? [String] ?? []
    
        if(item_photo!.count == 0) {
            item_photo = itemsDict["item_photos"] as? [String] ?? []
        }
        

    }
}
class AdminReasonModel{
    var cancellation_fee : String?
    var reason_message : String?
    var reason_title : String?
    init?(adminReasonDict: [String: Any])
    {
        reason_title = (adminReasonDict["reason_title"] as? String ?? "")
        reason_message = (adminReasonDict["reason_message"] as? String ?? "")
        cancellation_fee = (adminReasonDict["cancellation_fee"] as? String ?? "")
    }
}
