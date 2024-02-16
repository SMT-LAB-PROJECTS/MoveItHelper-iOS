//
//  EditItemViewController.swift
//  Move It Customer
//
//  Created by Dushyant on 07/05/19.
//  Copyright © 2019 Agicent Technologies. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class EditItemViewController: UIViewController,UITextFieldDelegate {
    var moveDict = [String: Any]()
    var addMoreItemVC:AddMoreItemViewController!
    var itemIndex:Int = 0
    var itemsDict = [String: Any]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var itemBackView: UIView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemRemoveButton: UIButton!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var quantityBkView: UIView!
    @IBOutlet weak var howManyLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var itemQuantityLabel: UILabel!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var bkView: UIView!
    @IBOutlet weak var takePhotoLabel: UILabel!
    @IBOutlet weak var subTakPhotoLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var continueLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var heightConst: NSLayoutConstraint!
    @IBOutlet weak var additionLabel: UILabel!
    
    var isFromAddMore = false
    var isFromEditMenue = false
    
    var canAssemble = true
    var isAssemble = false
    
    var is_custom_item = false
    
    var isAdditionalinfVisible = false
    var requires2Person = false
    var isCarryWithPeople = false

    var imagesArray = [UIImage]()
    
    var itemImage = UIImage()
    var itemName = String()
    
    var imageUrls = [String]()
    
    var itemWidth  = 0.0
    var itemDepth  = 0.0
    var itemHeight = 0.0
    var itemWeight = 0.0
    var itemPrice  = 0.0
    
    var additionalInfo = String()
    
    var quantityNumber = 1{
        didSet {            
            itemQuantityLabel.text = String(quantityNumber)
            junkQuantityLabel.text = String(quantityNumber)
        }
    }
    
    let imagePickerController = UIImagePickerController()
        
    @IBOutlet weak var topInfoLabel: NSLayoutConstraint!
    
    @IBOutlet weak var junkMinusButton: UIButton!
    @IBOutlet weak var junkPlusButton: UIButton!
    @IBOutlet weak var junkQuantityLabel: UILabel!
    @IBOutlet weak var junkQuantityTitle: UILabel!
    @IBOutlet weak var junkHeight: NSLayoutConstraint!

    var selectedMoveType:MoveTypeModel?
    var alertPermmisionView :AlertViewPermmision?

    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()

        self.itemRemoveButton.isHidden = true
        self.navigationConfiguration()
        self.uiConfigurationAfterStoryboard()
        
        self.configureDynamicUI()
        
        self.someOtherSettings()
    }
    
    func someOtherSettings() {
        if self.isFromAddMore{
            self.continueLabel.text = "Add Item(s)"
        }
        
        if let k = itemsDict["is_custom_item"] as? Int, k == 1{
            self.is_custom_item = true
        } else{
            self.is_custom_item = false
        }
        
        if isFromEditMenue {

            self.itemName = itemsDict[keysForBookMoves.item_name] as! String
            self.quantityNumber = itemsDict[keysForBookMoves.quantity] as! Int
            if ((itemsDict[keysForBookMoves.can_assamble] as! Int) == 0) {
                self.canAssemble = false
            } else {
                self.canAssemble = true
            }
            if ((itemsDict[keysForBookMoves.is_assamble] as? Int ?? 0) == 0) {
                if (itemsDict["can_assemble"] as? Int ?? 0) == 0{
                       self.canAssemble = false
                } else{
                    self.canAssemble = true
                }
            } else {
                self.isAssemble = true
            }
            
            if ((itemsDict[keysForBookMoves.is_carry_with_people] as? Int ?? 0) == 0) {
                self.isCarryWithPeople = false
            }else{
                self.isCarryWithPeople = true
            }
            
            self.itemHeight = itemsDict[keysForBookMoves.item_height] as! Double
            self.itemWidth = itemsDict[keysForBookMoves.item_width] as! Double
            self.itemDepth = itemsDict[keysForBookMoves.item_depth] as! Double
            self.itemWeight = itemsDict[keysForBookMoves.item_weight] as! Double
            self.additionalInfo = itemsDict[keysForBookMoves.additional_info] as! String
            self.itemPrice = (itemsDict[keysForBookMoves.item_price] as! Double)
            
            self.imageUrls = itemsDict[keysForBookMoves.item_photos] as! [String]
            self.imagesArray = Array.init(repeating: UIImage(), count: imageUrls.count)
            self.itemNameLabel.text = self.itemName
            let imgURL = URL.init(string: (itemsDict["subcategory_photo_url"] as! String))
            if imgURL != nil{
                self.itemImageView.af.setImage(withURL: imgURL!)
            }
            
            self.tableView.reloadData()
            self.collectionView.reloadData()
        } else {
//            let itemsDs = moveDict["items"] as? [[String:Any]] ?? []
//
//            for itemD in itemsDs {
//                let arrURLs:[String] = itemD[keysForBookMoves.item_photos]  as? [String] ?? []
//
//                for strURL in arrURLs {
//                    self.imageUrls.append(strURL)
//                }
//            }
//
//            self.imagesArray = Array.init(repeating: UIImage(), count: imageUrls.count)

            self.itemName = itemsDict["subcategory_name"] as! String

            let imgURL = URL.init(string: (itemsDict["subcategory_photo_url"] as! String))
            if imgURL != nil{
                self.itemImageView.af.setImage(withURL: imgURL!)
            } else{
                 self.itemImageView.image = UIImage.init(named: "home_card_img_placeholder")
            }
            
            if is_custom_item{
                  self.itemPrice = 0.0
            } else {
                  self.itemPrice = Double(itemsDict["subcategory_price"] as! String)!
            }
            self.itemNameLabel.text = self.itemName
            if (itemsDict[keysForBookMoves.can_assamble] as? Int ?? 0) == 0{
                if (itemsDict["can_assemble"] as? Int ?? 0) == 0{
                       self.canAssemble = false
                } else{
                    self.canAssemble = true
                }
            } else{
                self.canAssemble = true
            }
         
            if ((itemsDict[keysForBookMoves.is_assamble] as? Int ?? 0) == 0) {
                self.isAssemble = false
            } else {
                self.isAssemble = true
            }
            if ((itemsDict[keysForBookMoves.is_carry_with_people] as? Int ?? 0) == 0) {
                self.isCarryWithPeople = false
            }else{
                self.isCarryWithPeople = true
            }
            
            self.tableView.reloadData()
            self.collectionView.reloadData()
        }
        itemQuantityLabel.text = String(quantityNumber)

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        heightConst.constant =  40.0 * screenHeightFactor
    }
    
    func navigationConfiguration() {

        self.navigationController?.navigationBar.backgroundColor = .white
        if isFromEditMenue {
            self.setNavigationTitle("Edit Item(s)")
        } else {
            self.setNavigationTitle("Add Item(s)")
        }
        self.navigationItem.leftBarButtonItem = StaticHelper.leftBarButton(withImageNamed: "backward_arrow_icon", forVC: self)
    }

    func configureDynamicUI() {
        
        junkQuantityTitle.isHidden = true
        junkQuantityLabel.isHidden = true
        junkMinusButton.isHidden = true
        junkPlusButton.isHidden = true
        
        additionLabel.isHidden = false
        additionLabel.font = UIFont.josefinSansRegularFontWithSize(size: 10.0)
        
        self.titleLabel.text = self.selectedMoveType!.add_item_label
        self.additionLabel.text = self.selectedMoveType!.move_info
        self.takePhotoLabel.text = self.selectedMoveType!.take_photo_label
        self.subTakPhotoLabel.text = self.selectedMoveType!.sub_take_photo_label//"This is extremely helpful for your job"
        self.howManyLabel.text = self.selectedMoveType!.how_many_label
        
        let imgURL = URL.init(string: self.selectedMoveType!.image_url!)
        self.itemImageView.af.setImage(withURL: imgURL!)

        quantityBkView.isHidden = true
        itemRemoveButton.isHidden = true

        if(self.selectedMoveType!.is_how_many == 1) {
            self.quantityBkView.isHidden = false

            if(self.selectedMoveType!.how_many_label == "How Many ?") {
                self.junkQuantityTitle.isHidden = true
                self.junkQuantityLabel.isHidden = true
                self.junkMinusButton.isHidden = true
                self.junkPlusButton.isHidden = true
            } else {//Junk

                self.junkQuantityTitle.text = self.selectedMoveType!.how_many_label
                
                self.topInfoLabel.constant = 85
                self.headerView.frame.size.height = 230 * screenHeightFactor

                self.itemQuantityLabel.isHidden = true
                self.howManyLabel.isHidden = true
                self.minusButton.isHidden = true
                self.plusButton.isHidden = true

                self.junkQuantityTitle.isHidden = false
                self.junkQuantityLabel.isHidden = false
                self.junkMinusButton.isHidden = false
                self.junkPlusButton.isHidden = false
            }
        }
    }
    
    func uiConfigurationAfterStoryboard() {
        self.itemImageView.layer.cornerRadius = 7.0 * screenHeightFactor
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 50.0 * screenHeightFactor, right: 0)
        
        junkHeight.constant = 50.0 * screenHeightFactor
        topInfoLabel.constant = 10

        
        headerView.frame.size.height = 170 * screenHeightFactor
        footerView.frame.size.height = 160 * screenHeightFactor
        itemBackView.layer.cornerRadius = 10.0 * screenHeightFactor
        quantityBkView.layer.cornerRadius = 10.0 * screenHeightFactor
        bkView.layer.cornerRadius = 10.0 * screenHeightFactor
        titleLabel.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        howManyLabel.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        itemQuantityLabel.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        itemNameLabel.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        takePhotoLabel.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        subTakPhotoLabel.font = UIFont.josefinSansRegularFontWithSize(size: 10.0)
        continueLabel.font = UIFont.josefinSansRegularFontWithSize(size: 13.0)
      
        junkQuantityLabel.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        junkQuantityTitle.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)

