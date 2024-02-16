//
//  PramotionalNotificationViewController.swift
//  MoveIt
//
//  Created by RV on 22/06/21.
//  Copyright © 2021 Jyoti. All rights reserved.
//

import UIKit

class PramotionalNotificationViewController: UIViewController {
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var offerImage: UIImageView!
    
    var price: String?
    var titleText: String?
    var desc: String?
    var code: String?
    var tnc: String?
    var photo_url: String?
    
    typealias CompletionBlock = (_ url: String) -> Void
    var onCompletion:CompletionBlock?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        offerImage.layer.cornerRadius = offerImage.frame.height/2
        priceLabel.text = price
        titleLabel.text = titleText
        descLabel.text = desc
        alertView.layer.cornerRadius = 8
        if let photo_url = photo_url{
            if let url = URL.init(string: photo_url){
                offerImage.af.setImage(withURL: url)
            }
        }
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

    @IBAction func goRedeemAction(_ sender: Any) {
        UIPasteboard.general.string = code
        self.dismiss(animated: true, completion: nil)
        UIApplication.shared.keyWindow?.rootViewController?.view.makeToast("Coupon code copied")
    }
    
    @IBAction func skipAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tncAction(_ sender: Any) {
        self.dismiss(animated: true) {
            if let isCompletion = self.onCompletion {
                isCompletion(self.tnc ?? "")
            }
        }
    }

}
