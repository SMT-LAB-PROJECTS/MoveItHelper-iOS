//
//  MoveTableViewCell.swift
//  MoveIt
//
//  Created by Dushyant on 20/06/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class MoveTableViewCell: UITableViewCell {
    
    var A1: String = ""
    var A2: String = ""

    @IBOutlet weak var labelMoveType: UILabel!
    @IBOutlet weak var bkView: UIView!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var serviceType: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var fromAddressLabel: UILabel!
    @IBOutlet weak var toAddressLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var cancelledButtton: UIButton!
    @IBOutlet weak var acceptTypeLabel: UILabel!
    
    @IBOutlet weak var viewDropOff: UIView!
    @IBOutlet weak var toIcon: UIImageView!
    @IBOutlet weak var dotedline: UIImageView!
    
    override func prepareForReuse() {
        userImgView.image = UIImage.init(named: "User_placeholder")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
  
        userNameLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        serviceType.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        labelMoveType.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)

        costLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        distanceLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        fromLabel.font = UIFont.josefinSansRegularFontWithSize(size: 10.0)
        toLabel.font = UIFont.josefinSansRegularFontWithSize(size: 10.0)
        fromAddressLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        toAddressLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        dateTimeLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        acceptButton.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        
        acceptButton.layer.cornerRadius = 15 //* screenHeightFactor
        bkView.layer.cornerRadius = 15.0 * screenHeightFactor
        userImgView.layer.cornerRadius = 20.0 //* screenHeightFactor
    }
    func setupInfoCompleted(_ moveInfo: [String: Any], isCompleted: Bool, isCanceled:Bool){
        
        let objMoveInfo:MoveDetailsModel? = MoveDetailsModel.init(moveDictFromList: moveInfo)
        
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
        let urlString = moveInfo["photo_url"] as! String
        let uRL = URL.init(string: urlString)
        
        if uRL != nil{
            userImgView.af.setImage(withURL: uRL!)
        }
        else{
            userImgView.image = UIImage.init(named: "User_placeholder")
        }
        
        print(moveInfo)
        
        fromAddressLabel.text = (moveInfo["pickup_address"] as! String)
        toAddressLabel.text = (moveInfo["dropoff_address"] as! String)
        serviceType.text = (moveInfo["dropoff_service_name"] as! String) + "\n" + (moveInfo["helping_service_name"] as! String)
        labelMoveType.text = (moveInfo["move_type_name"] as! String)
        print(moveInfo)
        if let dt = moveInfo["pickup_date"] as? String ,!dt.isEmpty{
            
            dateTimeLabel.text = (moveInfo["pickup_date"] as! String) + "\n" + (moveInfo["pickup_start_time"] as! String) + " - " + (moveInfo["pickup_end_time"] as! String)
        }
        
        let miles = (moveInfo["total_miles_distance"] as! Double)
        distanceLabel.text = String.init(format: "%0.2f", miles) + " Miles"
        //distanceLabel.text = String(moveInfo["total_miles_distance"] as! Double) + " Miles"
        
        let userDefault = UserDefaults.standard
        let helper_service_type:Int = userDefault.value(forKey: kUserCache.service_type) as! Int
        
        let helping_service_required_pros:Int = (moveInfo["helping_service_required_pros"] as? Int ?? 0)
        let helping_service_required_muscle:Int = (moveInfo["helping_service_required_muscle"] as? Int ?? 0)
        
        let helper_accept_service_type:Int = moveInfo["helper_accept_service_type"] as? Int ?? 0
        
        
        if(helping_service_required_pros > 0 && helping_service_required_muscle > 0) {
            if helper_accept_service_type == HelperType.Pro{
                acceptTypeLabel.text = "Pro"
                if let total_amount = (moveInfo["total_amount"] as? Double) {
                    costLabel.text = "$" + String.init(format: "%0.2f", total_amount)
                }
                if let amount = (moveInfo["total_pros_amount"] as? Double) {
                    if (moveInfo["is_estimate_hour"] as? Int) == 0{
                        costLabel.text = "$" + String.init(format: "%0.2f", amount)
                    }else {
                        costLabel.text = "$" + String.init(format: "%0.2f/hr", amount)
                    }
                }
            }else if helper_accept_service_type == HelperType.Muscle{
                acceptTypeLabel.text = "Muscle"
                if let total_amount = (moveInfo["total_amount"] as? Double) {
                    costLabel.text = "$" + String.init(format: "%0.2f", total_amount)
                }
                if let amount = (moveInfo["total_muscle_amount"] as? Double) {
                    if (moveInfo["is_estimate_hour"] as? Int) == 0{
                        costLabel.text = "$" + String.init(format: "%0.2f", amount)
                        return
                    }
                    costLabel.text = "$" + String.init(format: "%0.2f/hr", amount)
                }
            }
        }else if (helping_service_required_pros > 0){
            acceptTypeLabel.text = "Pro"
            if let total_amount = (moveInfo["total_amount"] as? Double) {
                costLabel.text = "$" + String.init(format: "%0.2f", total_amount)
            }
            if let amount = (moveInfo["total_pros_amount"] as? Double) {
                if (moveInfo["is_estimate_hour"] as? Int) == 0 {
                    costLabel.text = "$" + String.init(format: "%0.2f", amount)
                    return
                }
                costLabel.text = "$" + String.init(format: "%0.2f/hr", amount)
            }
        }else if (helping_service_required_muscle > 0){
            acceptTypeLabel.text = "Muscle"
            if let total_amount = (moveInfo["total_amount"] as? Double) {
                costLabel.text = "$" + String.init(format: "%0.2f", total_amount)
            }
            if let amount = (moveInfo["total_muscle_amount"] as? Double) {
                if (moveInfo["is_estimate_hour"] as? Int) == 0{
                    costLabel.text = "$" + String.init(format: "%0.2f", amount)
                    return
                }
                costLabel.text = "$" + String.init(format: "%0.2f/hr", amount)
            }
        }
        
        if (objMoveInfo?.move_type_id == 12) {
            costLabel.text = "$0.0"
        }
        
    }
    func setupInfo(_ moveInfo: [String: Any], isCompleted: Bool, isCanceled:Bool){
        
        let objMoveInfo:MoveDetailsModel? = MoveDetailsModel.init(moveDictFromList: moveInfo)
        
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

        let urlString = moveInfo["photo_url"] as! String
        let uRL = URL.init(string: urlString)
        
        if uRL != nil{
            userImgView.af.setImage(withURL: uRL!)
        }
        else{
            userImgView.image = UIImage.init(named: "User_placeholder")
        }
        
        print(moveInfo)
        
        fromAddressLabel.text = (moveInfo["pickup_address"] as! String)
        toAddressLabel.text = (moveInfo["dropoff_address"] as! String)
        serviceType.text = (moveInfo["dropoff_service_name"] as! String) + "\n" + (moveInfo["helping_service_name"] as! String)
        labelMoveType.text = (moveInfo["move_type_name"] as! String)

        print(moveInfo)
        if let dt = moveInfo["pickup_date"] as? String ,!dt.isEmpty{
            
            dateTimeLabel.text = (moveInfo["pickup_date"] as! String) + "\n" + (moveInfo["pickup_start_time"] as! String) + " - " + (moveInfo["pickup_end_time"] as! String)
        }
        
        let miles = (moveInfo["total_miles_distance"] as! Double)
        distanceLabel.text = String.init(format: "%0.2f", miles) + " Miles"
        //distanceLabel.text = String(moveInfo["total_miles_distance"] as! Double) + " Miles"
        
        let userDefault = UserDefaults.standard
        let helper_service_type:Int = userDefault.value(forKey: kUserCache.service_type) as! Int
        
        let helping_service_required_pros:Int = (moveInfo["helping_service_required_pros"] as? Int ?? 0)
        let helping_service_required_muscle:Int = (moveInfo["helping_service_required_muscle"] as? Int ?? 0)
        
        let helper_accept_service_type:Int = moveInfo["helper_accept_service_type"] as? Int ?? 0
        
        if (helper_accept_service_type == HelperType.Pro) {//Pro
            acceptTypeLabel.text = "Pro"
            if let total_amount = (moveInfo["total_amount"] as? Double) {
                costLabel.text = "$" + String.init(format: "%0.2f", total_amount)
            }
            
            if(helping_service_required_pros > 0 && helping_service_required_muscle > 0) {
                if let amount = (moveInfo["total_pros_amount"] as? Double){
                    if (moveInfo["is_estimate_hour"] as? Int) == 0{
                        costLabel.text = "$" + String.init(format: "%0.2f", amount)
                        return
                    }
                    costLabel.text = "$" + String.init(format: "%0.2f/hr", amount)
                }
            }
        } else if (helper_accept_service_type == HelperType.Muscle){//Muscle
            acceptTypeLabel.text = "Muscle"
            if let total_amount = (moveInfo["total_amount"] as? Double) {
                if (moveInfo["is_estimate_hour"] as? Int) == 0{
                    costLabel.text = "$" + String.init(format: "%0.2f", total_amount)
                    return
                }
                costLabel.text = "$" + String.init(format: "%0.2f/hr", total_amount)
            }
            
            if(helping_service_required_pros > 0 && helping_service_required_muscle > 0) {
                if let amount = (moveInfo["total_muscle_amount"] as? Double){
                    if (moveInfo["is_estimate_hour"] as? Int) == 0{
                        costLabel.text = "$" + String.init(format: "%0.2f", amount)
                        return
                    }
                    costLabel.text = "$" + String.init(format: "%0.2f/hr", amount)
                }
            }
        } else {//Pro + Muscle
            
            // helper_accept_service_type = Int(ggg)!
            
            if let total_amount = (moveInfo["total_amount"] as? Double) {
                costLabel.text = "$" + String.init(format: "%0.2f", total_amount)
            }
            
            if(helping_service_required_pros > 0 && helping_service_required_muscle > 0) {
                if let total_amount = (moveInfo["total_amount"] as? Double) {
                    costLabel.text = "$" + String.init(format: "%0.2f", total_amount)
                    
                    if(helper_accept_service_type == HelperType.None) {
                        acceptTypeLabel.text = ""
                        let ggg2:String = moveInfo["other_helper_service_type"] as? String ?? "0"
                        var other_helper_service_type:Int = moveInfo["other_helper_service_type"] as? Int ?? 0
                        other_helper_service_type = Int(ggg2)!
                        
                        if let musleamount = (moveInfo["total_muscle_amount"] as? Double){
                            if (moveInfo["is_estimate_hour"] as? Int) == 1{
                                A1 = "$" + String.init(format: "%0.2f/hr", musleamount)
                            }else {
                                A1 = "$" + String.init(format: "%0.2f", musleamount)
                            }
                        }
                        if let proamount = (moveInfo["total_pros_amount"] as? Double){
                            if (moveInfo["is_estimate_hour"] as? Int) == 1{
                                A2 = "$" + String.init(format: "%0.2f/hr", proamount)
                            }else {
                                A2 = "$" + String.init(format: "%0.2f", proamount)
                            }
                            
                        }
                        let finalSt1 = "Muscle " + A1
                        let finalSt2 = "\n" + "Pro " + A2
                        costLabel.text = finalSt1 + finalSt2
                        costLabel.halfTextColorChange(fullText: costLabel.text!, changeText: "Muscle", changeText1: "Pro")
                        
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
                            
                            if (moveInfo["is_estimate_hour"] as? Int) == 1{
                                costLabel.text = "$" + String.init(format: "%0.2f/hr", amount)
                            }else {
                                costLabel.text = "$" + String.init(format: "%0.2f", amount)
                            }
                            
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
                    }else if(helper_accept_service_type == HelperType.ProMuscle) {
                        acceptTypeLabel.text = "Pro+Muscle"
                        if let amount = (moveInfo["total_muscle_amount"] as? Double){
                            if (moveInfo["is_estimate_hour"] as? Int) == 0{
                                costLabel.text = "$" + String.init(format: "%0.2f", amount)
                                return
                            }
                            costLabel.text = "$" + String.init(format: "%0.2f/hr", amount)
                        }
                        
                        if let musleamount = (moveInfo["total_muscle_amount"] as? Double){
                            if (moveInfo["is_estimate_hour"] as? Int) == 1{
                                A1 = "$" + String.init(format: "%0.2f/hr", musleamount)
                            }else {
                                A1 = "$" + String.init(format: "%0.2f", musleamount)
                            }
                            
                        }
                        if let proamount = (moveInfo["total_pros_amount"] as? Double){
                            if (moveInfo["is_estimate_hour"] as? Int) == 1{
                                A2 = "$" + String.init(format: "%0.2f/hr", proamount)
                            }else {
                                A2 = "$" + String.init(format: "%0.2f", proamount)
                            }
                            
                        }
                        let finalSt1 = "Muscle " + A1
                        let finalSt2 = "\n" + "Pro " + A2
                        costLabel.text = finalSt1 + finalSt2
                        costLabel.halfTextColorChange(fullText: costLabel.text!, changeText: "Muscle", changeText1: "Pro")
                        //                        costLabel.setLineHeightMultiple(to: 2.0, withAttributedText: costLabel)
                    }
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
            } else if(helping_service_required_pros > 0) {
                if let amount = (moveInfo["total_pros_amount"] as? Double){
                    acceptTypeLabel.text = "Pro"
                    costLabel.text = "$" + String.init(format: "%0.2f", amount)
                    if (moveInfo["is_estimate_hour"] as? Int) == 0{
                        costLabel.text = "$" + String.init(format: "%0.2f", amount)
                        return
                    }
                    costLabel.text = "$" + String.init(format: "%0.2f/hr", amount)

                }
            }
        }
        if (objMoveInfo?.move_type_id == 12) {
            costLabel.text = "$0.0"
        }
        
    }
    func setupInfoAvailableCancel(_ moveInfo: [String: Any], isCompleted: Bool, isCanceled:Bool){
        
        let objMoveInfo:MoveDetailsModel? = MoveDetailsModel.init(moveDictFromList: moveInfo)
        
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

//        let urlString = moveInfo["photo_url"] as! String
//        let uRL = URL.init(string: urlString)
//        userImgView.image = UIImage.init(named: "User_placeholder")
//        if uRL != nil{
//            userImgView.af.setImage(withURL: uRL!)
//        }
        print(moveInfo)
        
        fromAddressLabel.text = (moveInfo["pickup_address"] as! String)
        toAddressLabel.text = (moveInfo["dropoff_address"] as! String)
        serviceType.text = (moveInfo["dropoff_service_name"] as! String) + "\n" + (moveInfo["helping_service_name"] as! String)
        labelMoveType.text = (moveInfo["move_type_name"] as! String)
        print(moveInfo)
        if let dt = moveInfo["pickup_date"] as? String ,!dt.isEmpty{
            
            dateTimeLabel.text = (moveInfo["pickup_date"] as! String) + "\n" + (moveInfo["pickup_start_time"] as! String) + " - " + (moveInfo["pickup_end_time"] as! String)
        }
        
        let miles = (moveInfo["total_miles_distance"] as! Double)
        distanceLabel.text = String.init(format: "%0.2f", miles) + " Miles"
        //distanceLabel.text = String(moveInfo["total_miles_distance"] as! Double) + " Miles"
        
        let userDefault = UserDefaults.standard
        let helper_service_type:Int = userDefault.value(forKey: kUserCache.service_type) as! Int
        
        let helping_service_required_pros:Int = (moveInfo["helping_service_required_pros"] as? Int ?? 0)
        let helping_service_required_muscle:Int = (moveInfo["helping_service_required_muscle"] as? Int ?? 0)
        
        let helper_accept_service_type:Int = moveInfo["helper_accept_service_type"] as? Int ?? 0
        
        if (helper_service_type == HelperType.Pro) {//Pro
            acceptTypeLabel.text = "Pro"
            if let total_amount = (moveInfo["total_amount"] as? Double) {
                costLabel.text = "$" + String.init(format: "%0.2f", total_amount)
            }
            
            if(helping_service_required_pros > 0 && helping_service_required_muscle > 0) {
                if let amount = (moveInfo["total_pros_amount"] as? Double){
                    costLabel.text = "$" + String.init(format: "%0.2f", amount)
                    if (moveInfo["is_estimate_hour"] as? Int) == 0{
                        costLabel.text = "$" + String.init(format: "%0.2f", amount)
                        return
                    }
                    costLabel.text = "$" + String.init(format: "%0.2f/hr", amount)

                }
            }
        } else if (helper_service_type == HelperType.Muscle){//Muscle
            acceptTypeLabel.text = "Muscle"
            if let total_amount = (moveInfo["total_amount"] as? Double) {
                if (moveInfo["is_estimate_hour"] as? Int) == 0{
                    costLabel.text = "$" + String.init(format: "%0.2f", total_amount)
                    return
                }
                costLabel.text = "$" + String.init(format: "%0.2f/hr", total_amount)
            }
            
            if(helping_service_required_pros > 0 && helping_service_required_muscle > 0) {
                if let amount = (moveInfo["total_muscle_amount"] as? Double){
                    if (moveInfo["is_estimate_hour"] as? Int) == 0{
                        costLabel.text = "$" + String.init(format: "%0.2f", amount)
                        return
                    }
                    costLabel.text = "$" + String.init(format: "%0.2f/hr", amount)
                }
            }
        } else {//Pro + Muscle
            
            // helper_accept_service_type = Int(ggg)!
            
            if let total_amount = (moveInfo["total_amount"] as? Double) {
                costLabel.text = "$" + String.init(format: "%0.2f", total_amount)
            }
            
            if(helping_service_required_pros > 0 && helping_service_required_muscle > 0) {
                if let total_amount = (moveInfo["total_amount"] as? Double) {
                    costLabel.text = "$" + String.init(format: "%0.2f", total_amount)
                    
                    if(helper_accept_service_type == HelperType.None) {
                        acceptTypeLabel.text = ""
                        let ggg2:String = moveInfo["other_helper_service_type"] as? String ?? "0"
                        var other_helper_service_type:Int = moveInfo["other_helper_service_type"] as? Int ?? 0
                        other_helper_service_type = Int(ggg2)!
                        
                        if let musleamount = (moveInfo["total_muscle_amount"] as? Double){
                            if (moveInfo["is_estimate_hour"] as? Int) == 1{
                                A1 = "$" + String.init(format: "%0.2f/hr", musleamount)
                            }else {
                                A1 = "$" + String.init(format: "%0.2f", musleamount)
                            }
                            
                        }
                        if let proamount = (moveInfo["total_pros_amount"] as? Double){
                            if (moveInfo["is_estimate_hour"] as? Int) == 1{
                                A2 = "$" + String.init(format: "%0.2f/hr", proamount)
                            }else {
                                A2 = "$" + String.init(format: "%0.2f", proamount)
                            }
                        }
                        let finalSt1 = "Muscle " + A1
                        let finalSt2 = "\n" + "Pro " + A2
                        costLabel.text = finalSt1 + finalSt2
                        costLabel.halfTextColorChange(fullText: costLabel.text!, changeText: "Muscle", changeText1: "Pro")
                        
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
                                if (moveInfo["is_estimate_hour"] as? Int) == 1{
                                    costLabel.text = "$" + String.init(format: "%0.2f/hr", amount)
                                    return
                                }
                                costLabel.text = "$" + String.init(format: "%0.2f", amount)
                            }
                        }
                    } else if(helper_accept_service_type == HelperType.Pro) {
                        acceptTypeLabel.text = "Pro"
                        if let amount = (moveInfo["total_pros_amount"] as? Double){
                            if (moveInfo["is_estimate_hour"] as? Int) == 1{
                                costLabel.text = "$" + String.init(format: "%0.2f/hr", amount)
                            }else {
                                costLabel.text = "$" + String.init(format: "%0.2f", amount)
                            }
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
                    }else if(helper_accept_service_type == HelperType.ProMuscle) {
                        acceptTypeLabel.text = "Pro+Muscle"
                        if let amount = (moveInfo["total_muscle_amount"] as? Double){
                            if (moveInfo["is_estimate_hour"] as? Int) == 0{
                                costLabel.text = "$" + String.init(format: "%0.2f", amount)
                                return
                            }
                            costLabel.text = "$" + String.init(format: "%0.2f/hr", amount)
                        }
                        
                        if let musleamount = (moveInfo["total_muscle_amount"] as? Double){
                            if (moveInfo["is_estimate_hour"] as? Int) == 1{
                                A1 = "$" + String.init(format: "%0.2f/hr", musleamount)
                            }else {
                                A1 = "$" + String.init(format: "%0.2f", musleamount)
                            }
                        }
                        if let proamount = (moveInfo["total_pros_amount"] as? Double){
                            if (moveInfo["is_estimate_hour"] as? Int) == 1{
                                A2 = "$" + String.init(format: "%0.2f/hr", proamount)
                            }else {
                                A2 = "$" + String.init(format: "%0.2f", proamount)
                            }
                        }
                        let finalSt1 = "Muscle " + A1
                        let finalSt2 = "\n" + "Pro " + A2
                        costLabel.text = finalSt1 + finalSt2
                        costLabel.halfTextColorChange(fullText: costLabel.text!, changeText: "Muscle", changeText1: "Pro")
                        //                        costLabel.setLineHeightMultiple(to: 2.0, withAttributedText: costLabel)
                    }
                }
            } else if(helping_service_required_muscle > 0) {
                if let amount = (moveInfo["total_muscle_amount"] as? Double){
                    if (moveInfo["is_estimate_hour"] as? Int) == 0{
                        costLabel.text = "$" + String.init(format: "%0.2f", amount)
                        acceptTypeLabel.text = "Muscle"
                        acceptTypeLabel.numberOfLines = 1
                        return
                    }
                    costLabel.text = "$" + String.init(format: "%0.2f/hr", amount)
                    acceptTypeLabel.text = "Muscle"
                    acceptTypeLabel.numberOfLines = 1
                }
            }else if(helping_service_required_pros > 0) {
                if let amount = (moveInfo["total_pros_amount"] as? Double){
                    if (moveInfo["is_estimate_hour"] as? Int) == 0 {
                        costLabel.text = "$" + String.init(format: "%0.2f", amount)
                    }else {
                        costLabel.text = "$" + String.init(format: "%0.2f/hr", amount)
                    }
                    acceptTypeLabel.text = "Pro"
                    acceptTypeLabel.numberOfLines = 1
                }
            }
        }
        if (objMoveInfo?.move_type_id == 12) {
            costLabel.text = "$0.0"
        }
        if isCanceled{
            acceptTypeLabel.text = ""
            costLabel.text = ""
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}


extension UILabel {

    func setLineHeightMultiple(to height: CGFloat, withAttributedText attributedText: NSMutableAttributedString) {

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.0
        paragraphStyle.lineHeightMultiple = height
        paragraphStyle.alignment = textAlignment

        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.length - 1))

        self.attributedText = attributedText
    }
}
extension UILabel {
    func halfTextColorChange (fullText : String , changeText : String, changeText1 : String ) {
        let pinkColor = UIColor(red: 0.96, green: 0.68, blue: 0.71, alpha: 1.00)
        let strNumber: NSString = fullText as NSString
        let range = (strNumber).range(of: changeText)
        let range1 = (strNumber).range(of: changeText1)
        let attribute = NSMutableAttributedString.init(string: fullText)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: pinkColor , range: range)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: pinkColor , range: range1)
        self.attributedText = attribute
    }
}
