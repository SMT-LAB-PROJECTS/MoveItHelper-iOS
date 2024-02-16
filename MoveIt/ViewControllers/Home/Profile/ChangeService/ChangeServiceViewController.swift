//
//  ChangeServiceViewController.swift
//  MoveIt
//
//  Created by RV on 08/06/21.
//  Copyright © 2021 Jyoti. All rights reserved.
//

import UIKit
import Alamofire

class ChangeServiceViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, ChangeServiceActionDelegate {
    
    func selectedServiceActionDelegate(yes: Bool) {
        if (yes) {
            if self.jobstatus == false{
                self.view.makeToast(self.jobMessage)
            } else{
                if selectService == 2 { //When current service is Muscle
                    if profileInfo?.vehicleDetails?.is_vehicle_request == "pending" || profileInfo?.vehicleDetails?.is_vehicle_request == "Pending"{
                        self.presentAlert(withTitle: "", message: "\(profileInfo?.vehicleDetails?.message ?? "")")
                    }else{
                        let step2 = self.storyboard?.instantiateViewController(withIdentifier: "Step2ViewController") as! Step2ViewController
                        step2.selectedService = self.selectedService ?? -1
                        step2.isHideBackButton = false
                        self.navigationController?.pushViewController(step2, animated: true)
                    }
                }else{
                    self.changeServiceType(selectService: "\(selectedService ?? 3)")

                }
                
//                if self.selectService == 2{
//                    let step2 = self.storyboard?.instantiateViewController(withIdentifier: "Step2ViewController") as! Step2ViewController
//                    step2.selectedService = self.selectedService ?? -1
//                    self.navigationController?.pushViewController(step2, animated: true)
//                }else{
//                    self.changeServiceType(selectService: "\(selectedService ?? 3)")
//                }
            }
            
            
//            if self.selectedService == 2 {
//                self.changeServiceType(selectService: "2")
//            } else{
//                if self.jobstatus == false{
//                    self.view.makeToast(self.jobMessage)
//                } else{
//                    if self.selectService == 1 && self.selectedService == 3 {
//                        self.changeServiceType(selectService: "3")
//                    }else if self.selectService == 3 && self.selectedService == 1 {
//                        self.changeServiceType(selectService: "1")
//                    }else{
//                        if selectService == 2 {
//                            let step2 = self.storyboard?.instantiateViewController(withIdentifier: "Step2ViewController") as! Step2ViewController
//                            step2.selectedService = self.selectedService ?? -1
//                            self.navigationController?.pushViewController(step2, animated: true)
//                        } else {
//                            let uploadInformationViewController = self.storyboard?.instantiateViewController(withIdentifier: "UploadInformationViewController") as! UploadInformationViewController
//                            uploadInformationViewController.selectedService = self.selectedService
//                            self.navigationController?.pushViewController(uploadInformationViewController, animated: true)
//                        }
//
//                    }
//                }
//            }
        }
    }
    

    @IBOutlet weak var chooseHelperTableView: UITableView!
    
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var moveItLabel: UILabel!
    @IBOutlet weak var luggageDescriptionLabel: UILabel!
    @IBOutlet weak var lblEdit: PaddingLabel!
    @IBOutlet weak var ConstraintTopTable: NSLayoutConstraint!
    
    @IBOutlet weak var lblRejectResoan: UILabel!
    @IBOutlet weak var lblRejectTitle: UILabel!
    @IBOutlet weak var rejectServiceView: UIView!
    @IBOutlet weak var lblEditView: UIView!
    @IBOutlet weak var btnOk: UIButton!

    var selectService:NSInteger!
    var selectedService: Int?
    var jobstatus = false
    var jobMessage = ""
    var isComeFromNotification = false
    var messageRejections = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationTitle("Change Service")
        
