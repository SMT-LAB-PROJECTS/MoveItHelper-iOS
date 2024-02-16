//
//  AllScheduledMoveViewController.swift
//  MoveIt
//
//  Created by Dushyant on 28/12/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit
import Combine

class AllScheduledMoveViewController: UIViewController {
    
    @IBOutlet weak var menuCollectionView: UICollectionView!
    @IBOutlet weak var containerCollectionView: UICollectionView!
    private var disposeBag: Set<AnyCancellable> = []
    private var objectCount: [String] = ["0", "0"]

    var selectedMenuIndex = 0
    var scheduledMovesVC = ScheduledMoveViewController()
    var pendingMovesVC = AllPendingScheduledMovesViewController()
    
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scheduledMovesVC.$countDic.receive(on: DispatchQueue.main).sink { dic in
            self.objectCount.removeAll()
            let helperScheduledMove = (dic["helperScheduledMove"] as? Int ?? 0).description
            let helperPendingdMove = (dic["helperPendingdMove"] as? Int ?? 0).description
            self.objectCount.append(helperScheduledMove)
            self.objectCount.append(helperPendingdMove)
            self.menuCollectionView.reloadData()

        }.store(in: &disposeBag)
    }
    
    func setupViewControllers(){
        
        scheduledMovesVC = self.storyboard?.instantiateViewController(withIdentifier: "ScheduledMoveViewController") as! ScheduledMoveViewController
        scheduledMovesVC.moveType = MoveType.Scheduled
        
        pendingMovesVC = self.storyboard?.instantiateViewController(withIdentifier: "AllPendingScheduledMovesViewController") as! AllPendingScheduledMovesViewController
        pendingMovesVC.moveType = MoveType.Pending
        
        addChild(scheduledMovesVC)
        addChild(pendingMovesVC)
        
        scheduledMovesVC.view.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height:  (SCREEN_HEIGHT - 64 - 40.0 * screenHeightFactor))
        pendingMovesVC.view.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height:  (SCREEN_HEIGHT - 64 - 40.0 * screenHeightFactor))
        
        scheduledMovesVC.didMove(toParent: self)
        pendingMovesVC.didMove(toParent: self)

        if (isPendingScheduled) {
            self.selectedMenuIndex = 1
            
            self.containerCollectionView.delegate = self
            self.containerCollectionView.reloadData()
            self.containerCollectionView.layoutIfNeeded()
            
            self.containerCollectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    @objc func changePendingScheduledView() {
        
        if (isPendingScheduled == false) {
            self.selectedMenuIndex = 0
            self.containerCollectionView.delegate = self
            self.containerCollectionView.reloadData()
            self.containerCollectionView.layoutIfNeeded()
            self.containerCollectionView.scrollToItem(at: IndexPath(item: self.selectedMenuIndex, section: 0), at: .centeredHorizontally, animated: true)
            
            self.scheduledMovesVC.getAllScheduledMoves()
            
        } else if (isPendingScheduled == true) {
            self.selectedMenuIndex = 1
            self.containerCollectionView.delegate = self
            self.containerCollectionView.reloadData()
            self.containerCollectionView.layoutIfNeeded()
            self.containerCollectionView.scrollToItem(at: IndexPath(item: self.selectedMenuIndex, section: 0), at: .centeredHorizontally, animated: true)
            
            self.pendingMovesVC.getAllPendingScheduledMoves()
        }
    }
    
    func refreshSelectedSection(section:Int) {
        self.selectedMenuIndex = section
        self.containerCollectionView.delegate = self
        self.containerCollectionView.layoutIfNeeded()
        self.containerCollectionView.scrollToItem(at: IndexPath(item: self.selectedMenuIndex, section: 0), at: .centeredHorizontally, animated: true)
        
        self.containerCollectionView.reloadData()

        if(self.selectedMenuIndex == 0) {
            self.scheduledMovesVC.getAllScheduledMoves()
        } else {
            self.pendingMovesVC.getAllPendingScheduledMoves()
        }
    }
}

extension AllScheduledMoveViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == menuCollectionView{
            let menuCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCollectionViewCell", for: indexPath) as! MenuCollectionViewCell
            
            switch indexPath.item{
            case 0:
                menuCollectionCell.menuLabel.text = "Scheduled"
            case 1:
                menuCollectionCell.menuLabel.text = "Pending"
            default:
                menuCollectionCell.menuLabel.text = "Canceled"
            }
            menuCollectionCell.pageCount = objectCount[indexPath.item]

            
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
                if !containerCollectionCell.subviews.contains(scheduledMovesVC.view){
                    containerCollectionCell.addSubview(scheduledMovesVC.view)
                }
            }
            else if indexPath.item == 1{
                if !containerCollectionCell.subviews.contains(pendingMovesVC.view){
                    containerCollectionCell.addSubview(pendingMovesVC.view)
                }
            }
            
            return containerCollectionCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == menuCollectionView{
            return CGSize.init(width: SCREEN_WIDTH / 2, height: 40.0 * screenHeightFactor)
        }
        else{
            return CGSize.init(width: SCREEN_WIDTH , height: (SCREEN_HEIGHT - 64 - 40.0 * screenHeightFactor))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == menuCollectionView{
            
            selectedMenuIndex = indexPath.item
            
            self.containerCollectionView.delegate = self
            self.containerCollectionView.reloadData()
            self.containerCollectionView.layoutIfNeeded()
            containerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            collectionView.reloadData()
            
            if(indexPath.row == 0) {
                self.scheduledMovesVC.getAllScheduledMoves()
            } else if(indexPath.row == 1) {
                self.pendingMovesVC.getAllPendingScheduledMoves()
            }
        } else {
            
        }
    }
}
