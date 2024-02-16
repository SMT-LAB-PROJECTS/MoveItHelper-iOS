//
//  AdditionalLocationDetailsViewController.swift
//  Move It
//
//  Created by Dushyant on 05/06/19.
//  Copyright © 2019 Agicent Technologies. All rights reserved.
//

import UIKit
import Alamofire

class AdditionalLocationDetailsViewController: UIViewController {

    var moveDict = [String: Any]()
    
    var isPickupStairsNeeded = false
    var pickupStairs = 0
    var isDropOffStairsNeeded = false
    var dropOffStairs = 0
    var pickupElevatorNeeded = false
    var dropoffElevatorNeeded = false
    var needToMoveWithHelper = false
    var pickupApartment = ""
    var dropoffApartment = ""
    var fromAddress = ""
    var toAddress = ""
    var numOfRider = 1
  
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var continueLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    var selectedMoveType:MoveTypeModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.uiConfigurationAfterStoryboard()
        
        
        self.showDraftInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func uiConfigurationAfterStoryboard() {
        setNavigationTitle("Location Details")
        
        self.navigationItem.leftBarButtonItem = StaticHelper.leftBarButton(withImageNamed: "backward_arrow_icon", forVC: self)
        continueLabel.font = UIFont.josefinSansBoldFontWithSize(size: 14.0)
        self.tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 70.0 * screenHeightFactor, right: 0)

    }
    
    @objc func leftPressed(_ selector: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    func showDraftInfo(){

        if let pickupStairs = Int(self.moveDict[keysForBookMoves.pickup_stairs] as! String){
            self.pickupStairs = Int(pickupStairs)
            if self.pickupStairs > 0 {
                isPickupStairsNeeded = true
            } else {
                isPickupStairsNeeded = false
            }
        }
        
        if let dropOffStairs = Int(self.moveDict[keysForBookMoves.drop_off_stairs] as! String){
            self.dropOffStairs = Int(dropOffStairs)
            if self.dropOffStairs > 0 {
                isDropOffStairsNeeded = true
            } else {
                isDropOffStairsNeeded = false
            }
        }

        if let pickupElevator = Int(self.moveDict[keysForBookMoves.use_pickup_elevator] as! String){

            if pickupElevator == 0 {
                self.pickupElevatorNeeded = false
            } else {
                self.pickupElevatorNeeded = true
            }
        }

        if let dropOffElevator = Int((self.moveDict[keysForBookMoves.use_pickup_elevator] as! String)){
            if dropOffElevator == 0 {
                self.dropoffElevatorNeeded = false
            } else {
                self.dropoffElevatorNeeded = true
            }
        }

        if let pickupApartment = self.moveDict[keysForBookMoves.pickup_apartment] as? String{
            self.pickupApartment = pickupApartment
        }
        
        if let dropoffApartment = self.moveDict[keysForBookMoves.pickup_apartment] as? String{
            self.dropoffApartment = dropoffApartment
        }
        self.tableView.reloadData()
    }
        
    @IBAction func continuePressed(_ sender: UIButton) {
    
        self.moveDict[keysForBookMoves.pickup_stairs] = pickupStairs
        self.moveDict[keysForBookMoves.drop_off_stairs] = dropOffStairs
        self.moveDict[keysForBookMoves.pickup_apartment] = pickupApartment
        self.moveDict[keysForBookMoves.dropoff_apartment] = dropoffApartment
        if pickupElevatorNeeded {
            self.moveDict[keysForBookMoves.use_pickup_elevator] = 1
        } else {
           self.moveDict[keysForBookMoves.use_pickup_elevator] = 0
        }
        
        if dropoffElevatorNeeded {
            self.moveDict[keysForBookMoves.use_dropoff_elevator] = 1
        } else {
            self.moveDict[keysForBookMoves.use_dropoff_elevator] = 0
        }
        
        if needToMoveWithHelper {
            self.moveDict[keysForBookMoves.ride_with_helper] = 1
            self.moveDict[keysForBookMoves.num_of_rider] = 1
        } else {
            self.moveDict[keysForBookMoves.ride_with_helper] = 0
            self.moveDict[keysForBookMoves.num_of_rider] = 0
        }
        
        self.moveDict[keysForBookMoves.ride_with_helper] = pickupStairs
        
        //Need to call Drop Off Service
        let dropOffServiceVc = self.storyboard?.instantiateViewController(withIdentifier: "SelectDropOffServiceViewController") as! SelectDropOffServiceViewController
        dropOffServiceVc.moveDict = self.moveDict
        dropOffServiceVc.selectedMoveType = self.selectedMoveType
        self.navigationController?.pushViewController(dropOffServiceVc, animated: true)
    }
    
    
    
}

