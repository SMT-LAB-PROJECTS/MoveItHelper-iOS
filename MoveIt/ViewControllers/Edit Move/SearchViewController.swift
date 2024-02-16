//
//  SearchViewController.swift
//  Move It
//
//  Created by Dushyant on 28/06/19.
//  Copyright © 2019 Agicent Technologies. All rights reserved.
//

import UIKit
import Alamofire


protocol SearchResultDelegate{
    func searchResult(_ dict: [String: Any])
}

class SearchViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var itemsDict = [[String: Any]](){
        didSet{
            self.tableView.reloadData()
        }
    }
    
    var customDictModel = [  "category_id": 0,
                             "subcategory_id": 0,
                             "subcategory_name": "",
                             "category_name": "",
                             "subcategory_price": "",
                             "can_assemble": 1,
                             "subcategory_photo_url": "",
                             "is_custom_item": 1] as [String : Any]
    
    var searchResultDelegate : SearchResultDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.addTarget(self, action: #selector(changeCharacter), for: .editingChanged)
        searchTextField.layer.cornerRadius = 20.0 * screenHeightFactor
        searchTextField.setLeftPaddingPoints(20.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func changeCharacter(){
        
        self.callSearchAPI()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func callSearchAPI(){
        
                if !StaticHelper.Connectivity.isConnectedToInternet {
                    StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: self, completion: nil)
                    return
                }
        
            //  MoveItStaticHelper.shared.startLoader(VC.view)
        
        
        let parameters : Parameters =  ["serach_keyword":searchTextField.text!]


            AF.request(baseURL+kAPIMethods.search_items, method: .post, parameters: parameters).responseJSON { (response) in
                
                DispatchQueue.main.async {
                switch response.result {
                case .success:
                    //       MoveItStaticHelper.shared.stopLoader()
                    if response.response?.statusCode == 200{
                        let result = (response.value as! [String: Any])
                        self.itemsDict = result["search_items"] as! [[String: Any]]
                    }
                    else if response.response?.statusCode == 401{
                        StaticHelper.shared.stopLoader()
                        let responseJson = response.value as! [String: AnyObject]
                        self.view.makeToast(responseJson["message"] as? String)
                    }
                    else{
                        let itemName = self.searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                        self.customDictModel["subcategory_name"] = itemName!
                        self.itemsDict = [self.customDictModel]
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

extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  itemsDict.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let addItemCell = tableView.dequeueReusableCell(withIdentifier: "AddItemTableViewCell", for: indexPath) as! AddItemTableViewCell
        let itemDict = itemsDict[indexPath.row]
        let imgUrl = URL.init(string: (itemDict["subcategory_photo_url"] as! String))
        if imgUrl != nil{
            addItemCell.itemImage.af.setImage(withURL: imgUrl!)
        }
        else{
            addItemCell.itemImage.image = UIImage.init(named: "home_card_img_placeholder")
        }
       
        addItemCell.itemNameLabel.text = (itemDict["subcategory_name"] as! String)
        return addItemCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0 * screenHeightFactor
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let itemDict = itemsDict[indexPath.row]
        self.dismiss(animated: true, completion: {
            self.searchResultDelegate?.searchResult(itemDict)
        })
    }
}
