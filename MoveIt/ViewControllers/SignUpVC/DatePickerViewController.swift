//
//  DatePickerViewController.swift
//  MoveIt
//
//  Created by Dushyant on 27/05/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

protocol DateSelectedDelegate {
    func selectedDate(_ dateString: Date)
}

class DatePickerViewController: UIViewController {

    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var dobLabel: UILabel!
    
    var dateSelectedDelegate: DateSelectedDelegate?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var isExpiry:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        let date = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        if(isExpiry == true) {
            let date = Calendar.current.date(byAdding: .day, value: 1, to: Date())

            dobLabel.text = "POLICY EXPIRY DATE"
            datePicker.minimumDate = date
        } else {
            datePicker.maximumDate = date
            dobLabel.font = UIFont.josefinSansBoldFontWithSize(size: 14.0)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        toolBar.roundCorners(corners: [.topLeft,.topRight], radius: 15.0 * screenHeightFactor)
    }
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func dateAction(_ sender: Any) {
        
        dateSelectedDelegate?.selectedDate(datePicker.date)
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension Date{
    func stringDateWitHFormat(_ format: String)-> String{
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = format
        return dateFormat.string(from: self)
    }
}
