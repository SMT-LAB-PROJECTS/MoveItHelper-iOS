//
//  DistanceViewController.swift
//  MoveIt
//
//  Created by Dushyant on 11/07/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit
import MapKit

class DistanceViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
 
    @IBOutlet weak var rangeBkView: UIView!
    @IBOutlet weak var rangeBar: UISlider!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var selectRangeLabel: UILabel!
    @IBOutlet weak var oneMileLabel: UILabel!
    @IBOutlet weak var fiftyMileLabel: UILabel!
    
    var locManager = CLLocationManager()
    
    var currentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle("Distance")
        
        let rightBarTextButton =  StaticHelper.rightBarButtonWithText(text: "Save", vc: self)
        let leftBarButtonItem = StaticHelper.leftBarButtonWithImageNamed(imageName: "backward_arrow_icon", vc: self)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        self.navigationItem.rightBarButtonItem = rightBarTextButton
        
        selectRangeLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 13.0)
        oneMileLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 8.0)
        fiftyMileLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 8.0)
        selectRangeLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        
        rangeBar.minimumValue = Float((profileInfo?.min_range)!)
        rangeBar.maximumValue = Float((profileInfo?.max_range)!)
        
        fiftyMileLabel.text = String(Int((profileInfo?.max_range)!))+" Miles"
        
        let rng =  Float((profileInfo?.range)!)
        rangeBar.setValue(rng, animated: true)
        oneMileLabel.text = "\(Int(rng)) Mile"
        
        rangeBkView.layer.cornerRadius = 5.0 * screenHeightFactor
        mapView.showsUserLocation = true
        determineMyCurrentLocation()
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways){
            currentLocation = locManager.location
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
    
    @objc func leftButtonPressed(_ selector: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func rightTextPressed(_ selector: UIButton){
        CommonAPIHelper.saveRange(VC: self, range: Int(rangeBar.value)) { (res, error, isExecuted) in
            if isExecuted{
                profileInfo?.range = Int(self.rangeBar.value)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func rangeAction(_ sender: Any) {
        print(rangeBar.value)
        oneMileLabel.text = "\(Int(rangeBar.value)) Mile"
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locManager.stopUpdatingLocation()
        let mUserLocation:CLLocation = locations[0] as CLLocation
        let center = CLLocationCoordinate2D(latitude: mUserLocation.coordinate.latitude, longitude: mUserLocation.coordinate.longitude)
        let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(mRegion, animated: true)
    }
}
