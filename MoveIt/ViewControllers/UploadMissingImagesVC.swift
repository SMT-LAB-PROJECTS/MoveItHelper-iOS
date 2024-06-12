//
//  UploadMissingImagesVC.swift
//  MoveIt
//
//  Created by SMT Sourabh  on 12/06/24.
//  Copyright © 2024 Jyoti. All rights reserved.
//

import UIKit

class UploadMissingImagesVC: UIViewController {
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonImage: UIButton!
    @IBOutlet weak var buttonVehicle: UIButton!
    @IBOutlet weak var buttonSignature: UIButton!
    typealias CompletionHandlerProfile = () -> Void
    typealias CompletionHandlerVehicle = () -> Void
    typealias CompletionHandlerSignature = () -> Void

    var onCompletionProfile:CompletionHandlerProfile?
    var onCompletionVehicle:CompletionHandlerVehicle?
    var onCompletionSignature:CompletionHandlerSignature?

    var profile = false
    var signature = false
    var vehicle = false
    var titleText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBackground.layer.cornerRadius = 20.0
        self.labelTitle.text = titleText
        buttonImage.isHidden = !profile
        buttonVehicle.isHidden = !vehicle
        buttonSignature.isHidden = !signature
    }
    
    @IBAction func actionOnProfile(_ sender: Any) {
        self.dismiss(animated: true)
        onCompletionProfile!()
    }
    
    @IBAction func actionOnVehicle(_ sender: Any) {
        self.dismiss(animated: true)
        onCompletionVehicle!()
    }
    
    @IBAction func actionOnSignature(_ sender: Any) {
        self.dismiss(animated: true)
        onCompletionSignature!()
    }
}
