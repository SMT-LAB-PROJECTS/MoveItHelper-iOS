//
//  DeleteInfoViewController.swift
//  MoveIt
//
//  Created by SMT LABS 1 on 14/07/22.
//  Copyright © 2022 Jyoti. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import FirebaseAnalytics

class DeleteInfoViewController: UIViewController {
    // MARK: - Outlet's...
    @IBOutlet weak var yesWantToPermanatlyLabel: UILabel!
    @IBOutlet weak var checkBoxUIButton: UIButton!

    // MARK: - Variable's...
    var isCheckBoxSelected = false
    
    // MARK: - View's life cycle method's...
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarConfiguration()
    }
    
    // MARK: - Required method's...
    func navigationBarConfiguration() {
         setNavigationTitle("My Profile")
         self.navigationItem.leftBarButtonItem = StaticHelper.leftBarButton(withImageNamed: "backward_arrow_icon", forVC: self)
     }
   
    func logoutClearData(){
        callAnalyticsEvent(eventName: "moveit_logout", desc: ["description":"\(profileInfo?.helper_id ?? 0) called logout function"])
        LocationUpdateGlobal.shared.stopUpdatingLocation()
        UserCache.shared.clearUserData()
        self.navigationController?.popToRootViewController(animated: false)
    }
    func callDedeleAccountAPI(){
        
        let httpheader: HTTPHeaders = ["Auth-Token": UserCache.userToken() ?? ""]
        StaticHelper.shared.startLoader(self.view)
        let user_id = "\(profileInfo?.helper_id ?? 0)"
        
        let parametersDict : Parameters = ["request_id": user_id, "reason":""] as [String : Any]
        
        AF.request(baseURL + kAPIMethods.account_deleted, method: .post, parameters: parametersDict, headers: httpheader).responseJSON { (response) in
            let windows = UIApplication.shared.windows
            StaticHelper.shared.stopLoader()
            switch response.result{
                
            case .success:
                if response.response?.statusCode == 200{
                    let obj = (response.value as! [String:Any])
                    if let flag = obj["status"] as? String{
                        if flag == "1"{
                            self.logoutClearData()
                        }else{
                            windows.last?.makeToast("\(obj["message"] ?? "")")
                        }
                        
                    }else if let flag = obj["status"] as? Int{
                        if flag == 1{
                            self.logoutClearData()
                        }else{
                            windows.last?.makeToast("\(obj["message"] ?? "")")
                        }
                    }else if let flag = obj["status"] as? Bool{
                        if flag{
                            self.logoutClearData()
                        }else{
                            windows.last?.makeToast("\(obj["message"] ?? "")")
                        }
                    }
                    print((response.value as! [String:Any]))
                }
            case .failure(let error):
                windows.last?.makeToast(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Required Action's...
    @objc func leftPressed(_ selector: Any){
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func cehckBoxAction(_ sender: UIButton) {
        if !isCheckBoxSelected{
            isCheckBoxSelected = true
            checkBoxUIButton.setImage(UIImage(named: "check_slct_icon"), for: .normal)
        }else{
            isCheckBoxSelected = false
            checkBoxUIButton.setImage(UIImage(named: "check_unslct_icon"), for: .normal)
        }
    }
    @IBAction func deleteMyAccountAction(_ sender: UIButton) {
        if !isCheckBoxSelected{
            self.view.makeToast("Please read the content carefully and select the checkbox first.")
        }else{
            // call api
            callDedeleAccountAPI()
        }
    }
}
