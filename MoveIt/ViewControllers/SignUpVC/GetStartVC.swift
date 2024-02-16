//
//  GetStartVC.swift
//  MoveIt
//
//  Created by Jyoti on 12/04/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit
import Alamofire
import GooglePlaces

class GetStartVC: UIViewController {
    
    @IBOutlet weak var backgroundImageview: UIImageView!
   
    @IBOutlet weak var onDemandLabel: UILabel!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var signUpButtonOutlet: UIButton!
    
    @IBOutlet weak var goCustomerAppButtonOutlet: UIButton!
    @IBOutlet weak var moveItProLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDefaultValueCancelationFee()
        self.setUpUIData()
    }
    
    func setUpUIData(){
      
        
        self.navigationController?.isNavigationBarHidden = true
        onDemandLabel.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        
        loginButtonOutlet.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        moveItProLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 17.0)
        signUpButtonOutlet.layer.cornerRadius = 20 * (UIScreen.main.bounds.height/568.0)
        signUpButtonOutlet.layer.borderColor = UIColor(red: 246/255, green: 175/255, blue: 181/255, alpha: 1).cgColor
        signUpButtonOutlet.layer.borderWidth = 1.0;
        signUpButtonOutlet.clipsToBounds = true;
        signUpButtonOutlet.titleLabel?.font = UIFont .josefinSansSemiBoldFontWithSize(size: 14.0)
       
        goCustomerAppButtonOutlet.titleLabel?.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
    }
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        let loginObj = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(loginObj, animated: true)
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
       
        if let navController: UINavigationController = appDelegate.window!.rootViewController as? UINavigationController{
            
            if #available(iOS 13.0, *) {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                navController.navigationBar.standardAppearance = appearance;
                navController.navigationBar.scrollEdgeAppearance = appearance //navController.navigationBar.standardAppearance
            } else {
                // Fallback on earlier versions
            }
            let chooseHelperObj = self.storyboard?.instantiateViewController(withIdentifier: "ChooseHelperOrProsVC") as! ChooseHelperOrProsVC
            self.navigationController?.pushViewController(chooseHelperObj, animated: true)
        }
        
    }
    @IBAction func cancelAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func gocustomerappButtonPressed(_ sender: Any) {
        if let url = URL(string: "itms-apps://apple.com/app/id1487797537") {
            UIApplication.shared.open(url)
        }
    }
}

extension GetStartVC{
    func getDefaultValueCancelationFee() {
            let header : HTTPHeaders = ["Auth-Token":""]
            AF.request(baseURL + kAPIMethods.get_default_value, method: .get, headers: header).responseJSON { (response) in
                switch response.result {
                case .success:
                    //StaticHelper.shared.stopLoader()
                    if response.response?.statusCode == 200{
                        let res = response.value as! [String: Any]
                        print(response)
                        print("getDefaultValueCancelationFee Response res \(res)")
                      
                        if let text = res["WEB_VIEW_DOMAIN"]{
                            appDelegate.baseContentURL = "\(text)"
                        }
                        if let text = res["GOOGLE_MAP_API_KEY"]{
                            appDelegate.googleMapAPIKey = "\(text)"
                        }
                        GMSPlacesClient.provideAPIKey("\(appDelegate.googleMapAPIKey)")

                    }
                    else if response.response?.statusCode == 401{
                    }
                case .failure(let error):
                    //StaticHelper.shared.stopLoader()
                    print("getDefaultValueCancelationFee error :-  \(error)")
                }
            }
    }
}
