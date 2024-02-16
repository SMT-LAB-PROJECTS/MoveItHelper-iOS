//
//  AddMoreItemViewController.swift
//  Move It Customer
//
//  Created by Dushyant on 10/05/19.
//  Copyright © 2019 Agicent Technologies. All rights reserved.
//

import UIKit
import Alamofire

class AddMoreItemViewController: UIViewController,SearchResultDelegate {
    
    var moveDict = [String: Any]()
    var serviceInfoDict = [[String: Any]]()
    
    var discount_amount:Double = 0
    var discount_percentage:Int = 0
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var totalItemsLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var checkOutBkView: UIView!
    @IBOutlet weak var checkOutLabel: UILabel!
    @IBOutlet weak var addMoreButton: UIButton!
    @IBOutlet weak var checkoutButton: UIButton!
    
    var selectedItemList = [[String:Any]]()
    
    var selectedMoveType:MoveTypeModel!
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle("Item Details")
        self.uiConfigurationAfterStoryboard()
        
        if let dropoff_service_id:Int = moveDict[keysForBookMoves.dropoff_service_id] as? Int {
            if(dropoff_service_id != 0) {
                self.getAllDropOffTypes()
            }
        }
//        if let is_promocode_applied = (moveDict[keysForBookMoves.is_promocode_applied] as? Int) {
//            if(is_promocode_applied == 1){
//                let promocode:String = moveDict[keysForBookMoves.promocode] as! String
//                self.callValidatePromocodeAPI(code: promocode)
//            }
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadData()
    }
    
    func uiConfigurationAfterStoryboard() {
        selectedItemList = self.moveDict["items"] as! [[String:Any]]
        
        if(self.selectedMoveType.can_add_item == 0) {
            addMoreButton.isHidden = true
        }
        
        self.navigationItem.leftBarButtonItem = StaticHelper.leftBarButton(withImageNamed: "backward_arrow_icon", forVC: self)
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 50.0 * screenHeightFactor, right: 0)
        self.totalItemsLabel.font = UIFont.josefinSansRegularFontWithSize(size: 14.0)
        self.quantityLabel.font = UIFont.josefinSansRegularFontWithSize(size: 14.0)
        self.checkOutLabel.font = UIFont.josefinSansRegularFontWithSize(size: 14.0)
    }
    
    @objc func reloadData(){
        selectedItemList =   self.moveDict["items"] as! [[String: Any]]
        self.quantityLabel.text = String(selectedItemList.count)
        self.tableView.reloadData()
    }
    
    
    //MARK: - Actions
    @objc func leftPressed(_ selector: Any){
        
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: AdditionalLocationDetailsViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    @IBAction func checkOutAction(_ sender: Any) {
        
        let arrItemsDict = self.moveDict["items"] as? [[String: Any]] ?? []
        
        if(arrItemsDict.count == 0) {
            self.view.makeToast("Please add at least one Item")
            return
        }
        
        self.calculatePrice()        
    }
    
    func calculatePrice() {
        
        let milagePrice = (self.moveDict[keysForBookMoves.total_miles_distance] as! Double) * 1.75
        let pickUpStairs = Double((self.moveDict[keysForBookMoves.pickup_stairs] as! Int) * 5)
        let dropOffStairs = Double((self.moveDict[keysForBookMoves.drop_off_stairs] as! Int) * 5)
        
        var ridingCost = 0.0
        if ((self.moveDict[keysForBookMoves.ride_with_helper] as! Int)) == 1{
            ridingCost = milagePrice
        }
        
        let oldServiceCharge = milagePrice + pickUpStairs + dropOffStairs + ridingCost
        
        let itemsDict = self.moveDict["items"] as! [[String: Any]]
        var itemTotal = 0.0
        var assemblyPrice = 0.0
        var totalItem = 0
        
        for dict in itemsDict {
            var quantity = 0
            var price = 0.0
            if let qun = (dict[keysForBookMoves.quantity] as? Int) {
                quantity = Int(qun)
            } else {
                quantity = Int(dict[keysForBookMoves.quantity] as! String)!
            }
            
            if let pr = dict[keysForBookMoves.item_price] as? Double {
                price = pr
            } else {
                price = Double(dict[keysForBookMoves.item_price] as! String)!
            }
            
            itemTotal = itemTotal + Double(quantity) * Double(price)
            totalItem =  totalItem + quantity
            
            if ((dict[keysForBookMoves.is_assamble] as! Int)) == 1 {
                assemblyPrice = assemblyPrice + Double((quantity) * 5)
            }
        }
        
        self.quantityLabel.text = String(totalItem)
        let insuranceAmount =  Double(self.moveDict[keysForBookMoves.insurance_charge] as! Double)
        let servicePrice =  Double(self.moveDict[keysForBookMoves.helping_service_price] as! Double)
        
        let totalPrice = oldServiceCharge + itemTotal + assemblyPrice + servicePrice //+ insuranceAmount
        self.moveDict[keysForBookMoves.total_amount] = totalPrice
                        
        var serviceDiscountAmount = 0.0
        let dropoff_service_id:Int = moveDict[keysForBookMoves.dropoff_service_id] as? Int ?? 0
        
        if(dropoff_service_id != 0) {
        for serviceDict in serviceInfoDict {
            let sId:Int = serviceDict["id"] as! Int
            if(sId == dropoff_service_id) {
                let sericeDiscoutPercentage:Int = serviceDict["price"] as? Int ?? 0
                serviceDiscountAmount = (totalPrice * (Double(sericeDiscoutPercentage) / 100))
                break
            }
        }
        }
        
        var promocodeDiscountAmount = 0.0
        if discount_percentage > 0 {
            promocodeDiscountAmount = ((totalPrice-serviceDiscountAmount) * (Double(self.discount_percentage) / 100))
        }

        //Next Release
        //Below code is for estimated_hour_price price value
        var move_type_id:Int! = moveDict[keysForBookMoves.move_type_id] as? Int ?? 0
        if(move_type_id == 0) {
            move_type_id = Int(moveDict[keysForBookMoves.move_type_id] as? String ?? "0")!
        }
        
        if(self.selectedMoveType.is_estimate_hour == 1) {
            let estimated_hour_price:Double = pickUpStairs + dropOffStairs + servicePrice
            moveDict[keysForBookMoves.estimate_hour_price] = estimated_hour_price //- promocodeDiscountAmount
            
            //New changes
            let estimated_hour:Int! = moveDict[keysForBookMoves.estimate_hour] as? Int ?? 1
            moveDict[keysForBookMoves.promocode_discount] = promocodeDiscountAmount * Double(estimated_hour)
        } else {
            moveDict[keysForBookMoves.promocode_discount] = promocodeDiscountAmount
        }
       
        
        moveDict[keysForBookMoves.service_discount] = serviceDiscountAmount
        moveDict[keysForBookMoves.discount_amount] = serviceDiscountAmount//+promocodeDiscountAmount
        moveDict[keysForBookMoves.insurance_charge] = insuranceAmount

        let finalPrice:Double = totalPrice - serviceDiscountAmount - promocodeDiscountAmount + insuranceAmount
        moveDict[keysForBookMoves.final_price] = finalPrice
        
        self.calculateLabourPrice()
    }
    
    func calculateLabourPrice(){
        let finalPrice = self.moveDict[keysForBookMoves.final_price] as! Double
        let reqPro = self.moveDict[keysForBookMoves.helping_service_required_pros] as! Int
        let reqMuscle = self.moveDict[keysForBookMoves.helping_service_required_muscle] as! Int
        
        let deductedPrice = finalPrice * 0.7
        var reqProPrice = 0.0
        var reqMusclePrice = 0.0
        
        if reqPro > 0 && reqMuscle == 0{
             reqProPrice = deductedPrice / Double(reqPro)
        }
        else if reqMuscle > 0 && reqPro == 0{
             reqMusclePrice = deductedPrice / Double(reqMuscle)
        }
        else {
            reqProPrice = deductedPrice * 0.65
            reqMusclePrice = deductedPrice * 0.35
        }
        self.moveDict[keysForBookMoves.pros_price] = reqProPrice
        self.moveDict[keysForBookMoves.muscle_price] = reqMusclePrice
        
        callAnalyticsEvent(eventName: "moveit_edit_move_request", desc: ["description":"\(profileInfo?.helper_id ?? 0) edit the move request"])
         self.callEditSubmitMoveAPI()
    }
    
    func callEditSubmitMoveAPI(){
        
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: self, completion: nil)
            return
        }
          
        StaticHelper.shared.startLoader(self.view)
        self.moveDict[keysForBookMoves.helper_edited] = 1

        let parameters : Parameters =  self.moveDict
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!,"Content-Type":"application/json"]
          
        print(parameters,header)
        
        AF.request(baseURL+kAPIMethods.helper_edit_move, method: .post, parameters: parameters,encoding: JSONEncoding.default,headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
            switch response.result {
            case .success:
                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200 {
                    let apiResponse = response.value as! [String: Any]
                    print(apiResponse)
                    self.self.moveDict = [String: Any]()
                    self.navigationController?.dismiss(animated: true, completion: {
                        for controller in self.navigationController!.viewControllers as Array {
                            if controller.isKind(of: OnGoingServiceViewController.self) {
                                self.navigationController!.popToViewController(controller, animated: true)
                                break
                            }
                        }
                  })
                  NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OngoingService"), object: nil)
                }
               else if response.response?.statusCode == 401 {
                  StaticHelper.shared.stopLoader()
                  let responseJson = response.value as! [String: AnyObject]
                  self.view.makeToast(responseJson["message"] as? String)
              }
                
            case .failure(let error):
                StaticHelper.shared.stopLoader()
                self.view.makeToast(error.localizedDescription)
            }
            }
        }
    }
    
    @IBAction func addMoreAction(_ sender: Any) {
        
        let selectItemVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectItemViewController") as! SelectItemViewController
        selectItemVC.selectedMoveType = self.selectedMoveType
        selectItemVC.moveDict = self.moveDict
        selectItemVC.isFromAddMore = true
        selectItemVC.addMoreItemVC = self
        self.navigationController?.pushViewController(selectItemVC, animated: true)
    }
    
   //MARK: - searchResultDelegate
    func searchResult(_ dict: [String : Any]) {
        
        let editItemVC = self.storyboard?.instantiateViewController(withIdentifier: "EditItemViewController") as! EditItemViewController
        editItemVC.selectedMoveType = self.selectedMoveType
        editItemVC.moveDict = self.moveDict
        editItemVC.isFromAddMore = true
        editItemVC.addMoreItemVC = self
        editItemVC.itemsDict = dict
        self.navigationController?.pushViewController(editItemVC, animated: true)
    }
    
    //MARK: - APIs
    
    func getAllDropOffTypes(){
        
        DispatchQueue.main.async {
            StaticHelper.shared.startLoader(self.view)
        }
        
        AF.request(baseURL+kAPIMethods.get_dropoff_services).responseJSON { (response) in
            
            DispatchQueue.main.async {
            switch response.result {
            case .success:
                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200{
                    let reponseDict = response.value as! [String: Any]
                    self.serviceInfoDict = reponseDict["drop_off_services"] as! [[String: Any]]
                  
                    if  (self.moveDict[keysForBookMoves.move_type_id] as! Int) == 12 {
                        var tempDict = [[String: Any]]()
                        for dic in self.serviceInfoDict {
                            if (dic["id"] as! Int) == 6 {
                                tempDict.append(dic)
                            }
                            self.serviceInfoDict = tempDict
                        }
                    } else if  (self.moveDict[keysForBookMoves.move_type_id] as! Int) == 10 {
                        var tempDict = [[String: Any]]()
                        for dic in self.serviceInfoDict {
                            if (dic["id"] as! Int) == 4 {
                                tempDict.append(dic)
                            }
                            self.serviceInfoDict = tempDict
                        }
                    } else  if  (self.moveDict[keysForBookMoves.move_type_id] as! Int) == 4 {
                        var tempDict = [[String: Any]]()
                        for dic in self.serviceInfoDict {
                            if (dic["id"] as! Int) == 1 {
                                tempDict.append(dic)
                            }
                            self.serviceInfoDict = tempDict
                        }
                    } else {
                        var index = 0
                        for dic in self.serviceInfoDict {
                            if (dic["id"] as! Int) == 4 {
                                self.serviceInfoDict .remove(at: index)
                                break
                            }
                            index += 1
                        }
                    }
                }
            case .failure(let error):
                StaticHelper.shared.stopLoader()
                self.view.makeToast(error.localizedDescription)
            }
            }
        }
    }
    
    func callValidatePromocodeAPI(code:String){
                
        StaticHelper.shared.startLoader(self.view)
        let param = ["promocode": code]
        AF.request(baseURL+kAPIMethods.validate_promocode, method: .post,parameters: param).responseJSON { (response) in
            DispatchQueue.main.async {
                StaticHelper.shared.stopLoader()
                switch response.result {
                case .success:
                    if response.response?.statusCode == 200 {
                        
                        let result = (response.value as! [String: Any])
                        if (result["is_valid_promocode"] as! Int) == 1{
                            self.discount_amount = (result["discount_amount"] as! Double)
                            self.discount_percentage = (result["discount_percentage"] as! Int)
                        } else {
                        }
                    } else {
                    }
                case .failure(_):
                    StaticHelper.shared.stopLoader()
                    self.view.makeToast("Internal Server Error. Sorry for inconvenience, Please try again later.")
                }
            }
        }
    }
}



