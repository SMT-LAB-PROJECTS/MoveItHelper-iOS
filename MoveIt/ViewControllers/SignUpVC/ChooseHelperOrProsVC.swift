//
//  ChooseHelperOrProsVC.swift
//  MoveIt
//
//  Created by Jyoti on 17/04/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class ChooseHelperOrProsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var chooseHelperTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setNavigationTitle("Choose Pro or Muscle")

        let leftBarButtonItem = StaticHelper.leftBarButtonWithImageNamed(imageName: "backward_arrow_icon", vc: self)
        self.navigationItem.leftBarButtonItems = [leftBarButtonItem]

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
    
    @objc func leftButtonPressed(_ selector: Any){
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func chooseHelperBackButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //# MARK:-UITableView Methods
    
   func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseHelper2Cell") as! ChooseHelper2Cell
            cell.helperImageView.image = UIImage(named: "move_it_pros")
            cell.moveItLabel.text = "Move It Pro"
            cell.pricingLabel.text = "Earn $45+/Hour"
            cell.luggageDescriptionLabel.text = " I have a pickup truck, cargo, box truck, or a vehicle with a trailer and can lift over 80 lbs"
            
            cell.moveItProHandler = {
                appDelegate.helperType = HelperType.Pro
                let signObj = self.storyboard?.instantiateViewController(withIdentifier: "SignUpStep1VC") as! SignUpStep1VC
                signObj.helperType = appDelegate.helperType
                self.navigationController?.pushViewController(signObj, animated: true)
            }
            
            cell.helperImageView2.image = UIImage(named: "muscle1")
            cell.moveItLabel2.text = "Move It Muscle"
            cell.pricingLabel2.text = "Earn $25+/Hour"
            cell.luggageDescriptionLabel2.text = "I don’t have a pickup truck but can lift over 80 lbs to assist Move It Pros or jobs that need only muscle"
            cell.moveItMuscleHandler = {
                appDelegate.helperType = HelperType.Muscle
                let signObj = self.storyboard?.instantiateViewController(withIdentifier: "SignUpStep1VC") as! SignUpStep1VC
                signObj.helperType = appDelegate.helperType
                self.navigationController?.pushViewController(signObj, animated: true)
            }
            return cell
        } else if(indexPath.row == 2){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseHelperCell") as! ChooseHelperCell
            cell.helperImageView.image = UIImage(named: "muscle")
            cell.helperImageView1.image = UIImage(named: "move_it_pros")
            cell.helperImageView2.image = UIImage(named: "muscle")
            
            cell.moveItLabel.text = "Move It Pro & Muscle"
            cell.pricingLabel.text = ""//"Earn $45+/Hour with 22+/Hour"
            cell.luggageDescriptionLabel.text = "I have a pickup truck, cargo van, box or trailer. I am available for all Pro & Muscle jobs and I can lift over 80 lbs"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CenterTextCell") as! CenterTextCell
            cell.nameLabel.text = "OR"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
         print("You tapped cell number \(indexPath.row).")
         if(indexPath.row == 0){
         }else{
             appDelegate.helperType = HelperType.ProMuscle
            let signObj = self.storyboard?.instantiateViewController(withIdentifier: "SignUpStep1VC") as! SignUpStep1VC
            signObj.helperType = appDelegate.helperType
            self.navigationController?.pushViewController(signObj, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(indexPath.row == 0){
            if (IS_IPHONE_X) || (IS_IPHONE_XSMax) {
                return ((290 / 568) * SCREEN_HEIGHT)-90
            } else{
                return ((290 / 568) * SCREEN_HEIGHT)
            }
        } else if(indexPath.row == 2){
            if (IS_IPHONE_X) || (IS_IPHONE_XSMax) {
                return ((290 / 568) * SCREEN_HEIGHT)-90
            } else{
                return ((290 / 568) * SCREEN_HEIGHT)
            }
        } else{
            return 50
        }
        
    }
}




