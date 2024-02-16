//
//  MapViewViewController.swift
//  MoveIt
//
//  Created by Dushyant on 21/06/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit
import MapKit

class MapViewViewController: UIViewController, CLLocationManagerDelegate, MoveArrivalTimeDelegate, ChooseServiceAlertDelegate {
    
    var moveInfo : MoveDetailsModel?
    var A1: String = ""
    var A2: String = ""
    
    var acceptMoveId = 0
    var isConnectingToAnotherHelper = false
    var alertView :AlertPopupView?

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet var customMapView: UIView!
    
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var serviceType: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var fromAddressLabel: UILabel!
    @IBOutlet weak var toAddressLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var cancelledButtton: UIButton!
    @IBOutlet weak var dotLineImgView: UIImageView!
    @IBOutlet weak var dropUpImgView: UIImageView!

    var moveDictArray = [[String: Any]](){
        
        didSet{
            mapView.removeAnnotations(mapView.annotations)
            self.setLocationMark()
        }
    }
    var pageIndex = 1
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllAvailableMoves()
        setupUI()
        self.navigationController?.isNavigationBarHidden = true
        determineMyCurrentLocation()
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways){
            currentLocation = locManager.location
        }

    }
    
    func setupUI(){
        mapView.showsUserLocation = true
        userNameLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        serviceType.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        costLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        distanceLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        fromLabel.font = UIFont.josefinSansRegularFontWithSize(size: 8.0)
        toLabel.font = UIFont.josefinSansRegularFontWithSize(size: 8.0)
        fromAddressLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 11.0)
        toAddressLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 11.0)
        dateTimeLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
        acceptButton.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        acceptButton.layer.cornerRadius = 15 * screenHeightFactor
    }
    func hideDropUpAddressThings(view: CustomMoveMapView, _ isHide:Bool = false){
        view.dotedImgView.isHidden = isHide
        view.toImgView.isHidden = isHide
        view.toLabel.isHidden = isHide
        view.toAddressLabel.isHidden = isHide
        view.fromLabel.text = "From"
        view.fromAddressLabel.numberOfLines = 1
        if isHide{
            view.fromLabel.text = "Pickup Address"
            view.fromAddressLabel.numberOfLines = 1
        }
    }
    func determineMyCurrentLocation() {
        locManager = CLLocationManager()
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locManager.requestAlwaysAuthorization()
        locManager.distanceFilter = 100
        //        manager.activityType = .other
        //        manager.desiredAccuracy = 45
        
        if CLLocationManager.locationServicesEnabled() {
            locManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    func getAllAvailableMoves(){
        CommonAPIHelper.getAllAvailableMoves(VC: self, page_index: pageIndex, completetionBlock: { (result, countDic, error, isexecuted)  in
            
            if error != nil{
                
                return
            }
            else{
                self.moveDictArray = result!
            }
        })
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.gotoBackVC()
    }
    
    func gotoBackVC() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.popViewController(animated: true)
        //self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func accpetMoveAction(_ sender: Any) {
        if(profileInfo?.is_new == 1) {
            if(profileInfo?.w9_form_status == 0 || profileInfo?.w9_form_verified == 0) {
                self.gotoBackVC()
                return
            }
        }
        
        let itemDict = moveDictArray[(sender as! UIButton).tag]
        moveInfo = MoveDetailsModel.init(moveDictFromList: itemDict)
        self.acceptMove((itemDict["request_id"] as! Int))
    }
    
    func showInsuranceExpiredMessage(_ message:String = "", _ titleMessage:String = "", _ isPendingRequestFlag:Bool = false, _ isRequestRejectedFlag:Bool = false) {

//            let viVC = self.storyboard?.instantiateViewController(withIdentifier: "InsuranceExpiredVC") as! InsuranceExpiredVC
//            viVC.message = message
//            viVC.titleMessage = titleMessage
//            viVC.isPendingRequest = isPendingRequestFlag
//            viVC.isRequestRejected = isRequestRejectedFlag
//            self.navigationController?.isNavigationBarHidden = true
//            self.navigationController?.pushViewController(viVC, animated: true)
        
            let viVC = self.storyboard?.instantiateViewController(withIdentifier: "EditVehicleInfoViewController") as! EditVehicleInfoViewController
            viVC.isComeFromServiceStoped = true
            self.navigationController?.pushViewController(viVC, animated: true)
    }
    
    func hideInsuranceExpiredMessage() {
        if let viewController =  StaticHelper.mainWindow().rootViewController?.topMostViewController(), viewController is InsuranceExpiredVC {
            if viewController is InsuranceExpiredVC{
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: HomeViewController.self) {
                        _ =  self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            }
        }
    }
    @IBAction func cancelMoveAction(_ sender: Any) {
        
    }
    
    @objc func accpetMovePressed(_ sender: Any) {
        let itemDict = moveDictArray[(sender as! UIButton).tag]
        moveInfo = MoveDetailsModel.init(moveDictFromList: itemDict)
        if checkCombineJobStatus((moveInfo?.request_id)!){
        }else{
          showPopupInsurance((moveInfo?.request_id)!)
        }
        
        
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locManager.stopUpdatingLocation()
        let mUserLocation:CLLocation = locations[0] as CLLocation
        let center = CLLocationCoordinate2D(latitude: mUserLocation.coordinate.latitude, longitude: mUserLocation.coordinate.longitude)
        let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(mRegion, animated: true)
    }
    
    //MARK: - Accept Logic
    
    @objc func acceptPressed(_ selector: UIButton){
        let itemDict = moveDictArray[selector.tag]
        moveInfo = MoveDetailsModel.init(moveDictFromList: itemDict)
        self.acceptMove((itemDict["request_id"] as! Int))
    }
    
    func acceptMove(_ requestID: Int ){
        
        let Iam = UserCache.shared.userInfo(forKey: kUserCache.service_type) as! Int
        
        if (moveInfo!.helping_service_required_pros! + moveInfo!.helping_service_required_muscle!) >= 2
        {
            //JOB NOT ACCEPTED By ANY HELPER
            if moveInfo!.meeting_slot!.isEmpty {
                
                if(Iam == HelperType.Pro) {
                    if moveInfo!.helping_service_required_pros! == 0 {
                        //Pro can not accept muscle job
                    } else if moveInfo!.helping_service_required_muscle! == 0 {
                        self.showArrivalTimeView(requestID, HelperType.Pro)
                    } else if moveInfo!.helping_service_required_pros! >= 1, moveInfo!.helping_service_required_muscle! >= 1 {
                        self.showArrivalTimeView(requestID, HelperType.Pro)
                    }
                } else if(Iam == HelperType.Muscle) {
                    if moveInfo!.helping_service_required_pros! == 0 {
                        self.showArrivalTimeView(requestID, HelperType.Muscle)
                    } else if moveInfo!.helping_service_required_muscle! == 0 {
                        //Muscle can not accept pro job
                    } else if moveInfo!.helping_service_required_pros! >= 1, moveInfo!.helping_service_required_muscle! >= 1 {
                        self.callAcceptMoveAPI(requestID, HelperType.Muscle)
                    }
                } else if(Iam == HelperType.ProMuscle) {
                    if moveInfo!.helping_service_required_pros! == 0 {
                        self.showArrivalTimeView(requestID, HelperType.Muscle)
                    } else if moveInfo!.helping_service_required_muscle! == 0 {
                        self.showArrivalTimeView(requestID, HelperType.Pro)
                    } else if moveInfo!.helping_service_required_pros! >= 1, moveInfo!.helping_service_required_muscle! >= 1 {
                        self.askServiceType(requestID)
                    }
                }
            }
            //JOB ACCEPTED By OTHER HELPER
            else {
                //Need to show by default selected time slot
                if(Iam == HelperType.Pro) {
                    if moveInfo!.helping_service_required_pros! == 0 {
                        //Pro can not accept muscle job
                    } else if moveInfo!.helping_service_required_muscle! == 0 {
                        self.showArrivalTimeView(requestID, HelperType.Pro)
                    } else if moveInfo!.helping_service_required_pros! >= 1, moveInfo!.helping_service_required_muscle! >= 1 {
                        self.showArrivalTimeView(requestID, HelperType.Pro)
                    }
                } else if(Iam == HelperType.Muscle) {
                    if moveInfo!.helping_service_required_pros! == 0 {
                        self.showArrivalTimeView(requestID, HelperType.Muscle)
                    } else if moveInfo!.helping_service_required_muscle! == 0 {
                        //Muscle can not accept pro job
                    } else if moveInfo!.helping_service_required_pros! >= 1, moveInfo!.helping_service_required_muscle! >= 1 {
                        self.callAcceptMoveAPI(requestID, HelperType.Muscle)
                    }
                } else if(Iam == HelperType.ProMuscle) {
                    if moveInfo!.helping_service_required_pros! == 0 {
                        self.showArrivalTimeView(requestID, HelperType.Muscle)
                    } else if moveInfo!.helping_service_required_muscle! == 0 {
                        self.showArrivalTimeView(requestID, HelperType.Pro)
                    } else if moveInfo!.helping_service_required_pros! >= 1, moveInfo!.helping_service_required_muscle! >= 1 {
                        self.askServiceType(requestID)
                    }
                }
            }
        }
        //SINGLE JOB TO ACCEPT
        else {
            if(Iam == HelperType.Pro) {
                self.showArrivalTimeView(requestID, HelperType.Pro)
            } else if(Iam == HelperType.Muscle) {
                self.showArrivalTimeView(requestID, HelperType.Muscle)
            } else if(Iam == HelperType.ProMuscle) {
                if moveInfo!.helping_service_required_pros! == 0 {
                    self.showArrivalTimeView(requestID, HelperType.Muscle)
                } else if moveInfo!.helping_service_required_muscle! == 0 {
                    self.showArrivalTimeView(requestID, HelperType.Pro)
                }
            }
        }
    }
    
    func checkCombineJobStatus(_ requestID: Int )->Bool{
        let Iam = UserCache.shared.userInfo(forKey: kUserCache.service_type) as! Int
        
        if (moveInfo!.helping_service_required_pros! + moveInfo!.helping_service_required_muscle!) >= 2
        {
            if moveInfo!.meeting_slot!.isEmpty {//JOB NOT ACCEPTED By ANY HELPER
                if(Iam == HelperType.ProMuscle) {
                    if moveInfo!.helping_service_required_pros! >= 1, moveInfo!.helping_service_required_muscle! >= 1 {
                        self.askServiceType(requestID)
                        return true
                    }
                }
            }else {//JOB ACCEPTED By OTHER HELPER
                //Need to show by default selected time slotif(Iam == HelperType.ProMuscle) {
                if moveInfo!.helping_service_required_pros! >= 1, moveInfo!.helping_service_required_muscle! >= 1 {
                    self.askServiceType(requestID)
                    return true
                }
            }
        }else if moveInfo!.helping_service_required_muscle! >= 1{
            if moveInfo?.is_estimate_hour == 1{
                self.acceptMoveId = (moveInfo?.request_id)!
                self.showAlertPopupView(AlertButtonTitle.alert, "\(self.moveInfo?.estimate_hour_confirmation_message! ?? "")", AlertButtonTitle.no, AlertButtonTitle.yes)
            }else{
                self.acceptMove((moveInfo?.request_id)!)
            }
            return true
        }
        return false
    }
    func showPopupInsurance(_ requestID: Int ){
        if(profileInfo!.vehicleDetails!.insurance_expired == "1") && (profileInfo!.vehicleDetails!.is_insurance_request == "0") {
            InsuranceExpiryView.instance.shwoDataWithClosures(profileInfo!.vehicleDetails!.insurance_message_title!, profileInfo!.vehicleDetails!.insurance_message!, "", "", "Update Info"){ status in
                if status{
                    print("Okay")
                    self.showInsuranceExpiredMessage(profileInfo!.vehicleDetails!.insurance_message!, profileInfo!.vehicleDetails!.insurance_message_title!)
                }else{
                    print("NO/Cancel")
                }
            }
        }else if(profileInfo!.vehicleDetails!.is_vehicle_insurance_request == "pending") && (profileInfo!.vehicleDetails!.is_insurance_request == "1"){
            InsuranceExpiryView.instance.shwoDataWithClosures(profileInfo!.vehicleDetails!.insurance_message_title!, profileInfo!.vehicleDetails!.insurance_message!, "", "", AlertButtonTitle.ok){ status in
                if status{
                }else{
                }
            }
        }else if(profileInfo!.vehicleDetails!.is_vehicle_insurance_request == "reject") && (profileInfo!.vehicleDetails!.is_insurance_request == "1") {
            InsuranceExpiryView.instance.shwoDataWithClosures(profileInfo!.vehicleDetails!.insurance_message_title!, profileInfo!.vehicleDetails!.insurance_message!, "", "", "Re-update Info"){ status in
                if status{
                    print("Okay")
                        self.showInsuranceExpiredMessage(profileInfo!.vehicleDetails!.insurance_message!, profileInfo!.vehicleDetails!.insurance_message_title!, false, true)
                }else{
                    print("NO/Cancel")
                }
            }
        }else{
            if moveInfo?.is_estimate_hour == 1{
                self.acceptMoveId = (moveInfo?.request_id)!
                self.showAlertPopupView(AlertButtonTitle.alert, "\(self.moveInfo?.estimate_hour_confirmation_message! ?? "")", AlertButtonTitle.no, AlertButtonTitle.yes)
            }else{
                self.acceptMove((moveInfo?.request_id)!)
            }
        }
    }
    func callAcceptMoveAPI(_ requestID:Int, _ helperType: Int)
    {
        CommonAPIHelper.acceptMoves(VC: self, request_id: requestID, helperType: helperType, completetionBlock: { (result, error, statusCode) in
            if error != nil{
                return
            } else {
                if(statusCode == 201) {
                    self.isConnectingToAnotherHelper = true
                    self.showAlertPopupView(AlertButtonTitle.alert, kStringPermission.connectingToAnotherHelper, "", "", AlertButtonTitle.ok)
//                    let alert = UIAlertController.init(title: "", message: "We are connecting another helper to accept this move. We'll notify you once this job is confirmed.", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: {_ in
//                        appDelegate.homeVC?.redirectToScheduledTab(section: 1)
//                    }))
//                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    appDelegate.homeVC?.redirectToScheduledTab(section: 0)
                }
            }
        })
    }
    
    func showArrivalTimeView(_ requestID:Int, _ helperType:Int)
    {
        let slotVC = self.storyboard?.instantiateViewController(withIdentifier: "MoveArrivalTimeViewController") as! MoveArrivalTimeViewController
        slotVC.modalPresentationStyle = .overFullScreen
        slotVC.moveInfo = moveInfo
        slotVC.startTime = moveInfo!.pickup_start_time!
        slotVC.endTime = moveInfo!.pickup_end_time!
        slotVC.moveRequestID = requestID
        slotVC.selectedHelperType = helperType
        slotVC.delegate = self
        self.navigationController?.present(slotVC, animated: true, completion: nil)
    }
    
    @objc func timeSlotFinalizeFor(_ requestID: Int, _ helperType: Int) {
        self.callAcceptMoveAPI(requestID, helperType)
    }
    
    @objc func dismissOnlyFromSlot(){
    }
    
    //MARK: - Service Type Logic
    func askServiceType(_ requestID:Int) {
        
        let serviceVC = self.storyboard?.instantiateViewController(withIdentifier: "ChooseServiceAlert") as! ChooseServiceAlert
        serviceVC.modalPresentationStyle = .overFullScreen
        serviceVC.requestID = requestID
        serviceVC.delegate = self
        serviceVC.otherHelperServiceType = moveInfo?.other_helper_service_type ?? 0
        serviceVC.totalProsAmount = moveInfo?.total_pros_amount ?? 0.0
        serviceVC.totalMuscleAmount = moveInfo?.total_muscle_amount ?? 0.0       
        self.present(serviceVC, animated: true, completion: nil)
    }
    
    @objc func serviceTypeSelected(_ requestID: Int,_ isProSelect: Bool)
    {
        if(isProSelect == true) {
            if(profileInfo!.vehicleDetails!.insurance_expired == "1") && (profileInfo!.vehicleDetails!.is_insurance_request == "0") {
                InsuranceExpiryView.instance.shwoDataWithClosures(profileInfo!.vehicleDetails!.insurance_message_title!, profileInfo!.vehicleDetails!.insurance_message!, "", "", "Update Info"){ status in
                    if status{
                        print("Okay")
                        self.showInsuranceExpiredMessage(profileInfo!.vehicleDetails!.insurance_message!, profileInfo!.vehicleDetails!.insurance_message_title!)
                    }else{
                        print("NO/Cancel")
                    }
                }
            }else if(profileInfo!.vehicleDetails!.is_vehicle_insurance_request == "pending") && (profileInfo!.vehicleDetails!.is_insurance_request == "1"){
                InsuranceExpiryView.instance.shwoDataWithClosures(profileInfo!.vehicleDetails!.insurance_message_title!, profileInfo!.vehicleDetails!.insurance_message!, "", "", AlertButtonTitle.ok){ status in
                    if status{
                    }else{
                    }
                }
            }else if(profileInfo!.vehicleDetails!.is_vehicle_insurance_request == "reject") && (profileInfo!.vehicleDetails!.is_insurance_request == "1") {
                InsuranceExpiryView.instance.shwoDataWithClosures(profileInfo!.vehicleDetails!.insurance_message_title!, profileInfo!.vehicleDetails!.insurance_message!, "", "", "Re-update Info"){ status in
                    if status{
                        print("Okay")
                            self.showInsuranceExpiredMessage(profileInfo!.vehicleDetails!.insurance_message!, profileInfo!.vehicleDetails!.insurance_message_title!, false, true)
                    }else{
                        print("NO/Cancel")
                    }
                }
            }else{
                self.showArrivalTimeView(requestID, HelperType.Pro)
            }
        } else {
            self.callAcceptMoveAPI(requestID, HelperType.Muscle)
        }
    }
    
    @objc func dismissOnlyFromChooseService(){
    }
}

