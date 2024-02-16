//
//  ChangeServiceAlert.swift
//  MoveIt
//
//  Created by RV on 11/06/21.
//  Copyright © 2021 Jyoti. All rights reserved.
//

import UIKit

protocol ChangeServiceActionDelegate {
    func selectedServiceActionDelegate(yes: Bool)
}

class ChangeServiceAlert: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
        
    var changeServiceDelegate: ChangeServiceActionDelegate?
    var message: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        messageLabel.text = message
        yesButton.layer.cornerRadius = 15
        noButton.layer.cornerRadius = 15
    }
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func yesAction(_ sender: Any) {
        changeServiceDelegate?.selectedServiceActionDelegate(yes: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func noAction(_ sender: Any) {
        changeServiceDelegate?.selectedServiceActionDelegate(yes: false)
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
