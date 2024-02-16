//
//  SelectItemViewController.swift
//  MoveIt
//
//  Created by Dilip Saket on 23/09/21.
//  Copyright © 2021 Jyoti. All rights reserved.
//

import UIKit
import Alamofire

class SelectItemViewController: UIViewController,UITextFieldDelegate,SearchResultDelegate {
    
    var moveDict = [String: Any]()
    var addMoreItemVC:AddMoreItemViewController!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var moveLabel: UILabel!
    @IBOutlet weak var itemSearchTextField: UITextField!
    
    var isFromAddMore = false
    
    var moveCategoryDict = [[String: Any]](){
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    var selectedMoveType:MoveTypeModel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setNavigationTitle("Select Item")
        
        moveLabel.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        itemSearchTextField.font = UIFont.josefinSansRegularFontWithSize(size: 14.0)
        itemSearchTextField.layer.cornerRadius = 20.0 * screenHeightFactor
        itemSearchTextField.layer.borderWidth = 1.0
        itemSearchTextField.layer.borderColor = UIColor.init(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0).cgColor
        itemSearchTextField.setLeftPaddingPoints(20.0 * screenWidthFactor)
        
        itemSearchTextField.setRightPaddingWithImage(25, image: UIImage(named: "search_icon")!)
        self.navigationItem.leftBarButtonItem = StaticHelper.leftBarButton(withImageNamed: "backward_arrow_icon", forVC: self)
        self.getAllMoveItems()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        itemSearchTextField.dropShadow(color: .black, opacity: 0.1, offSet: CGSize(width: -1, height: 1), radius: ((self.itemSearchTextField.bounds.height / 4)), scale: false)
    }
    
    @objc func leftPressed(_ selector: Any){
        
        if isFromAddMore {
            self.dismiss(animated: true, completion: nil)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let searchVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        searchVC.searchResultDelegate = self
        searchVC.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(searchVC, animated: true, completion: nil)
        return false
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

    func searchResult(_ dict: [String : Any]) {
      
        let editItemVC = self.storyboard?.instantiateViewController(withIdentifier: "EditItemViewController") as! EditItemViewController
        editItemVC.selectedMoveType = self.selectedMoveType
        editItemVC.itemsDict = dict
        editItemVC.moveDict = self.moveDict//1
        editItemVC.isFromAddMore = true
        editItemVC.addMoreItemVC = self.addMoreItemVC
        self.navigationController?.pushViewController(editItemVC, animated: true)
    }
        
    func getAllMoveItems(){
        StaticHelper.shared.startLoader(self.view)
        AF.request(baseURL+kAPIMethods.get_items_category).responseJSON { (response) in
            
            DispatchQueue.main.async {
            switch response.result {
            case .success:
                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200{
                    let reponseDict = response.value as! [String: Any]
                    self.moveCategoryDict = reponseDict["items_category"] as! [[String: Any]]
                } else if(response.response?.statusCode == 401){
//                    StaticHelper.logout()
                }
            case .failure(let error):
                StaticHelper.shared.stopLoader()
                self.view.makeToast(error.localizedDescription)
            }
            }
        }
    }
}

extension SelectItemViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moveCategoryDict.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let selectItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectItemCollectionViewCell", for: indexPath) as! SelectItemCollectionViewCell
        let itemDict = moveCategoryDict[indexPath.item] as [String:Any]
        let itemURL = URL.init(string: (itemDict["photo_url"] as! String))
        selectItemCell.itemImgView.af.setImage(withURL: itemURL!)
//        selectItemCell.itemImgView.image = UIImage.init(named: itemImages[indexPath.item])
        selectItemCell.itemName.text = (itemDict["name"] as! String)
        
        return selectItemCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let addItemVC = self.storyboard?.instantiateViewController(withIdentifier: "AddItemsViewController") as! AddItemsViewController
        addItemVC.selectedMoveType = self.selectedMoveType
        addItemVC.moveDict = self.moveDict
        let itemDict = self.moveCategoryDict[indexPath.item]
        addItemVC.addMoreItemVC = self.addMoreItemVC
        addItemVC.selectedItem = itemDict["name"] as! String
        addItemVC.selectedCategoryID = itemDict["category_id"] as! Int
        addItemVC.isFromAddMore = self.isFromAddMore
        let collectioncell = collectionView.cellForItem(at: indexPath) as! SelectItemCollectionViewCell
        addItemVC.cellImage = collectioncell.itemImgView.image!
        self.navigationController?.pushViewController(addItemVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: ((SCREEN_WIDTH - 45) / 2) , height: 100.0 * screenHeightFactor)
    }
}
extension UIView {

  // OUTPUT 1
  func dropShadow(scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 1.0
    layer.shadowOffset = CGSize(width: 0, height: 0)
    layer.shadowRadius = 1

    layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }

  // OUTPUT 2
  func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = color.cgColor
    layer.shadowOpacity = opacity
    layer.shadowOffset = offSet
    layer.shadowRadius = radius

    layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 2.0
  }
    
    func setlayer(color: UIColor, width : Double? = 1.0){
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = CGFloat(width!)
    }
    
}
