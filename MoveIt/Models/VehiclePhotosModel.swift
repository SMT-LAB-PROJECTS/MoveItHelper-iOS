//
//  VehiclePhotosModel.swift
//  MoveIt
//
//  Created by Dilip Saket on 08/01/22.
//  Copyright © 2022 Jyoti. All rights reserved.
//

import Foundation

class VehiclePhotosModel {

    var photo_id          : String?
    var photo_url          : String?
    
    
    init(photo_id: String?, photo_url: String?) {
        self.photo_url = photo_url
        self.photo_id = photo_id
    }
    
    init?(itemsDict: [String: Any]){
        photo_id        = (itemsDict["photo_id"] as! String)
        photo_url       = (itemsDict["photo_url"] as! String)
    }
    
    public func dictionaryRepresentation() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.photo_id, forKey: "photo_id")
        dictionary.setValue(self.photo_url, forKey: "photo_url")
        return dictionary
    }
    
}

func convertVehiclePhotosArrayToDictionaries(list: [VehiclePhotosModel]) -> [[String : AnyObject]] {
    var allDictionaries : [[String : AnyObject]] = []
    for data in list {
        var detail:[String:AnyObject] = [:]
        detail["photo_id"] = data.photo_id as AnyObject?
        detail["photo_url"] = data.photo_url as AnyObject?
        allDictionaries.append(detail)
    }
    return allDictionaries
}

func convertVehiclePhotosArrayToString(list: [VehiclePhotosModel]) -> [String] {
    var allStrig : [String] = []
    for data in list {
        allStrig.append(data.photo_url ?? "")
    }
    return allStrig
}
