//
//  AllMovesViewController.swift
//  Move It
//
//  Created by Dushyant on 02/05/19.
//  Copyright © 2019 Agicent Technologies. All rights reserved.
//

import UIKit
import Combine

class AllMovesViewController: UIViewController {
    
    @IBOutlet weak var menuCollectionView: UICollectionView!
    
    @IBOutlet weak var containerCollectionView: UICollectionView!
    private var disposeBag: Set<AnyCancellable> = []
    private var objectCount: [String] = ["0", "0", "0"]

    var selectedMenuIndex = 0
    var availableMovesVC = AllMovesChildViewController()
    var completedMovesVC = AllMovesChildViewController()
    var cancelledMovesVC = AllMovesChildViewController()
    
    //MARK: - Methods Starts
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
        availableMovesVC.$countDic.receive(on: DispatchQueue.main).sink { dic in
            self.objectCount.removeAll()
            let availableMove = (dic["helperAvailableMove"] as? Int ?? 0)
            self.objectCount.append(availableMove.description)
            self.objectCount.append("0")
            self.objectCount.append("0")
            self.menuCollectionView.reloadData()

        }.store(in: &disposeBag)
    }
    
    func setupViewControllers(){
        
        availableMovesVC = self.storyboard?.instantiateViewController(withIdentifier: "AllMovesChildViewController") as! AllMovesChildViewController
        availableMovesVC.moveType = MoveType.Available
        completedMovesVC = self.storyboard?.instantiateViewController(withIdentifier: "AllMovesChildViewController") as! AllMovesChildViewController
        completedMovesVC.moveType = MoveType.Complete
        cancelledMovesVC = self.storyboard?.instantiateViewController(withIdentifier: "AllMovesChildViewController") as! AllMovesChildViewController
        cancelledMovesVC.moveType = MoveType.Canceled
      
        addChild(availableMovesVC)
        addChild(completedMovesVC)
        addChild(cancelledMovesVC)
        
        availableMovesVC.view.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height:  (SCREEN_HEIGHT - 64 - 40.0 * screenHeightFactor))
        completedMovesVC.view.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height:  (SCREEN_HEIGHT - 64 - 40.0 * screenHeightFactor))
        cancelledMovesVC.view.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height:  (SCREEN_HEIGHT - 64 - 40.0 * screenHeightFactor))
        
        availableMovesVC.didMove(toParent: self)
        completedMovesVC.didMove(toParent: self)
        cancelledMovesVC.didMove(toParent: self)
    }
}

extension AllMovesViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == menuCollectionView{
            let menuCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCollectionViewCell", for: indexPath) as! MenuCollectionViewCell
            
            switch indexPath.item{
            case 0:
                menuCollectionCell.menuLabel.text = "Available"
            case 1:
                menuCollectionCell.menuLabel.text = "Complete"
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
                if !containerCollectionCell.subviews.contains(availableMovesVC.view){
                    containerCollectionCell.addSubview(availableMovesVC.view)
                }
            }
            else if indexPath.item == 1{
                if !containerCollectionCell.subviews.contains(completedMovesVC.view){
                    containerCollectionCell.addSubview(completedMovesVC.view)
                }
            }
            else{
                if !containerCollectionCell.subviews.contains(cancelledMovesVC.view){
                    containerCollectionCell.addSubview(cancelledMovesVC.view)
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
            
            selectedMenuIndex = indexPath.item
            
            self.containerCollectionView.delegate = self
            self.containerCollectionView.reloadData()
            self.containerCollectionView.layoutIfNeeded()
            
            containerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            if(indexPath.row == 0) {
                SELECTED_MOVE_UPER_TAB_INDEX = 0
                appDelegate.homeVC?.showChangeRequestServicePopup(0)
                self.availableMovesVC.getAllAvailableMoves()
            } else if(indexPath.row == 1) {
                SELECTED_MOVE_UPER_TAB_INDEX = 1
                appDelegate.homeVC?.hideChangeRequestPopUpForCompleteCancel()
                self.completedMovesVC.getAllCompletedMoves()
            } else if(indexPath.row == 2) {
                SELECTED_MOVE_UPER_TAB_INDEX = 2
                appDelegate.homeVC?.hideChangeRequestPopUpForCompleteCancel()
                self.cancelledMovesVC.getAllCancelledMoves()
            }
            collectionView.reloadData()
        } else {
            
        }
    }
}
