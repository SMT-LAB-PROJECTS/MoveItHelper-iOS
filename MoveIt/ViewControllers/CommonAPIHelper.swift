//
//  CommonAPIHelper.swift
//  Move It
//
//  Created by Dushyant on 11/06/19.
//  Copyright © 2019 Agicent Technologies. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage


class CommonAPIHelper: NSObject {
    
    class var shared : CommonAPIHelper {
        struct Static {
            static let instance = CommonAPIHelper()
        }
        
        return Static.instance
    }
    
    class func getAllAvailableMoves(VC: UIViewController, page_index: Int, completetionBlock: @escaping ([[String : Any]]?, [String : Any]?, _ error:NSError?, Bool) -> Void){
        print(#function)
        if UserCache.userToken() == nil {
            clearData(VC: VC)
            return
        }
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        
        StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)

        let parameters : Parameters =  ["page_no": page_index, "timezone": TimeZone.current.identifier, "lat": appDelegate.strLat, "lng": appDelegate.strLng]
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
        
        if OnboardService.isPrintLog{
            print("\n***********************START********************\n")
            print("Header :\n",header)
            print("Request Param :\n",parameters)
            print("Base URL :\n",(baseURL + kAPIMethods.get_helper_available_move))
        }
        AF.request(baseURL+kAPIMethods.get_helper_available_move, method: .post, parameters: parameters,headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
            switch response.result {
            case .success:
                if OnboardService.isPrintLog{print("Availabl Response :\n",response)}
                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200 {
                    let res = response.value as! [String: Any]
                    let nextPageAvailable = (res["next_page"] as! Bool)
                    completetionBlock(res["data"] as? [[String: Any]],
                                      res["HelperMoveCount"] as? [String: Any],
                                      nil,
                                      nextPageAvailable)
                }else  if response.response?.statusCode == 204{
                    completetionBlock([[String: Any]](),nil,nil,false)
                }else  if response.response?.statusCode == 406{
                    completetionBlock([[String: Any]](),nil,nil,false)
                }else if response.response?.statusCode == 401{
                    if let _ = UserDefaults.standard.object(forKey: kUserCache.auth_key) as? String {
                        StaticHelper.shared.stopLoader()
                        let responseJson = response.value as! [String: AnyObject]
                        VC.view.makeToast(responseJson["message"] as? String)
                } else {
                        clearData(VC: VC)
                    }
                }
            case .failure(let error):
                if OnboardService.isPrintLog{print("Error :\n",error)}

                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 401{
                    clearData(VC: VC)
                } else{
                    completetionBlock(nil,nil,error as NSError,false)
                }
            }
                if OnboardService.isPrintLog{print("\n***********************END********************\n")}

            }
        }
    }
    class func updateNotificationStatusAPI(parameters:[String:Any]){
        if UserCache.userToken() == nil {
            return
        }
        
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!,"Content-Type":"application/json"]
        
        print(parameters,header)

        AF.request(baseURL+kAPIMethods.update_notification_status, method: .post, parameters: parameters,encoding: JSONEncoding.default,headers: header).responseJSON { (response) in
            switch response.result {
            case .success: break
//                if response.response?.statusCode == 200 {
//                    UserCache.setTokenUpdated(isTrue: true)
//                } else if(response.response?.statusCode == 401) {
//                    MoveItStaticHelper.logout()
//                }
            case .failure(_):
                print("Failed")
            }
        }
    }
    class func getAllCompletedMoves(VC: UIViewController, page_index: Int, completetionBlock: @escaping ([[String : Any]]?, _ error:NSError?,Bool) -> Void){
        print(#function)
        if UserCache.userToken() == nil {
            clearData(VC: VC)
            return
        }
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        
        StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
        
        let parameters : Parameters =  ["page_no": page_index,"timezone": TimeZone.current.identifier]
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
        
        if OnboardService.isPrintLog{
            print("\n***********************START********************\n")
            print("Header :\n",header)
            print("Request Param :\n",parameters)
            print("Base URL :\n",(baseURL + kAPIMethods.get_helper_completed_move))
        }
        AF.request(baseURL+kAPIMethods.get_helper_completed_move, method: .post, parameters: parameters,headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
            switch response.result {
            case .success:
                if OnboardService.isPrintLog{print("Completed Response :\n",response)}

                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200{
                    let res = response.value as! [String: Any]
                    let nextPageAvailable = (res["next_page"] as! Bool)
                    completetionBlock(res["data"] as? [[String: Any]],nil,nextPageAvailable)
                } else if response.response?.statusCode == 401{
                    if let _ = UserDefaults.standard.object(forKey: kUserCache.auth_key) as? String {
                        StaticHelper.shared.stopLoader()
                        let responseJson = response.value as! [String: AnyObject]
                        VC.view.makeToast(responseJson["message"] as? String)
                    } else{
                        clearData(VC: VC)
                    }
                }
            case .failure(let error):
                if OnboardService.isPrintLog{print("Error :\n",error)}

                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 401{
                    clearData(VC: VC)
                } else{
                    completetionBlock(nil,error as NSError,false)
                }
            }
                if OnboardService.isPrintLog{print("\n***********************END********************\n")}

            }
        }
    }
    
    class func getAllCancelledMoves(VC: UIViewController, page_index: Int, completetionBlock: @escaping ([[String : Any]]?, _ error:NSError?,Bool) -> Void){
        print(#function)
        if UserCache.userToken() == nil {
            clearData(VC: VC)
            return
        }
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        
        StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
        
        let parameters : Parameters =  ["page_no": page_index,"timezone": TimeZone.current.identifier]
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
        
        if OnboardService.isPrintLog{
            print("\n***********************START********************\n")
            print("Header :\n",header)
            print("Request Param :\n",parameters)
            print("Base URL :\n",(baseURL + kAPIMethods.get_helper_cancel_move))
        }
        AF.request(baseURL+kAPIMethods.get_helper_cancel_move, method: .post, parameters: parameters,headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
            switch response.result {
            case .success:
                if OnboardService.isPrintLog{print("Cancelled Response :\n",response)}
                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200{
                    let res = response.value as! [String: Any]
                    let nextPageAvailable = (res["next_page"] as! Bool)
                    completetionBlock(res["data"] as? [[String: Any]],nil,nextPageAvailable)
                }
                else if response.response?.statusCode == 401{
                    StaticHelper.shared.stopLoader()
                    clearData(VC: VC)
                }
            case .failure(let error):
                if OnboardService.isPrintLog{print("Error :\n",error)}
                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 401{
                    clearData(VC: VC)
                } else{
                    completetionBlock(nil,error as NSError,false)
                }
            }
                if OnboardService.isPrintLog{print("\n***********************END********************\n")}
            }
        }
    }
    
    class func acceptMoves(VC: UIViewController, request_id: Int, helperType: Int, completetionBlock: @escaping ([String : Any]?, _ error:NSError?, Int) -> Void){
        print(#function)
        if UserCache.userToken() == nil {
            clearData(VC: VC)
            return
        }
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        
        StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
   
        let parameters : Parameters =  ["request_id": request_id, "service_type": helperType]
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
        
        if OnboardService.isPrintLog{
            print("\n***********************START********************\n")
            print("Header :\n",header)
            print("Request Param :\n",parameters)
            print("Base URL :\n",(baseURL + kAPIMethods.helper_accept_move_request))
        }
        callAnalyticsEvent(eventName: "moveit_accept_move", desc: ["description":"Request Id - \(request_id)"])
        AF.request(baseURL+kAPIMethods.helper_accept_move_request, method: .post, parameters: parameters,headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
                switch response.result {
                case .success:
                    StaticHelper.shared.stopLoader()
                    if OnboardService.isPrintLog{print("Accept Moves Response :\n",response)}
                    
                    if response.response?.statusCode == 200 {
                        let res = response.value as! [String: Any]
                        completetionBlock(res,nil,response.response?.statusCode ?? 0)
                    } else if response.response?.statusCode == 201 {
                        let res = response.value as! [String: Any]
                        completetionBlock(res,nil,response.response?.statusCode ?? 0)
                    } else if response.response?.statusCode == 401 {
                        StaticHelper.shared.stopLoader()
                        let responseJson = response.value as! [String: AnyObject]
                        VC.view.makeToast(responseJson["message"] as? String)
                    } else if response.response?.statusCode == 405 {
                        UIApplication.shared.keyWindow?.rootViewController!.view.makeToast("This Move has already been accepted by another helper.")
                    }
                case .failure(let error):
                    //if OnboardService.isPrintLog{print("Accept Moves Response :\n",String(decoding: response.data!, as: UTF8.self))}
                    if OnboardService.isPrintLog{print("Error :\n",error)}
                    StaticHelper.shared.stopLoader()
                    completetionBlock(nil,error as NSError,0)
                }
                if OnboardService.isPrintLog{print("\n***********************END********************\n")}

            }
        }
    }
    
    class func getAllScheduledMoves(VC: UIViewController, page_index: Int, completetionBlock: @escaping ([[String : Any]]?, [String: Any]?, _ error:NSError?,Bool) -> Void){
    print(#function)
    if UserCache.userToken() == nil {
        clearData(VC: VC)
        return
    }
    if !StaticHelper.Connectivity.isConnectedToInternet {
        StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
        return
    }
    
    StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
    
    let parameters : Parameters =  ["page_no": page_index,"timezone": TimeZone.current.identifier]
    let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
    
    if OnboardService.isPrintLog{
        print("\n***********************START********************\n")
        print("Header :\n",header)
        print("Request Param :\n",parameters)
        print("Base URL :\n",(baseURL + kAPIMethods.get_helper_scheduled_move))
    }
    AF.request(baseURL+kAPIMethods.get_helper_scheduled_move, method: .post, parameters: parameters,headers: header).responseJSON { (response) in
        DispatchQueue.main.async {
        switch response.result {
        case .success:
            StaticHelper.shared.stopLoader()
            if response.response?.statusCode == 200{
                if OnboardService.isPrintLog{print("All Scheduled Moves Response :\n",response)}
                let res = response.value as! [String: Any]
                let nextPageAvailable = (res["next_page"] as! Bool)
                completetionBlock(res["data"] as? [[String: Any]],
                                  res["HelperMoveCount"] as? [String: Any],
                                  nil,
                                  nextPageAvailable)
            }
            else  if response.response?.statusCode == 204{
                let res = [[String: Any]]()
                completetionBlock(res,nil,nil,true)
            }
            else if response.response?.statusCode == 401{
                StaticHelper.shared.stopLoader()
                let responseJson = response.value as! [String: AnyObject]
                VC.view.makeToast(responseJson["message"] as? String)
            }
        case .failure(let error):
            if OnboardService.isPrintLog{print("Error :\n",error)}
            StaticHelper.shared.stopLoader()
            completetionBlock(nil,nil,error as NSError,false)
        }
            if OnboardService.isPrintLog{print("\n***********************END********************\n")}

        }
    }
}


class func getAllPendingScheduledMoves(VC: UIViewController, page_index: Int, completetionBlock: @escaping ([[String : Any]]?, _ error:NSError?,Bool) -> Void){
    print(#function)
    if UserCache.userToken() == nil {
        clearData(VC: VC)
        return
    }
    callAnalyticsEvent(eventName: "moveit_check_pending", desc: ["description":"\(profileInfo?.helper_id ?? 0) checked Pending moves list"])
    if !StaticHelper.Connectivity.isConnectedToInternet {
        StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
        return
    }
    
    StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
    
    let parameters : Parameters =  ["page_no": page_index,"timezone": TimeZone.current.identifier]
    let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
    
    if OnboardService.isPrintLog{
        print("\n***********************START********************\n")
        print("Header :\n",header)
        print("Request Param :\n",parameters)
        print("Base URL :\n",(baseURL + kAPIMethods.get_helper_scheduled_pendding_move))
    }
    AF.request(baseURL+kAPIMethods.get_helper_scheduled_pendding_move, method: .post, parameters: parameters,headers: header).responseJSON { (response) in
        
        DispatchQueue.main.async {
        switch response.result {
        case .success:
            if OnboardService.isPrintLog{print("All Pending Scheduled Moves Response :\n",response)}
            StaticHelper.shared.stopLoader()
            if response.response?.statusCode == 200{
                let res = response.value as! [String: Any]
                let nextPageAvailable = (res["next_page"] as! Bool)
                completetionBlock(res["data"] as? [[String: Any]],nil,nextPageAvailable)
            }
            else  if response.response?.statusCode == 204{
                let res = [[String: Any]]()
                completetionBlock(res,nil,true)
            }
            else if response.response?.statusCode == 401{
                StaticHelper.shared.stopLoader()
                let responseJson = response.value as! [String: AnyObject]
                VC.view.makeToast(responseJson["message"] as? String)
            }
        case .failure(let error):
            if OnboardService.isPrintLog{print("Error :\n",error)}
            StaticHelper.shared.stopLoader()
            completetionBlock(nil,error as NSError,false)
        }
            if OnboardService.isPrintLog{print("\n***********************END********************\n")}
        }
    }
}


    class func saveMeetingSlots(VC: UIViewController, params: [String: Any], completetionBlock: @escaping ([String : Any]?, _ error:NSError?,Bool) -> Void){
        print(#function)
        if UserCache.userToken() == nil {
            clearData(VC: VC)
            return
        }
           if !StaticHelper.Connectivity.isConnectedToInternet {
               StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
               return
           }
           
           StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
      
           let parameters : Parameters = params
           let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
           
           print(parameters,header)
           
           AF.request(baseURL+kAPIMethods.set_helper_meettinng_slot, method: .post, parameters: parameters,headers: header).responseJSON { (response) in
               
               DispatchQueue.main.async {
               switch response.result {
               case .success:
                   StaticHelper.shared.stopLoader()
                   
                   if response.response?.statusCode == 200{
                        completetionBlock([String: Any](),nil,true)
                   }
                   else if response.response?.statusCode == 401{
                       StaticHelper.shared.stopLoader()
                       let responseJson = response.value as! [String: AnyObject]
                       VC.view.makeToast(responseJson["message"] as? String)
                   }
               case .failure(let error):
                   StaticHelper.shared.stopLoader()
                   completetionBlock(nil,error as NSError,false)
               }
               }
           }
       }
        
    class func getMoveDetailByID(VC: UIViewController, move_id: Int, screen_type:String = "", completetionBlock: @escaping ([String : Any]?, _ error:NSError?,Bool) -> Void){
        print(#function)
        if UserCache.userToken() == nil {
            clearData(VC: VC)
            return
        }
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        
        StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
        
        let parameters : Parameters =  ["request_id": move_id,"timezone": TimeZone.current.identifier, "screen_type":screen_type]
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
        
        print(parameters,header)
        
        AF.request(baseURL + kAPIMethods.get_move_detail_by_id, method: .post, parameters: parameters,headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
            switch response.result {
            case .success:
                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200{
                    let res = response.value as! [String: Any]
                    completetionBlock(res,nil,false)
                }
                else if response.response?.statusCode == 401{
                    StaticHelper.shared.stopLoader()
                    let responseJson = response.value as! [String: AnyObject]
                    VC.view.makeToast(responseJson["message"] as? String)
                }
            case .failure(let error):
                StaticHelper.shared.stopLoader()
                completetionBlock(nil,error as NSError,false)
            }
            }
        }
    }
    
    
    class func getAllotedHelperInfo(VC: UIViewController, move_id: Int, completetionBlock: @escaping ([[String : Any]]?, _ error:NSError?,Bool) -> Void){
        print(#function)
        if UserCache.userToken() == nil {
            clearData(VC: VC)
            return
        }
          if !StaticHelper.Connectivity.isConnectedToInternet {
              StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
              return
          }
          
          StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
          
          let parameters : Parameters =  ["request_id": move_id]
          let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
          
          print(parameters,header)
          
          AF.request(baseURL + kAPIMethods.get_allotment_helper_info, method: .post, parameters: parameters,headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
                switch response.result {
                case .success:
                    StaticHelper.shared.stopLoader()
                    if response.response?.statusCode == 200{
                        let res = response.value as! [String: Any]
                      completetionBlock((res["helper"] as! [[String: Any]]),nil,true)
                    }
                  else if response.response?.statusCode == 401{
                      StaticHelper.shared.stopLoader()
                      let responseJson = response.value as! [String: AnyObject]
                      VC.view.makeToast(responseJson["message"] as? String)
                  }
                case .failure(let error):
                    StaticHelper.shared.stopLoader()
                  completetionBlock(nil,error as NSError,false)
                }

            }
            }
      }
    
    
    class func updateMoveStatus(VC: UIViewController, dict: [String: Any], completetionBlock: @escaping ([[String : Any]]?, _ error:NSError?,Bool) -> Void){
        print(#function)
        if UserCache.userToken() == nil {
            clearData(VC: VC)
            return
        }
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        
 
        
        let parameters : Parameters = dict
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
        
        print(parameters,header)
        
        DispatchQueue.main.async {
            StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
        }
           
        AF.request(baseURL + kAPIMethods.update_helper_move_status, method: .post, parameters: parameters,headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
            switch response.result {
            case .success:
               
                if response.response?.statusCode == 200{
                    let res = response.value as? [[String: Any]]
                    completetionBlock(res,nil,true)
                } else if response.response?.statusCode == 401{
                    StaticHelper.shared.stopLoader()
                    let responseJson = response.value as! [String: AnyObject]
                    VC.view.makeToast(responseJson["message"] as? String)
                    completetionBlock(nil,nil,false)
                } else if response.response?.statusCode == 202{
                    StaticHelper.shared.stopLoader()
                    let responseJson = response.value as! [String: AnyObject]
                    VC.view.makeToast(responseJson["message"] as? String)
                    completetionBlock(nil,nil,false)
                }
                else{
                     completetionBlock(nil,nil,false)
                }
            case .failure(let error):
                StaticHelper.shared.stopLoader()
                completetionBlock(nil,error as NSError,false)
            }
            }
        }
    }
    
    class func cancelSavedMove(VC: UIViewController, request_id: Int, helper_reason: String, completetionBlock: @escaping ([[String : Any]]?, _ error:NSError?,Bool) -> Void){
        print(#function)
        if UserCache.userToken() == nil {
            clearData(VC: VC)
            return
        }
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        
        StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
        
        let parameters : Parameters =  [
            "request_id": request_id,
            "helper_reason":helper_reason,
            "timezone": TimeZone.current.identifier]
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
        
        print(parameters,header)
        
        AF.request(baseURL + kAPIMethods.helper_save_cancel_move, method: .post, parameters: parameters,headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
            switch response.result {
            case .success:
                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200{
                    let res = response.value as? [[String: Any]]
                    completetionBlock(res,nil,true)
                }
                else if response.response?.statusCode == 401{
                    StaticHelper.shared.stopLoader()
                    let responseJson = response.value as! [String: AnyObject]
                    VC.view.makeToast(responseJson["message"] as? String)
                }
            case .failure(let error):
                StaticHelper.shared.stopLoader()
                completetionBlock(nil,error as NSError,false)
            }
            }
        }
    }
    
    class func uploadDropOffPhoto(VC: UIViewController, paramas: [String: Any], completetionBlock: @escaping ([String : Any]?, _ error:NSError?,Bool) -> Void){
        print(#function)
        let parameter = paramas as Parameters
        
        
        let header : HTTPHeaders = ["Content-Type":"application/json","Auth-Token":UserCache.userToken()!]
        
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        

        AF.request(baseURL + kAPIMethods.upload_dropoff_photo, method: .post, parameters: parameter,encoding: JSONEncoding.default,  headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
            switch response.result {
            case .success:
                if response.response?.statusCode == 200{
                    StaticHelper.shared.stopLoader()
                    let res = response.value as? [String: Any]
                    completetionBlock(res,nil,true)
                }
                else if response.response?.statusCode == 401{
                    StaticHelper.shared.stopLoader()
                    let responseJson = response.value as! [String: AnyObject]
                    VC.view.makeToast(responseJson["message"] as? String)
                }
            case .failure(let error):
                print(error.localizedDescription)
                StaticHelper.shared.stopLoader()
                completetionBlock(nil,nil,false)
            }
            }
        }
    }
    
    class func uploadPickUpPhoto(VC: UIViewController, paramas: [String: Any], completetionBlock: @escaping ([String : Any]?, _ error:NSError?,Bool) -> Void){
        print(#function)
        let parameter = paramas as Parameters
        
        
        let header : HTTPHeaders = ["Content-Type":"application/json","Auth-Token":UserCache.userToken()!]
        
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        print(paramas)
        print(header)
        
        AF.request(baseURL + kAPIMethods.upload_pickup_photo, method: .post, parameters: parameter,encoding: JSONEncoding.default,  headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
            switch response.result {
            case .success:
                if response.response?.statusCode == 200{
                    StaticHelper.shared.stopLoader()
                    let res = response.value as? [String: Any]
                    completetionBlock(res,nil,true)
                }
                else if response.response?.statusCode == 401{
                    StaticHelper.shared.stopLoader()
                    let responseJson = response.value as! [String: AnyObject]
                    VC.view.makeToast(responseJson["message"] as? String)
                }
            case .failure(let error):
                print(error.localizedDescription)
                StaticHelper.shared.stopLoader()
                completetionBlock(nil,nil,false)
            }
            }
        }
    }
    
    class func updateHelperLocation(VC: UIViewController, params: [String: Any], completetionBlock: @escaping ([[String : Any]]?, _ error:NSError?,Bool) -> Void){
        print(#function)
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        
//        StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
        
        if UserCache.userToken() == nil{
            StaticHelper.shared.stopLoader()
            return
        }
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]

        
        AF.request(baseURL+kAPIMethods.update_helper_location, method: .post, parameters: params,headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
            switch response.result {
            case .success:
                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200{
                }
                else if response.response?.statusCode == 401{
                    StaticHelper.shared.stopLoader()
                    let responseJson = response.value as! [String: AnyObject]
                    VC.view.makeToast(responseJson["message"] as? String)
                }
            case .failure(let error):
                StaticHelper.shared.stopLoader()
                completetionBlock(nil,error as NSError,false)
            }
            }
        }
    }
    
    class func getAllMesages(VC: UIViewController, page_index: Int, completetionBlock: @escaping ([[String : Any]]?, _ error:NSError?,Bool) -> Void){
        print(#function)
        if UserCache.userToken() == nil {
            clearData(VC: VC)
            return
        }
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        
        StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
        
        let parameters : Parameters =  ["page_no": page_index, "timezone": TimeZone.current.identifier, "user_type":"H"]
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
        
        print(parameters,header)
        
        AF.request(baseURL + kAPIMethods.get_all_chat, method: .post, parameters: parameters,headers: header).responseJSON { (response) in
            DispatchQueue.main.async {
            switch response.result {
            case .success:
                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200{
                    let res = response.value as! [String: Any]
                    let nextPageAvailable = (res["next_page"] as! Bool)
                    completetionBlock((res["data"] as! [[String: Any]]),nil,nextPageAvailable)
                }
                else if response.response?.statusCode == 204{
                     completetionBlock(nil,nil,false)
                }
                else if response.response?.statusCode == 401{
                    StaticHelper.shared.stopLoader()
                    let responseJson = response.value as! [String: AnyObject]
                    VC.view.makeToast(responseJson["message"] as? String)
                } else {
                    completetionBlock(nil,nil,false)
                }
            case .failure(let error):
                
                StaticHelper.shared.stopLoader()
                completetionBlock(nil,error as NSError,false)
            }
            }
        }
    }
    
    class func getAllHelperMesages(VC: UIViewController, page_index: Int, completetionBlock: @escaping ([[String : Any]]?, _ error:NSError?,Bool) -> Void){
        print(#function)
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        
        StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
        
        let parameters : Parameters =  ["page_no": page_index, "timezone": TimeZone.current.identifier, "user_type":"H"]
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
        
        print(parameters,header)
        
        AF.request(baseURL + kAPIMethods.get_all_helper_chat, method: .post, parameters: parameters,headers: header).responseJSON { (response) in
            DispatchQueue.main.async {
            switch response.result {
            case .success:
                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200{
                    let res = response.value as! [String: Any]
                    let nextPageAvailable = (res["next_page"] as! Bool)
                    completetionBlock((res["data"] as! [[String: Any]]),nil,nextPageAvailable)
                }
                else if response.response?.statusCode == 204{
                     completetionBlock(nil,nil,false)
                }
                else if response.response?.statusCode == 401{
                    StaticHelper.shared.stopLoader()
                    let responseJson = response.value as! [String: AnyObject]
                    VC.view.makeToast(responseJson["message"] as? String)
                }
            case .failure(let error):
                
                StaticHelper.shared.stopLoader()
                completetionBlock(nil,error as NSError,false)
            }
            }
        }
    }
    
    class func getChatMesages(VC: UIViewController,
                              page_index: Int,
                              request_id: Int,
                              completetionBlock: @escaping ([[String : Any]]?, _ error:NSError?, Bool, Bool, String) -> Void){
        print(#function)
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        
        StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
        
        let parameters : Parameters =  ["page_no": page_index,
                                        "timezone": TimeZone.current.identifier,
                                        "user_type":"H",
                                        "request_id":request_id]
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
        
        print(parameters,header)
        
        AF.request(baseURL + kAPIMethods.get_chat_message, method: .post, parameters: parameters,headers: header).responseJSON { (response) in
            DispatchQueue.main.async {
            switch response.result {
            case .success:
                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200{
                    let res = response.value as! [String: Any]
                    
                    let requestId = (res["request_id"] as? String) ?? "0"

                    let job_status = (res["job_status"] as? Bool) ?? false
                    let nextPageAvailable = (res["next_page"] as? Bool) ?? false
                    completetionBlock((res["data"] as! [[String: Any]]),nil,nextPageAvailable, job_status, requestId)
                }
                else if response.response?.statusCode == 204{
                    completetionBlock(nil,nil,false,false, "")
                }
                else if response.response?.statusCode == 401{
                    StaticHelper.shared.stopLoader()
                    let responseJson = response.value as! [String: AnyObject]
                    VC.view.makeToast(responseJson["message"] as? String)
                }
            case .failure(let error):
                
                StaticHelper.shared.stopLoader()
                completetionBlock(nil,error as NSError,false,false, "")
            }
            }
        }
    }
    class func getAdminChatMesages(_ isLoader:Bool = false, VC: UIViewController, page_index: Int,chat_id: Int, completetionBlock: @escaping ([[String : Any]]?, _ error:NSError?,Bool,Bool) -> Void){
        print(#function)
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        if !isLoader{
            StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
        }
        let parameters : Parameters =  ["page_no": page_index, "timezone": TimeZone.current.identifier]//receiver_id":chat_id
//        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!,"Content-Type":"application/json"]
        print(parameters,header)
        
        AF.request(baseURL + kAPIMethods.get_admin_chat_msg, method: .post, parameters: parameters,encoding: JSONEncoding.default,headers: header).responseJSON { (response) in

            DispatchQueue.main.async {
//                let res = response.value as! [String: Any]
//
//                print("Admin chat msg = \(res["data"] as! [[String: Any]])")
            switch response.result {
            case .success:
                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200{
                    let res = response.value as! [String: Any]
                    let job_status = (res["job_status"] as? Bool) ?? false
                    let nextPageAvailable = (res["next_page"] as? Bool) ?? false
                    completetionBlock((res["data"] as! [[String: Any]]),nil,nextPageAvailable,job_status)
                }
                else if response.response?.statusCode == 204{
                    completetionBlock(nil,nil,false,false)
                }
                else if response.response?.statusCode == 401{
                    StaticHelper.shared.stopLoader()
                    let responseJson = response.value as! [String: AnyObject]
                    VC.view.makeToast(responseJson["message"] as? String)
                }
            case .failure(let error):
                StaticHelper.shared.stopLoader()
                completetionBlock(nil,error as NSError,false,false)
            }
            }
        }
    }
    class func getHelperChatMesages(VC: UIViewController,
                                    page_index: Int,
                                    receiver_id: Int,
                                    request_id: String,
                                    completetionBlock: @escaping ([[String : Any]]?, _ error:NSError?,Bool,Bool, String) -> Void){
        print(#function)
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        
        StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
        
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
        
        let parameters : Parameters =  ["page_no": page_index,
                                        "timezone": TimeZone.current.identifier,
                                        "receiver_id":receiver_id,
                                        "request_id":request_id]
        
        print(parameters,header)
        
        AF.request(baseURL + kAPIMethods.get_helper_chat_message, method: .post, parameters: parameters,headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
            switch response.result {
            case .success:
                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200{
                    let res = response.value as! [String: Any]
                    print("Helper Chat :- \(res)")
                    let requestId = String((res["request_id"] as? Int) ?? 0)
                    let job_status = (res["job_status"] as? Bool) ?? false
                    let nextPageAvailable = (res["next_page"] as? Bool) ?? false
                    completetionBlock((res["data"] as! [[String: Any]]),nil,nextPageAvailable,job_status, requestId)
                }
                else if response.response?.statusCode == 204{
                    completetionBlock(nil,nil,false,false, "")
                }
                else if response.response?.statusCode == 401{
                    StaticHelper.shared.stopLoader()
                    let responseJson = response.value as! [String: AnyObject]
                    VC.view.makeToast(responseJson["message"] as? String)
                }
            case .failure(let error):
                StaticHelper.shared.stopLoader()
                completetionBlock(nil,error as NSError,false,false, "")
            }
            }
        }
    }
    
    class func sendMessages(VC: UIViewController, params: [String: Any], completetionBlock: @escaping ([String : Any]?, _ error:NSError?,Bool) -> Void){
        print(#function)
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }

        StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)

        let parameters : Parameters =  params
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]

        print(parameters,header)

        AF.request(baseURL + kAPIMethods.send_message, method: .post, parameters: parameters,headers: header).responseJSON { (response) in
            DispatchQueue.main.async {
            switch response.result {
            case .success:
                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200{
                    let res = response.value as! [String: Any]
                    let respo = (res["data"] as! [[String: Any]]).first
                    completetionBlock(respo,nil,true)
                }
                else if response.response?.statusCode == 204{
                    completetionBlock(nil,nil,false)
                }
                else if response.response?.statusCode == 202{
                    StaticHelper.shared.stopLoader()
                    let responseJson = response.value as! [String: AnyObject]
                    VC.view.makeToast(responseJson["message"] as? String)
                }
                else if response.response?.statusCode == 401{
                    StaticHelper.shared.stopLoader()
                    let responseJson = response.value as! [String: AnyObject]
                    VC.view.makeToast(responseJson["message"] as? String)
                }
            case .failure(let error):
                StaticHelper.shared.stopLoader()
                completetionBlock(nil,error as NSError,false)
            }
            }
        }
    }
    
    class func sendMessageToAdmin(VC: UIViewController, params: [String: Any], completetionBlock: @escaping ([String : Any]?, _ error:NSError?,Bool) -> Void){
        print(#function)
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        
        StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
        
        let parameters : Parameters =  params
//        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!,"Content-Type":"application/json"]
//        ""
        print(parameters,header)
        AF.request(baseURL + kAPIMethods.helper_to_admin_send_message, method: .post, parameters: parameters,encoding: JSONEncoding.default,headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
//                let res = response.value as! [String: Any]
//
//                print("Send msg to Admin = \(res["data"] as! [[String: Any]])")
//                print("Error = \(Error)")

            switch response.result {
            case .success:
                StaticHelper.shared.stopLoader()
                
                if response.response?.statusCode == 200{
                    let res = response.value as! [String: Any]
                    print("Res = \(res)")
                    let respo = (res["data"] as! [String: Any])

                    completetionBlock(respo,nil,true)
                }
                else if response.response?.statusCode == 204{
                    completetionBlock(nil,nil,false)
                }
                else if response.response?.statusCode == 202{
                    StaticHelper.shared.stopLoader()
                    let responseJson = response.value as! [String: AnyObject]
                    VC.view.makeToast(responseJson["message"] as? String)
                }
                else if response.response?.statusCode == 401{
                    StaticHelper.shared.stopLoader()
                    let responseJson = response.value as! [String: AnyObject]
                    VC.view.makeToast(responseJson["message"] as? String)
                }
            case .failure(let error):
                StaticHelper.shared.stopLoader()
                completetionBlock(nil,error as NSError,false)
            }
            }
        }
    }
    class func sendMessageToHelper(VC: UIViewController, params: [String: Any], completetionBlock: @escaping ([String : Any]?, _ error:NSError?,Bool) -> Void){
        print(#function)
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        
        StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
        
        let parameters : Parameters =  params
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
        
        print(parameters,header)
        
        AF.request(baseURL + kAPIMethods.helper_to_helper_send_message, method: .post, parameters: parameters,headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
            switch response.result {
            case .success:
                StaticHelper.shared.stopLoader()
                
                if response.response?.statusCode == 200{
                    let res = response.value as! [String: Any]
                    let respo = (res["data"] as! [[String: Any]]).first
                    completetionBlock(respo,nil,true)
                }
                else if response.response?.statusCode == 204{
                    completetionBlock(nil,nil,false)
                }
                else if response.response?.statusCode == 202{
                    StaticHelper.shared.stopLoader()
                    let responseJson = response.value as! [String: AnyObject]
                    VC.view.makeToast(responseJson["message"] as? String)
                }
                else if response.response?.statusCode == 401{
                    StaticHelper.shared.stopLoader()
                    let responseJson = response.value as! [String: AnyObject]
                    VC.view.makeToast(responseJson["message"] as? String)
                }
            case .failure(let error):
                StaticHelper.shared.stopLoader()
                completetionBlock(nil,error as NSError,false)
            }
            }
        }
    }
    
    class func getAdminChatCountMessage(VC: UIViewController, completetionBlock: @escaping ([String : Any]?, _ error:NSError?,Bool) -> Void){
        print(#function)
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        
        StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
        
        AF.request(baseURL + kAPIMethods.get_admin_chat_count_message+"?timezone="+TimeZone.current.identifier, headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
                switch response.result {
                case .success:
                    StaticHelper.shared.stopLoader()
                    if response.response?.statusCode == 200{
                        let res = response.value as! [String: Any]
                        completetionBlock(res,nil,true)
                    }
                    else if response.response?.statusCode == 204{
                        completetionBlock(nil,nil,false)
                    } else if(response.response?.statusCode == 401){
                        clearData(VC: VC)
                    }else if (response.response?.statusCode == 403){
                        StaticHelper.shared.stopLoader()
                        appDelegate.showBlockedMessage()
                    }

                case .failure(let error):
                    StaticHelper.shared.stopLoader()
                    completetionBlock(nil,error as NSError,false)
                }
            }
        }
    }
    class func getProfile(_ isRejectedKey:Bool=false, VC: UIViewController, completetionBlock: @escaping ([String : Any]?, _ error:NSError?,Bool) -> Void){
        print(#function)
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
        if OnboardService.isPrintLog{
            print("\n***********************START********************\n")
            print("Header :\n",header)
            print("Base URL :\n",(baseURL + kAPIMethods.get_helper_info))
        }
        var finalUrl = "\(baseURL + kAPIMethods.get_helper_info+"?timezone="+TimeZone.current.identifier)"
        if isRejectedKey{
            finalUrl = finalUrl + "&is_reject_read=1"
        }
        AF.request(finalUrl, headers: header).responseJSON { (response) in
            if OnboardService.isPrintLog{print("Get Profile Response :\n",response)}
            DispatchQueue.main.async {
            switch response.result {
            case .success:

                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200{
                     let res = response.value as! [String: Any]
                    completetionBlock(res,nil,true)
                }else if response.response?.statusCode == 204{
                    completetionBlock(nil,nil,false)
                }else if response.response?.statusCode == 401{
                    clearData(VC: VC)
                }else if response.response?.statusCode == 403{
                    let responseJson = response.value as! [String: AnyObject]
                    VC.view.makeToast(responseJson["message"] as? String)
                }
            case .failure(let error):
                if OnboardService.isPrintLog{print("Error :\n",error)}
                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 401{
                    clearData(VC: VC)
                }else{
                    completetionBlock(nil,error as NSError,false)
                }
            }
                if OnboardService.isPrintLog{print("\n***********************END********************\n")}

            }
        }
    }

    class func saveRange(VC: UIViewController, range: Int, completetionBlock: @escaping ([String : Any]?, _ error:NSError?,Bool) -> Void){
        print(#function)
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        
        StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
        
        let parameters : Parameters =  ["range": range]
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
        
        print(parameters,header)
        
        AF.request(baseURL + kAPIMethods.save_range, method: .post, parameters: parameters,headers: header).responseJSON { (response) in
            DispatchQueue.main.async {
            switch response.result {
            case .success:
                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200{
                    let res = response.value as! [String: Any]
                    completetionBlock(res,nil,true)
                    UIApplication.shared.keyWindow?.rootViewController!.view.makeToast("Range updated successfully.")
                }
                else if response.response?.statusCode == 401{
                    StaticHelper.shared.stopLoader()
                    let responseJson = response.value as! [String: AnyObject]
                    VC.view.makeToast(responseJson["message"] as? String)
                }
            case .failure(let error):
                
                StaticHelper.shared.stopLoader()
                completetionBlock(nil,error as NSError,false)
                UIApplication.shared.keyWindow?.rootViewController!.view.makeToast("Internal Server Error. Sorry for inconvenience, Please try again later.")
            }
            }
        }
    }
    
    class func setNotificationDays(VC: UIViewController, params: [String: Any], completetionBlock: @escaping ([String : Any]?, _ error:NSError?,Bool) -> Void){
        print(#function)
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        
        StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
        
        let parameters : Parameters = params
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
        
        print(parameters,header)
        
        AF.request(baseURL + kAPIMethods.set_notification_days, method: .post, parameters: parameters,encoding: JSONEncoding.default ,headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
            switch response.result {
            case .success:
                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200{
                    
                    let res = response.value as! [String: Any]
                    UIApplication.shared.keyWindow?.rootViewController!.view.makeToast("Notification Info updated successfully.")
                    completetionBlock(res,nil,true)
                }
                else if response.response?.statusCode == 401{
                    StaticHelper.shared.stopLoader()
                }
            case .failure(let error):
                StaticHelper.shared.stopLoader()
                completetionBlock(nil,error as NSError,false)
            }
            }
        }
    }
    
    class func getHelperNotification(VC: UIViewController, page_index: Int, completetionBlock: @escaping ([[String : Any]]?, _ error:NSError?,Bool) -> Void){
        print(#function)
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        
        StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
        
        let parameters : Parameters =  ["page_no": page_index, "timezone": TimeZone.current.identifier]
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
        
        print(parameters,header)
        
        AF.request(baseURL + kAPIMethods.get_helper_notification, method: .post, parameters: parameters,headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
            switch response.result {
                
            case .success:
                StaticHelper.shared.stopLoader()
                
                if response.response?.statusCode == 200{
                    
                    let res = response.value as! [String: Any]
                    let nextPageAvailable = (res["next_page"] as! Bool)
                    completetionBlock((res["data"] as! [[String: Any]]),nil,nextPageAvailable)
                }
                else if response.response?.statusCode == 204{
                    completetionBlock(nil,nil,false)
                }
                else if response.response?.statusCode == 401{
                    StaticHelper.shared.stopLoader()
                }
            case .failure(let error):
                StaticHelper.shared.stopLoader()
                completetionBlock(nil,error as NSError,false)
            }
            }
        }
    }
    
    class func getDiscountHelperNotification(VC: UIViewController, page_index: Int, notification_type:String, completetionBlock: @escaping ([[String : Any]]?, _ error:NSError?,Bool) -> Void){
        print(#function)
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        
        StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
        
        let parameters : Parameters =  [
            "page_no": page_index,
            "timezone": TimeZone.current.identifier,
            "notification_type":notification_type,
        ]
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
        
        print(parameters,header)
        
        AF.request(baseURL + kAPIMethods.get_helper_notification_list, method: .post, parameters: parameters,headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
            switch response.result {
                
            case .success:
                StaticHelper.shared.stopLoader()
                if OnboardService.isPrintLog{print("HelperNotification :\n",response)}

                if response.response?.statusCode == 200{
                    
                    let res = response.value as! [String: Any]
                    let nextPageAvailable = (res["next_page"] as! Bool)
                    completetionBlock((res["data"] as! [[String: Any]]),nil,nextPageAvailable)
                }
                else if response.response?.statusCode == 204{
                    completetionBlock(nil,nil,false)
                }
                else if response.response?.statusCode == 401{
                    StaticHelper.shared.stopLoader()
                }
            case .failure(let error):
                StaticHelper.shared.stopLoader()
                completetionBlock(nil,error as NSError,false)
            }
            }
        }
    }
    
    class func setAvailability(VC: UIViewController, params: [String: Any], completetionBlock: @escaping ([String : Any]?, _ error:NSError?,Bool) -> Void){
        print(#function)
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        
        StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
        
        let parameters : Parameters = params
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
        
        print(parameters,header)
        
        AF.request(baseURL + kAPIMethods.set_helper_availability_slot, method: .post, parameters: parameters,headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
            switch response.result {
            case .success:
                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200{
                    let res = response.value as! [String: Any]
                    UIApplication.shared.keyWindow?.rootViewController!.view.makeToast("Availability mode updated successfully.")
                    completetionBlock(res,nil,true)
                }
                else if response.response?.statusCode == 401{
                    StaticHelper.shared.stopLoader()
                }
            case .failure(let error):
                
                StaticHelper.shared.stopLoader()
                completetionBlock(nil,error as NSError,false)
                UIApplication.shared.keyWindow?.rootViewController!.view.makeToast("Internal Server Error. Sorry for inconvenience, Please try again later.")
            }
            }
        }
    }
    
    class func getAvailability(VC: UIViewController, params: [String: Any], completetionBlock: @escaping ([String : Any]?, _ error:NSError?,Bool) -> Void){
        print(#function)
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        
        StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
        
        let parameters : Parameters = params
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
        
        print(parameters,header)
        
        AF.request(baseURL + kAPIMethods.helper_time_slot, method: .post, parameters: parameters,headers: header).responseJSON { (response) in
            DispatchQueue.main.async {
            switch response.result {
            case .success:
                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200{
                    let res = response.value as! [String: Any]
                    completetionBlock(res,nil,true)
                }
                else if response.response?.statusCode == 401{
                    StaticHelper.shared.stopLoader()
                }
            case .failure(let error):
                
                StaticHelper.shared.stopLoader()
                completetionBlock(nil,error as NSError,false)
                UIApplication.shared.keyWindow?.rootViewController!.view.makeToast("Internal Server Error. Sorry for inconvenience, Please try again later.")
            }
            }
        }
    }
    
    class func saveQuery(VC: UIViewController, params: [String: Any], completetionBlock: @escaping ([String : Any]?, _ error:NSError?,Bool) -> Void){
        print(#function)
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        
        StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
        
        let parameters : Parameters = params
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
        

        
        AF.request(baseURL + kAPIMethods.save_helper_query, method: .post, parameters: parameters,headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
            switch response.result {
            case .success:
                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200{
                    let res = response.value as! [String: Any]
                    completetionBlock(nil,nil,true)
                }
                else if response.response?.statusCode == 401{
                    StaticHelper.shared.stopLoader()
                }
            case .failure(let error):
                StaticHelper.shared.stopLoader()
                completetionBlock(nil,error as NSError,false)
            }
            }
        }
    }
    
    class func saveAgreement(VC: UIViewController, params: [String: Any], completetionBlock: @escaping ([String : Any]?, _ error:NSError?,Bool) -> Void){
        print(#function)
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        
        StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
        
        let parameters : Parameters = params
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
        
        print(parameters,header)
        
        AF.request(baseURL + kAPIMethods.save_helper_agreement, method: .post, parameters: parameters,headers: header).responseJSON { (response) in
            DispatchQueue.main.async {
            switch response.result {
            case .success:
                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200{
                    UserCache.shared.updateUserProperty(forKey: kUserCache.is_agree, withValue: 1 as AnyObject)
                    completetionBlock(nil,nil,true)
                }
                else if response.response?.statusCode == 401{
                    StaticHelper.shared.stopLoader()
                }
            case .failure(let error):
                StaticHelper.shared.stopLoader()
                completetionBlock(nil,error as NSError,false)
            }
            }
        }
    }
    
    class func saveSecurityKey(VC: UIViewController, params: [String: Any], completetionBlock: @escaping ([String : Any]?, _ error:NSError?,Bool) -> Void){
        print(#function)
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        
        StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
        
        let parameters : Parameters = params
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
        
        print(parameters,header)
        
        AF.request(baseURL + kAPIMethods.add_helper_security_key, method: .post, parameters: parameters,headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
            switch response.result {
            case .success:
                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200{
                    UserCache.shared.updateUserProperty(forKey: kUserCache.is_security_key_added, withValue: 1 as AnyObject)
                    completetionBlock(nil,nil,true)
                }
                else if response.response?.statusCode == 401{
                    StaticHelper.shared.stopLoader()
                }
            case .failure(let error):
                StaticHelper.shared.stopLoader()
                completetionBlock(nil,error as NSError,false)
            }
            }
        }
    }
    
    class func createMerchantUrl(VC: UIViewController, completetionBlock: @escaping ([String : Any]?, _ error:NSError?,Bool) -> Void){
        print(#function)
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        
        StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
        
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
        
        AF.request(baseURL + kAPIMethods.create_merchant_url,method: .get,headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
            switch response.result {
            case .success:
                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200{
                    let res = response.value as! [String: Any]
                    completetionBlock(res,nil,true)
                }
                else if response.response?.statusCode == 401{
                    StaticHelper.shared.stopLoader()
                }
            case .failure(let error):
                StaticHelper.shared.stopLoader()
                completetionBlock(nil,error as NSError,false)
            }
            }
        }
    }
    
    class func saveRatings(VC: UIViewController, params: [String: Any], completetionBlock: @escaping ([String : Any]?, _ error:NSError?,Bool) -> Void){
        print(#function)

          if !StaticHelper.Connectivity.isConnectedToInternet {
              StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
              return
          }
          
          StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
          
          let parameters : Parameters = params
          let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
          
          print(parameters,header)
          AF.request(baseURL + kAPIMethods.submit_customer_review, method: .post, parameters: parameters,headers: header).responseJSON { (response) in
              
              DispatchQueue.main.async {
              switch response.result {
              case .success:
                  StaticHelper.shared.stopLoader()
                  if response.response?.statusCode == 200{
                      completetionBlock(nil,nil,true)
                  }
                else if response.response?.statusCode == 401{
                    StaticHelper.shared.stopLoader()
                    let responseJson = response.value as! [String: AnyObject]
                    VC.view.makeToast(responseJson["message"] as? String)
                }
              case .failure(let error):
                  StaticHelper.shared.stopLoader()
                  completetionBlock(nil,error as NSError,false)
              }
              }
          }
      }
    
    class func getHelperAccountingInfo(VC: UIViewController, page_index: Int, completetionBlock: @escaping ([String : Any]?, _ error:NSError?,Bool) -> Void){
        print(#function)
           if !StaticHelper.Connectivity.isConnectedToInternet {
               StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
               return
           }
           
           StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
           
           let parameters : Parameters =  ["page_no": page_index, "timezone": TimeZone.current.identifier]
           let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
           
           print(parameters,header)
           
           AF.request(baseURL + kAPIMethods.get_helper_accounting_info, method: .post, parameters: parameters,headers: header).responseJSON { (response) in
               
               DispatchQueue.main.async {
               switch response.result {
               case .success:
                   StaticHelper.shared.stopLoader()
                   if response.response?.statusCode == 200{
                       let res = response.value as! [String: Any]
                       completetionBlock((res["data"] as! [String: Any]),nil,true)
                   }
                   else if response.response?.statusCode == 204{
                       completetionBlock(nil,nil,false)
                   }
                else if response.response?.statusCode == 401{
                    StaticHelper.shared.stopLoader()
                }
               case .failure(let error):
                   StaticHelper.shared.stopLoader()
                   completetionBlock(nil,error as NSError,false)
               }
               }
           }
       }
    
    class func getHelperTipPaymentInfo(VC: UIViewController, page_index: Int, completetionBlock: @escaping ([String : Any]?, _ error:NSError?,Bool) -> Void){
        print(#function)
           if !StaticHelper.Connectivity.isConnectedToInternet {
               StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
               return
           }
           
           StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
           
           let parameters : Parameters =  ["page_no": page_index, "timezone": TimeZone.current.identifier]
           let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
           
           print(parameters,header)
           
           AF.request(baseURL + kAPIMethods.get_helper_tip_accounting_info, method: .post, parameters: parameters,headers: header).responseJSON { (response) in
               
               DispatchQueue.main.async {
               switch response.result {
               case .success:
                   StaticHelper.shared.stopLoader()
                   if response.response?.statusCode == 200{
                       let res = response.value as! [String: Any]
                       completetionBlock((res["data"] as! [String: Any]),nil,true)
                   }
                   else if response.response?.statusCode == 204{
                       completetionBlock(nil,nil,false)
                   }
                else if response.response?.statusCode == 401{
                    StaticHelper.shared.stopLoader()
                    let responseJson = response.value as! [String: AnyObject]
                    VC.view.makeToast(responseJson["message"] as? String)
                }
               case .failure(let error):
                   StaticHelper.shared.stopLoader()
                   completetionBlock(nil,error as NSError,false)
               }
               }
           }
       }
    
    
    class func savePaypalInfo(VC: UIViewController, params: [String: Any], completetionBlock: @escaping ([String : Any]?, _ error:NSError?,Bool) -> Void){
        print(#function)

            if !StaticHelper.Connectivity.isConnectedToInternet {
                StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
                return
            }
            
            StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
            
            let parameters : Parameters = params
            let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
            
            print(parameters,header)
            
            AF.request(baseURL + kAPIMethods.save_helper_paypal_id, method: .post, parameters: parameters,headers: header).responseJSON { (response) in
                
                DispatchQueue.main.async {
                switch response.result {
                case .success:
                    StaticHelper.shared.stopLoader()
                    if response.response?.statusCode == 200{
                        completetionBlock(nil,nil,true)
                    }
                    else if response.response?.statusCode == 401{
                        StaticHelper.shared.stopLoader()
                        let responseJson = response.value as! [String: AnyObject]
                        VC.view.makeToast(responseJson["message"] as? String)
                    }
                case .failure(let error):
                    StaticHelper.shared.stopLoader()
                    completetionBlock(nil,error as NSError,false)
                }
                }
            }
        }
    
    class func reportAProblem(VC: UIViewController, params: [String: Any], completetionBlock: @escaping ([String : Any]?, _ error:NSError?,Bool) -> Void){
        print(#function)
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        
        StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
        
        let parameters : Parameters = params
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]

        AF.request(baseURL + kAPIMethods.helper_report, method: .post, parameters: parameters,headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
            switch response.result {
            case .success:
                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200{
                    completetionBlock(nil,nil,true)
                }
                else if response.response?.statusCode == 401{
                    StaticHelper.shared.stopLoader()
                    let responseJson = response.value as! [String: AnyObject]
                    VC.view.makeToast(responseJson["message"] as? String)
                }
            case .failure(let error):
                StaticHelper.shared.stopLoader()
                completetionBlock(nil,error as NSError,false)
            }
            }
        }
    }
    
    class func getCustomerDetailUrl(VC: UIViewController,customerId: String, completetionBlock: @escaping ([String : Any]?, _ error:NSError?,Bool) -> Void){
        print(#function)
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        
        StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
        
        AF.request(baseURL + kAPIMethods.customer_detail_by_helper+"\(customerId)",method: .get,headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
            switch response.result {
            case .success:
                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200{
                    let res = response.value as! [String: Any]
                    completetionBlock(res,nil,true)
                }
                else if response.response?.statusCode == 401{
                    StaticHelper.shared.stopLoader()
                    let responseJson = response.value as! [String: AnyObject]
                    VC.view.makeToast(responseJson["message"] as? String)
                }
            case .failure(let error):
                StaticHelper.shared.stopLoader()
                completetionBlock(nil,error as NSError,false)
            }
            }
        }
    }
    
    class func getHelperConfirmationReason(VC: UIViewController, completetionBlock: @escaping ([String : Any]?, _ error:NSError?,Bool) -> Void){
        print(#function)
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
        AF.request(baseURL + kAPIMethods.get_confirm_reason, method: .get,headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
            switch response.result {
            case .success:
                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200{
                    let res = response.value as! [String: Any]
                    completetionBlock(res,nil,true)
                }
//                else if response.response?.statusCode == 401{
//                    StaticHelper.shared.stopLoader()
//                    let responseJson = response.value as! [String: AnyObject]
//                    VC.view.makeToast(responseJson["message"] as? String)
//                }
            case .failure(let error):
                StaticHelper.shared.stopLoader()
                completetionBlock(nil,error as NSError,false)
            }
            }
        }
    }
    
    class func gewthelperInfofromId(VC: UIViewController, parameter: [String: Any], completetionBlock: @escaping ([String : Any]?, _ error:NSError?,Bool) -> Void){
        
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
        
        let parameters : Parameters =  parameter
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
        
        print(parameters,header)
        
        AF.request(baseURL + kAPIMethods.get_helper_detail_by_id  , method: .post, parameters: parameters,headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
            switch response.result {
            case .success:
                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200{
                    let res = response.value as! [String: Any]
                    completetionBlock( res,nil,true)
                } else if response.response?.statusCode == 204{
                    completetionBlock(nil,nil,false)
                } else if(response.response?.statusCode == 401){
                    completetionBlock(nil,nil,false)
                }
            case .failure(let error):
                StaticHelper.shared.stopLoader()
                completetionBlock(nil,error as NSError,false)
            }
            }
        }
    }
    
    //Crash is here
    class func getHelperNotificationCount(_ isLoaderHide:Bool = false, VC: UIViewController, completetionBlock: @escaping ([String : Any]?, _ error:NSError?,Bool) -> Void){
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        if !isLoaderHide{
            StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
        }
        let parameters : Parameters =  ["page_no": "1", "timezone": TimeZone.current.identifier]
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken() ?? ""]
        print(parameters,header)
        
        AF.request(baseURL + kAPIMethods.get_helper_notification_count, method: .post, parameters: parameters,headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
            switch response.result {
            case .success:
                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200{
                    let res = response.value as! [String: Any]
                    debugPrint("Response \(res)")
                    completetionBlock(res,nil,true)
                }
                else if response.response?.statusCode == 204{
                    completetionBlock(nil,nil,false)
                } else if(response.response?.statusCode == 401){
                    clearData(VC: VC)
                }else if (response.response?.statusCode == 403){
                    StaticHelper.shared.stopLoader()
                    appDelegate.showBlockedMessage()
                }

            case .failure(let error):
                StaticHelper.shared.stopLoader()
                completetionBlock(nil,error as NSError,false)
            }
            }
        }
    }
    
    
    class func getDefaultValueAPICall(VC: UIViewController, completetionBlock: @escaping ([[String : Any]]?, _ error:NSError?,Bool) -> Void){

        print(#function)
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        
        StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
        
        AF.request(baseURL + kAPIMethods.get_cities, method: .get,headers: header).responseJSON { (response) in
            DispatchQueue.main.async {
            switch response.result {
            case .success:
                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200{
                    let res = response.value as! [[String: Any]]
                    completetionBlock(res,nil,true)
                }
                else if response.response?.statusCode == 401{
                    StaticHelper.shared.stopLoader()
                    let responseJson = response.value as! [String: AnyObject]
                    VC.view.makeToast(responseJson["message"] as? String)
                }
            case .failure(let error):
                StaticHelper.shared.stopLoader()
                completetionBlock(nil,error as NSError,false)
            }
            }
        }
    }
    class func getCitiesAPICall(VC: UIViewController, completetionBlock: @escaping ([[String : Any]]?, _ error:NSError?,Bool) -> Void){

        print(#function)
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        
        StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
        
        AF.request(baseURL + kAPIMethods.get_cities, method: .get,headers: header).responseJSON { (response) in
            DispatchQueue.main.async {
            switch response.result {
            case .success:
                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200{
                    let res = response.value as! [[String: Any]]
                    completetionBlock(res,nil,true)
                }
                else if response.response?.statusCode == 401{
                    StaticHelper.shared.stopLoader()
                    let responseJson = response.value as! [String: AnyObject]
                    VC.view.makeToast(responseJson["message"] as? String)
                }
            case .failure(let error):
                StaticHelper.shared.stopLoader()
                completetionBlock(nil,error as NSError,false)
            }
            }
        }
    }
    class func postHelperAppRating(VC: UIViewController, move_id: Int, rating: Int, message:String, completetionBlock: @escaping (String, _ error:NSError?,Bool) -> Void){
        
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        
        StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
        
        let parameters : Parameters =  ["move_id": move_id,"rating": rating, "review": message]

        print(parameters, header)
        
        AF.request(baseURL + kAPIMethods.helper_app_rating, method: .post, parameters: parameters, headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
            switch response.result {
            case .success:
                StaticHelper.shared.stopLoader()

                if response.response?.statusCode == 200 {
                    let res = response.value as? String ?? ""
                    completetionBlock("", nil, true)
                } else if response.response?.statusCode == 204 {
                    completetionBlock("", nil, true)
                } else if(response.response?.statusCode == 401) {
                    StaticHelper.shared.stopLoader()
                    let responseJson = response.value as! [String: AnyObject]
                    VC.view.makeToast(responseJson["message"] as? String)
                }
            case .failure(let error):
                StaticHelper.shared.stopLoader()
                completetionBlock("",error as NSError,false)
                if(response.response?.statusCode == 401) {
                    StaticHelper.shared.stopLoader()
                    let responseJson = response.value as! [String: AnyObject]
                    VC.view.makeToast(responseJson["message"] as? String)
                } else {
//                    VC.showInternalServerError()
                }
            }
            }
        }
    }
    class func getHelperAppRating(VC: UIViewController, move_id: Int, completetionBlock: @escaping ([String : Any]?, _ error:NSError?, Bool) -> Void){
        
        print(#function)
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        
        StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
        
        AF.request(baseURL + kAPIMethods.get_helper_app_rating+"?move_id="+String(move_id), method: .get, parameters: [:], headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
            switch response.result {
            case .success:
                StaticHelper.shared.stopLoader()

                if response.response?.statusCode == 200 {
                    let res = response.value as! [String: Any]
                    completetionBlock(res, nil, true)
                } else if response.response?.statusCode == 204 {
                    completetionBlock([String: Any](), nil, true)
                } else if(response.response?.statusCode == 401) {
                    StaticHelper.shared.stopLoader()
                    let responseJson = response.value as! [String: AnyObject]
                    VC.view.makeToast(responseJson["message"] as? String)
                }
            case .failure(let error):
                StaticHelper.shared.stopLoader()
                completetionBlock(nil,error as NSError,false)
                if(response.response?.statusCode == 401) {
                    StaticHelper.shared.stopLoader()
                    let responseJson = response.value as! [String: AnyObject]
                    VC.view.makeToast(responseJson["message"] as? String)
                } else {
                    completetionBlock(nil,error as NSError,false)
                }
            }
            }
        }
    }
    
    class func getHelperRejectionMessage(VC: UIViewController, completetionBlock: @escaping ([String : Any]?, _ error:NSError?, Bool) -> Void){
        
        print(#function)
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        
        StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
        
        AF.request(baseURL + kAPIMethods.helper_rejection_message, method: .get, parameters: [:], headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
            switch response.result {
            case .success:
                StaticHelper.shared.stopLoader()

                if response.response?.statusCode == 200 {
                    let res = response.value as! [String: Any]
                    completetionBlock(res, nil, true)
                } else if response.response?.statusCode == 204 {
                    completetionBlock([String: Any](), nil, true)
                } else if(response.response?.statusCode == 401) {
                    StaticHelper.shared.stopLoader()
                    let responseJson = response.value as! [String: AnyObject]
                    VC.view.makeToast(responseJson["message"] as? String)
                }
            case .failure(let error):
                StaticHelper.shared.stopLoader()
                completetionBlock(nil,error as NSError,false)
                if(response.response?.statusCode == 401) {
                    StaticHelper.shared.stopLoader()
                    let responseJson = response.value as! [String: AnyObject]
                    VC.view.makeToast(responseJson["message"] as? String)
                } else {
                    completetionBlock(nil,error as NSError,false)
                }
            }
            }
        }
    }
    
    //helper_update_pending_move_status
    class func helperUpdatePendingMoveStatusAPICall(VC: UIViewController, params: [String: Any], completetionBlock: @escaping ([String : Any]?, _ error:NSError?,Bool) -> Void) {
        print(#function)

            if !StaticHelper.Connectivity.isConnectedToInternet {
                StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
                return
            }
            
            StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
            
            let parameters : Parameters = params
            let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
            
            print(parameters,header)
            
            AF.request(baseURL + kAPIMethods.helper_update_pending_move_status, method: .post, parameters: parameters,headers: header).responseJSON { (response) in
                
                DispatchQueue.main.async {
                switch response.result {
                case .success:
                    StaticHelper.shared.stopLoader()
                    if response.response?.statusCode == 200{
                        completetionBlock(nil,nil,true)
                    }
                    else if response.response?.statusCode == 401{
                        StaticHelper.shared.stopLoader()
                        let responseJson = response.value as! [String: AnyObject]
                        VC.view.makeToast(responseJson["message"] as? String)
                    }
                case .failure(let error):
                    StaticHelper.shared.stopLoader()
                    completetionBlock(nil,error as NSError,false)
                }
                }
            }
        }

    class func saveHelperW9FormDetailAPICall(VC: UIViewController, params: [String: Any], completetionBlock: @escaping ([String : Any]?, _ error:NSError?,Bool) -> Void) {
        print(#function)

        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        
        StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
        
        let parameters : Parameters = params
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
        
        print(parameters,header)
        
        AF.request(baseURL + kAPIMethods.save_helper_w9_form_detail, method: .post, parameters: parameters,headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
                switch response.result {
                case .success:
                    StaticHelper.shared.stopLoader()
                    if response.response?.statusCode == 200{
                        completetionBlock(nil,nil,true)
                    }
                    else if response.response?.statusCode == 401{
                        StaticHelper.shared.stopLoader()
                        let responseJson = response.value as! [String: AnyObject]
                        VC.view.makeToast(responseJson["message"] as? String)
                    }
                case .failure(let error):
                    StaticHelper.shared.stopLoader()
                    completetionBlock(nil,error as NSError,false)
                }
            }
        }
    }
    
    class func getHelperW9FormDetailAPICall(VC: UIViewController, completetionBlock: @escaping ([String : Any]?, _ error:NSError?,Bool) -> Void) {
        print(#function)

        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        
        StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
        
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
        
        AF.request(baseURL + kAPIMethods.get_helper_w9_form_detail, method: .get, parameters: [:], headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
                switch response.result {
                case .success:
                    StaticHelper.shared.stopLoader()
                    if response.response?.statusCode == 200{
                        let res = response.value as! [String: Any]
                        completetionBlock(res, nil, true)
                    } else if response.response?.statusCode == 401 {
                        StaticHelper.shared.stopLoader()
                        let responseJson = response.value as! [String: AnyObject]
                        VC.view.makeToast(responseJson["message"] as? String)
                        clearData(VC: VC)
                    }
                case .failure(let error):
                    StaticHelper.shared.stopLoader()
                    completetionBlock(nil,error as NSError,false)
                    
                    if response.response?.statusCode == 401{
                        clearData(VC: VC)
                    }
                }
            }
        }
    }
    
    class func finalSubmissionW9FormAPICall(VC: UIViewController, completetionBlock: @escaping ([String : Any]?, _ error:NSError?,Bool) -> Void) {
        print(#function)

        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        
        StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
                
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
                
        AF.request(baseURL + kAPIMethods.final_submission_w9_form, method: .post, parameters: [:],headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
                print("response.result = ", response.result)
                switch response.result {
                case .success:
                    StaticHelper.shared.stopLoader()
                    if response.response?.statusCode == 200{
                        let res = response.value as! [String: Any]
                        completetionBlock(res, nil, true)
                    }
                    else if response.response?.statusCode == 401{
                        StaticHelper.shared.stopLoader()
                        let responseJson = response.value as! [String: AnyObject]
                        VC.view.makeToast(responseJson["message"] as? String)
                    }
                case .failure(let error):
                    StaticHelper.shared.stopLoader()
                    completetionBlock(nil,error as NSError,false)
                }
            }
        }
    }
    
    class func updateHelperDemoStatusAPICall(VC: UIViewController, completetionBlock: @escaping ([String : Any]?, _ error:NSError?,Bool) -> Void) {
        print(#function)

        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        
        StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)

        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken()!]
        AF.request(baseURL + kAPIMethods.update_helper_demo_status, method: .post, parameters: [:],headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
                StaticHelper.shared.stopLoader()
                print("response.result = ", response.result)
                switch response.result {
                case .success:
                    if response.response?.statusCode == 200{
                        let res = response.value as! [String: Any]
                        completetionBlock(res, nil, true)
                    } else if response.response?.statusCode == 401{
                        let responseJson = response.value as! [String: AnyObject]
//                        VC.view.makeToast(responseJson["message"] as? String)
                    }
                case .failure(let error):
                    completetionBlock(nil,error as NSError,false)
                }
            }
        }
    }
    
    class func getHelperLastJobStatus(VC: UIViewController, completetionBlock: @escaping ([String : Any]?, _ error:NSError?,Bool) -> Void){
        if !StaticHelper.Connectivity.isConnectedToInternet {
            StaticHelper.showAlertViewWithTitle(nil, message: APIMessages.internetError, buttonTitles: ["OK"], viewController: VC, completion: nil)
            return
        }
        StaticHelper.shared.startLoader(StaticHelper.mainWindow().rootViewController?.topMostViewController().view ?? VC.view)
        
        let parameters : Parameters =  ["timezone": TimeZone.current.identifier]
        let header : HTTPHeaders = ["Auth-Token":UserCache.userToken() ?? ""]
        
        print(parameters,header)
        AF.request(baseURL + kAPIMethods.get_helper_last_job_status, method: .post, parameters: parameters,headers: header).responseJSON { (response) in
            
            DispatchQueue.main.async {
            switch response.result {
            case .success:
                StaticHelper.shared.stopLoader()
                if response.response?.statusCode == 200{
                    let res = response.value as! [String: Any]
                    completetionBlock(res, nil, true)
                }
                else if response.response?.statusCode == 204{
                    completetionBlock(nil, nil, false)
                } else if(response.response?.statusCode == 401 || response.response?.statusCode == 403) {
                    clearData(VC: VC)
                }
            case .failure(let error):
                StaticHelper.shared.stopLoader()
                completetionBlock(nil,error as NSError,false)
            }
            }
        }
    }
    
    class func clearData(VC: UIViewController) {
        
        StaticHelper.shared.stopLoader()
        LocationUpdateGlobal.shared.stopUpdatingLocation()
        UserCache.shared.clearUserData()
        VC.navigationController?.popToRootViewController(animated: false)
    }

}

