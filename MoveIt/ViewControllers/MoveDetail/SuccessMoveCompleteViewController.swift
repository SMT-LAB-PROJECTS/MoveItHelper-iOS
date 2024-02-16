//
//  SuccessMoveCompleteViewController.swift
//  MoveIt
//
//  Created by Dushyant on 23/07/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

protocol ShowRatingPopupDelegate {
    func showRatingMethod()
}

class SuccessMoveCompleteViewController: UIViewController {
    
    var showRatingPopupDelegate : ShowRatingPopupDelegate?
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.font = UIFont.josefinSansSemiBoldFontWithSize(size: 17.0)
        
        _ = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(dismissView), userInfo: nil, repeats: false)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func dismissView(){
        
        
        self.dismiss(animated: true, completion: {
            
            self.showRatingPopupDelegate?.showRatingMethod()
        })
    }
}
