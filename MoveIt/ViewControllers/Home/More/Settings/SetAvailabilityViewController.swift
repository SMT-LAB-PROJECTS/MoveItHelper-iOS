//
//  SetAvailabilityViewController.swift
//  MoveIt
//
//  Created by Dushyant on 11/07/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class SetAvailabilityViewController: UIViewController,UITextFieldDelegate,MoveTimeDelegate {
    
    var fromTimeString = "06:00"
    var toTimeString = "01:00"
    
    var utcFromTime = "08:00"
    var utcToTime = "21:00"
    
    var isToTime  = false
    
    @IBOutlet weak var tableView: UITableView!
    
    let normalTimeArray = ["06:00 AM","06:30 AM","07:00 AM","07:30 AM","08:00 AM","08:30 AM","09:00 AM","09:30 AM","10:00 AM","10:30 AM","11:00 AM","11:30 AM","12:00 PM","12:30 PM","01:00 PM","01:30 PM","02:00 PM","02:30 PM","03:00 PM","03:30 PM","04:00 PM","04:30 PM","05:00 PM","05:30 PM","06:00 PM","06:30 PM","07:00 PM","07:30 PM","08:00 PM","08:30 PM","09:00 PM","09:30 PM","10:00 PM","10:30 PM","11:00 PM","11:30 PM","12:00 AM","12:30 AM","01:00 AM"]
    
    let utcTimeArray = ["06:00","06:30","07:00","07:30","08:00","08:30","09:00","09:30","10:00","10:30","11:00","11:30", "12:00","12:30","13:00","13:30","14:00","14:30","15:00","15:30","16:00","16:30","17:00","17:30","18:00","18:30","19:00","19:30","20:00","20:30","21:00","21:30","22:00","22:30","23:00","23:30","00:00","00:30","01:00"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationTitle("Set Availability")
        
        let leftBarButtonItem = StaticHelper.leftBarButtonWithImageNamed(imageName: "backward_arrow_icon", vc: self)
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let avSlot =  profileInfo?.available_slots?.last

        if avSlot?["start_time"] != nil {

            fromTimeString = avSlot?["start_time"] as! String
            toTimeString = avSlot?["end_time"] as! String
            utcFromTime = fromTimeString
        }
        else {
            fromTimeString = "06:00"
            toTimeString = "01:00"
            //self.getHelperAvailibility()
        }
    }
    
    func getHelperAvailibility() {
        let param = ["timezone": TimeZone.current.identifier]
        CommonAPIHelper.getAvailability(VC: self, params: param) { (res, err, isExecuted) in
            DispatchQueue.main.async {
                if isExecuted{
                    let start_time:String = res?["start_time"] as! String
                    let end_time:String = res?["end_time"] as! String
                    
                    profileInfo?.available_slots = [res!]
                    
                    self.fromTimeString = start_time
                    self.toTimeString = end_time
                    
                    self.tableView.reloadData()
                } else {
                }
            }
        }
    }
    
    @objc func leftButtonPressed(_ selector: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func rightTextPressed(_ selector: UIButton){
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 2 { //TO TIME
            let toTimeVC = self.storyboard?.instantiateViewController(withIdentifier: "MoveTimeViewController") as! MoveTimeViewController
            toTimeVC.modalPresentationStyle = .overFullScreen
            isToTime = true
            toTimeVC.isFromToTime = true
            toTimeVC.selectdFromTime = self.fromTimeString
            toTimeVC.moveTimeDelegate =  self
            self.present(toTimeVC, animated: true, completion: nil)
        } else { //FROM TIME
            let toTimeVC = self.storyboard?.instantiateViewController(withIdentifier: "MoveTimeViewController") as! MoveTimeViewController
            self.toTimeString = ""
            toTimeVC.modalPresentationStyle = .overFullScreen
            isToTime = false
            toTimeVC.isFromToTime = false
            toTimeVC.selectdFromTime = self.fromTimeString
            toTimeVC.moveTimeDelegate =  self
            self.present(toTimeVC, animated: true, completion: nil)
        }
        return false
    }

    func selectedMoveTimeDelegate(moveTime: String, utcTime: String) {
        if isToTime {
            self.utcToTime = utcTime
            self.toTimeString = utcTime
        } else {
            self.utcFromTime = utcTime
            self.fromTimeString = utcTime
            if !utcToTime.isEmpty {
                if  utcFromTime.formattedTimeFromString() >= utcToTime.formattedTimeFromString() {
                    toTimeString = "21:00"
                    utcToTime = "21:00"
                }
            }
        }
        self.tableView.reloadData()
    }
}

extension SetAvailabilityViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeSlotTableViewCell", for: indexPath) as! TimeSlotTableViewCell
        cell.addTimeSlotButton.addTarget(self, action: #selector(addTimeSlot(_:)), for: .touchUpInside)
        cell.fromTimeTextField.setLeftPaddingPoints(10.0 * screenWidthFactor)
        cell.toTimeTextField.setLeftPaddingPoints(10.0 * screenWidthFactor)
        
        if(fromTimeString.contains("AM") || fromTimeString.contains("PM")) {
            cell.fromTimeTextField.text = fromTimeString
        } else {
            let indexFrom:Int = utcTimeArray.firstIndex(of: fromTimeString)!
            cell.fromTimeTextField.text = normalTimeArray[indexFrom]
        }
        
        if(toTimeString.contains("AM") || toTimeString.contains("PM")) {
            cell.toTimeTextField.text = toTimeString
        } else {
            if toTimeString != "" {
                let indexTo:Int = utcTimeArray.firstIndex(of: toTimeString)!
                cell.toTimeTextField.text = normalTimeArray[indexTo]
            }else{
                cell.toTimeTextField.text = ""
            }
        }
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270.0 * screenHeightFactor
    }
    
    @objc func addTimeSlot(_ selector: UIButton){
        if self.toTimeString == ""{
            let windows = UIApplication.shared.windows
            windows.last?.rootViewController!.view.makeToast("Please select to time")
            return
        }
        let param = ["start_time": utcFromTime,"end_time": utcToTime]
        CommonAPIHelper.setAvailability(VC: self, params: param) { (res, err, isExecuted) in
            if isExecuted {
                profileInfo?.available_slots? = [param]
                self.navigationController?.popViewController(animated: true)
            } else {
            }
        }
    }
}

