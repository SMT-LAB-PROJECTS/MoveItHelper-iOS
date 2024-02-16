//
//  ScheduleMoveTableViewCell.swift
//  MoveIt
//
//  Created by Dushyant on 20/06/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class ScheduleMoveTableViewCell: UITableViewCell {

    @IBOutlet weak var bkView: UIView!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var serviceType: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var acceptTypeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var fromAddressLabel: UILabel!
    @IBOutlet weak var toAddressLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var cancelledButtton: UIButton!

    @IBOutlet weak var toIcon: UIImageView!
    @IBOutlet weak var dotedline: UIImageView!
    @IBOutlet weak var labelMoveType: UILabel!

    @IBOutlet weak var lblEditedJob: UILabel!
    @IBOutlet weak var viewDropOff: UIView!

    override func prepareForReuse() {
        userImgView.image = UIImage.init(named: "User_placeholder")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userNameLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        serviceType.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        costLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 15.0)
        distanceLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        fromLabel.font = UIFont.josefinSansRegularFontWithSize(size: 8.0)
        toLabel.font = UIFont.josefinSansRegularFontWithSize(size: 8.0)
        fromAddressLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 11.0)
        toAddressLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 11.0)
        dateTimeLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        labelMoveType.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)

        lblEditedJob.font = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        
        bkView.layer.cornerRadius = 15.0 * screenHeightFactor
        cancelledButtton.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        
        cancelledButtton.layer.cornerRadius = 15.0
        userImgView.layer.cornerRadius = 20.0 
    }

    func setupInfo(_ moveInfo: [String: Any]){
        
        let objMoveInfo:MoveDetailsModel? = MoveDetailsModel.init(moveDictFromList: moveInfo)
        
        if(objMoveInfo?.is_reconfirm == 1) {
            self.lblEditedJob.isHidden = false
            let message = "Customer edited move"
            let textRange = NSRange(location: 0, length: message.count)
            let attributedText = NSMutableAttributedString(string: message)
            attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: textRange)
            self.lblEditedJob.attributedText = attributedText
        } else {
            self.lblEditedJob.isHidden = true
        }
        //if(objMoveInfo?.move_type_id == 4 || objMoveInfo?.move_type_id == 10 || objMoveInfo?.move_type_id == 12) {
        if(objMoveInfo?.is_dropoff_address == 0) {
            fromLabel.text = "Pickup Address"
            toLabel.isHidden = true
            viewDropOff.isHidden = true
            toAddressLabel.isHidden = true
            distanceLabel.isHidden = true
            toIcon.isHidden = true
            dotedline.isHidden = true
            fromAddressLabel.numberOfLines = 1
        } else {
            fromLabel.text = "From"
            toLabel.isHidden = false
            viewDropOff.isHidden = false
            toAddressLabel.isHidden = false
            distanceLabel.isHidden = false
            toIcon.isHidden = false
            dotedline.isHidden = false
            fromAddressLabel.numberOfLines = 1
        }

        userNameLabel.text = (moveInfo["customer_name"] as! String)
        labelMoveType.text = (moveInfo["move_type_name"] as! String)

        let urlString = moveInfo["photo_url"] as! String
        if !urlString.isEmpty{
            let uRL = URL.init(string: urlString)
            userImgView.af.setImage(withURL: uRL!)
        } else{
            userImgView.image = UIImage(named: "User_placeholder")
        }

        fromAddressLabel.text = (moveInfo["pickup_address"] as! String)
        toAddressLabel.text = (moveInfo["dropoff_address"] as! String)
        serviceType.text = (moveInfo["dropoff_service_name"] as! String) + "\n" + (moveInfo["helping_service_name"] as! String)
        dateTimeLabel.text = (moveInfo["pickup_date"] as! String) + "\n" + (moveInfo["pickup_start_time"] as! String) + " - " + (moveInfo["pickup_end_time"] as! String)
        
        
        let miles = (moveInfo["total_miles_distance"] as! Double)
        distanceLabel.text = String.init(format: "%0.2f", miles) + " Miles"
        
        //distanceLabel.text = String(moveInfo["total_miles_distance"] as! Double) + " Miles"
        
        if let amount = (moveInfo["total_amount"] as? Double){
            costLabel.text = "$" + String.init(format: "%0.2f", amount)
        }
        if  (moveInfo["helper_status"] as! Int) > 1{
            cancelledButtton.isHidden = true
        }
        else{
            cancelledButtton.isHidden = false
        }
   
        let userDefault = UserDefaults.standard
        let helper_service_type:Int = userDefault.value(forKey: kUserCache.service_type) as! Int
        let helping_service_required_pros:Int = (moveInfo["helping_service_required_pros"] as? Int ?? 0)
        let helping_service_required_muscle:Int = (moveInfo["helping_service_required_muscle"] as? Int ?? 0)
        
        let helper_accept_service_type:Int = moveInfo["helper_accept_service_type"] as? Int ?? 0
        
//        1 - Pro
//        2 Muscle
//        3  Pro & Muscle
        