//        let permission = PermissionCameraHelper()
//        permission.requestCameraPermission { (status) in
//        }
//
//        let permission2 = PermissionPhotoHelper()
//        permission2.requestPhotoPermission { (status) in
//        }
    }
    func showActionSheetWithPermission(){
        let permission = PermissionCameraHelper()
        let permissionPhoto = PermissionPhotoHelper()
        if permission.checkCameraPermission() == .notDetermined {
            let permission = PermissionCameraHelper()
            permission.requestCameraPermission { (status) in
            }
        }
        if permissionPhoto.checkPhotoPermission() == .notDetermined {
            let permission2 = PermissionPhotoHelper()
            permission2.requestPhotoPermission { (status) in
            }
        }
        if permission.checkCameraPermission() == .denied && permissionPhoto.checkPhotoPermission() == .denied {
            showPermmisonAlert(AlertButtonTitle.alert,kStringPermission.cameraGalaryMessageTitle, kStringPermission.photosItemMessage)
        }else{
            self.showActionSheet(in: self, title: "", message: kStringPermission.pickAnOption, buttonArray:  [kStringPermission.takePhoto, kStringPermission.choosePhoto], completion:{ (index) in
                if index == 0 {
                    let permission = PermissionCameraHelper()
                    if permission.checkCameraPermission() == .accepted {
                        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
                            self.imagePickerController.sourceType = .camera
                            //self.imagePickerController.allowsEditing = true
                            self.imagePickerController.cameraCaptureMode = .photo
                            self.imagePickerController.modalPresentationStyle = .fullScreen
                            self.imagePickerController.delegate = self
                            self.navigationController?.present(self.imagePickerController, animated: true, completion: nil)
                        }else{
                            let alert  = UIAlertController(title: kStringPermission.warning, message: kStringPermission.youDontHaveCamera, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: AlertButtonTitle.ok, style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }else{
                        self.showPermmisonAlert(AlertButtonTitle.alert,kStringPermission.cameraMessageTitle, kStringPermission.photos1ItemMessage)
                    }
                }else if index == 1 {
                    let permission = PermissionPhotoHelper()
                    if permission.checkPhotoPermission() == .accepted {
                        self.imagePickerController.sourceType = .photoLibrary
                        //self.imagePickerController.allowsEditing = true
                        self.imagePickerController.delegate = self
                        self.navigationController?.present(self.imagePickerController, animated: true, completion: nil)
                    }else{
                        self.showPermmisonAlert(AlertButtonTitle.alert,kStringPermission.galaryMessageTitle, kStringPermission.photosItemMessage)
                    }
                }else{
                    self.imagePickerController.dismiss(animated: true, completion: {})
                }
            })
        }
    }
    //MARK: - Actions
    @objc func leftPressed(_ selector: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func itemRemoveButtonAction(_ sender: Any) {
    }
    
    @IBAction func minusButtonAction(_ sender: Any) {
        if quantityNumber > 1 {
            quantityNumber = quantityNumber - 1
        }
    }
    
    @IBAction func plusButtonAction(_ sender: Any) {
        
        if(self.selectedMoveType!.how_many_limit != 0) {
            if quantityNumber < self.selectedMoveType!.how_many_limit! {
                quantityNumber = quantityNumber + 1
            }
        } else {
            quantityNumber = quantityNumber + 1
        }
    }
    
    @IBAction func continueAction(_ sender: Any) {
        self.view.endEditing(true)
          
        if(self.selectedMoveType!.is_additional_info == 1) {
        //if (moveDict[keysForBookMoves.move_type_id] as! Int) != 4 && (moveDict[keysForBookMoves.move_type_id] as! Int) != 10 && (moveDict[keysForBookMoves.move_type_id] as! Int) != 12 {
            if itemWeight == 0.0 {
                self.view.makeToast("Please enter estimated weight of the item.")
                return
            }
            if itemHeight == 0.0 {
                self.view.makeToast("Please enter estimated height of the item.")
                return
            }
            if itemDepth == 0.0 {
                self.view.makeToast("Please enter estimated depth of the item.")
                return
            }
            if itemWidth == 0.0 {
                self.view.makeToast("Please enter estimated width of the item.")
                return
            }
        }
        if additionalInfo.isEmpty {
            self.view.makeToast("Please enter additional info.")
            return
        }
        if imageUrls.count < 1 {
            self.view.makeToast("Please select or take a picture of your item(S).")
            return
        }
        
        var canAssmbleValue = 0
        
        if canAssemble {
            canAssmbleValue = 1
        } else {
            canAssmbleValue = 0
        }
        
        
        var is_carry_with_people = 0
        if isCarryWithPeople {
            is_carry_with_people = 1
        } else {
            is_carry_with_people = 0
        }
        var isAssembleValue = 0
        if isAssemble {
            isAssembleValue = 1
        } else {
            isAssembleValue = 0
        }
        
        var is_custom_itemTemp = 0
        if self.is_custom_item{
            is_custom_itemTemp = 1
            if isCarryWithPeople == true{
                    itemPrice = 15.0
            } else {
                if itemWeight <= 50.0 {
                     itemPrice = 5.0
                } else if itemWeight > 50.0 && itemWeight <= 80.0 {
                     itemPrice = 10.0
                } else {
                      itemPrice = 15.0
                }
            }
        }
        
        let ItemDict = [keysForBookMoves.item_name:itemName,
                        keysForBookMoves.quantity: quantityNumber,
                        keysForBookMoves.total_amount: 0.0,
                        keysForBookMoves.can_assamble: canAssmbleValue,
                        keysForBookMoves.is_assamble: isAssembleValue,
                        keysForBookMoves.is_carry_with_people: is_carry_with_people,
                        keysForBookMoves.item_height: itemHeight,
                        keysForBookMoves.item_width: itemWidth,
                        keysForBookMoves.item_depth: itemDepth,
                        keysForBookMoves.item_weight: itemWeight,
                        keysForBookMoves.additional_info: additionalInfo,
                        keysForBookMoves.item_price: itemPrice,
                        keysForBookMoves.item_photos: imageUrls,
                        keysForBookMoves.is_custom_item: is_custom_itemTemp,
                        "subcategory_photo_url": itemsDict["subcategory_photo_url"] as! String
            ] as [String : Any]
                
        if self.isFromEditMenue == true {
            var itemsDict = self.addMoreItemVC.moveDict["items"] as! [[String:Any]]
            itemsDict[itemIndex] = ItemDict
            self.addMoreItemVC.moveDict["items"] = itemsDict
//            NotificationCenter.default.post(name: Notification.Name(rawValue: "ReloadCheckOutData"), object: nil)
            self.addMoreItemVC.reloadData()
            self.navigationController?.popViewController(animated: true);
            return
        } else if self.isFromAddMore == true {
            var itemsDict = self.addMoreItemVC.moveDict["items"] as! [[String:Any]]
            itemsDict.append(ItemDict)
            self.addMoreItemVC.moveDict["items"] = itemsDict
            self.navigationController?.popToViewController(self.addMoreItemVC, animated: true)
        }
    }
}

extension EditItemViewController: UITableViewDelegate,UITableViewDataSource, UITextViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.selectedMoveType?.is_describe == 1) {
            return 1
        } else {
            if canAssemble {
                if is_custom_item {
                      return 3
                }
                return 2
            }else {
                return 1
            }
        }
        
