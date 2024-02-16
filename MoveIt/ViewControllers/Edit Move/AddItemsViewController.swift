//
//  AddItemsViewController.swift
//  MoveIt
//
//  Created by Dilip Saket on 23/09/21.
//  Copyright © 2021 Jyoti. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import JVFloatLabeledTextField

class AddItemsViewController: UIViewController,UIScrollViewDelegate {
    
    var moveDict = [String: Any]()
    
    var addMoreItemVC:AddMoreItemViewController!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedItem = ""
    var selectedCategoryID = 0
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var headLabel: UILabel!
    var isFromAddMore = false
    
    @IBOutlet weak var continueButton: UIButton!

    var itemsArray = [[String:Any]](){
        didSet{
           self.tableView.reloadData()
        }
    }
    
    var cellImage = UIImage()
    let itemSearchTextField = UITextField()

    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var textview: JVFloatLabeledTextView!
    
    var selectedMoveType:MoveTypeModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.contentInsetAdjustmentBehavior = .automatic
        
        headerView.frame.size.height = 40.0 * screenHeightFactor
        headLabel.font = UIFont.josefinSansRegularFontWithSize(size: 10.0)
        
        if(self.selectedMoveType?.can_add_item == 0) {
         
            headLabel.text = self.selectedMoveType?.add_item_label

            footerView.isHidden = false
            footerView.frame.size.height = 130.0 * screenHeightFactor
            textview.layer.borderColor = darkPinkColor.cgColor
            textview.layer.borderWidth = 1.0
            textview.layer.cornerRadius = 5.0 * screenHeightFactor
            textview.contentInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        } else {
            headLabel.text = "Select " + selectedItem + " Type"
            self.tableView.tableFooterView = UIView()
           // footerView.isHidden = false
            footerView.frame.size.height = 0.0
        }

        self.tableView.reloadData()
        
        continueButton.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 13.0)
        
        setNavigationTitle("Select Item")
        
        self.navigationItem.leftBarButtonItem = StaticHelper.leftBarButton(withImageNamed: "backward_arrow_icon", forVC: self)
        self.getAllItems()
        self.headerSetup()
    }
    
    let imageView = UIImageView()
    let label = UILabel()
   
    @objc func leftPressed(_ selector: Any){
        self.navigationController?.popViewController(animated: true)
    }
    

