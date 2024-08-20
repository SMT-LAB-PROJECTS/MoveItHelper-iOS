//
//  DirectionViewController.swift
//  MoveIt
//
//  Created by Dushyant on 24/06/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit
import MapKit

class DirectionViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var getDirectionButton: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var backButton: UIButton!
    var locManager = CLLocationManager()
    
    var helperStatus = 0
    var requestID = 0
  
    var pickUpLat = 0.0
    var pickUpLong = 0.0
    var dropOffLat = 0.0
    var dropOffLong = 0.0
    
    var moveInfo : MoveDetailsModel!
    var currentLocation: CLLocation!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dropOffLat = moveInfo.pickup_lat!
        dropOffLong = moveInfo.pickup_long!
        
        determineMyCurrentLocation()
        locManager.requestWhenInUseAuthorization()
       
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways){
            
            currentLocation = locManager.location
            drawRoute()
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
    
    func drawRoute(){
        
        pickUpLat = currentLocation.coordinate.latitude
        pickUpLong = currentLocation.coordinate.longitude

        self.setLocationMark()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let userLocation:CLLocation = locations[0] as CLLocation
            currentLocation = userLocation
        
          updateLocationStatus()
        self.drawRoute()
    }
    
    func updateLocationStatus(){
        
        if helperStatus >= 2 , helperStatus<4 {
            
            let param = ["request_id": requestID,"helper_lat":currentLocation.coordinate.latitude,"helper_lng":currentLocation.coordinate.longitude] as [String : Any]
            CommonAPIHelper.updateHelperLocation(VC: self, params: param) { (res, err, isExe) in
                
            }
        }
    }
    
    func updateLocation(){
        
        let param = [
                     "request_id":requestID,
                     "helper_status": helperStatus,
                     "helper_lat": currentLocation?.coordinate.latitude ?? 0.0,
                     "helper_long": currentLocation?.coordinate.longitude ?? 0.0,
                     "helper_address": ""//currentAddress(currentLocation.coordinate)
                    ] as [String: Any]
        
        CommonAPIHelper.updateMoveStatus(VC: self, dict: param, completetionBlock: { (result, error, isexecuted) in
            
            if error != nil{
                return
            } else {
                //print(result)
            }
        })
    }
    
    func currentAddress(_ coordinate:CLLocationCoordinate2D) -> String
    {
        let loc = LocationManager()
        var addr = ""
        
        loc.getPlace(for: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { [] (placemark) in
            if let name = placemark?.name {
                addr = name
            }
            if let subLocality = placemark?.subLocality {
                if addr == "" {
                    addr = subLocality
                } else{
                    addr = addr + ", " + subLocality
                }
            }
            if let locality = placemark?.locality {
                if addr == "" {
                    addr = locality
                } else{
                    addr = addr + ", " + locality
                }
            }
            if let administrativeArea = placemark?.administrativeArea {
                if addr == "" {
                    addr = administrativeArea
                } else{
                    addr = addr + ", " + administrativeArea
                }
            }
            if let subAdministrativeArea = placemark?.subAdministrativeArea {
                if addr == "" {
                    addr = subAdministrativeArea
                } else{
                    addr = addr + ", " + subAdministrativeArea
                }
            }
            if let postalCode = placemark?.postalCode {
                if addr == "" {
                    addr = postalCode
                } else{
                    addr = addr + ", " + postalCode
                }
            }
            print("addr : ", addr)
        }
        return "\(addr)"
    }
    @IBAction func getDirectionAction(_ sender: Any) {
        self.dismiss(animated: false) {
            let gpsVC = self.storyboard?.instantiateViewController(withIdentifier: "GPSDirectionViewController") as! GPSDirectionViewController
            gpsVC.modalPresentationStyle = .overFullScreen
            UIApplication.shared.keyWindow?.rootViewController?.present(gpsVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
            self.dismiss(animated: true, completion: nil)
    }
    
}
extension DirectionViewController: MKMapViewDelegate{
    
    func setLocationMark(){
        
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)

        let sourceLocation = CLLocationCoordinate2D(latitude: pickUpLat, longitude: pickUpLong)
        let destinationLocation = CLLocationCoordinate2D(latitude: dropOffLat, longitude: dropOffLong)
        
        // 3.
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        // 4.
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        // 5.
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "Current Location"
        
        
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        
        let destinationAnnotation = MKPointAnnotation()
     //   destinationAnnotation.title = dropOff
        
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        // 6.
        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        // 7.
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        // 8.
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        let annotationIdentifier = "AnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        if annotation.title != "Current Location"{
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
                annotationView!.canShowCallout = true
            }
            else {
                annotationView!.annotation = annotation
            }
            
            let pinImage = UIImage(named: "location_ending_point")
            annotationView!.image = pinImage
        }
        else{
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
                annotationView!.canShowCallout = true
            }
            else {
                annotationView!.annotation = annotation
            }
            
            let pinImage = UIImage(named: "car")
            annotationView!.image = pinImage
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = darkPinkColor
        renderer.lineWidth = 5.0
        
        return renderer
    }
}
