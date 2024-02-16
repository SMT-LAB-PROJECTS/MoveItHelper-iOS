//
//  DiscountofferViewController.swift
//  MoveIt
//
//  Created by RV on 22/06/21.
//  Copyright © 2021 Jyoti. All rights reserved.
//

import UIKit
protocol RefreshNotifcationBagCount:AnyObject{
    func reloadNotificationCount()
}
class DiscountofferViewController: UIViewController {
    
    @IBOutlet weak var menuCollectionView: UICollectionView!
    @IBOutlet weak var containerCollectionView: UICollectionView!
    
    var selectedMenuIndex = 0
    
    var offerVC = NotificationListViewController()
    var appUpdateVC = NotificationListViewController()
    weak var delegate: RefreshNotifcationBagCount!

    var notification_type:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpNavigationBar()
        self.setupViewControllers()        
    }

    func setUpNavigationBar(){
        setNavigationTitle("Notification")
        
        self.navigationItem.leftBarButtonItem = StaticHelper.leftBarButton(withImageNamed: "backward_arrow_icon", forVC: self)
    }
    
    @objc func leftPressed(_ selector: Any){
        if let complition = delegate {
            complition.reloadNotificationCount()
        }
        self.navigationController?.popViewController(animated: true)
    }
 
    func setupViewControllers(){
        
        offerVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationListViewController") as! NotificationListViewController
        offerVC.notification_type = self.notification_type
        offerVC.vcType = 1
        
        appUpdateVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationListViewController") as! NotificationListViewController
        appUpdateVC.vcType = 2
        
        addChild(offerVC)
        addChild(appUpdateVC)
        
        offerVC.view.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height:  (SCREEN_HEIGHT - 64 - 40.0 * screenHeightFactor))
        appUpdateVC.view.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height:  (SCREEN_HEIGHT - 64 - 40.0 * screenHeightFactor))
        
        offerVC.didMove(toParent: self)
        appUpdateVC.didMove(toParent: self)
        self.containerCollectionView.reloadData()
        if discountOfferTab == 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                discountOfferTab = 0
                self.selectedMenuIndex = 1
                self.appUpdateVC.updateServiceCall()

                self.containerCollectionView.delegate = self
                self.containerCollectionView.reloadData()
                self.containerCollectionView.layoutIfNeeded()
                self.containerCollectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: false)
                self.menuCollectionView.reloadData()
            }
        }else{
            self.offerVC.announceServiceCall()
        }
    }
}


extension DiscountofferViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == menuCollectionView{
            let menuCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCollectionViewCell", for: indexPath) as! MenuCollectionViewCell
            
            switch indexPath.item{
                case 0:
                    menuCollectionCell.menuLabel.text = "Announcement"
                default:
                    menuCollectionCell.menuLabel.text = "Update"
            }
            
            if indexPath.item == selectedMenuIndex{
                menuCollectionCell.menuLabel.textColor = violetColor
                menuCollectionCell.dotView.isHidden = false
                menuCollectionCell.menuLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
            }
            else{
                menuCollectionCell.menuLabel.textColor = dullColor
                menuCollectionCell.dotView.isHidden = true
                menuCollectionCell.menuLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
            }
        
            
            return menuCollectionCell
        }
        else{
            let containerCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoveVCContainerCollectionViewCell", for: indexPath) as! MoveVCContainerCollectionViewCell
            if indexPath.item == 0{
                containerCollectionCell.addSubview(offerVC.view)
                offerVC.tableView.reloadData()
            } else if indexPath.item == 1{
                containerCollectionCell.addSubview(appUpdateVC.view)
                appUpdateVC.tableView.reloadData()
            }
            return containerCollectionCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == menuCollectionView{
            return CGSize.init(width: SCREEN_WIDTH / 2, height: 40.0 * screenHeightFactor)
        }
        else{
            return CGSize.init(width: SCREEN_WIDTH , height: (SCREEN_HEIGHT - 40.0 * screenHeightFactor))
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == menuCollectionView{
        
            selectedMenuIndex = indexPath.item
            print(indexPath)
            self.containerCollectionView.delegate = self
            self.containerCollectionView.reloadData()
            self.containerCollectionView.layoutIfNeeded()
            if indexPath.row == 0{
                self.offerVC.announceServiceCall()
            }else{
                self.appUpdateVC.updateServiceCall()
            }
            self.containerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            collectionView.reloadData()
        }
        else{
            
        }
    }
}
