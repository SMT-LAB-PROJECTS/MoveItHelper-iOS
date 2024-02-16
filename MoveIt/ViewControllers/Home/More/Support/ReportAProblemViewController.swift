//
//  ReportAProblemViewController.swift
//  MoveIt
//
//  Created by Dilip Technology on 31/03/21.
//  Copyright © 2021 Jyoti. All rights reserved.
//

import UIKit

class ReportAProblemViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var txtView:UITextView!
    var lblPlaceHolder : UILabel!
    
    @IBOutlet var ViewBG:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle("Report a Problem")

        let leftBarButtonItem = StaticHelper.leftBarButtonWithImageNamed(imageName: "backward_arrow_icon", vc: self)

        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        self.txtView.delegate = self
        self.txtView.layer.cornerRadius = 6.0
        self.txtView.layer.borderColor = UIColor.init(red: 205/255.0, green: 185/255.0, blue: 189/255.0, alpha: 1.0).cgColor
        self.txtView.layer.borderWidth = 1.0
        self.txtView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        lblPlaceHolder = UILabel()
        lblPlaceHolder.text = "Describe your problem here.."
        //lblPlaceHolder.font = UIFont.systemFont(ofSize: txtView.font!.pointSize)
        
        lblPlaceHolder.font = UIFont.josefinSansSemiBoldFontWithSize(size: 13.0)
        lblPlaceHolder.sizeToFit()
        txtView.addSubview(lblPlaceHolder)
        lblPlaceHolder.frame.origin = CGPoint(x: 15, y: 2+(txtView.font?.pointSize)! / 2)
        lblPlaceHolder.textColor = UIColor.lightGray
        lblPlaceHolder.isHidden = !txtView.text.isEmpty
        
        self.ViewBG.layer.masksToBounds = false
        self.ViewBG.layer.shadowColor = UIColor.black.cgColor
        self.ViewBG.layer.shadowOpacity = 0.2
        self.ViewBG.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    @objc func leftButtonPressed(_ selector: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        lblPlaceHolder.isHidden = !textView.text.isEmpty
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let model = UIDevice.modelName
        let version = UIDevice.current.systemVersion
        let app_version = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
        let version_release = "IOS"
        
        if self.txtView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            self.view.makeToast("Please enter your problem.")
            return
        }
        
        let param:[String: Any] = ["message":txtView.text.trimmingCharacters(in: .whitespacesAndNewlines), "model":model, "version":version, "app_version":app_version, "version_release":version_release]

        // API name : helper-report
        CommonAPIHelper.reportAProblem(VC: self, params: param) { (res, err, isExecuted) in
            if isExecuted{
                UIApplication.shared.keyWindow?.rootViewController?.view.makeToast("Report a problem submitted succesfully.")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}


public extension UIDevice {
    
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }

    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod touch (5th generation)"
            case "iPod7,1":                                 return "iPod touch (6th generation)"
            case "iPod9,1":                                 return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPhone12,1":                              return "iPhone 11"
            case "iPhone12,3":                              return "iPhone 11 Pro"
            case "iPhone12,5":                              return "iPhone 11 Pro Max"
            case "iPhone12,8":                              return "iPhone SE (2nd generation)"
            case "iPhone13,1":                              return "iPhone 12 mini"
            case "iPhone13,2":                              return "iPhone 12"
            case "iPhone13,3":                              return "iPhone 12 Pro"
            case "iPhone13,4":                              return "iPhone 12 Pro Max"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
            case "iPad11,6", "iPad11,7":                    return "iPad (8th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad11,3", "iPad11,4":                    return "iPad Air (3rd generation)"
            case "iPad13,1", "iPad13,2":                    return "iPad Air (4th generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad mini (5th generation)"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch) (1st generation)"
            case "iPad8,9", "iPad8,10":                     return "iPad Pro (11-inch) (2nd generation)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch) (1st generation)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "iPad8,11", "iPad8,12":                    return "iPad Pro (12.9-inch) (4th generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "AudioAccessory5,1":                       return "HomePod mini"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }

        return mapToDevice(identifier: identifier)
    }()

}
