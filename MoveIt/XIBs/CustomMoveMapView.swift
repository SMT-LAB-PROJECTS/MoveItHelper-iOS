//
//  CustomMoveMapView.swift
//  MoveIt
//
//  Created by Dushyant on 03/07/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class CustomMoveMapView: UIView {

    class var shared : CustomMoveMapView {
        struct Static {
            static let instance = CustomMoveMapView()
        }
        return Static.instance
    }
    
    @IBOutlet var customMapView: UIView!
    
    @IBOutlet weak var moveType: UILabel!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var serviceType: UILabel!
//    @IBOutlet weak var helpingService: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var fromAddressLabel: UILabel!
    @IBOutlet weak var toAddressLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var cancelledButtton: UIButton!
    
    @IBOutlet weak var dotedImgView: UIImageView!
    @IBOutlet weak var toImgView: UIImageView!

    
    class func getCustomMapView() -> CustomMoveMapView {
        
        return UINib(nibName: "CustomMoveMapView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomMoveMapView
    }
    
    func setupUI(){
        
        userNameLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        serviceType.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        moveType.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        //helpingService.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        costLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        distanceLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        fromLabel.font = UIFont.josefinSansRegularFontWithSize(size: 10.0)
        toLabel.font = UIFont.josefinSansRegularFontWithSize(size: 10.0)
        fromAddressLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        toAddressLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        dateTimeLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        acceptButton.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        acceptButton.layer.cornerRadius = 15 * screenHeightFactor
        userImgView.layer.cornerRadius = 20.0
    }
    
    func setupInfo(_ moveInfo: [String: Any]){
        
        userNameLabel.text = (moveInfo["customer_name"] as! String)
        moveType.text = (moveInfo["move_type_name"] as! String)
        let urlString = moveInfo["photo_url"] as! String
        let uRL = URL.init(string: urlString)
        userImgView.af.setImage(withURL: uRL!)
        fromAddressLabel.text = (moveInfo["pickup_address"] as! String)
        toAddressLabel.text = (moveInfo["dropoff_address"] as! String)
        let strServiceType:String = (moveInfo["dropoff_service_name"] as! String) + "\n" + (moveInfo["helping_service_name"] as! String)
        serviceType.text = strServiceType
        //helpingService.text = (moveInfo["helping_service_name"] as! String)
        dateTimeLabel.text = (moveInfo["pickup_date"] as! String) + ", " + (moveInfo["pickup_start_time"] as! String) + " - " + (moveInfo["pickup_end_time"] as! String)
        
        let miles = (moveInfo["total_miles_distance"] as! Double)
        distanceLabel.text = String.init(format: "%0.2f", miles) + " Miles"
        //distanceLabel.text = String(moveInfo["total_miles_distance"] as! Double) + " Miles"
        if let amount = (moveInfo["total_amount"] as? Double) {
            costLabel.text = "$" + String.init(format: "%0.2f", amount)
        }
        
    }

}
