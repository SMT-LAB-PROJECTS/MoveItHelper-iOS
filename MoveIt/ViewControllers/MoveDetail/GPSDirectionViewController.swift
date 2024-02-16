//
//  GPSDirectionViewController.swift
//  MoveIt
//
//  Created by Dushyant on 27/12/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import MapKit
import UIKit
import CoreLocation
class GPSDirectionViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
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
      var currentLocation: CLLocation?
    
    
//    var reloadTimer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
           mapView.delegate = self
        mapView.showsUserLocation = true
        
        
        helperStatus = moveInfo!.helper_status!
        print(helperStatus)
        
        if helperStatus == 2{
             dropOffLat = moveInfo!.pickup_lat!
             dropOffLong = moveInfo!.pickup_long!
            
        }
        else{
             dropOffLat = moveInfo!.dropoff_lat!
             dropOffLong = moveInfo!.dropoff_long!
        }
        
        determineMyCurrentLocation()
           locManager.requestAlwaysAuthorization()
          
            locManager.allowsBackgroundLocationUpdates = true
           if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
               CLLocationManager.authorizationStatus() ==  .authorizedAlways){
               
               currentLocation = locManager.location
            pickUpLat = currentLocation?.coordinate.latitude ?? 0.0
            pickUpLong = currentLocation?.coordinate.longitude ?? 0.0
            drawRoute()
            
           }
    }
    
    @objc func updatMapAPI(){
        updateLocationStatus(lat: pickUpLat, long: pickUpLong)
    }
    
    func determineMyCurrentLocation() {
        
        locManager = CLLocationManager()
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locManager.requestAlwaysAuthorization()
        locManager.distanceFilter = 10
        //manager.activityType = .other
        //manager.desiredAccuracy = 45
        
        if CLLocationManager.locationServicesEnabled() {
            locManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
     
        let userLocation:CLLocation = locations[0] as CLLocation
        currentLocation = userLocation
        pickUpLat = currentLocation!.coordinate.latitude
        pickUpLong = currentLocation!.coordinate.longitude
        updateLocationStatus(lat: userLocation.coordinate.latitude, long: userLocation.coordinate.longitude)
        if self.mapView != nil{
             self.drawRoute()
        }
    }
    
    func updateLocationStatus(lat : Double, long: Double){
        if helperStatus >= 2 , helperStatus<4 {
            let param = ["request_id": moveInfo!.request_id!,"helper_lat": lat,"helper_lng": long] as [String : Any]
            CommonAPIHelper.updateHelperLocation(VC: self, params: param) { (res, err, isExe) in
                
            }
        }
    }
    
    func  drawRoute(){
        setLocationMark()
             let request = MKDirections.Request()
           request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: pickUpLat, longitude: pickUpLong), addressDictionary: nil))
                request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: dropOffLat, longitude: dropOffLong), addressDictionary: nil))
                request.requestsAlternateRoutes = true
                request.transportType = .automobile

                let directions = MKDirections(request: request)

                directions.calculate { [unowned self] response, error in
                   
                   if error != nil{
                       print(error)
                   }
                   
                    guard let unwrappedResponse = response else { return }

                        let route = unwrappedResponse.routes[0]
                        if self.mapView != nil{
                            self.mapView.addOverlay(route.polyline)
                            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                        }
                }
        
    }

    @IBAction func backAction(_ sender: Any) {
//            reloadTimer.invalidate()
        self.dismiss(animated: true, completion: nil)
    }
    
    func setLocationMark(){
        
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)

        let sourceLocation = CLLocationCoordinate2D(latitude: moveInfo!.pickup_lat!, longitude: moveInfo!.pickup_long!)
        let destinationLocation = CLLocationCoordinate2D(latitude: moveInfo!.dropoff_lat!, longitude: moveInfo!.dropoff_long!)
        
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
            
            let pinImage = UIImage(named: "location_starting_point")
            annotationView!.image = pinImage
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = darkPinkColor
        renderer.lineWidth = 5.0
        return renderer
    }
}
