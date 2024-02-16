//
//  MainMessagesViewController.swift
//  MoveIt
//
//  Created by RV on 29/05/21.
//  Copyright © 2021 Jyoti. All rights reserved.
//

import UIKit

class MainMessagesViewController: UIViewController {
   
    
    @IBOutlet weak var menuCollectionView: UICollectionView!
    @IBOutlet weak var containerCollectionView: UICollectionView!
    
    var selectedMenuIndex = 0
    
    var customerChatVC = MessagesViewController()
    var helperChatVC = MessagesViewController()
    var adminChatVC = AdminChatViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.containerCollectionView.contentInsetAdjustmentBehavior = .automatic
        
        if #available(iOS 11.0, *) {
            self.containerCollectionView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            // Fallback on earlier versions
        }
        self.setupViewControllers()
    }
    
    func redirectToTheMessage(_ userInfo: [AnyHashable : Any]) {
        
        if userInfo[AnyHashable("chat_id")] != nil {//CUSTOMER CHAT
            selectedMenuIndex = 0
        } else {//HELPER CHAT
            selectedMenuIndex = 1
        }
        
        self.containerCollectionView.delegate = self
        self.containerCollectionView.reloadData()
        self.containerCollectionView.layoutIfNeeded()
        
        self.containerCollectionView.scrollToItem(at: IndexPath.init(item: selectedMenuIndex, section: 0), at: .centeredHorizontally, animated: true)
        self.containerCollectionView.reloadData()
        
        if(selectedMenuIndex == 0) {
            self.customerChatVC.getChats()
            self.customerChatVC.redirectToTheMessageChat(userInfo)
        } else {
            self.helperChatVC.getChats()
            self.helperChatVC.redirectToTheMessageChat(userInfo)
        }
        
    }
    
    func setupViewControllers(){
        
        customerChatVC = self.storyboard?.instantiateViewController(withIdentifier: "MessagesViewController") as! MessagesViewController
        customerChatVC.chatUserType = ChatUserType.Customer
        
        helperChatVC = self.storyboard?.instantiateViewController(withIdentifier: "MessagesViewController") as! MessagesViewController
        helperChatVC.chatUserType = ChatUserType.Helper
        
//        adminChatVC = AdminChatViewController.getVCInstance() as! AdminChatViewController
//        adminChatVC.chatUserType = ChatUserType.Admin
        
        addChild(customerChatVC)
        addChild(helperChatVC)
//        addChild(adminChatVC)

        customerChatVC.view.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height:  (SCREEN_HEIGHT - 64 - 40.0 * screenHeightFactor))
        
        helperChatVC.view.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height:  (SCREEN_HEIGHT - 64 - 40.0 * screenHeightFactor))
        
//        adminChatVC.view.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height:  (SCREEN_HEIGHT - menuCollectionView.frame.size.height - 80))
//        (width: SCREEN_WIDTH , height: (SCREEN_HEIGHT - menuCollectionView.frame.size.height) - 80)
        customerChatVC.didMove(toParent: self)
        helperChatVC.didMove(toParent: self)
//        adminChatVC.didMove(toParent: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
//        if selectedMenuIndex == 2{
//            selectedMenuIndex = 0
//          let indexPath = IndexPath(item: 2, section: 0)
//          let containerCollectionCell = self.containerCollectionView.dequeueReusableCell(withReuseIdentifier: "MoveVCContainerCollectionViewCell", for: indexPath) as! MoveVCContainerCollectionViewCell
//            if !containerCollectionCell.subviews.contains(customerChatVC.view){
//                containerCollectionCell.addSubview(customerChatVC.view)
//            }
//
//            self.customerChatVC.getChats()
//            containerCollectionView.reloadData()
            menuCollectionView.reloadData()
        }
//    }
   
}

extension MainMessagesViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == menuCollectionView{
            let menuCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCollectionViewCell", for: indexPath) as! MenuCollectionViewCell
            
            switch indexPath.item{
            case 0:
                menuCollectionCell.menuLabel.text = "Customer"
            case 1:
                menuCollectionCell.menuLabel.text = "Helper"
            default:
                menuCollectionCell.menuLabel.text = "Support"
            }
            menuCollectionCell.adminChatCountView.isHidden = true
            menuCollectionCell.adminChatCountLabel.isHidden = true
            if indexPath.row == 2{
                menuCollectionCell.menuLabel.textColor = dullColor
                menuCollectionCell.dotView.isHidden = true
                menuCollectionCell.menuLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
                if adminChatNotificationCount != 0{
                    menuCollectionCell.adminChatCountView.layer.cornerRadius = 7.0
                    menuCollectionCell.adminChatCountView.isHidden = false
                    menuCollectionCell.adminChatCountLabel.isHidden = false
                    menuCollectionCell.adminChatCountLabel.text =  "\(adminChatNotificationCount)"
                }
            }else{
                if indexPath.item == selectedMenuIndex{
                    menuCollectionCell.menuLabel.textColor = violetColor
                    menuCollectionCell.dotView.isHidden = false
                    menuCollectionCell.menuLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
                }else{
                    menuCollectionCell.menuLabel.textColor = dullColor
                    menuCollectionCell.dotView.isHidden = true
                    menuCollectionCell.menuLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
                }
            }
            return menuCollectionCell
        }
        else{
            let containerCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoveVCContainerCollectionViewCell", for: indexPath) as! MoveVCContainerCollectionViewCell
            
            if indexPath.item == 0{
                if !containerCollectionCell.subviews.contains(customerChatVC.view){
                    containerCollectionCell.addSubview(customerChatVC.view)
                }
            }else if indexPath.item == 1{
                if !containerCollectionCell.subviews.contains(helperChatVC.view){
                    containerCollectionCell.addSubview(helperChatVC.view)
                }
            }
            return containerCollectionCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == menuCollectionView{
            return CGSize.init(width: SCREEN_WIDTH / 3, height: 40.0 * screenHeightFactor)
        }
        else{
            return CGSize.init(width: SCREEN_WIDTH , height: (SCREEN_HEIGHT - 64 - 40.0 * screenHeightFactor))
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == menuCollectionView{
            if indexPath.row == 2{
                let objAdminChat = AdminChatViewController.getVCInstance() as! AdminChatViewController
                self.navigationController?.pushViewController(objAdminChat, animated: true)
            }else{
                selectedMenuIndex = indexPath.item
                
                self.containerCollectionView.delegate = self
                self.containerCollectionView.reloadData()
                self.containerCollectionView.layoutIfNeeded()
                
                containerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                collectionView.reloadData()
                
                if(selectedMenuIndex == 0) {
                    self.customerChatVC.getChats()
                }else if(selectedMenuIndex == 1){
                    self.helperChatVC.getChats()
                }
            }
        }
        else{
            
        }
    }
}