//    func headerSetup(){
//
//        tableView.contentInset = UIEdgeInsets(top: 150*screenHeightFactor, left: 0, bottom: 0, right: 0)
//
//        imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 150*screenHeightFactor)
//
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.image = cellImage
//        label.text = selectedItem
//        label.frame = CGRect(x: 20 * screenHeightFactor, y: imageView.frame.size.height-30, width: UIScreen.main.bounds.size.width, height: 30)
//        label.font = UIFont.josefinSansBoldFontWithSize(size: 15.0)
//        label.textColor = UIColor.white
//        view.addSubview(imageView)
//        view.addSubview(label)
//        view.clipsToBounds = true
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        let y = 150*screenHeightFactor - (scrollView.contentOffset.y + 150*screenHeightFactor)
//        let height = min(max(y, 60), 150*screenHeightFactor)
//        // let labelHeight = min(max(y, 20), 60)
//        imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height)
//        label.frame = CGRect(x: 20.0 * screenWidthFactor, y: height - 30 , width: 290 * screenWidthFactor, height: 30)
//    }
    
    
    func headerSetup(){
        tableView.contentInset = UIEdgeInsets(top: 180*screenHeightFactor, left: 0, bottom: 0, right: 0)
        
        imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 180*screenHeightFactor)
      
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .black
        imageView.image = cellImage
        label.text = selectedItem
        label.frame = CGRect(x: 20 * screenHeightFactor, y: imageView.frame.size.height-115, width: UIScreen.main.bounds.size.width, height: 30)
        label.font = UIFont.josefinSansBoldFontWithSize(size: 15.0)
        label.textColor = UIColor.white
        self.setSearchBoxFrame()
        view.addSubview(imageView)
        view.addSubview(label)
        view.addSubview(itemSearchTextField)
        view.clipsToBounds = true
    }
    func setSearchBoxFrame(){
        itemSearchTextField.frame = CGRect(x: 20, y: imageView.frame.size.height-75, width: UIScreen.main.bounds.size.width-40, height: 50)
        itemSearchTextField.layer.cornerRadius = 25.0
        itemSearchTextField.layer.masksToBounds = true
        itemSearchTextField.placeholder = "Type your item here..."
        itemSearchTextField.font = UIFont.josefinSansRegularFontWithSize(size: 14.0)
        itemSearchTextField.layer.borderWidth = 1.0
        itemSearchTextField.backgroundColor = .white
        itemSearchTextField.layer.borderColor = UIColor.init(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0).cgColor
        itemSearchTextField.setLeftPaddingPoints(20.0 * screenWidthFactor)
        itemSearchTextField.setRightPaddingWithImage(25, image: UIImage(named: "search_icon")!)
        itemSearchTextField.delegate = self
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let y = 180*screenHeightFactor - (scrollView.contentOffset.y + 180*screenHeightFactor)
        let height = min(max(y, 125), 180*screenHeightFactor)
        // let labelHeight = min(max(y, 20), 60)
        imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height)
        label.frame = CGRect(x: 20.0 * screenWidthFactor, y: height - 115 , width: 290 * screenWidthFactor, height: 30)
        itemSearchTextField.frame = CGRect(x: 20.0, y: height - 75 , width: UIScreen.main.bounds.size.width-40.0, height: 50)
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
        let text = textview.text.trimmingCharacters(in: .whitespacesAndNewlines)
        var customDictModel = [  "category_id": 0,
                                 "subcategory_id": 0,
                                 "subcategory_name": "Junk",
                                 "category_name": "",
                                 "subcategory_price": "0",
                                 "can_assemble": 0,
                                 "subcategory_photo_url": "http://13.233.89.178/public/app_data/move_type_images/img_1570799307.png",
                                 "is_custom_item": 0
                                 ] as [String : Any]
        
        if(self.selectedMoveType?.can_add_item == 0) {
            customDictModel["subcategory_name"] = self.selectedMoveType?.item_name
            customDictModel["subcategory_price"] = self.selectedMoveType?.item_price
        }
        
        if text.isEmpty{
            self.view.makeToast("Please describe your junk in detail.")
            return
        }
        else{
            let editItemVC = self.storyboard?.instantiateViewController(withIdentifier: "EditItemViewController") as! EditItemViewController
            editItemVC.selectedMoveType = self.selectedMoveType
            editItemVC.moveDict = self.moveDict//2
            editItemVC.addMoreItemVC = self.addMoreItemVC
            editItemVC.itemsDict = customDictModel
            editItemVC.additionalInfo = text
            editItemVC.isFromAddMore = self.isFromAddMore
            self.navigationController?.pushViewController(editItemVC, animated: true)
        }
    }
    
    func getAllItems(){
        let parameters = ["category_id": self.selectedCategoryID]
        StaticHelper.shared.startLoader(self.view)
        AF.request(baseURL+kAPIMethods.get_items_sub_category, method: .post, parameters: parameters).responseJSON { (response) in
            
            DispatchQueue.main.async {
            switch response.result {
            case .success:
                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200{
                    let reponseDict = response.value as! [String: Any]
                    self.itemsArray = reponseDict["items_subcategory"] as! [[String: Any]]
                } else if(response.response?.statusCode == 401){
//                    MoveItStaticHelper.logout()
                }
            case .failure(let error):
                StaticHelper.shared.stopLoader()
                self.view.makeToast(error.localizedDescription)
            }
            }
        }
    }
    
      //************************************************
      //MARK: - Keyboard Notification Methods
      //************************************************
      
      @objc func keyboardWillShow(_ sender: Notification) {
          let kbSize = (sender.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
          let duration: TimeInterval? = CDouble((sender.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval)!)
          UIView.animate(withDuration: duration!, animations: {() -> Void in
              let edgeInsets: UIEdgeInsets? = UIEdgeInsets(top: 0, left: 0, bottom: (kbSize.height), right: 0)
              self.tableView.contentInset = edgeInsets!
              self.tableView.scrollIndicatorInsets = edgeInsets!
          })
      }
      
      @objc func keyboardWillHide(_ sender: Notification) {
          let duration: TimeInterval? = CDouble((sender.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval)!)
          UIView.animate(withDuration: duration!, animations: {() -> Void in
              let edgeInsets: UIEdgeInsets = UIEdgeInsets.zero
              self.tableView.contentInset = edgeInsets
              self.tableView.scrollIndicatorInsets = edgeInsets
          })
      }
}

