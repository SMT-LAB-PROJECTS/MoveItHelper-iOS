//
//  PermissionCameraHelper.swift
//  MoveIt
//
//  Created by Govind Kumar Patidar on 09/05/22.
//  Copyright © 2022 Jyoti. All rights reserved.
//

import UIKit
import AVKit
import Photos
class PermissionCameraHelper: NSObject {
    var permissionSelectionDelegate : PermissionSelectionDelegate?
    var cameraPermissionStatus : PermissionStatus!
    
    override init() {
        super.init()
        cameraPermissionStatus =  self.checkCameraPermission()
    }
    
    func checkCameraPermission()-> PermissionStatus{
        let ps = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if ps ==  .authorized {
            
            return .accepted
        } else if ps == .denied {
            
            return .denied
        }
        else if ps == .restricted{
            
            return .restricted
        }
        else{
            
            return .notDetermined
        }
    }
    
    func requestCameraPermission(completetionBlock: @escaping (PermissionStatus?) -> Void){
        
        if self.cameraPermissionStatus == PermissionStatus.denied{
            DispatchQueue.main.async {
                //completetionBlock(.denied)
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
        }
        else if self.cameraPermissionStatus == PermissionStatus.notDetermined{
            
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
                if granted == true {
                    
                    self.cameraPermissionStatus = .accepted
                    completetionBlock(.accepted)
                    self.permissionSelectionDelegate?.permissionStatus(.camera, status: .accepted)
                    
                } else {
                    
                    DispatchQueue.main.async {
                        completetionBlock(.denied)
//                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }
                }
            })
        }
        else if self.cameraPermissionStatus == PermissionStatus.accepted{
            completetionBlock(.accepted)
        }
    }
}
