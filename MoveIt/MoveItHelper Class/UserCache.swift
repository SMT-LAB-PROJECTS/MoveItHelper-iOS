//
//  UserCache.swift
//  Hasfit
//
//  Created by Dushyant Kumar on 28/09/17.
//  Copyright © 2017 Agicent. All rights reserved.
//

import UIKit

class UserCache: NSObject {
    override init() {
        super.init()
    }
    
    class var shared : UserCache {
        struct Static {
            static let instance = UserCache()
        }
        return Static.instance
    }
    
    class func userToken() -> String? {
       return UserDefaults.standard.object(forKey: kUserCache.auth_key) as? String
    }
    class func getCancalationFeeText() -> String? {
       return UserDefaults.standard.object(forKey: kUserCache.cancalationFeeText) as? String
    }
    class func getCancalationFeeHour() -> String? {
       return UserDefaults.standard.object(forKey: kUserCache.cancalationFeeHour) as? String
    }
    class func gethelperStartServisPoupText() -> String? {
       return UserDefaults.standard.object(forKey: kUserCache.helperStartServisPoupText) as? String
    }
    
    // MARK: - Clear & Save User Data
    func saveUserData(_ userDetails: [String: Any]) {
        let userDefault = UserDefaults.standard
        userDefault.setValue(userDetails[kUserCache.first_name], forKey: kUserCache.first_name)
        userDefault.setValue(userDetails[kUserCache.last_name], forKey: kUserCache.last_name)
        userDefault.setValue(userDetails[kUserCache.phone_num], forKey: kUserCache.phone_num)
        userDefault.setValue(userDetails[kUserCache.helper_id], forKey: kUserCache.helper_id)
        userDefault.setValue(userDetails[kUserCache.auth_key], forKey: kUserCache.auth_key)
        userDefault.setValue(userDetails[kUserCache.is_verified], forKey: kUserCache.is_verified)
        userDefault.setValue(userDetails[kUserCache.is_blocked], forKey: kUserCache.is_blocked)
        userDefault.setValue(userDetails[kUserCache.is_active], forKey: kUserCache.is_active)
        userDefault.setValue(userDetails[kUserCache.photo_url], forKey: kUserCache.photo_url)
        userDefault.setValue(userDetails[kUserCache.completedStep], forKey: kUserCache.completedStep)
        userDefault.setValue(userDetails[kUserCache.service_type], forKey: kUserCache.service_type)
        userDefault.setValue(userDetails[kUserCache.is_agree], forKey: kUserCache.is_agree)
        userDefault.setValue(userDetails[kUserCache.is_security_key_added], forKey: kUserCache.is_security_key_added)
        userDefault.setValue(userDetails[kUserCache.is_payment_method_added], forKey: kUserCache.is_payment_method_added)
        userDefault.setValue(userDetails[kUserCache.paypal_merchant_id] ?? "", forKey: kUserCache.paypal_merchant_id)

        userDefault.synchronize()
    }
    
    class func saveW9UserData(w9_form_status: Int, w9_form_verified: Int) {
        let userDefault = UserDefaults.standard
        userDefault.setValue(w9_form_status, forKey: kUserCache.w9_form_status)
        userDefault.setValue(w9_form_verified, forKey: kUserCache.w9_form_verified)
    }
    
    func saveUserImage(_ profileImageUrlString : String){
        if profileImageUrlString == ""{
            return
        }
        
        let userDefault = UserDefaults.standard
    //    let imageData = try? Data(contentsOf: URL(string: profileImageUrlString)!)
     //   userDefault.setValue(imageData, forKey: kUserCache.profilePicData)
        userDefault.synchronize()
    }
    
    func clearUserData() {
        let userDefault = UserDefaults.standard
        userDefault.setValue(nil, forKey: kUserCache.w9_form_status)
        userDefault.setValue(nil, forKey: kUserCache.w9_form_verified)
    
        userDefault.setValue(nil, forKey: kUserCache.last_name)
        userDefault.setValue(nil, forKey: kUserCache.service_type)
        userDefault.setValue(nil, forKey: kUserCache.first_name)
        userDefault.setValue(nil, forKey: kUserCache.email_id)
        userDefault.setValue(nil, forKey: kUserCache.phone_num)
        userDefault.setValue(nil, forKey: kUserCache.helper_id)
        userDefault.setValue(nil, forKey: kUserCache.auth_key)
        userDefault.setValue(nil, forKey: kUserCache.is_verified)
        userDefault.setValue(nil, forKey: kUserCache.is_blocked)
        userDefault.setValue(nil, forKey: kUserCache.is_active)
        userDefault.setValue(nil, forKey: kUserCache.photo_url)
        userDefault.setValue(nil, forKey: kUserCache.completedStep)
        userDefault.setValue(nil, forKey: kUserCache.is_agree)
        
        userDefault.setValue(nil, forKey: kUserCache.cancalationFeeHour)
        userDefault.setValue(nil, forKey: kUserCache.cancalationFeeText)
        userDefault.setValue(nil, forKey: kUserCache.helperStartServisPoupText)
        userDefault.synchronize()
    }
    
    func updateUserProperty(forKey: String, withValue: AnyObject) {
        let userDefault = UserDefaults.standard
        userDefault.setValue(withValue, forKey: forKey)
        
        userDefault.synchronize()
    }
    
    func userInfo(forKey: String) -> AnyObject? {
        let userDefault = UserDefaults.standard
        
        return userDefault.value(forKey: forKey) as AnyObject?
    }
}

