//
//  LocationUpdateGlobal.swift
//  MoveIt
//
//  Created by Dushyant on 04/03/20.
//  Copyright © 2020 Jyoti. All rights reserved.
//

import UIKit
import CoreLocation

class LocationUpdateGlobal: NSObject,CLLocationManagerDelegate {

    
    class var shared : LocationUpdateGlobal {
        struct Static {
            static let instance = LocationUpdateGlobal()
        }
        
        return Static.instance
    }
    
    var locManager = CLLocationManager()
    var timer = Timer()
    var request_id = Int()
    var newLat = 0.0
    var newLong = 0.0
    
    var oldLat = 0.0
    var oldLong = 0.0
    
    func startUpdateingLocation(_ request_id: Int){
        self.request_id = request_id
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updatMapAPI), userInfo: nil, repeats: true)
        determineMyCurrentLocation()
    }
    
    @objc func updatMapAPI() {
        
        if(newLat*newLong == 0) {
            print("newLat*newLong*oldLat*oldLong == 0")
            return
        } else if (oldLat*oldLong == 0) {
            print("oldLat*oldLong == 0")
            oldLat = newLat
            oldLong = newLong
            updateLocationStatus(lat: newLat, long: newLong)
            return
        }
        
        let coordinate₀ = CLLocation(latitude: oldLat, longitude: oldLong)
        let coordinate₁ = CLLocation(latitude: newLat, longitude: newLong)

        let distanceInMeters = coordinate₀.distance(from: coordinate₁) // result is in meters

        if(distanceInMeters > 2) {
            updateLocationStatus(lat: newLat, long: newLong)
        } else {
           print("distanceInMeters = ", distanceInMeters)
        }
     }
   
    func stopUpdatingLocation() {
        if(timer != nil && timer.isValid == true ) {
            self.timer.invalidate()
        }
    }
    
    func determineMyCurrentLocation() {
             
             locManager = CLLocationManager()
             locManager.delegate = self
             locManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
             locManager.requestAlwaysAuthorization()
             locManager.distanceFilter = 10
     //        manager.activityType = .other
     //        manager.desiredAccuracy = 45
            locManager.allowsBackgroundLocationUpdates = true
            locManager.pausesLocationUpdatesAutomatically = false
             if CLLocationManager.locationServicesEnabled() {
                 locManager.startUpdatingLocation()
                 //locationManager.startUpdatingHeading()
             }
         }
     
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      
         let userLocation:CLLocation = locations[0] as CLLocation
         //  currentLocation = userLocation
         newLat = userLocation.coordinate.latitude
         newLong = userLocation.coordinate.longitude
         updateLocationStatus(lat: userLocation.coordinate.latitude, long: userLocation.coordinate.longitude)
     }
    func updateLocationStatus(lat : Double, long: Double){
              
          //    if helperStatus >= 2 , helperStatus<4{
        callAnalyticsEvent(eventName: "moveit_update_location", desc: ["description":"job id : \(self.request_id), latitude : \(lat) longitude : \(long) to trcak the location is updating for job "])
        let param = ["request_id": self.request_id,"helper_lat": lat,"helper_lng": long] as [String : Any]
                  
                CommonAPIHelper.updateHelperLocation(VC: UIViewController(), params: param) { (res, err, isExe) in
                      print("Call update location services")
                  }
             // }
    }
}
