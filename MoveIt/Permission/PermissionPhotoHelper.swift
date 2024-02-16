//
//  PermissionPhotoHelper.swift
//  MoveIt
//
//  Created by Govind Kumar Patidar on 09/05/22.
//  Copyright © 2022 Jyoti. All rights reserved.
//

import UIKit
import AVKit
import Photos

enum Permission {
    case camera
    case photo
    case notification
    case microphone
    case speech
}

enum PermissionStatus{
    case accepted
    case denied
    case notDetermined
    case restricted
}

protocol PermissionSelectionDelegate {
    
    func permissionStatus(_ permission: Permission, status : PermissionStatus)
}

class PermissionEnumsViewController: NSObject {
}

class PermissionPhotoHelper: NSObject {
    var permissionSelectionDelegate : PermissionSelectionDelegate?
    var photoPermissionStatus : PermissionStatus!
    
    override init() {
        super.init()
        photoPermissionStatus =  self.checkPhotoPermission()
    }
    
    
    func checkPhotoPermission()-> PermissionStatus{
        let ps = PHPhotoLibrary.authorizationStatus()
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
    
    func requestPhotoPermission(completetionBlock: @escaping (PermissionStatus?) -> Void){
        
        
        if self.photoPermissionStatus == PermissionStatus.denied  {
            DispatchQueue.main.async {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
               // completetionBlock(.denied)
            }
        }
        else if self.photoPermissionStatus == PermissionStatus.notDetermined{
            PHPhotoLibrary.requestAuthorization({ (status) in
                
                let ps = status
                if ps ==  .authorized {
                    
                    self.photoPermissionStatus = .accepted
                    completetionBlock(.accepted)
                    self.permissionSelectionDelegate?.permissionStatus(.camera, status: .accepted)
                }else{
                    
                    DispatchQueue.main.async {
//                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                        completetionBlock(.denied)
                    }
                }
                
            })
        }
        else if self.photoPermissionStatus == PermissionStatus.accepted{
            completetionBlock(.accepted)
        }
        
    }
    
}
