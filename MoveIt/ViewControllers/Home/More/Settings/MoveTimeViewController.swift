//
//  MoveTimeViewController.swift
//  Move It
//
//  Created by Dushyant on 12/06/19.
//  Copyright © 2019 Agicent Technologies. All rights reserved.
//

import UIKit

protocol MoveTimeDelegate {
    func selectedMoveTimeDelegate(moveTime: String, utcTime: String)
}

class MoveTimeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timeTypeLabel: UILabel!
    var timeTypeString = ""
    var moveTimeDelegate: MoveTimeDelegate?
    
    var isFromToTime = false
    var selectdFromTime = ""
    
    var normalTimeArray = ["06:00 AM","06:30 AM","07:00 AM","07:30 AM","08:00 AM","08:30 AM","09:00 AM","09:30 AM","10:00 AM","10:30 AM","11:00 AM","11:30 AM","12:00 PM","12:30 PM","01:00 PM","01:30 PM","02:00 PM","02:30 PM","03:00 PM","03:30 PM","04:00 PM","04:30 PM","05:00 PM","05:30 PM","06:00 PM","06:30 PM","07:00 PM","07:30 PM","08:00 PM","08:30 PM","09:00 PM","09:30 PM","10:00 PM","10:30 PM","11:00 PM","11:30 PM","12:00 AM","12:30 AM","01:00 AM"]
    var utcTimeArray = ["06:00","06:30","07:00","07:30","08:00","08:30","09:00","09:30","10:00","10:30","11:00","11:30", "12:00","12:30","13:00","13:30","14:00","14:30","15:00","15:30","16:00","16:30","17:00","17:30","18:00","18:30","19:00","19:30","20:00","20:30","21:00","21:30","22:00","22:30","23:00","23:30","00:00","00:30","01:00"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.timeTypeLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        
        if !isFromToTime{
            timeTypeLabel.text = "From Time"
            normalTimeArray.removeLast()
            utcTimeArray.removeLast()
        }
        else{
            timeTypeLabel.text = "To Time"
        }

        if isFromToTime && normalTimeArray.contains(selectdFromTime){
            let indexOfTime = normalTimeArray.firstIndex(of: selectdFromTime)! + 1
            var newTimeArray = [String]()
            var newUTCTimeArray = [String]()
            for  i in indexOfTime..<normalTimeArray.count{
                    newTimeArray.append(normalTimeArray[i])
                    newUTCTimeArray.append(utcTimeArray[i])
            }
            normalTimeArray = newTimeArray
            utcTimeArray = newUTCTimeArray
            tableView.reloadData()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension MoveTimeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return normalTimeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let moveCell = tableView.dequeueReusableCell(withIdentifier: "MoveTimeTableViewCell", for: indexPath) as! MoveTimeTableViewCell
        moveCell.moveTimeLabel.text = normalTimeArray[indexPath.row]
        return moveCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.dismiss(animated: true, completion: {
            self.moveTimeDelegate?.selectedMoveTimeDelegate(moveTime: self.normalTimeArray[indexPath.row], utcTime: self.utcTimeArray[indexPath.row])
        })
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30.0 * screenHeightFactor
    }
}
