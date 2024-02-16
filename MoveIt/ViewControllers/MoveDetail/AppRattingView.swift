//
//  AppRattingView.swift
//  Move It
//
//  Created by Dilip Saket on 30/10/21.
//  Copyright © 2021 Agicent Technologies. All rights reserved.
//

import Foundation
import UIKit

class AppRattingViewView:UIView, UITextViewDelegate {
    
    var ratingValue:Int = 0
    var request_id:Int = 0
    var selfVC:UIViewController!
    
    let viewUpdate = UIView()
    let lblTitle = UILabel()
    let imgLogo = UIImageView()
    let lblDesc = UILabel()
    let viewRtingStar:UIView = UIView()
    
    let txtViewReview:UITextView = UITextView()
    let lblPlaceHolder:UILabel = UILabel()
    
    let btnUpdate = UIButton()
    let btnSkip = UIButton()
    
    
    var width:CGFloat = 320
    let height:CGFloat = 420
    let space:CGFloat = 20
    
    let imgView1:UIButton = UIButton()
    let imgView2:UIButton = UIButton()
    let imgView3:UIButton = UIButton()
    let imgView4:UIButton = UIButton()
    let imgView5:UIButton = UIButton()
    
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override init(frame: CGRect) {

        super.init(frame:frame)
        
        self.frame = appDelegate.window!.bounds
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        
        viewUpdate.layer.cornerRadius = 10.0
        viewUpdate.clipsToBounds = true
        viewUpdate.frame = CGRect(x: (appDelegate.window!.bounds.size.width-width)/2.0, y: (appDelegate.window!.bounds.size.height-height-60)/2.0, width: width, height: height)
        viewUpdate.backgroundColor = .white
        self.addSubview(viewUpdate)
                        
        lblTitle.frame = CGRect(x: 20, y: 20, width: width-space-space, height: 50)
        lblTitle.text = "Move It App Rating"
        lblTitle.textAlignment = .center
        lblTitle.font = UIFont.josefinSansBoldFontWithSize(size: 20.0)
        viewUpdate.addSubview(lblTitle)
                
        imgLogo.frame = CGRect(x: (width-60)/2.0, y: 80, width: 60, height: 60)
        imgLogo.backgroundColor = .clear
        imgLogo.image = UIImage.init(named: "logo")
        viewUpdate.addSubview(imgLogo)

        lblDesc.frame = CGRect(x: 20, y: 160, width: width-space-space, height: 60)
        lblDesc.numberOfLines = 0
        lblDesc.textColor = .darkGray
        lblDesc.textAlignment = .center
        lblDesc.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        lblDesc.text = "How was your experience with us? \nTap a star to rate it on the App Store."
        viewUpdate.addSubview(lblDesc)

        
        viewRtingStar.frame = CGRect(x:0, y: 240, width: width, height: 44)
        viewRtingStar.backgroundColor = .clear
        viewUpdate.addSubview(viewRtingStar)
        
        let wh:CGFloat = 40
        let xSpace:CGFloat = 10
        var xRef:CGFloat = (width - ((4*xSpace) + (wh*5)))/2.0
        
        imgView1.frame = CGRect(x: xRef, y: 0, width: wh, height: wh)
        imgView1.setImage(UIImage.init(named: "rating_star_unselected"), for: .normal)
        imgView1.setImage(UIImage.init(named: "rating_star_selected"), for: .selected)
        viewRtingStar.addSubview(imgView1)
        
        xRef = xRef + xSpace + wh
        
        imgView2.frame = CGRect(x: xRef, y: 0, width: wh, height: wh)
        imgView2.setImage(UIImage.init(named: "rating_star_unselected"), for: .normal)
        imgView2.setImage(UIImage.init(named: "rating_star_selected"), for: .selected)
        viewRtingStar.addSubview(imgView2)
        
        xRef = xRef + xSpace + wh
        
        imgView3.frame = CGRect(x: xRef, y: 0, width: wh, height: wh)
        imgView3.setImage(UIImage.init(named: "rating_star_unselected"), for: .normal)
        imgView3.setImage(UIImage.init(named: "rating_star_selected"), for: .selected)
        viewRtingStar.addSubview(imgView3)
        
        xRef = xRef + xSpace + wh
        
        imgView4.frame = CGRect(x: xRef, y: 0, width: wh, height: wh)
        imgView4.setImage(UIImage.init(named: "rating_star_unselected"), for: .normal)
        imgView4.setImage(UIImage.init(named: "rating_star_selected"), for: .selected)
        viewRtingStar.addSubview(imgView4)
        
        xRef = xRef + xSpace + wh
        
        imgView5.frame = CGRect(x: xRef, y: 0, width: wh, height: wh)
        imgView5.setImage(UIImage.init(named: "rating_star_unselected"), for: .normal)
        imgView5.setImage(UIImage.init(named: "rating_star_selected"), for: .selected)
        viewRtingStar.addSubview(imgView5)
        
        xRef = xRef + xSpace + wh
        
        
        imgView1.tag = 1
        imgView2.tag = 2
        imgView3.tag = 3
        imgView4.tag = 4
        imgView5.tag = 5
        
        imgView1.addTarget(self, action: #selector(imgViewClicked(_:)), for: .touchDown)
        imgView2.addTarget(self, action: #selector(imgViewClicked(_:)), for: .touchDown)
        imgView3.addTarget(self, action: #selector(imgViewClicked(_:)), for: .touchDown)
        imgView4.addTarget(self, action: #selector(imgViewClicked(_:)), for: .touchDown)
        imgView5.addTarget(self, action: #selector(imgViewClicked(_:)), for: .touchDown)
        
//        rating_star_unselected
//        rating_star_selected
        
        self.txtViewReview.frame = CGRect(x:space, y: 300, width: width-space-space, height: 80)
        self.txtViewReview.font = UIFont.josefinSansRegularFontWithSize(size: 14.0)
        self.txtViewReview.delegate = self
        self.txtViewReview.text = ""
        self.txtViewReview.isHidden = true
        self.txtViewReview.layer.cornerRadius = 6.0
        self.txtViewReview.layer.borderColor = UIColor.init(red: 205/255.0, green: 185/255.0, blue: 189/255.0, alpha: 1.0).cgColor
        self.txtViewReview.layer.borderWidth = 1.0
        self.txtViewReview.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        viewUpdate.addSubview(txtViewReview)
        
        lblPlaceHolder.text = "Enter your feedback..."
        lblPlaceHolder.font = UIFont.systemFont(ofSize: txtViewReview.font!.pointSize)
        lblPlaceHolder.sizeToFit()
        txtViewReview.addSubview(lblPlaceHolder)
        lblPlaceHolder.frame.origin = CGPoint(x: 15, y: 2+(txtViewReview.font?.pointSize)! / 2)
        lblPlaceHolder.textColor = UIColor.lightGray
        lblPlaceHolder.isHidden = !txtViewReview.text.isEmpty

        btnUpdate.setBackgroundImage(UIImage.init(named: "btn_gradient"), for: .normal)
        btnUpdate.frame = CGRect(x:space, y: 300, width: width-space-space, height: 54)
        btnUpdate.setTitle("Submit", for: .normal)
        btnUpdate.titleLabel?.font = UIFont.josefinSansRegularFontWithSize(size: 17.0)
        btnUpdate.setTitleColor(.black, for: .normal)
        btnUpdate.addTarget(self, action: #selector(self.btnUpdateClicked), for: .touchDown)
        btnUpdate.addTarget(self, action: #selector(self.removeFromSuperview), for: .touchDown)
        viewUpdate.addSubview(btnUpdate)
        
        btnSkip.frame = CGRect(x:space, y: 354, width: width-space-space, height: 60)
        btnSkip.backgroundColor = .clear
        btnSkip.setTitle("Skip", for: .normal)
        btnSkip.titleLabel?.font = UIFont.josefinSansRegularFontWithSize(size: 17.0)
        btnSkip.setTitleColor(.black, for: .normal)
        btnSkip.addTarget(self, action: #selector(self.removeFromSuperview), for: .touchDown)
        viewUpdate.addSubview(btnSkip)

        appDelegate.window?.addSubview(self)
    }
    
    @objc func btnUpdateClicked() {
                
        if(ratingValue > 0) {
            self.postCustomerRatingsStatus(rating: ratingValue)
        } else {
            makeToast("please rate the app.")
        }
    }
    
    @objc func imgViewClicked(_ sender:UIButton) {
        
        imgView1.isSelected = false
        imgView2.isSelected = false
        imgView3.isSelected = false
        imgView4.isSelected = false
        imgView5.isSelected = false
        
        self.txtViewReview.isHidden = true
        
        viewUpdate.frame = CGRect(x: (appDelegate.window!.bounds.size.width-width)/2.0, y: (appDelegate.window!.bounds.size.height-height-60)/2.0, width: width, height: height)
        
        btnUpdate.frame = CGRect(x:space, y: 300, width: width-space-space, height: 54)
        btnSkip.frame = CGRect(x:space, y: 354, width: width-space-space, height: 60)
        
        ratingValue = sender.tag
        print("rating = ", ratingValue)
        if(ratingValue == 1) {
            imgView1.isSelected = true
            self.showTextEnter()
        } else if(ratingValue == 2) {
            imgView1.isSelected = true
            imgView2.isSelected = true
            self.showTextEnter()
        } else if(ratingValue == 3) {
            imgView1.isSelected = true
            imgView2.isSelected = true
            imgView3.isSelected = true
            self.showTextEnter()
        } else if(ratingValue == 4) {
            imgView1.isSelected = true
            imgView2.isSelected = true
            imgView3.isSelected = true
            imgView4.isSelected = true
        } else if(ratingValue == 5) {
            imgView1.isSelected = true
            imgView2.isSelected = true
            imgView3.isSelected = true
            imgView4.isSelected = true
            imgView5.isSelected = true
        }
        
    }

    func showTextEnter()
    {
        self.txtViewReview.isHidden = false
        
        let diff:CGFloat = 90
        viewUpdate.frame = CGRect(x: (appDelegate.window!.bounds.size.width-width)/2.0, y: (appDelegate.window!.bounds.size.height-height-60)/2.0, width: width, height: height+diff)
        
        btnUpdate.frame = CGRect(x:space, y: 300+diff, width: width-space-space, height: 54)
        btnSkip.frame = CGRect(x:space, y: 354+diff, width: width-space-space, height: 60)

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textViewDidChange(_ textView: UITextView) {
        lblPlaceHolder.isHidden = !textView.text.isEmpty
    }
    
    func postCustomerRatingsStatus(rating:Int) {
        
        CommonAPIHelper.postHelperAppRating(VC: selfVC, move_id: request_id, rating: rating, message:self.txtViewReview.text!, completetionBlock: { (result, error, isexecuted) in
                             
            DispatchQueue.main.async {
                self.removeFromSuperview()
                if error != nil{
                    return
                }
                else {
                    self.makeToast("please rate the app.")

                    if(self.ratingValue >= 4) {
                        if let url = URL(string: "itms-apps://apple.com/app/1488199360?action=write-review") {
                            UIApplication.shared.open(url)
                        }
                    }
                }
            }
        })
    }

}