extension AdditionalLocationDetailsViewController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
            
        if self.selectedMoveType?.is_dropoff_address == 0 {
            return 1
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            switch indexPath.row{
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddStairsTableViewCell") as! AddStairsTableViewCell
                cell.titleLabel.text = "Needs to use stairs"
                cell.selectButton.tag = 1
                
                cell.minusButton.tag = 11
                cell.plusButton.tag = 12
                
                cell.minusButton.addTarget(self, action: #selector(minusButton(_:)), for: .touchUpInside)
                cell.plusButton.addTarget(self, action: #selector(plusButton(_:)), for: .touchUpInside)
                
                cell.stairsLabel.text = String(pickupStairs) + " flight(s)"
                if isPickupStairsNeeded{
                    cell.selectButton.isSelected = true
                    cell.heightConst.constant = 30.0 * screenHeightFactor
                    cell.addStairsBkView.isHidden = false
                }
                else{
                    cell.selectButton.isSelected = false
                    cell.heightConst.constant = 0.0
                    cell.addStairsBkView.isHidden = true
                }
                
                cell.selectButton.addTarget(self, action: #selector(selectPressed(_:)), for: .touchUpInside)
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "NextLocationTableViewCell") as! NextLocationTableViewCell
                 cell.titleLabel.text = "Can use elevator"
                 cell.markButton.tag = 2
                
                if pickupElevatorNeeded{
                    cell.markButton.isSelected = true
                }
                else{
                    cell.markButton.isSelected = false
                }

                cell.markButton.addTarget(self, action: #selector(selectPressed(_:)), for: .touchUpInside)
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "NextLocationTableViewCell") as! NextLocationTableViewCell
                cell.markButton.tag = 3
               
                if needToMoveWithHelper{
                    cell.markButton.isSelected = true
                }
                else{
                    cell.markButton.isSelected = false
                }
                
                cell.markButton.addTarget(self, action: #selector(selectPressed(_:)), for: .touchUpInside)
                
                cell.titleLabel.text = "Ride with Helper to next location"
                return cell
            default:
                break
            }
        }
        else{
            switch indexPath.row{
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddStairsTableViewCell") as! AddStairsTableViewCell
                cell.titleLabel.text = "Needs to use stairs"
                cell.stairsLabel.text = String(dropOffStairs) + " flight(s)"
                
                cell.minusButton.tag = 13
                cell.plusButton.tag = 14
                cell.minusButton.addTarget(self, action: #selector(minusButton(_:)), for: .touchUpInside)
                cell.plusButton.addTarget(self, action: #selector(plusButton(_:)), for: .touchUpInside)
                cell.selectButton.tag = 4
                if isDropOffStairsNeeded{
                    cell.selectButton.isSelected = true
                    cell.heightConst.constant = 30.0 * screenHeightFactor
                    cell.addStairsBkView.isHidden = false
                }
                else{
                    cell.selectButton.isSelected = false
                    cell.heightConst.constant = 0.0
                    cell.addStairsBkView.isHidden = true
                }
                cell.selectButton.addTarget(self, action: #selector(selectPressed(_:)), for: .touchUpInside)
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "NextLocationTableViewCell") as! NextLocationTableViewCell
                cell.markButton.tag = 5
                if dropoffElevatorNeeded{
                    cell.markButton.isSelected = true
                }
                else{
                    cell.markButton.isSelected = false
                }
                cell.markButton.addTarget(self, action: #selector(selectPressed(_:)), for: .touchUpInside)
                cell.titleLabel.text = "Can use elevator"
                return cell
            default:
                break
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            switch indexPath.row{
            case 0:
                if isPickupStairsNeeded{
                    return 100.0 * screenHeightFactor
                } else {
                    return 65.0 * screenHeightFactor
                }
            case 1:
                return 40.0 * screenHeightFactor
            case 2:
                return 40.0 * screenHeightFactor
            default:
                break
            }
        }
        else{
            switch indexPath.row{
            case 0:
                if isDropOffStairsNeeded{
                    return 100.0 * screenHeightFactor
                }
                else{
                    return 65.0 * screenHeightFactor
                }
            case 1:
                return 40.0 * screenHeightFactor
            default:
                break
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 50.0 * screenHeightFactor))
        label.textAlignment = .center
        label.font = UIFont.josefinSansSemiBoldFontWithSize(size: 17.0)
        if section == 0{
            label.text = "Pick up Info"
        }
        else{
            label.text = "Drop off Info"
        }
        
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 50.0 * screenHeightFactor
        } else {
            return 50.0 * screenHeightFactor
        }
    }
    
    
    @objc func selectPressed(_ selector: UIButton){
        
        switch selector.tag {
            case 1:
                if selector.isSelected {
                    isPickupStairsNeeded = false
                } else {
                    isPickupStairsNeeded = true
                }
            case 2:
                if selector.isSelected {
                    pickupElevatorNeeded = false
                } else {
                    pickupElevatorNeeded = true
                }
            case 3:
                if selector.isSelected {
                    needToMoveWithHelper = false
                } else {
                    needToMoveWithHelper = true
                }
            case 4:
                if selector.isSelected {
                    isDropOffStairsNeeded = false
                } else {
                    isDropOffStairsNeeded = true
                }
            case 5:
                if selector.isSelected {
                    dropoffElevatorNeeded = false
                } else {
                    dropoffElevatorNeeded = true
                }
        default:
            break
        }
        self.tableView.reloadData()
    }
    
    @objc func minusButton(_ selector: UIButton){
     
        if selector.tag == 11 {
            if pickupStairs > 0 {
                pickupStairs = pickupStairs - 1
                tableView.reloadData()
            }
        } else {
            if dropOffStairs > 0 {
                dropOffStairs = dropOffStairs - 1
                tableView.reloadData()
            }
        }
        
    }
    
    @objc func plusButton(_ selector: UIButton){
        if selector.tag == 12 {
            pickupStairs = pickupStairs + 1
            tableView.reloadData()
        } else {
            dropOffStairs = dropOffStairs + 1
            tableView.reloadData()
        }
    }
    
}

extension AdditionalLocationDetailsViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1{
            self.pickupApartment =  (textField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
        } else {
            self.dropoffApartment =  (textField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
        }
        self.tableView.reloadData()
    }
}

