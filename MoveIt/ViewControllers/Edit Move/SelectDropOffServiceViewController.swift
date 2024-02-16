//
//  SelectDropOffServiceViewController.swift
//  MoveIt
//
//  Created by Dilip Saket on 23/09/21.
//  Copyright © 2021 Jyoti. All rights reserved.
//

import UIKit
import Alamofire

class SelectDropOffServiceViewController: UIViewController {
    
    var moveDict = [String: Any]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headLabel: UILabel!
    
    var serviceInfoDict = [[String: Any]](){
        didSet{
            self.tableView.reloadData()
        }
    }
    
    var selectedMoveType:MoveTypeModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle("Select Drop Off Service")
        self.uiConfigurationAfterStoryboards()
        //self.getAllDropOffTypes()
        self.getAllDropOffTypesNew()
    }
    
    func uiConfigurationAfterStoryboards() {
        headLabel.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        headerView.frame.size.height = 60.0 * screenHeightFactor
        
        self.navigationItem.leftBarButtonItem = StaticHelper.leftBarButton(withImageNamed: "backward_arrow_icon", forVC: self)
    }
    
    func getAllDropOffTypesNew() {
        
        DispatchQueue.main.async {
            StaticHelper.shared.startLoader(self.view)
        }
        
        AF.request(baseURL+kAPIMethods.get_dropoff_services+"?move_type_id="+String(self.selectedMoveType.id!)).responseJSON { (response) in
            switch response.result {
            case .success:
                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200{
                    let reponseDict = response.value as! [String: Any]
                    self.serviceInfoDict = reponseDict["drop_off_services"] as! [[String: Any]]
                  
                } else if(response.response?.statusCode == 401){
                    //StaticHelper.logout()
                }
            case .failure(let error):
                StaticHelper.shared.stopLoader()
                self.view.makeToast(error.localizedDescription)
            }
        }
    }
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
                        for dic in self.serviceInfoDict{
                            
                            if (dic["id"] as! Int) == 6 {
                                tempDict.append(dic)
                            }
                            self.serviceInfoDict = tempDict
                        }
                    } else if  (self.moveDict[keysForBookMoves.move_type_id] as! Int) == 10  {
                        var tempDict = [[String: Any]]()
                        for dic in self.serviceInfoDict{
                            
                            if (dic["id"] as! Int) == 4{
                                tempDict.append(dic)
                            }
                            self.serviceInfoDict = tempDict
                        }
                    } else  if  (self.moveDict[keysForBookMoves.move_type_id] as! Int) == 4  {
                        var tempDict = [[String: Any]]()
                        for dic in self.serviceInfoDict{
                            if (dic["id"] as! Int) == 1 {
                                tempDict.append(dic)
                            }
                            self.serviceInfoDict = tempDict
                        }
                    } else {
                        var index = 0
                        for dic in self.serviceInfoDict {
                            if (dic["id"] as! Int) == 4{
                                self.serviceInfoDict .remove(at: index)
                                break
                            }
                            index += 1
                        }
                    }
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
    
    @objc func leftPressed(_ selector: Any){
        self.navigationController?.popViewController(animated: true)
    }
}
extension SelectDropOffServiceViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceInfoDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dropOffCell = tableView.dequeueReusableCell(withIdentifier: "DropOff2TableViewCell", for: indexPath) as! DropOff2TableViewCell
        if let _ = self.moveDict[keysForBookMoves.dropoff_service_id] as? Int{
            if ((self.moveDict[keysForBookMoves.dropoff_service_id] as! Int) == (serviceInfoDict[indexPath.row]["id"] as! Int)){
                dropOffCell.contentView.backgroundColor = UIColor.lightGray
            }
            else{
                dropOffCell.contentView.backgroundColor = UIColor.init(red: 235.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
            }
        }
        dropOffCell.setInfo(serviceInfoDict[indexPath.row])
        return dropOffCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        moveDict[keysForBookMoves.dropoff_service_id] = serviceInfoDict[indexPath.row]["id"]

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddMoreItemViewController") as!  AddMoreItemViewController
        vc.selectedMoveType = self.selectedMoveType
        vc.moveDict = self.moveDict
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
