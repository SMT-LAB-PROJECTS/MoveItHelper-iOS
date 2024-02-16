//
//  MoveTimeViewController.swift
//  Move It
//
//  Created by Dushyant on 12/06/19.
//  Copyright © 2019 Agicent Technologies. All rights reserved.
//

import UIKit

@objc protocol MoveArrivalTimeDelegate {
    @objc optional func dismissOnlyFromSlot()
    func timeSlotFinalizeFor(_ requestID: Int,_ helperType: Int)
}

class MoveArrivalTimeViewController: UIViewController {

    var isForJobEdit:Bool = false
    var delegate: MoveArrivalTimeDelegate?
    
    var Iam:Int!
    var selectedHelperType:Int = HelperType.Pro
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timeTypeLabel: UILabel!

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    
    var moveRequestID = Int()
    var moveInfo : MoveDetailsModel!
    var otherHelperInfo = [[String: Any]]()
    
    var previousClassReference : AllMovesChildViewController?
    
    var selectedIndex : Int?

    var startTime   =   ""
    var endTime     =   ""
    var timeSlotArray = [String]()

    var normalTimeArray = [
        "06:00 AM", "06:30 AM", "07:00 AM", "07:30 AM", "08:00 AM", "08:30 AM", "09:00 AM","09:30 AM", "10:00 AM", "10:30 AM",
        "11:00 AM", "11:30 AM", "12:00 PM", "12:30 PM", "01:00 PM", "01:30 PM", "02:00 PM", "02:30 PM", "03:00 PM", "03:30 PM",
        "04:00 PM", "04:30 PM", "05:00 PM", "05:30 PM","06:00 PM", "06:30 PM", "07:00 PM", "07:30 PM", "08:00 PM", "08:30 PM",
        "09:00 PM", "09:30 PM", "10:00 PM", "10:30 PM", "11:00 PM", "11:30 PM", "12:00 AM", "12:30 AM", "01:00 AM"]
   
    var allTimeArray = [
        "06:00 AM - 06:30 AM", "06:30 AM - 07:00 AM", "07:00 AM - 07:30 AM", "07:30 AM - 08:00 AM", "08:00 AM - 08:30 AM","08:30 AM - 09:00 AM",
        "09:00 AM - 09:30 AM", "09:30 AM - 10:00 AM", "10:00 AM - 10:30 AM", "10:30 AM - 11:00 AM", "11:00 AM - 11:30 AM","11:30 AM - 12:00 PM",
        "12:00 PM - 12:30 PM", "12:30 PM - 01:00 PM", "01:00 PM - 01:30 PM", "01:30 PM - 02:00 PM", "02:00 PM - 02:30 PM","02:30 PM - 03:00 PM",
        "03:00 PM - 03:30 PM", "03:30 PM - 04:00 PM", "04:00 PM - 04:30 PM", "04:30 PM - 05:00 PM", "05:00 PM - 05:30 PM","05:30 PM - 06:00 PM",
        "06:00 PM - 06:30 PM", "06:30 PM - 07:00 PM", "07:00 PM - 07:30 PM", "07:30 PM - 08:00 PM", "08:00 PM - 08:30 PM","08:30 PM - 09:00 PM",
        "09:00 PM - 09:30 PM", "09:30 PM - 10:00 PM", "10:00 PM - 10:30 PM", "10:30 PM - 11:00 PM", "11:00 PM - 11:30 PM","11:30 PM - 12:00 AM",
        "12:00 AM - 12:30 AM", "12:30 AM - 01:00 AM"]
    
    //MARK: - Methods Start
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion:
                        {
                            self.delegate?.dismissOnlyFromSlot!()
                        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Iam = (UserCache.shared.userInfo(forKey: kUserCache.service_type) as! Int)
        self.uiConfigurationAfterStoryboard()

        //self.getMoveDetails()
        self.showTimeSlots()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        acceptButton.layer.cornerRadius = (acceptButton.bounds.size.height / 2)
    }
    
