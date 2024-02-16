//
//  InsuranceExpiredVC.swift
//  MoveIt
//
//  Created by Govind Kumar on 05/04/22.
//  Copyright © 2022 Jyoti. All rights reserved.
//

import UIKit

class InsuranceExpiredVC: UIViewController {
    
    var message:String = ""
    var titleMessage:String = ""
    var isPendingRequest:Bool = false
    var isRequestRejected:Bool = false

    @IBOutlet weak var pendingTitle: UILabel!
    @IBOutlet weak var pendingMessage: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
//  @IBOutlet weak var lblContactSupport: UILabel!
//  @IBOutlet weak var lblEmailAddress: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

//        setNavigationTitle("Insurance Expired")

//
        let leftBarButtonItem = StaticHelper.leftBarButtonWithImageNamed(imageName: "backward_arrow_icon", vc: self)
//  self.navigationItem.leftBarButtonItems = [leftBarButtonItem]
        
            pendingTitle.text = titleMessage
            pendingMessage.text = message
        
        if isPendingRequest{
            btnSubmit.isHidden = true
        }
//        if isRequestRejected{
//            btnSubmit.setTitle("Re-Update Info", for: .normal)
//        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.isNavigationBarHidden = false
    }

    //MARK: - Actions

    func gotoEditVehicleInfoVC() {
        let viVC = self.storyboard?.instantiateViewController(withIdentifier: "EditVehicleInfoViewController") as! EditVehicleInfoViewController
        viVC.isComeFromServiceStoped = true
        self.navigationController?.pushViewController(viVC, animated: true)
    }
    @IBAction func actionsOfSubmitBtn(_ sender: Any) {
        gotoEditVehicleInfoVC()
    }
    
}