        self.navigationItem.leftBarButtonItem = StaticHelper.leftBarButton(withImageNamed: "backward_arrow_icon", forVC: self)
        
        
        outerView.layer.cornerRadius = 10.0
        outerView.clipsToBounds = true
        moveItLabel.font = UIFont.josefinSansBoldFontWithSize(size: 13.0)
        luggageDescriptionLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 11.0)
        
        if selectService == 1 {
            self.moveItLabel.text = "Move It Pro"
            self.luggageDescriptionLabel.text = " I have a pickup truck, cargo, box truck, or a vehicle with a trailer and can lift over 80 lbs"
        } else if selectService == 2 {
            self.moveItLabel.text = "Move It Muscle"
            self.luggageDescriptionLabel.text = "I don’t have a pickup truck but can lift over 80 lbs to assist Move It Pros or jobs that need only muscle"
        } else if selectService == 3 {
            self.moveItLabel.text = "Move It Pro & Muscle"
            self.luggageDescriptionLabel.text = "I have a pickup truck, cargo van, box or trailer. I am available for all Pro & Muscle jobs and I can lift over 80 lbs"
        }
//        NotificationCenter.default.addObserver(self, selector: #selector(getChangeServiceRejectedDetails), name: NSNotification.Name(rawValue: "getChangeServiceRejectedDetails"), object: String())

        rejectServiceView.isHidden = true
        lblEditView.isHidden = true

        if selectService == 2 { //When current service is Muscle
            if profileInfo?.vehicleDetails?.is_vehicle_request == "pending"{
                showEditedRequestView()
            }else if profileInfo?.vehicleDetails?.is_vehicle_request == "reject"{
                rejectServiceChnageRequest(profileInfo?.vehicleDetails?.message ?? "")
            }else{

            }
        }
        
        if isComeFromNotification{
            rejectServiceChnageRequest(messageRejections)
            getChangeServiceRejectedDetails()
        }
    }
    func rejectServiceChnageRequest(_ textReject:String){

        lblEditView.isHidden = true
        rejectServiceView.isHidden = false

        lblRejectTitle.font = UIFont.josefinSansBoldFontWithSize(size: 12.0)
        lblRejectResoan.font = UIFont.josefinSansRegularFontWithSize(size: 11)
        lblRejectTitle.text = "Request Rejected"
        lblRejectResoan.text = textReject
        btnOk.setTitle("DISMISS", for: .normal)
        rejectServiceView.layer.borderWidth = 0.5
        rejectServiceView.layer.cornerRadius = 10
        rejectServiceView.layer.borderColor = UIColor.lightGray.cgColor
        rejectServiceView.layer.masksToBounds = true
        btnOk.layer.cornerRadius = 15.0
        btnOk.layer.masksToBounds = true
        lblRejectResoan.textColor = .black
        lblRejectResoan.setLineSpacing()
        self.navigationItem.rightBarButtonItem = nil

    }
    func showEditedRequestView() {
        rejectServiceView.isHidden = true
        lblEditView.isHidden = false
        lblEdit.font = UIFont.josefinSansBoldFontWithSize(size: 13.0)
        lblEdit.backgroundColor = UIColor.white
        lblEdit.layer.borderWidth = 0.5
        lblEdit.layer.cornerRadius = 10
        lblEdit.layer.borderColor = UIColor.white.cgColor
        lblEdit.layer.masksToBounds = true
                    
        let str1:String = ""//\nYour Change Service Request Is Pending.
        let str12:String = "\n"
        let str2:String = "\(profileInfo?.vehicleDetails?.message ?? "")\n"
        
        let attributedText = NSMutableAttributedString(string: str1, attributes: [NSAttributedString.Key.font: UIFont.josefinSansRegularFontWithSize(size: 13.0), NSAttributedString.Key.foregroundColor: UIColor.black])
        
        attributedText.append(NSAttributedString(string: str12, attributes: [NSAttributedString.Key.font: UIFont.josefinSansRegularFontWithSize(size: 6.0), NSAttributedString.Key.foregroundColor: UIColor.black]))
        
        let color2 = UIColor.init(_colorLiteralRed: 101/255.0, green: 113/255.0, blue: 142/255.0, alpha: 1.0)
        
        attributedText.append(NSAttributedString(string: str2, attributes: [NSAttributedString.Key.font: UIFont.josefinSansRegularFontWithSize(size: 12.0), NSAttributedString.Key.foregroundColor: color2]))
        
        lblEdit.numberOfLines = 0
        lblEdit.attributedText = attributedText
        lblEdit.textAlignment = .left
        self.navigationItem.rightBarButtonItem = nil

    }
    @objc func leftPressed(_ selector: Any){
        self.navigationController?.popViewController(animated: true)
    }
    func showPopup(){
        let toTimeVC = self.storyboard?.instantiateViewController(withIdentifier: "ChangeServiceAlert") as! ChangeServiceAlert
        toTimeVC.modalPresentationStyle = .overFullScreen
        if selectService == 1 {
                toTimeVC.message = "Your current service type is Move It Pro and you want to become Move It Pro & Muscle"
                self.selectedService = 3
        } else if selectService == 2 {
                toTimeVC.message = "Your current service type is Move It Muscle and you want to become Move It Pro & Muscle"
                self.selectedService = 3
        } else{
                toTimeVC.message = "Your current service type is Move It Pro & Muscle and you want to become Move It Muscle"
                self.selectedService = 2
        }
        
            toTimeVC.changeServiceDelegate = self
            self.present(toTimeVC, animated: true, completion: nil)
       
    }
    func getJobStatus() {
        let parameters : Parameters = ["service_type": selectedService ?? 3]
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
        StaticHelper.shared.startLoader(self.view)
        AF.request(baseURL + kAPIMethods.get_helper_job_status,method: .post ,parameters: parameters,headers: header).responseJSON { (response) in
            DispatchQueue.main.async {
            switch response.result {
            case .success:
                StaticHelper.shared.stopLoader()
                print(response.response?.statusCode ?? 0)
                if response.response?.statusCode == 200{
                    let res = response.value as! [String: Any]
                    print(res["message"] ?? "")
                    if let message = res["message"] as? Bool {
                        self.jobstatus = message
                        self.jobMessage = res["text_message"] as? String ?? ""
                        if message == false {
                            self.view.makeToast(self.jobMessage)
                        } else{
                            self.showPopup()
                        }
                    }
                } else if response.response?.statusCode == 204{
                }
            case .failure( _):
                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 401{
                } else{
                    //self.view.makeToast(error.localizedDescription)
                }
            }
            }
        }
    }
    
    
    func changeServiceType(selectService: String) {
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
        let parameters : Parameters =  ["vehicle_type_id": "","vehicle_year": "","plate_num": "","company_name": "","service_type": selectService,"model":"","vehicle_image_url":""]
        
        AF.request(baseURL + kAPIMethods.update_helper_service_type, method: .post, parameters: parameters,headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
            switch response.result {
            case .success:
                StaticHelper.shared.stopLoader()
                print(response.response?.statusCode ?? 0)
                if response.response?.statusCode == 200{
                    let resposneDict = response.value as! [String: Any]
                    if !resposneDict.isEmpty{
                        UserCache.shared.updateUserProperty(forKey: kUserCache.service_type , withValue: self.selectedService as AnyObject )
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getProfileInfo"), object: nil)
                        self.dismiss(animated: true, completion: nil)
                        UIApplication.shared.keyWindow?.rootViewController?.view.makeToast("Service Type change successfully.")
                        self.navigationController?.popViewController(animated: true)
                    }
                } else if response.response?.statusCode == 204{
                }
            case .failure( _):
                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 401{
                } else{
                    //self.view.makeToast(error.localizedDescription)
                }
            }
            }
        }
    }
     
    func getChangeServiceRejectedDetails(){
         CommonAPIHelper.getProfile(VC: self) { (res, err, isExecuted) in
             if isExecuted{
                 DispatchQueue.main.async {
                     profileInfo =  HelperDetailsModel.init(profileDict: res!)
                     self.rejectServiceChnageRequest(profileInfo?.vehicleDetails?.message ?? "")

                 }
             }
         }
     }
    
    @objc func getProfileInfo(){
         
         CommonAPIHelper.getProfile(true, VC: self) { (res, err, isExecuted) in
             if isExecuted{
                 DispatchQueue.main.async {
                     self.rejectServiceView.isHidden = true
                     profileInfo =  HelperDetailsModel.init(profileDict: res!)
                 }
             }
         }
     }
    @IBAction func okRejectAction(_ sender: UIButton) {
        getProfileInfo()
        //self.navigationController?.popViewController(animated: true)

    }
    
    //# MARK:-UITableView Methods
    
   func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectService == 1 {
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectService == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseHelperCell") as! ChooseHelperCell
            if indexPath.row == 0 {
                cell.helperImageView.image = UIImage(named: "muscle1")
                cell.helperImageView.isHidden = false
                cell.helperImageView1.isHidden = true
                cell.helperImageView2.isHidden = true
                cell.moveItLabel.text = "Move It Muscle"
                cell.pricingLabel.text = ""//"Earn $25+/Hour"
                cell.luggageDescriptionLabel.text = "I don’t have a pickup truck but can lift over 80 lbs to assist Move It Pros or jobs that need only muscle"
            } else{
                cell.helperImageView.isHidden = true
                cell.helperImageView1.isHidden = false
                cell.helperImageView2.isHidden = false
                cell.helperImageView1.image = UIImage(named: "move_it_pros")
                cell.helperImageView2.image = UIImage(named: "muscle")
                cell.moveItLabel.text = "Move It Pro & Muscle"
                cell.pricingLabel.text = ""//"Earn $45+/Hour with 22+/Hour"
                cell.luggageDescriptionLabel.text = "I have a pickup truck, cargo van, box or trailer. I am available for all Pro & Muscle jobs and I can lift over 80 lbs"
            }
            return cell
        } else if selectService == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseHelperCell") as! ChooseHelperCell