extension AddMoreItemViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let addItemCell = tableView.dequeueReusableCell(withIdentifier: "AddMoreItemTableViewCell", for: indexPath) as! AddMoreItemTableViewCell
        addItemCell.itemLabel.text = (selectedItemList[indexPath.row][keysForBookMoves.item_name] as! String)
    
        if let itemQuantity = selectedItemList[indexPath.row][keysForBookMoves.quantity] as? Int{
            addItemCell.itemQuantityLabel.text = String(itemQuantity)
        }
        else{
            addItemCell.itemQuantityLabel.text = (selectedItemList[indexPath.row][keysForBookMoves.quantity] as! String)
        }
        addItemCell.editButton.backgroundColor = darkPinkColor
        addItemCell.editButton.layer.cornerRadius = 10.0
        addItemCell.editButton.tag = indexPath.row
        addItemCell.editButton.addTarget(self, action: #selector(editPressed(_:)), for: .touchUpInside)
        
        addItemCell.deleteButton.backgroundColor = darkPinkColor
        addItemCell.deleteButton.layer.cornerRadius = 10.0
        addItemCell.deleteButton.tag = indexPath.row
        addItemCell.deleteButton.addTarget(self, action: #selector(deletePressed(_:)), for: .touchUpInside)
        
        
        var move_type_id:Int! = moveDict[keysForBookMoves.move_type_id] as? Int ?? 0
        if(move_type_id == 0) {
            move_type_id = Int(moveDict[keysForBookMoves.move_type_id] as? String ?? "0")!
        }
        if(self.selectedMoveType.can_edit_item == 0) {
            addItemCell.editButton.isHidden = true
        } else {
            addItemCell.editButton.isHidden = false
        }
        
        if(self.selectedMoveType.can_delete_item == 0) {        
            addItemCell.deleteButton.isHidden = true
        } else {
            addItemCell.deleteButton.isHidden = false
        }
        
        return addItemCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0 * screenHeightFactor
    }
    
    @objc func editPressed(_ selector: UIButton){
        self.editItems(selector.tag)
    }
    @objc func deletePressed(_ selector: UIButton){
        
        let alertController = UIAlertController.init(title: "Do you really  want to remove this item?", message: "", preferredStyle: .alert)
        
        let cancelButton = UIAlertAction.init(title: "NO", style: .cancel, handler: nil)
        let yesButton = UIAlertAction.init(title: "YES", style: .default) { (_) in
            self.deleteItems(selector.tag)
        }
        alertController.addAction(yesButton)
        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func morePressed(_ selector: UIButton){
        StaticHelper.showActionSheetWithTitle("Select Option", message: "", buttonTitles: ["Edit","Delete"], viewController: self) { (option) in
            switch (option){
                case 0:
                    self.editItems(selector.tag)
                case 1:
                    self.deleteItems(selector.tag)
                default:
                    break
            }
        }
    }
   
    @objc func editItems(_ index: Int){
        self.moveDict["items"] = selectedItemList
        let editItemVC = self.storyboard?.instantiateViewController(withIdentifier: "EditItemViewController") as! EditItemViewController
        editItemVC.selectedMoveType = self.selectedMoveType
        editItemVC.moveDict = self.moveDict
        editItemVC.isFromEditMenue = true
        editItemVC.addMoreItemVC = self
        editItemVC.itemIndex = index
        editItemVC.itemsDict = (self.moveDict["items"] as! [[String: Any]])[index]
        self.navigationController?.pushViewController(editItemVC, animated: true)
    }
    
    @objc func deleteItems(_ index: Int){
         selectedItemList.remove(at: index)
         self.moveDict["items"] = selectedItemList
         self.quantityLabel.text = String(selectedItemList.count)
         self.tableView.reloadData()
    }
}
