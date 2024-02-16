//
//  MoveTypeModel.swift
//  MoveIt
//
//  Created by Dilip Saket on 14/12/21.
//  Copyright © 2021 Jyoti. All rights reserved.
//

import Foundation


class MoveTypeModel {
    
    var id:Int?
    var name: String?
    var description: String?
    var image_url: String?
    var is_pickup_address:Int?
    var is_dropoff_address:Int?
    var is_how_many:Int?
    var how_many_label: String?
    var is_additional_info:Int?
    var take_photo_label: String?
    var add_item_label: String?
    var is_move_info:Int?
    var move_info: String?
    var is_describe:Int?
    var describe_label: String?
    var helping_service_label: String?
    var dropoff_service_label: String?
    var is_estimate_hour:Int?
    var can_add_item:Int?
    var can_edit_item:Int?
    var can_delete_item:Int?
    var is_payment_required:Int?

    var is_item_price:Int?
    var item_price:Int?
    var item_name: String?
    
    var sub_take_photo_label:String?
    
    var how_many_limit:Int?
    var checkout_message:String?
    
    var is_insurance:Int?
    var insurance_value:Int?
    var is_promocode:Int?
    
    init?(itemsDict: [String: Any])
    {
        id = (itemsDict["id"] as? Int ?? 0)
        
        name = (itemsDict["name"] as? String ?? "")
        description = (itemsDict["description"] as? String ?? "")
        image_url = (itemsDict["image_url"] as? String ?? "")
        
        is_pickup_address = (itemsDict["is_pickup_address"] as? Int ?? 0)
        is_dropoff_address = (itemsDict["is_dropoff_address"] as? Int ?? 0)
        is_how_many = (itemsDict["is_how_many"] as? Int ?? 0)
        
        how_many_label = (itemsDict["how_many_label"] as? String ?? "")
        is_additional_info = (itemsDict["is_additional_info"] as? Int ?? 0)
        take_photo_label = (itemsDict["take_photo_label"] as? String ?? "")
        add_item_label = (itemsDict["add_item_label"] as? String ?? "")
        
        
        is_move_info = (itemsDict["is_move_info"] as? Int ?? 0)
        move_info = (itemsDict["move_info"] as? String ?? "")
        is_describe = (itemsDict["is_describe"] as? Int ?? 0)
        describe_label = (itemsDict["describe_label"] as? String ?? "")

        helping_service_label = (itemsDict["helping_service_label"] as? String ?? "")
        dropoff_service_label = (itemsDict["dropoff_service_label"] as? String ?? "")

        is_estimate_hour = (itemsDict["is_estimate_hour"] as? Int ?? 0)
        can_add_item = (itemsDict["can_add_item"] as? Int ?? 0)
        can_edit_item = (itemsDict["can_edit_item"] as? Int ?? 0)
        can_delete_item = (itemsDict["can_delete_item"] as? Int ?? 0)
        is_payment_required = (itemsDict["is_payment_required"] as? Int ?? 0)
        
        is_item_price = (itemsDict["is_item_price"] as? Int ?? 0)
        item_price = (itemsDict["item_price"] as? Int ?? 0)
        item_name = (itemsDict["item_name"] as? String ?? "")
        
        sub_take_photo_label = (itemsDict["sub_take_photo_label"] as? String ?? "")
        
        how_many_limit = (itemsDict["no_of_item"] as? Int ?? 0)
        
        checkout_message = (itemsDict["checkout_message"] as? String ?? "")
        
        is_insurance = (itemsDict["is_insurance"] as? Int ?? 0)
        insurance_value = (itemsDict["insurance_value"] as? Int ?? 0)
        is_promocode = (itemsDict["is_promocode"] as? Int ?? 0)
        
    }
}