extension AddItemsViewController: UITableViewDelegate,UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(self.selectedMoveType?.can_add_item == 0) {

//        if  (self.addMoreItemVC.moveDict[keysForBookMoves.move_type_id] as! Int) == 10 || (self.addMoreItemVC.moveDict[keysForBookMoves.move_type_id] as! Int) == 4 {
            return 0
         }
         else{
              return itemsArray.count
        }
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0 * screenHeightFactor
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let addItemCell = tableView.dequeueReusableCell(withIdentifier: "AddItemTableViewCell", for: indexPath) as! AddItemTableViewCell
        let itemDict = itemsArray[indexPath.row]
        let imgUrl = URL.init(string: (itemDict["subcategory_photo_url"] as! String))
        addItemCell.itemImage.af.setImage(withURL: imgUrl!)
        addItemCell.itemNameLabel.text = (itemDict["subcategory_name"] as! String)
        return addItemCell
    }
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       
        if(self.selectedMoveType?.can_add_item == 0) {
        //if  (self.addMoreItemVC.moveDict[keysForBookMoves.move_type_id] as! Int) == 10 || (self.addMoreItemVC.moveDict[keysForBookMoves.move_type_id] as! Int) == 4  {
            let text = textview.text.trimmingCharacters(in: .whitespacesAndNewlines)
            if text.isEmpty{
                self.view.makeToast("Please describe your junk in detail.")
                return
            }
            else{
                let editItemVC = self.storyboard?.instantiateViewController(withIdentifier: "EditItemViewController") as! EditItemViewController
                editItemVC.selectedMoveType = self.selectedMoveType
                editItemVC.moveDict = self.moveDict//3
                let itemDict = itemsArray[indexPath.row]
                editItemVC.addMoreItemVC = self.addMoreItemVC
                editItemVC.itemsDict = itemDict
                editItemVC.additionalInfo = text
                editItemVC.isFromAddMore = self.isFromAddMore
                self.navigationController?.pushViewController(editItemVC, animated: true)
            }
        }
        else{
            let editItemVC = self.storyboard?.instantiateViewController(withIdentifier: "EditItemViewController") as! EditItemViewController
            editItemVC.selectedMoveType = self.selectedMoveType
            editItemVC.moveDict = self.moveDict//4
            editItemVC.addMoreItemVC = self.addMoreItemVC
            let itemDict = itemsArray[indexPath.row]
            editItemVC.itemsDict = itemDict
            editItemVC.isFromAddMore = self.isFromAddMore
            self.navigationController?.pushViewController(editItemVC, animated: true)
        }
    }
}
// MARK: - Delegate for the search item's....
extension AddItemsViewController:SearchResultDelegate, UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == itemSearchTextField{
            let searchVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
            searchVC.searchResultDelegate = self
            searchVC.modalPresentationStyle = .overFullScreen
            self.navigationController?.present(searchVC, animated: true, completion: nil)
            return false
        }
        return true
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
}