    func uiConfigurationAfterStoryboard() {
        
        timeTypeLabel.text = "Arrival Time"
        self.timeTypeLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        self.headerView.frame.size.height = 60.0 * screenHeightFactor
        self.headerLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        self.acceptButton.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 15.0)
    }
    
    func initializeSlotsArrayReload() {
        if let statingTimeIndex = normalTimeArray.firstIndex(of: startTime) {
            if let endingTimeIndex  = normalTimeArray.firstIndex(of: endTime) {
                let i = statingTimeIndex
                for x in i...Int(endingTimeIndex-1){
                        timeSlotArray.append("\(normalTimeArray[x])" + " - " + "\(normalTimeArray[x+1])")
                }
            }
        }
        tableView.reloadData()
    }
    
    func showTimeSlots() {
        if (moveInfo!.helping_service_required_pros! + moveInfo!.helping_service_required_muscle!) >= 2 {
            StaticHelper.shared.stopLoader()
            
            if self.moveInfo!.meeting_slot!.isEmpty {
                self.initializeSlotsArrayReload()
            } else {
                self.headerLabel.text = "Another helper has set the selected time slot. Only accept if you will arrive at customer address during this time."
                
                self.timeSlotArray = [self.moveInfo!.meeting_slot!]
                self.selectedIndex = 0
                self.tableView.selectRow(at: IndexPath.init(row: self.selectedIndex!, section: 0), animated: false, scrollPosition: .none)
                self.tableView.allowsSelection = false
                self.tableView.reloadData()
            }
        } else {
            self.initializeSlotsArrayReload()
        }
    }
    
    @IBAction func acceptAction(_ sender: UIButton) {
        if(isForJobEdit == false) {
            if selectedIndex == nil{
                self.view.makeToast("Please select a time for your arrival at customer address.")
            } else if ((moveInfo!.helping_service_required_pros ?? 0) + (moveInfo!.helping_service_required_muscle ?? 0)) >= 2{
                self.checkRequared2HelpersMeetingSlots()
            } else{
                self.saveMeetingsSlotAndThenAcceptJob()
            }
        } else {
            if selectedIndex == nil {
                self.view.makeToast("Please select a time for your arrival at customer address.")
            } else {
                self.dismiss(animated: true) {
                    self.delegate?.timeSlotFinalizeFor(self.moveRequestID, self.selectedHelperType)
                }                
            }
        }
    }
    
    func checkRequared2HelpersMeetingSlots() {
        if moveInfo!.meeting_slot!.isEmpty {
            self.saveMeetingsSlotAndThenAcceptJob()
        } else{
            self.processAcceptMove()
        }
    }
    
    func saveMeetingsSlotAndThenAcceptJob() {
        let par = ["meeting_slot": timeSlotArray[selectedIndex!], "request_id":moveRequestID] as [String : Any]
      
        CommonAPIHelper.saveMeetingSlots(VC: self, params: par) { (res, err, isExe) in
            if isExe{
                self.processAcceptMove()
            }
        }
    }
    
    func processAcceptMove(){
        self.dismiss(animated: true) {
            self.delegate?.timeSlotFinalizeFor(self.moveRequestID, self.selectedHelperType)
        }
    }
    
    //MARK: - Extra Methods to remove
    @objc func getMoveDetails() {
        
        StaticHelper.shared.startLoader(self.view)
        CommonAPIHelper.getMoveDetailByID(VC: self, move_id: moveRequestID, completetionBlock: { (result, error, isexecuted) in
            
            DispatchQueue.main.async {
                if error != nil{
                    return
                } else{
                    self.moveInfo = MoveDetailsModel.init(moveDict: result!)
                    self.showTimeSlots()
                    //self.setupData()
                }
            }
        })
    }
    
    func setupData() {
        
        if (moveInfo!.helping_service_required_pros! + moveInfo!.helping_service_required_muscle!) >= 2 {
            StaticHelper.shared.stopLoader()
            CommonAPIHelper.getAllotedHelperInfo(VC: self, move_id: moveInfo!.request_id!) { (res, err, isExe) in
                DispatchQueue.main.async {
                    StaticHelper.shared.stopLoader()
                    if isExe{
                        self.otherHelperInfo = res!
                        if self.moveInfo!.meeting_slot!.isEmpty {
                            self.initializeSlotsArrayReload()
                        } else {
                            self.headerLabel.text = "Another helper has set the selected time slot. Only accept if you will arrive at customer address during this time."
                            
                            self.timeSlotArray = [self.moveInfo!.meeting_slot!]
                            self.selectedIndex = 0
                            self.tableView.selectRow(at: IndexPath.init(row: self.selectedIndex!, section: 0), animated: false, scrollPosition: .none)
                            self.tableView.allowsSelection = false
                            self.tableView.reloadData()
                        }
                    } else {
                        self.initializeSlotsArrayReload()
                    }
                }
            }
        } else {
            self.initializeSlotsArrayReload()
        }
    }
}

extension MoveArrivalTimeViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeSlotArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let moveCell = tableView.dequeueReusableCell(withIdentifier: "MoveTimeTableViewCell", for: indexPath) as! MoveTimeTableViewCell
        moveCell.moveTimeLabel.text = "\(timeSlotArray[indexPath.row])"
        
        if selectedIndex == indexPath.row{
            moveCell.backgroundColor = lightPinkColor
        }else{
            moveCell.backgroundColor = UIColor.white
        }
        return moveCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        selectedIndex = indexPath.row
        self.tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30.0 * screenHeightFactor
    }
}