//        if (moveInfo["is_estimate_hour"] as? Int) == 0{
//            costLabel.text = "$" + String.init(format: "%0.2f", total_amount)
//            return
//        }

        if (helper_accept_service_type == HelperType.Pro) {
            acceptTypeLabel.text = "Pro"
            if let total_amount = (moveInfo["total_amount"] as? Double) {
                costLabel.text = "$" + String.init(format: "%0.2f", total_amount)
            }
            
            if(helping_service_required_pros > 0) {
                if let amount = (moveInfo["total_pros_amount"] as? Double){
                    if (moveInfo["is_estimate_hour"] as? Int) == 0 {
                        costLabel.text = "$" + String.init(format: "%0.2f", amount)
                    }else {
                        costLabel.text = "$" + String.init(format: "%0.2f/hr", amount)
                    }
                }
            }
        } else if (helper_accept_service_type == HelperType.Muscle){
            acceptTypeLabel.text = "Muscle"
//            if let total_amount = (moveInfo["total_amount"] as? Double) {
//                        if (moveInfo["is_estimate_hour"] as? Int) == 0{
//                            costLabel.text = "$" + String.init(format: "%0.2f", total_amount)
//                            return
//                        }
//                costLabel.text = "$" + String.init(format: "%0.2f/hr", total_amount)
//            }
            
            if(helping_service_required_muscle > 0) {
                if let amount = (moveInfo["total_muscle_amount"] as? Double){
                    if (moveInfo["is_estimate_hour"] as? Int) == 0{
                        costLabel.text = "$" + String.init(format: "%0.2f", amount)
                    }else{
                        costLabel.text = "$" + String.init(format: "%0.2f/hr", amount)
                    }
                }
            }
        } else {//Pro + Muscle
            if let total_amount = (moveInfo["total_amount"] as? Double) {
                costLabel.text = "$" + String.init(format: "%0.2f", total_amount)
            }
            
            if(helping_service_required_pros > 0 && helping_service_required_muscle > 0) {
                if let total_amount = (moveInfo["total_amount"] as? Double) {
                          
                    costLabel.text = "$" + String.init(format: "%0.2f", total_amount)
                    
                    if(helper_accept_service_type == 0) {
                        acceptTypeLabel.text = ""
                        
                        //let ggg2:String = moveInfo["other_helper_service_type"] as? String ?? "0"
                        var other_helper_service_type:Int = moveInfo["other_helper_service_type"] as? Int ?? 0
                        //other_helper_service_type = Int(ggg2)!
                        
                        if(other_helper_service_type == HelperType.Pro) {
                            acceptTypeLabel.text = "Muscle"
                            if let amount = (moveInfo["total_muscle_amount"] as? Double){
                                        if (moveInfo["is_estimate_hour"] as? Int) == 0{
                                            costLabel.text = "$" + String.init(format: "%0.2f", amount)
                                            return
                                        }
                                costLabel.text = "$" + String.init(format: "%0.2f/hr", amount)
                            }
                        } else if(other_helper_service_type == HelperType.Muscle) {
                            acceptTypeLabel.text = "Pro"
                            if let amount = (moveInfo["total_pros_amount"] as? Double){
                                if (moveInfo["is_estimate_hour"] as? Int) == 0{
                                    costLabel.text = "$" + String.init(format: "%0.2f", amount)
                                    return
                                }
                                costLabel.text = "$" + String.init(format: "%0.2f/hr", amount)
                            }
                        }
                        
                    } else if(helper_accept_service_type == HelperType.Pro) {
                        acceptTypeLabel.text = "Pro"
                        if let amount = (moveInfo["total_pros_amount"] as? Double){
                            if (moveInfo["is_estimate_hour"] as? Int) == 0{
                                costLabel.text = "$" + String.init(format: "%0.2f", amount)
                                return
                            }
                            costLabel.text = "$" + String.init(format: "%0.2f/hr", amount)
                        }
                    } else if(helper_accept_service_type == HelperType.Muscle) {
                        acceptTypeLabel.text = "Muscle"
                        if let amount = (moveInfo["total_muscle_amount"] as? Double){
                            if (moveInfo["is_estimate_hour"] as? Int) == 0{
                                costLabel.text = "$" + String.init(format: "%0.2f", amount)
                                return
                            }
                            costLabel.text = "$" + String.init(format: "%0.2f/hr", amount)
                        }
                    }
                }
            } else {
                if(helping_service_required_pros > 0) {
                    if let amount = (moveInfo["total_pros_amount"] as? Double){
                        acceptTypeLabel.text = "Pro"
                        costLabel.text = "$" + String.init(format: "%0.2f", amount)
                        if (moveInfo["is_estimate_hour"] as? Int) == 0{
                            costLabel.text = "$" + String.init(format: "%0.2f", amount)
                            return
                        }
                        costLabel.text = "$" + String.init(format: "%0.2f/hr", amount)

                    }
                } else if(helping_service_required_muscle > 0) {
                    if let amount = (moveInfo["total_muscle_amount"] as? Double){
                        acceptTypeLabel.text = "Muscle"
                        if (moveInfo["is_estimate_hour"] as? Int) == 0{
                            costLabel.text = "$" + String.init(format: "%0.2f", amount)
                            return
                        }
                        costLabel.text = "$" + String.init(format: "%0.2f/hr", amount)
                    }
                }
            }
        }
        if (objMoveInfo?.move_type_id == 12) {
            costLabel.text = "$0.0"
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