//        if canAssemble {
//            if is_custom_item {
//                  return 3
//            }
//            return 2
//        } else {
//            return 1
//        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(self.selectedMoveType?.is_describe == 1) {
            return 120.0 * screenHeightFactor
        }
        
        if indexPath.row == 0 && canAssemble{
            return 115.0 * screenHeightFactor
        }
        if indexPath.row == 1 && canAssemble && is_custom_item{
            return 75.0 * screenHeightFactor
        } else{
            if (isAdditionalinfVisible){
                return 240.0 * screenHeightFactor
            } else{
                return 45.0 * screenHeightFactor
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(self.selectedMoveType?.is_describe == 1) {
          let junkCell = tableView.dequeueReusableCell(withIdentifier: "JunkRemovalTableViewCell", for: indexPath) as! JunkRemovalTableViewCell
         
            junkCell.describeLabel.text = self.selectedMoveType?.describe_label
            junkCell.junkTextView.placeholder = self.selectedMoveType?.name ?? "" + " Details"

          if isFromEditMenue{
              additionalInfo = (itemsDict["additional_info"] as! String)
               junkCell.junkTextView.text = (itemsDict["additional_info"] as! String)
               junkCell.junkTextView.delegate = self
          }
          else{
               junkCell.junkTextView.text = additionalInfo
          }
          return junkCell
        }
        
        if indexPath.row == 0 && canAssemble {
            
            let assembleCell = tableView.dequeueReusableCell(withIdentifier: "AssembleTableViewCell", for: indexPath) as! AssembleTableViewCell
            assembleCell.assembleLabel.text = "Assemble and Disassemble"
            assembleCell.descriptionLabel.text = "This is something that needs to be broken down and then reassembled after moving. If there are any special tools required, please add in the optional details below."
            assembleCell.selectButton.tag = indexPath.row
            assembleCell.selectButton.isSelected = self.isAssemble

            assembleCell.selectButton.addTarget(self, action: #selector(assembleSelectButton(_:)), for: .touchUpInside)
            return assembleCell
        }
        if indexPath.row == 1 && canAssemble && is_custom_item {
            
            let assembleCell = tableView.dequeueReusableCell(withIdentifier: "AssembleTableViewCell", for: indexPath) as! AssembleTableViewCell
            assembleCell.assembleLabel.text = "Carry with 2 people"
            assembleCell.descriptionLabel.text = "Does this item need to be carried by two people?"
            assembleCell.selectButton.tag = indexPath.row
            assembleCell.selectButton.isSelected = self.isCarryWithPeople
            assembleCell.selectButton.addTarget(self, action: #selector(assembleSelectButton(_:)), for: .touchUpInside)
            return assembleCell
        }
        else {
            if (isAdditionalinfVisible) {
                let opanAddCell = tableView.dequeueReusableCell(withIdentifier: "AdditionalItemOpenTableViewCell", for: indexPath) as! AdditionalItemOpenTableViewCell
                if is_custom_item {
                    opanAddCell.addditionalInfoLabel.text =  "Add Additional Details"
                } else {
                    opanAddCell.addditionalInfoLabel.text =  "Add Additional Details"
                }
                                
                if self.itemWidth != 0.0{
                    opanAddCell.widthTextField.text = String.init(self.itemWidth)
                }
                if self.itemHeight != 0.0{
                     opanAddCell.heightTextField.text = String.init(self.itemHeight)
                }
                if self.itemDepth != 0.0{
                      opanAddCell.depthTextField.text = String.init(self.itemDepth)
                }
                if self.itemWeight != 0.0{
                      opanAddCell.weightTextField.text = String.init(self.itemWeight)
                }
                if !self.additionalInfo.isEmpty{
                      opanAddCell.addtionInfoTextField.text = additionalInfo
                }
              
                opanAddCell.hideButton.addTarget(self, action: #selector(hideadditionInfo(_:)), for: .touchUpInside)
                
                return opanAddCell
            } else {
                let closeAddCell = tableView.dequeueReusableCell(withIdentifier: "AdditionalInfoClosedTableViewCell", for: indexPath) as! AdditionalInfoClosedTableViewCell
                if is_custom_item {
                    closeAddCell.additionalInfoLabel.text =  "Add Additional Details"
                } else {
                    closeAddCell.additionalInfoLabel.text =  "Add Additional Details"
                }
                closeAddCell.showButton.addTarget(self, action: #selector(showAdditionalInfo(_:)), for: .touchUpInside)
                return closeAddCell
            }
        }
    }

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
         additionalInfo = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        additionalInfo = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        if indexPath.row == 0 && !canAssemble{
            if isAdditionalinfVisible == false{
                isAdditionalinfVisible = true
                self.tableView.reloadData()
            }
        }else if is_custom_item && indexPath.row == 1 {
            if !isCarryWithPeople{
                isCarryWithPeople = true
            }else{
                isCarryWithPeople = false
            }
            self.tableView.reloadData()

        }else if is_custom_item && indexPath.row == 0{
            if !isAssemble{
                isAssemble = true
            }else{
                isAssemble = false
            }
            self.tableView.reloadData()
        }
    }
    @objc func assembleSelectButton(_ selector: UIButton){
        if selector.tag == 1{
            if !isCarryWithPeople{
                isCarryWithPeople = true
                selector.isSelected = true
            }else{
                selector.isSelected = false
                isCarryWithPeople =  false
            }
        }else{
            if selector.isSelected{
                selector.isSelected = false
                isAssemble =  false
            }else{
                isAssemble = true
                selector.isSelected = true
            }
        }
    }
    
    @objc func hideadditionInfo(_ selector: UIButton){
         isAdditionalinfVisible = false
         self.tableView.reloadData()
    }
    @objc func showAdditionalInfo(_ selector: UIButton){
         isAdditionalinfVisible = true
         self.tableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!{
            return
        }
        switch textField.tag {
        case 1:
            itemWidth = Double(textField.text!)!
        case 2:
            itemHeight = Double(textField.text!)!
        case 3:
            itemDepth = Double(textField.text!)!
        case 4:
            itemWeight = Double(textField.text!)!
        case 5:
            additionalInfo = textField.text!
        default:
            break
        }
    }
}
extension EditItemViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imagesArray.count == 3{
            return 3
        }
        else{
            return imagesArray.count + 1
        }
     
    }
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemImageCollectionViewCell", for: indexPath) as! ItemImageCollectionViewCell

        if imagesArray.count == 3{
            if imagesArray[indexPath.item].size == CGSize.zero{
                let url = URL.init(string: imageUrls[indexPath.item])
                itemCell.imageView.af.setImage(withURL: url!)
            }
            else{
                itemCell.imageView.image = imagesArray[indexPath.item]
            }
            
            itemCell.crossButton.isHidden = false
        }
        else{

            if indexPath.item == imagesArray.count{
                itemCell.imageView.image = UIImage.init(named: "add_item_photo")
              itemCell.crossButton.isHidden = true
            }
            else{
                itemCell.crossButton.isHidden = false
                if imagesArray[indexPath.item].size == CGSize.zero{
                    let url = URL.init(string: imageUrls[indexPath.item])
                    itemCell.imageView.af.setImage(withURL: url!)
                }
                else{
                    itemCell.imageView.image = imagesArray[indexPath.item]
                }
            }
        }
        itemCell.crossButton.tag = indexPath.row
        itemCell.crossButton.addTarget(self, action: #selector(crossPressed(_:)), for: .touchUpInside)
        return itemCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.showActionSheetWithPermission()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 50.0 * screenHeightFactor, height: 50.0 * screenHeightFactor)
    }
    
    @objc func crossPressed(_ selector: UIButton){
        
        if(selector.tag < self.imagesArray.count && selector.tag < self.imageUrls.count) {
            self.imagesArray.remove(at: selector.tag)
            self.imageUrls.remove(at: selector.tag)
        }
        self.collectionView.reloadData()
    }
}

