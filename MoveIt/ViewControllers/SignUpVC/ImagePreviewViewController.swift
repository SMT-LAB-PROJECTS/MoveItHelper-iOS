//
//  ImagePreviewViewController.swift
//  MoveIt
//
//  Created by Dushyant on 30/05/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class ImagePreviewViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    
    var selctedImage = UIImage()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgView.image = selctedImage
    }
    

    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
  

}
