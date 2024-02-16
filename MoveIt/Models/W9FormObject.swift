//
//  W9FormObject.swift
//  MoveIt
//
//  Created by Dilip Saket on 07/01/22.
//  Copyright © 2022 Jyoti. All rights reserved.
//

import Foundation


class W9FormObject {
        
//        "id": 6,
//        "helper_id": 1,
//        "status": 1,
//        "is_verified": 0,
//        "message": "Heleper W9 form detail is rejected",
//        "name": "Optional(\"Dilip\")",
//        "business_name": "Optional(\"Zombie\")",
//        "address": "Optional(\"Dsds sad\")",
//        "city": "Optional(\"323\")",
//        "state": "",
//        "zipcode": "",
//        "account_number": "Optional(\"\")",
//        "account_number_2": "",
//        "requester_name_address": "Optional(\"\")",
//        "payee_code": "Optional(\"12321\")",
//        "reporting_code": "Optional(\"12323\")",
//        "ss_number": "Optional(\"Fvfe1232\")",
//        "sei_number": "Optional(\"\")",
//        "individual": 0,
//        "c_corporation": 0,
//        "s_corporation": 0,
//        "partnership": 0,
//        "trust": 0,
//        "limited_liability_company": 0,
//        "tax_classification": "0",
//        "other": 0,
//        "created_at": "2022-01-06 17:46:14",
//        "updated_at": "2022-01-06 17:46:14",
//        "helper_signature": "https://new-go-move-it.s3-us-west-1.amazonaws.com/helper_signature/img_1640946950.png",
//        "fw9Form": "https://devadmin.gomoveit.com/fw9"
//    
    
    var move_item_id    : Int?
    var item_name       : String?
    var quantity        : Int?
    var total_amount    : Double?
    var can_assamble    : Bool?
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
        if (itemsDict["can_assamble"] as! Int) == 1{
             can_assamble = true
        }
        else{
             can_assamble = false
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
