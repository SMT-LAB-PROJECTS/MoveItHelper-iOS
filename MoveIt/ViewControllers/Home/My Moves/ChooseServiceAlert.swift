//
//  ChooseServiceAlert.swift
//  MoveIt
//
//  Created by RV on 15/06/21.
//  Copyright © 2021 Jyoti. All rights reserved.
//

import UIKit

@objc protocol ChooseServiceAlertDelegate {
    @objc optional func dismissOnlyFromChooseService()
    func serviceTypeSelected(_ requestID: Int,_ isProSelect: Bool)
}

class ChooseServiceAlert: UIViewController {

    var moveInfo : MoveDetailsModel?
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var proButton: UIButton!
    @IBOutlet weak var muscleButton: UIButton!
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var proPriceLabel: UILabel!
    @IBOutlet weak var musclePriceLabel: UILabel!
    @IBOutlet weak var proView: UIView!
    @IBOutlet weak var muscleView: UIView!
        
    var delegate: ChooseServiceAlertDelegate?
    var message: String?
    var requestID: Int?
    var isProSelect: Bool?
    var otherHelperServiceType: Int?
    var totalProsAmount: Double?
    var totalMuscleAmount: Double?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        proceedButton.layer.cornerRadius = 15
        proView.isHidden = true
        muscleView.isHidden = true
        proceedButton.isHidden = true
        
        self.getMoveDetails()        
    }
    
    func getMoveDetails(){
        StaticHelper.shared.startLoader(self.view)
        
        CommonAPIHelper.getMoveDetailByID(VC: self, move_id: requestID!, completetionBlock: { (result, error, isexecuted) in
            
            if error != nil{
                return
            } else{
                StaticHelper.shared.stopLoader()
                self.moveInfo = MoveDetailsModel.init(moveDict: result!)
                self.otherHelperServiceType = self.moveInfo?.other_helper_service_type
                
                self.configureOptions()
            }
        })
    }
            
    func configureOptions()
    {
        proceedButton.isHidden = false
        if otherHelperServiceType == HelperType.Pro {
            proView.isHidden = true
            muscleView.isHidden = false
            messageLabel.text = "This job has been already accepted by Pro helper, you can accept this job for Muscle service."
        } else if otherHelperServiceType == HelperType.Muscle {
            proView.isHidden = false
            muscleView.isHidden = true
            messageLabel.text = "This job has been already accepted by Muscle helper, you can accept this job for Pro service."
        } else {
            proView.isHidden = false
            muscleView.isHidden = false
        }
        if let amount = totalProsAmount {
            if moveInfo?.is_estimate_hour == 0{
                proPriceLabel.text = "$" + String.init(format: "%0.2f", amount)
                return
            }
            proPriceLabel.text = "$" + String.init(format: "%0.2f/hr", amount)

        }
        if let amount = totalMuscleAmount {
            if moveInfo?.is_estimate_hour == 0{
                musclePriceLabel.text = "$" + String.init(format: "%0.2f", amount)
                return
            }
            
            musclePriceLabel.text = "$" + String.init(format: "%0.2f/hr", amount)
        }
    }
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touch = touches.first
        guard let location = touch?.location(in: self.view) else { return }
        if !alertView.frame.contains(location) {
            print("Tapped outside the view")
            
            self.dismiss(animated: true, completion: {
                self.delegate?.dismissOnlyFromChooseService?()
            })
        } else {
            print("Tapped inside the view")
        }
    }

    @IBAction func proAction(_ sender: Any) {
        isProSelect = true
        proButton.setImage(UIImage(named: "radio_slct_btn"), for: .normal)
        muscleButton.setImage(UIImage(named: "radio_unslct_btn"), for: .normal)
    }
    
    @IBAction func muscleAction(_ sender: Any) {
        isProSelect = false
        proButton.setImage(UIImage(named: "radio_unslct_btn"), for: .normal)
        muscleButton.setImage(UIImage(named: "radio_slct_btn"), for: .normal)
    }
    
    @IBAction func proceedAction(_ sender: Any) {
        if isProSelect != nil {        
            //self.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: {
                self.delegate?.serviceTypeSelected(self.requestID ?? 0, self.isProSelect!)
            })
        }
    }    
}
