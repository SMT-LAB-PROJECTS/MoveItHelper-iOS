//
//  TutorialViewController.swift
//  MoveIt
//
//  Created by Dilip Saket on 14/01/22.
//  Copyright © 2022 Jyoti. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {

    let btnPrevious = UIButton()
    let btnNext = UIButton()

    let scrlViewBG = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.screenDesigningForTutorial()

        let btnBack = UIButton()
        btnBack.setImage(UIImage.init(named: "backward_arrow_icon"), for: .normal)
        btnBack.frame = CGRect(x: 10, y: 30, width: 44, height: 44)
        btnBack.addTarget(self, action: #selector(btnBackClicked), for: .touchDown)
        self.view.addSubview(btnBack)
        

        btnPrevious.backgroundColor = darkPinkColor
        btnPrevious.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        btnPrevious.setTitleColor(.black, for: .normal)
        btnPrevious.layer.cornerRadius = 20.0
        btnPrevious.clipsToBounds = true
        btnPrevious.setTitle("Prev", for: .normal)
        btnPrevious.frame = CGRect(x: 20, y: SCREEN_HEIGHT-60, width: 120, height: 40)
        btnPrevious.addTarget(self, action: #selector(btnPreviousClicked), for: .touchDown)
        self.view.addSubview(btnPrevious)

        btnNext.backgroundColor = darkPinkColor
        btnNext.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        btnNext.setTitleColor(.black, for: .normal)
        btnNext.layer.cornerRadius = 20.0
        btnNext.clipsToBounds = true
        btnNext.setTitle("Next", for: .normal)
        btnNext.frame = CGRect(x: SCREEN_WIDTH-140, y: SCREEN_HEIGHT-60, width: 120, height: 40)
        btnNext.addTarget(self, action: #selector(btnNextClicked), for: .touchDown)
        self.view.addSubview(btnNext)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.isNavigationBarHidden = true
                
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.isNavigationBarHidden = false
    }

    @objc func btnBackClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnNextClicked() {
        
        let strTitle:String = btnNext.title(for: .normal) ?? ""
        if(strTitle == "Got it") {
            if(profileInfo?.is_demo_completed == 0) {
                self.updateHelperDemoStatusAPICall()
            } else {
                self.btnBackClicked()
            }
        }
        
        if(scrlViewBG.contentOffset.x <= scrlViewBG.contentSize.width-SCREEN_WIDTH-SCREEN_WIDTH) {
            scrlViewBG.contentOffset = CGPoint(x: scrlViewBG.contentOffset.x+SCREEN_WIDTH, y: scrlViewBG.contentOffset.y)
        }
        
        if(scrlViewBG.contentOffset.x >= scrlViewBG.contentSize.width-SCREEN_WIDTH-SCREEN_WIDTH) {
            btnNext.setTitle("Got it", for: .normal)
        } else {
            btnNext.setTitle("Next", for: .normal)
        }
    }
    
    @objc func btnPreviousClicked() {
        if(scrlViewBG.contentOffset.x >= SCREEN_WIDTH) {
            scrlViewBG.contentOffset = CGPoint(x: scrlViewBG.contentOffset.x-SCREEN_WIDTH, y: scrlViewBG.contentOffset.y)
        }
        btnNext.setTitle("Next", for: .normal)
    }
    
    @objc func screenDesigningForTutorial() {
        
        self.view.backgroundColor = UIColor.init(_colorLiteralRed: 72.0/255.0, green: 72.0/255.0, blue: 72.0/255.0, alpha: 1.0)
        
        scrlViewBG.frame = CGRect(x: 0, y: 30, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-90)
        scrlViewBG.clipsToBounds = true
        scrlViewBG.bounces = false
        scrlViewBG.isPagingEnabled = true
        scrlViewBG.backgroundColor = UIColor.init(_colorLiteralRed: 72.0/255.0, green: 72.0/255.0, blue: 72.0/255.0, alpha: 1.0)
        self.view.addSubview(scrlViewBG)
        
        var xRef:CGFloat = 0.0
        for i in 1...26{

            let imgView = UIImageView()
            imgView.frame = CGRect(x: xRef, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-90)
            imgView.contentMode = .scaleToFill
            imgView.image = UIImage.init(named: "sc_"+String(i))
            scrlViewBG.addSubview(imgView)
            
            xRef = xRef+SCREEN_WIDTH
        }
        
        scrlViewBG.contentSize = CGSize(width: xRef, height: scrlViewBG.frame.size.height-20)
    }
    
    //MARK: -
    func updateHelperDemoStatusAPICall() {
        
        StaticHelper.shared.startLoader(self.view)

        CommonAPIHelper.updateHelperDemoStatusAPICall(VC: self, completetionBlock: { (result, error, isexecuted) in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                StaticHelper.shared.stopLoader()
                
                if error != nil {
                    return
                } else {
                    self.btnBackClicked()
                    return
                }
            }
        })
    }
    
}
