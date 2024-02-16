//
//  SimpleNotificationsAlertViewController.swift
//  MoveIt
//
//  Created by RV on 30/07/21.
//  Copyright © 2021 Jyoti. All rights reserved.
//

import UIKit

class SimpleNotificationsAlertViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var alertView: UIView!
    
    var titleText: String?
    var desc: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = titleText
        descLabel.text = desc
        alertView.layer.cornerRadius = 4
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touch = touches.first
        guard let location = touch?.location(in: self.view) else { return }
        if !alertView.frame.contains(location) {
            print("Tapped outside the view")
            self.dismiss(animated: true, completion: nil)
        } else {
            print("Tapped inside the view")
        }
        //self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func skipAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