extension MapViewViewController: MKMapViewDelegate{
    func setLocationMark(){
        
        
        var annotationView = [MKPointAnnotation]()
        var i =  0
        
        for dict in moveDictArray{
            
//             hideDropUpAddressThings()
//             if(dict["is_dropoff_address"] as? Int) == 0 {
//                 hideDropUpAddressThings(true)
//             }
            let sourceLocation = CLLocationCoordinate2D(latitude: (dict["pickup_lat"] as! Double), longitude: (dict["pickup_long"] as! Double))
            let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
            //  let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
            let sourceAnnotation = CustomPointAnnotation()
            // sourceAnnotation.title = "pickup Address"
            sourceAnnotation.tag = i
            if let location = sourcePlacemark.location {
                sourceAnnotation.coordinate = location.coordinate
            }
            
            annotationView.append(sourceAnnotation)
            i = i + 1
        }
        
        self.mapView.showAnnotations(annotationView, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        let annotationIdentifier = "AnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }
        
        
        let pinImage = UIImage(named: "move_map_pointer")
        annotationView!.image = pinImage
        annotationView?.tag = (annotation as! CustomPointAnnotation).tag
        //        let customeView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
        //        customeView.backgroundColor = UIColor.red
        //        annotationView!.rightCalloutAccessoryView = customeView
        configureDetailView(annotationView: annotationView!)
        return annotationView
    }
    
    func configureDetailView(annotationView: MKAnnotationView) {
        let moveInfo: [String: Any] =  moveDictArray[annotationView.tag]
     
        var heightOfAnotationView: CGFloat = 190.0
        if(moveInfo["is_dropoff_address"] as? Int) == 0 {
            heightOfAnotationView = 190.0
        }
        let width = 285 * screenWidthFactor
        let height = heightOfAnotationView * screenHeightFactor
        
        let snapshotView = UIView()
        let customMapView = CustomMoveMapView.getCustomMapView()
        
        
//        let views = ["snapshotView": customMapView]
//        customMapView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[snapshotView(\(width))]", options: [], metrics: nil, views: views as [String : Any]))
//        customMapView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[snapshotView(\(height))]", options: [], metrics: nil, views: views as [String : Any]))
////        customMapView.frame.size.height = heightOfAnotationView * screenHeightFactor
////        customMapView.frame.size.width = 285 * screenWidthFactor
//        snapshotView.addSubview(customMapView)
        
        
        let tapgesture = UITapGestureRecognizer.init(target: self, action: #selector(calloutTapped(_:)))
        customMapView.tag = annotationView.tag
        customMapView.addGestureRecognizer(tapgesture)
        customMapView.setupUI()
        self.setupInfo(moveDictArray[annotationView.tag],view: customMapView)
        annotationView.detailCalloutAccessoryView = customMapView
    }
    
    func setupInfo(_ moveInfo: [String: Any], view: CustomMoveMapView){
       
        view.moveType.text = (moveInfo["move_type_name"] as! String)
        view.userNameLabel.text = (moveInfo["customer_name"] as! String)
        let urlString = moveInfo["photo_url"] as! String
        let uRL = URL.init(string: urlString)
        if uRL != nil{
            view.userImgView.af.setImage(withURL: uRL!)
        }else{
            view.userImgView.image = UIImage(named: "User_placeholder")
        }
        view.acceptButton.tag = view.tag
        view.fromAddressLabel.text = (moveInfo["pickup_address"] as! String)
        view.toAddressLabel.text = (moveInfo["dropoff_address"] as! String)
        
        let strServiceType:String = (moveInfo["dropoff_service_name"] as! String) + "\n" + (moveInfo["helping_service_name"] as! String)
        view.serviceType.text = strServiceType//(moveInfo["dropoff_service_name"] as! String)
        
        view.dateTimeLabel.text = (moveInfo["pickup_date"] as! String) + "\n" + (moveInfo["pickup_start_time"] as! String) + " - " + (moveInfo["pickup_end_time"] as! String)
        view.acceptButton.addTarget(self, action: #selector(accpetMovePressed(_:)), for: .touchUpInside)
        
        let miles = (moveInfo["total_miles_distance"] as! Double)
        distanceLabel.text = String.init(format: "%0.2f", miles) + " Miles"
        view.distanceLabel.text = String.init(format: "%0.2f", miles) + " Miles"
        
        //        if let amount = (moveInfo["total_amount"] as? Double) {
        //            view.costLabel.text = "$" + String.init(format: "%0.2f", amount)
        //        }
        print(moveInfo)
        hideDropUpAddressThings(view:view)
        if(moveInfo["is_dropoff_address"] as? Int) == 0 {
            hideDropUpAddressThings(view:view, true)
        }
        let userDefault = UserDefaults.standard
        let helper_service_type:Int = userDefault.value(forKey: kUserCache.service_type) as! Int
        
        let helping_service_required_muscle = (moveInfo["helping_service_required_muscle"] as! Int)
        let helping_service_required_pros = (moveInfo["helping_service_required_pros"] as! Int)
        
        if (helper_service_type == HelperType.Pro) {//Pro
            if let total_amount = (moveInfo["total_amount"] as? Double) {
                view.costLabel.text = "Pro " + "$" + String.init(format: "%0.2f", total_amount)
            }
            
            if(helping_service_required_pros > 0 && helping_service_required_muscle > 0) {
                if let amount = (moveInfo["total_pros_amount"] as? Double){
//                    acceptTypeLabel.text = "Pro"
                    if (moveInfo["is_estimate_hour"] as? Int) == 0 {
                        view.costLabel.text = "Pro " + "$" + String.init(format: "%0.2f", amount)
                    }else {
                        view.costLabel.text = "Pro " + "$" + String.init(format: "%0.2f/hr", amount)
                    }
                }
            }
            view.costLabel.halfTextColorChange(fullText: view.costLabel.text!, changeText: "Pro", changeText1: "Muscle")

        } else if (helper_service_type == HelperType.Muscle){//Muscle
            if let total_amount = (moveInfo["total_amount"] as? Double) {
                if (moveInfo["is_estimate_hour"] as? Int) == 0{
                    view.costLabel.text = "Muscle " + "$" + String.init(format: "%0.2f", total_amount)
                    view.costLabel.halfTextColorChange(fullText: view.costLabel.text!, changeText: "Muscle", changeText1: "Pro")
                    return
                }
                view.costLabel.text = "Muscle " + "$" + String.init(format: "%0.2f/hr", total_amount)
            }
            
            if(helping_service_required_pros > 0 && helping_service_required_muscle > 0) {
                if let amount = (moveInfo["total_muscle_amount"] as? Double){
//                    acceptTypeLabel.text = "Muscle"
                    if (moveInfo["is_estimate_hour"] as? Int) == 0{
                        view.costLabel.text = "$" + String.init(format: "%0.2f", amount)
                        view.costLabel.halfTextColorChange(fullText: view.costLabel.text!, changeText: "Muscle", changeText1: "Pro")

                        return
                    }
                    view.costLabel.text = "$" + String.init(format: "%0.2f/hr", amount)
                }
            }
            view.costLabel.halfTextColorChange(fullText: view.costLabel.text!, changeText: "Muscle", changeText1: "Pro")

        } else {//Pro + Muscle
            if(helping_service_required_pros > 0 && helping_service_required_muscle > 0) {
                if let musleamount = (moveInfo["total_muscle_amount"] as? Double){
                    if (moveInfo["is_estimate_hour"] as? Int) == 0{
                        A1 =  String.init(format: "%0.2f", musleamount)
                    }else{
                        A1 =  String.init(format: "%0.2f/hr", musleamount)
                    }
                }
                if let proamount = (moveInfo["total_pros_amount"] as? Double){
                    if (moveInfo["is_estimate_hour"] as? Int) == 0{
                        A2 =  String.init(format: "%0.2f", proamount)
                    }else{
                        A2 =  String.init(format: "%0.2f/hr", proamount)
                    }
                }
                view.costLabel.numberOfLines = 0
                let finalSt1 = "Muscle " + "$" + A1
                let finalSt2 = "\n" + "Pro " + "$" + A2
                view.costLabel.text = finalSt1 + finalSt2
                view.costLabel.halfTextColorChange(fullText: view.costLabel.text!, changeText: "Muscle", changeText1: "Pro")

            }else{
                if(helping_service_required_pros > 0) {
                    if let amount = (moveInfo["total_pros_amount"] as? Double){
                        if (moveInfo["is_estimate_hour"] as? Int) == 0 {
                            let finalSt2 = "Pro " + "$" + String.init(format: "%0.2f", amount)
                            view.costLabel.text = finalSt2
                        }else {
                            let finalSt2 = "Pro " + "$" + String.init(format: "%0.2f/hr", amount)
                            view.costLabel.text = finalSt2
                        }
                    }
                } else if(helping_service_required_muscle > 0) {
                    if let amount = (moveInfo["total_muscle_amount"] as? Double){
                        if (moveInfo["is_estimate_hour"] as? Int) == 0{
                            let finalSt1 = "Muscle " + "$" + String.init(format: "%0.2f", amount)
                            view.costLabel.text = finalSt1
                            view.costLabel.halfTextColorChange(fullText: view.costLabel.text!, changeText: "Muscle", changeText1: "Pro")

                            return
                        }
                        let finalSt1 = "Muscle " + "$" + String.init(format: "%0.2f/hr", amount)
                        view.costLabel.text = finalSt1
                        view.costLabel.halfTextColorChange(fullText: view.costLabel.text!, changeText: "Muscle", changeText1: "Pro")
                    }
                }

            }
        }
       
        view.costLabel.halfTextColorChange(fullText: view.costLabel.text!, changeText: "Muscle", changeText1: "Pro")
    }
    
    @objc func calloutTapped(_ tapgesture: UITapGestureRecognizer){
        
        let moveDict = (moveDictArray[(tapgesture.view?.tag)!] )
        
        let moveDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "MoveDetailsViewController") as! MoveDetailsViewController
        moveDetailsVC.moveDict = moveDict
        moveDetailsVC.moveType = MoveType.Available
        moveDetailsVC.moveID = (moveDict["request_id"] as! Int)
        self.navigationController?.pushViewController(moveDetailsVC, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = darkPinkColor
        renderer.lineWidth = 5.0
        
        return renderer
    }
    private func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView)
        {
            if let annotationTitle = view.annotation?.title
            {
                print("User tapped on annotation with title: \(annotationTitle!)")
            }
        }
}

class CustomPointAnnotation: MKPointAnnotation {
    var tag: Int!
}
//extension MapViewViewController:CLLocationManagerDelegate{
//    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView)
//        {
//            if let annotationTitle = view.annotation?.title
//            {
//                print("User tapped on annotation with title: \(annotationTitle!)")
//            }
//        }
//}

extension MapViewViewController{
    //Alert...
    func showAlertPopupView(_ popUpTitleMsg:String = "", _ message:String,  _ cancelButtonTitle:String = "",  _ okButtonTitle:String = "", _ centerOkButtonTitle:String = ""){
        self.view.endEditing(true)
        AlertPopupView.instance.shwoDataWithClosures(popUpTitleMsg, message, cancelButtonTitle, okButtonTitle, centerOkButtonTitle){ status in
            if status{
                print("Okay")
                if self.isConnectingToAnotherHelper{
                    appDelegate.homeVC?.redirectToScheduledTab(section: 1)
                }else{
                    self.acceptMove(self.acceptMoveId)
                }
            }else{
                print("NO/Cancel")
            }
        }
    }
}



