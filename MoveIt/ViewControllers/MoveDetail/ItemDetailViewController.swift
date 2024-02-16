//
//  ItemDetailViewController.swift
//  MoveIt
//
//  Created by Dushyant on 24/07/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var itemBkView: UIView!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var itemQunLabel: UILabel!
    
    @IBOutlet weak var additionDeatailBkView: UIView!
    
    @IBOutlet weak var additionalLabel: UILabel!
    
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var depthLabel: UILabel!
    @IBOutlet weak var wightLabel: UILabel!
    @IBOutlet weak var asmDsmLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    
    @IBOutlet weak var widthInfoLabel: UILabel!
    @IBOutlet weak var heightInfoLabel: UILabel!
    @IBOutlet weak var depthInfoLabel: UILabel!
    @IBOutlet weak var weightInfoLabel: UILabel!
    @IBOutlet weak var asmDsmInfoLabel: UILabel!
    @IBOutlet weak var aboutInfoLabel: UITextView!
    
    @IBOutlet weak var imagesBkView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var itemPhotosLabel: UILabel!
    
    var itemDetails : MoveItems?
    var move_type_id:Int = 0
    
    @IBOutlet weak var yAboutTitle: NSLayoutConstraint!
    @IBOutlet weak var heightAboutView: NSLayoutConstraint!
    
    var selectedMoveType:MoveTypeModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBarConfiguration()
        self.uiConfigurationAfterStoryboard()
        aboutInfoLabel.isEditable = false
        setupdata()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        itemQunLabel.layer.cornerRadius = (itemQunLabel.bounds.size.height / 2)
    }
    
    func navigationBarConfiguration() {
        setNavigationTitle("Item Details")        
        self.navigationItem.leftBarButtonItem = StaticHelper.leftBarButton(withImageNamed: "backward_arrow_icon", forVC: self)
    }
    
    func uiConfigurationAfterStoryboard() {
        
        headerView.frame.size.height = SCREEN_HEIGHT - 64
        itemBkView.layer.cornerRadius = 10.0 * screenHeightFactor
        additionDeatailBkView.layer.cornerRadius = 10.0 * screenHeightFactor
        imagesBkView.layer.cornerRadius = 10.0 * screenHeightFactor
        
        itemLabel.font = UIFont.josefinSansRegularFontWithSize(size: 14.0)
        itemQunLabel.font = UIFont.josefinSansRegularFontWithSize(size: 14.0)
        
        additionalLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        widthLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        heightLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        depthLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        wightLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        asmDsmLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        aboutLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        aboutLabel.text = "Notes"
        itemPhotosLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        widthInfoLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        heightInfoLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        depthInfoLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        weightInfoLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        asmDsmInfoLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        aboutInfoLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)

    }
    
    
    @objc func leftPressed(_ selector: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupdata(){
      
        itemLabel.text = itemDetails?.item_name
        itemQunLabel.text = String((itemDetails?.quantity)!)
        
        if itemDetails?.item_width != nil,itemDetails?.item_width != 0.0{
            widthInfoLabel.text = String((itemDetails?.item_width)!)
        } else {
            widthInfoLabel.text = "N/A"
        }
        
        if itemDetails?.item_height != nil,itemDetails?.item_height != 0.0{
            heightInfoLabel.text = String((itemDetails?.item_height)!)
        } else {
            heightInfoLabel.text = "N/A"
        }
        
        if itemDetails?.item_weight != nil,itemDetails?.item_weight != 0.0{
            weightInfoLabel.text = String((itemDetails?.item_weight)!)
        } else {
            weightInfoLabel.text = "N/A"
        }
        
        if itemDetails?.item_depth != nil,itemDetails?.item_depth != 0.0{
            depthInfoLabel.text = String((itemDetails?.item_depth)!)
        } else {
            depthInfoLabel.text = "N/A"
        }
        
        if itemDetails?.additional_info != nil,!((itemDetails?.additional_info?.isEmpty)!){
            aboutInfoLabel.text = (itemDetails?.additional_info)!
        } else {
            aboutInfoLabel.text = "N/A"
        }
        if (itemDetails?.is_assamble)! == true{
            asmDsmInfoLabel.text = "YES"
        } else {
            asmDsmInfoLabel.text = "NO"
        }
        
        if(self.selectedMoveType?.is_additional_info == 0) {
            
            additionalLabel.isHidden = true
            widthLabel.isHidden = true
            heightLabel.isHidden = true
            depthLabel.isHidden = true
            wightLabel.isHidden = true
            asmDsmLabel.isHidden = true
            
            widthInfoLabel.isHidden = true
            heightInfoLabel.isHidden = true
            depthInfoLabel.isHidden = true
            weightInfoLabel.isHidden = true
            asmDsmInfoLabel.isHidden = true
                        
            yAboutTitle.constant = 20 * screenHeightFactor
            heightAboutView.constant = 120.0 * screenHeightFactor
        } else {
            yAboutTitle.constant = 170 * screenHeightFactor
            heightAboutView.constant = 270 * screenHeightFactor
        }
        
        self.collectionView.reloadData()
    }

}

extension ItemDetailViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let itemsDict = itemDetails?.item_photo{
             return itemsDict.count
        } else {
             return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemsImagesCell", for: indexPath)
        let imgView = cell.viewWithTag(1) as! UIImageView
        imgView.layer.cornerRadius = 5.0 * screenHeightFactor
        imgView.clipsToBounds = true
        if let itemsDict = itemDetails?.item_photo{
            let url = URL.init(string: itemsDict[indexPath.item])
            imgView.af.setImage(withURL: url!)
        }
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 50.0 * screenHeightFactor, height: 50.0 * screenHeightFactor)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imgPrevVc = self.storyboard?.instantiateViewController(withIdentifier: "ImagePreviewViewController") as! ImagePreviewViewController
        let cl = collectionView.cellForItem(at: indexPath)
        let imgv = cl?.viewWithTag(1) as! UIImageView
        imgPrevVc.modalPresentationStyle = .overFullScreen
        imgPrevVc.selctedImage = (imgv.image)!
        self.present(imgPrevVc, animated: true, completion: nil)
    }
}
