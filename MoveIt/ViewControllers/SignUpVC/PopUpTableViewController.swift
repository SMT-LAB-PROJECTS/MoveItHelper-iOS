//
//  PopUpTableViewController.swift
//  MoveIt
//
//  Created by Dushyant on 24/05/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit


protocol PopUpDelegate {
    func selectedItems(_ index: Int)
}

class PopUpTableViewController: UIViewController {

    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    var selectedIndex : Int!
    var dataSourceArray = [String]()
    var popUpDelegate: PopUpDelegate?
    
    var selectedItemIndex : Int?
    
    var popUpTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         titleLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
         cancelButton.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 13.0)
         doneButton.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 13.0)
         titleLabel.text = popUpTitle
        cancelButton.layer.borderWidth = 1.0
        cancelButton.layer.borderColor = violetColor.cgColor
        
        if selectedIndex == nil{
           //  doneButton.isEnabled = false
        }
        else{
           //  doneButton.isEnabled = true
            selectedItemIndex = selectedIndex
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneAction(_ sender: Any) {
        if selectedItemIndex == nil{
            self.view.makeToast("Please select an option from the list.")
            return
        }
        popUpDelegate?.selectedItems(selectedItemIndex!)
        self.dismiss(animated: true, completion: nil)
    }
}
extension PopUpTableViewController: UITableViewDelegate,UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let popUpCell = tableView.dequeueReusableCell(withIdentifier: "PopUpTableViewCell", for: indexPath) as! PopUpTableViewCell
        popUpCell.itemLabel.text = dataSourceArray[indexPath.row]
        
        if selectedIndex == indexPath.row{
            popUpCell.checkImgView.image = UIImage.init(named: "radio_slct_btn")
        }
        else{
             popUpCell.checkImgView.image = UIImage.init(named: "radio_unslct_btn")
        }
        
        return popUpCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30.0 * screenHeightFactor
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedItemIndex = indexPath.row
        selectedIndex = indexPath.row
      //  doneButton.isEnabled = true
        self.tableView.reloadData()

    }
    
}