//            if indexPath.row == 0 {
//                cell.helperImageView.image = UIImage(named: "move_it_pros")
//                cell.helperImageView.isHidden = false
//                cell.helperImageView1.isHidden = true
//                cell.helperImageView2.isHidden = true
//                cell.moveItLabel.text = "Move It Pro"
//                cell.pricingLabel.text = ""//"Earn $45+/Hour"
//                cell.luggageDescriptionLabel.text = " I have a pickup truck, cargo, box truck, or a vehicle with a trailer and can lift over 80 lbs"
//            } else{
                cell.helperImageView.isHidden = true
                cell.helperImageView1.isHidden = false
                cell.helperImageView2.isHidden = false
                cell.helperImageView1.image = UIImage(named: "move_it_pros")
                cell.helperImageView2.image = UIImage(named: "muscle")
                cell.moveItLabel.text = "Move It Pro & Muscle"
                cell.pricingLabel.text = ""//"Earn $45+/Hour with 22+/Hour"
                cell.luggageDescriptionLabel.text = "I have a pickup truck, cargo van, box or trailer. I am available for all Pro & Muscle jobs and I can lift over 80 lbs"
//            }
            return cell
        } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseHelperCell") as! ChooseHelperCell
//            if indexPath.row == 0 {
//                cell.helperImageView.image = UIImage(named: "move_it_pros")
//                cell.helperImageView.isHidden = false
//                cell.helperImageView1.isHidden = true
//                cell.helperImageView2.isHidden = true
//                cell.moveItLabel.text = "Move It Pro"
//                cell.pricingLabel.text = ""//"Earn $45+/Hour"
//                cell.luggageDescriptionLabel.text = " I have a pickup truck, cargo, box truck, or a vehicle with a trailer and can lift over 80 lbs"
//            } else{
                cell.helperImageView.image = UIImage(named: "muscle1")
                cell.helperImageView.isHidden = false
                cell.helperImageView1.isHidden = true
                cell.helperImageView2.isHidden = true
                cell.moveItLabel.text = "Move It Muscle"
                cell.pricingLabel.text = ""//"Earn $25+/Hour"
                cell.luggageDescriptionLabel.text = "I don’t have a pickup truck but can lift over 80 lbs to assist Move It Pros or jobs that need only muscle"
//            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
         print("You tapped cell number \(indexPath.row).")
        getJobStatus()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return (270 / 568) * SCREEN_HEIGHT
    }
}
@IBDesignable class PaddingLabel:UILabel {

    @IBInspectable var topInset: CGFloat = 0.0
    @IBInspectable var bottomInset: CGFloat = 0.0
    @IBInspectable var leftInset: CGFloat = 0.0
    @IBInspectable var rightInset: CGFloat = 0.0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }

    override var bounds: CGRect {
        didSet {
            // ensures this works within stack views if multi-line
            preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
        }
    }
}