extension EditItemViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    //********************************
    //MARK: - Image Picker Methods
    //********************************
    
    func uploadImages(_ image: UIImage){
//
//        let httpheader: HTTPHeaders = ["Auth-Token": UserCache.userToken() ?? ""]
        let imageData = image.jpegData(compressionQuality: 0.6)
        
       StaticHelper.shared.startLoader(self.view)
        if !StaticHelper.Connectivity.isConnectedToInternet {
                StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: self, completion: nil)
                return
            }
            
        let parametersDict : Parameters = ["folder_name": "item_image"] as [String : Any]
        
        AF.upload(multipartFormData: {
            multipartFormData in
            multipartFormData.append(imageData!, withName: "vehicle_image",fileName: "profile_img.jpg", mimeType: "image/jpg")
            
            for (key, value) in parametersDict {
                if value is String {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                } else if value is Int {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                }
            }
            
        }, to: baseURL + kAPIMethods.upload_helper_vehicle_image, method: .post).responseJSON { (response) in
            defer{
                StaticHelper.shared.stopLoader()
            }
            print("resp is \(response)")
            StaticHelper.shared.stopLoader()
            if response.response?.statusCode == 200{
                  StaticHelper.shared.stopLoader()
                self.imageUrls.append(((response.value as! [String:Any])["vehicle_image_url"] as! String))
                self.collectionView.reloadData()
            } else{
                 StaticHelper.shared.stopLoader()
                self.imagesArray.removeLast()
                self.view.makeToast("There is some issue while uploading image. Please upload again.")
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var photo = info[UIImagePickerController.InfoKey.originalImage] as! UIImage?
        photo = self.resizeImage(image: photo!, targetSize: CGSize.init(width: 720.0, height: 1080.0))
        imagesArray.append(photo!)
        self.uploadImages(photo!)
        self.collectionView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    func showActionSheet(in controller: UIViewController, title: String?, message: String?, buttonArray: [String], completion block: @escaping (_ buttonIndex: Int) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for buttonTitle: String in buttonArray{
            let alertAction = UIAlertAction(title: buttonTitle, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                let index: Int = (buttonArray as NSArray).index(of: action.title ?? "defaultValue")
                block(index)
            })
            alertController.addAction(alertAction)
        }
        let alertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            block(buttonArray.count)
        })
        alertController.addAction(alertAction)
        DispatchQueue.main.async {
            if UIDevice.current.userInterfaceIdiom == .pad{
                if alertController.responds(to: #selector(getter: self.popoverPresentationController)) {
                    alertController.popoverPresentationController?.sourceView = self.collectionView
                    alertController.popoverPresentationController?.sourceRect = self.collectionView.bounds
                    self.present(alertController, animated: true, completion: {})
                }
                
            }
            else if UIDevice.current.userInterfaceIdiom == .phone {
                controller.present(alertController, animated: true, completion: {})
            }
        }
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
          let size = image.size
          
          let widthRatio  = targetSize.width  / size.width
          let heightRatio = targetSize.height / size.height
          
          // Figure out what our orientation is, and use that to form the rectangle
          var newSize: CGSize
          if(widthRatio > heightRatio) {
              newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
          } else {
              newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
          }
          
          // This is the rect that we've calculated out and this is what is actually used below
          let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
          
          // Actually do the resizing to the rect using the ImageContext stuff
          UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
          image.draw(in: rect)
          let newImage = UIGraphicsGetImageFromCurrentImageContext()
          UIGraphicsEndImageContext()
          
          return newImage!
      }
}
// MARK: - ALert Permmison method's ....
extension EditItemViewController:AlertViewPermmisionDelegate{
    func alertViewPermmisionCLick(isOk: Bool) {
        alertPermmisionView!.removeFromSuperview()
        alertPermmisionView = nil
        if isOk {
            let permission = PermissionCameraHelper()
            permission.requestCameraPermission { (status) in
            }
            let permission2 = PermissionPhotoHelper()
            permission2.requestPhotoPermission { (status) in
            }
        }
    }
    
    func showPermmisonAlert(_ popUpTitleMsg:String, _ titleMsg:String, _ message:String) {
       self.view.endEditing(true)
        alertPermmisionView = AlertViewPermmision(frame: appDelegate.window!.bounds)
        alertPermmisionView!.delegate = self
        alertPermmisionView!.strPopupTitle = popUpTitleMsg
        alertPermmisionView!.strTitleMessage = titleMsg
        alertPermmisionView!.strMessage = message
       appDelegate.window?.addSubview(alertPermmisionView!)
    }
}
