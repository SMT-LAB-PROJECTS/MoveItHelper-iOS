//
//  StaticHelper.swift
//  MoveIt
//
//  Created by Jyoti on 17/04/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import Foundation
import MBProgressHUD
import Alamofire
import AlamofireImage
import Crashlytics
import FirebaseCrashlytics
import FirebaseAnalytics
import AdSupport

var isProgressShowForce = false

class StaticHelper: NSObject {
    @objc var window: UIWindow?
    
    var progressHud = MBProgressHUD()
    
    class var shared : StaticHelper {
        struct Static {
            static let instance = StaticHelper()
        }
        
        return Static.instance
    }
    
    // MARK: - Network Monitoring
    class Connectivity {
        class var isConnectedToInternet:Bool {
            return NetworkReachabilityManager()!.isReachable
        }
    }
    

    // MARK: - Move To View Controller
    
    class func moveToViewController(_ viewControllerName: String, animated: Bool) {
        
        let window = StaticHelper.mainWindow()
        
        if let navController: UINavigationController = window.rootViewController as? UINavigationController{
            
            if #available(iOS 13.0, *) {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                navController.navigationBar.standardAppearance = appearance;
                navController.navigationBar.scrollEdgeAppearance = appearance
            }

            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: viewControllerName)
            navController.pushViewController(viewController, animated: true)
            
//            if(homeVC == nil) {
//                self.homeVC = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
//                navController.pushViewController(homeVC!, animated: true)
//            } else {
//                homeVC = nil
//                self.homeVC = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
//                navController.pushViewController(homeVC!, animated: true)
//            }
//            return
        } else {
        
        let window = StaticHelper.mainWindow()
        
        if let navController: UINavigationController = window.rootViewController as? UINavigationController{
            
            if #available(iOS 13.0, *) {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                navController.navigationBar.standardAppearance = appearance;
                navController.navigationBar.scrollEdgeAppearance = appearance
            } 

            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            
            let homecontroller = storyBoard.instantiateViewController(withIdentifier: viewControllerName)
            navController.setViewControllers([homecontroller], animated: animated)
            return
        }
        }
    }
    
    class func getViewControllerWithID(_ name: String) -> UIViewController? {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: name)
        return viewController
    }
    
    class func mainWindow() -> UIWindow {
        
        var window: UIWindow?
        let appDelegate: UIApplicationDelegate = UIApplication.shared.delegate!
        // Prefer the window property on the app delegate, if accessible
        if appDelegate.responds(to: #selector(getter: self.window)) {
            window = appDelegate.window!
        }
        // Otherwise fall back on the first window of the app's collection, if present.
        window = window ?? UIApplication.shared.windows.first
        return window!
    }
    
    // Mark : -- MBProgressHUD Loader
    
    func startLoader(_ view:UIView) {
        if progressHud.superview != nil {
            progressHud.hide(animated: false)
        }
        
        progressHud = MBProgressHUD.showAdded(to: view, animated: true)
        
        if #available(iOS 9.0, *) {
            UIActivityIndicatorView.appearance(whenContainedInInstancesOf: [MBProgressHUD.self]).color = UIColor.gray
        } else {
            // Fallback on earlier versions
            progressHud.contentColor = UIColor.gray
        }
        progressHud.bezelView.color = UIColor.clear
        progressHud.contentColor = darkPinkColor
        DispatchQueue.main.async {
//            print("**********************")
            self.progressHud.show(animated: true)
        }
    }
    
    
    func stopLoader() {
        progressHud.hide(animated: true)
    }
    
    //Mark : - ALertviewMethod
    
   class func showAlertViewWithTitle(_ title:String?, message:String, buttonTitles:[String], viewController:UIViewController, completion: ((_ index: Int) -> Void)?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for buttonTitle in buttonTitles {
            let alertAction = UIAlertAction(title: buttonTitle, style: .default, handler: { (action:UIAlertAction) in
                completion?(buttonTitles.index(of: buttonTitle)!)
            })
            alertController .addAction(alertAction)
        }
        viewController .present(alertController, animated: true, completion: nil)
    }
    
    func showActionSheetWithTitle(_ title: String?, message: String?, buttonTitles: [String], viewController: UIViewController, completion: ((_ index: Int) -> Void)?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for buttonTitle in buttonTitles {
            let alertAction = UIAlertAction(title: buttonTitle, style: .default, handler: { (action:UIAlertAction) in
                completion?(buttonTitles.index(of: buttonTitle)!)
            })
            alertController.addAction(alertAction)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        DispatchQueue.main.async {
            if UIDevice.current.userInterfaceIdiom == .pad{
                if alertController.responds(to: #selector(getter: viewController.popoverPresentationController)) {
                    
                    viewController.present(alertController, animated: true, completion:nil)
                }
            }
            else if UIDevice.current.userInterfaceIdiom == .phone {
                viewController.present(alertController, animated: true, completion: {})
            }
        }
        
        //    viewController.present(alertController, animated: true, completion: nil)
    }
    
    
    class func addDoneButton(onKeyboard vc: UIViewController) -> UIToolbar {
        let doneButtonToolBar = UIToolbar(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(320), height: CGFloat(50)))
        doneButtonToolBar.barStyle = .default
        doneButtonToolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: vc, action: Selector(("dismissKeyboard:")))]
        doneButtonToolBar.sizeToFit()
        return doneButtonToolBar
    }
    
    
    static func heightForText(forText text: String, withFixedWidth width: Float, andFont font: UIFont) -> (lines : Int,height : CGFloat) {
        if (text.count ) == 0 {
            return (0,0)
        }
        let size = text.boundingRect(with: CGSize(width: CGFloat(width), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil).size
        return (Int((Double((size.height) / font.pointSize))),ceil(size.height))
    }
    
    class func leftBarButton(withImageNamed imageName: String, forVC vc: UIViewController) -> UIBarButtonItem {
        let leftButton = UIButton(type: .custom)
  
        var leftImage = UIImage(named: imageName)
        leftButton.setImage(leftImage, for: .normal)
        leftButton.addTarget(vc, action: Selector(("leftPressed:")), for: .touchUpInside)
        leftButton.frame = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat((leftImage?.size.width)! + 10*screenHeightFactor ), height: CGFloat((leftImage?.size.height)! + 10*screenHeightFactor))
        let leftItem = UIBarButtonItem(customView: leftButton)
        leftImage = nil
        return leftItem
    }
    
    class func leftBarImage(imageURL:String, vc:UIViewController)->UIBarButtonItem{
        let imgView = UIImageView()
        imgView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        if let url = URL.init(string: imageURL){
         
            imgView.af.setImage(withURL: url)
        }
        
        imgView.layer.cornerRadius = 15.0
        imgView.clipsToBounds = true
        let leftBarButton = UIBarButtonItem(customView: imgView)
        return leftBarButton
    }
    
   class func leftBarButtonWithImageNamed(imageName:String, vc:UIViewController)->UIBarButtonItem{
    
        let leftButton = UIButton(type: .custom)
        var leftImage = UIImage(named: imageName)
        leftButton.setImage(leftImage, for: .normal)
        leftButton.frame = CGRect(x: 0, y: 0, width: leftImage!.size.width + 10*screenHeightFactor, height: leftImage!.size.height + 10*screenHeightFactor)
        leftButton.addTarget(vc, action: Selector(("leftButtonPressed:")), for: .touchUpInside)
    
        let leftBarButton = UIBarButtonItem(customView: leftButton)
        leftImage = nil
        return leftBarButton
    }
    
    class func leftBarButtonWithImage(leftImage:UIImage, vc:UIViewController)->UIBarButtonItem{
        
        let leftButton = UIButton(type: .custom)
        let leftImageT = leftImage
        leftButton.setImage(leftImageT, for: .normal)
        leftButton.frame = CGRect(x: 0, y: 0, width: leftImageT.size.width, height: leftImageT.size.height)

        leftButton.addTarget(vc, action: Selector(("leftButtonPressed:")), for: .touchUpInside)
        leftButton.layer.cornerRadius = 20.0
        leftButton.clipsToBounds = false
        let leftBarButton = UIBarButtonItem(customView: leftButton)
        if adminChatNotificationCount != 0{
            leftBarButton.setBadge(text: "\(adminChatNotificationCount)")
        }
        return leftBarButton
    }
    
    class func rightBarButtonWithText(text:String, vc:UIViewController)->UIBarButtonItem{
        
        let rightButton = UIButton(type: .custom)
        rightButton.setTitle(text, for: .normal)
        rightButton.frame = CGRect(x: 0, y: 0, width: 80.0, height: 30.0)
        rightButton.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 12.0)
        rightButton.addTarget(vc, action: Selector(("rightTextPressed:")), for: .touchUpInside)
        rightButton.layer.cornerRadius = 15.0
        rightButton.layer.borderColor = violetColor.cgColor
        rightButton.layer.borderWidth = 1.0
        rightButton.setTitleColor(violetColor, for: .normal)
        let rightBarButton = UIBarButtonItem(customView: rightButton)
        return rightBarButton
    }
    
    
    class func rightBarButtonWithImageNamed(imageName:String, vc:UIViewController)->UIBarButtonItem{
        
        let rightButton = UIButton(type: .custom)
        var rightImage = UIImage(named: imageName)
        rightButton.setImage(rightImage, for: .normal)
        rightButton.frame = CGRect(x: 0, y: 0, width: rightImage!.size.width, height: rightImage!.size.height)
        rightButton.addTarget(vc, action: Selector(("rightButtonPressed:")), for: .touchUpInside)
        
        let rightBarButton = UIBarButtonItem(customView: rightButton)
        rightImage = nil
        if imageName == "offer-icon-color" {
            if appNotificationCount != 0 {
                rightBarButton.setBadge(text: "\(appNotificationCount)")
            }
        }
        return rightBarButton
    }
    
    class func rightBarButtonWithImageURL(imageName:UIImage, vc:UIViewController)->UIBarButtonItem{
         let rightButton = UIButton(type: .custom)
         var rightImage = imageName
     
            let im = StaticHelper.shared.resizeImage(image: rightImage, targetSize: CGSize.init(width: 40, height: 40))
                  rightButton.setImage(im, for: .normal)
                  
                   rightButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
                   rightButton.addTarget(vc, action: Selector(("rightButtonPressed:")), for: .touchUpInside)
                   rightButton.layer.cornerRadius = 20.0
                   rightButton.clipsToBounds = false
                   let rightBarButton = UIBarButtonItem(customView: rightButton)
                //   rightImage = nil
                   return rightBarButton
       
      
     }
    
    
     class func showActionSheetWithTitle(_ title: String?, message: String?, buttonTitles: [String], viewController: UIViewController, completion: ((_ index: Int) -> Void)?) {
         
         let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
         
         for buttonTitle in buttonTitles {
             let alertAction = UIAlertAction(title: buttonTitle, style: .default, handler: { (action:UIAlertAction) in
                 completion?(buttonTitles.index(of: buttonTitle)!)
             })
             alertController.addAction(alertAction)
         }
         
         alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
         
         DispatchQueue.main.async {
             if UIDevice.current.userInterfaceIdiom == .pad{
                 if alertController.responds(to: #selector(getter: viewController.popoverPresentationController)) {
                     
                     viewController.present(alertController, animated: true, completion:nil)
                 }
             }
             else if UIDevice.current.userInterfaceIdiom == .phone {
                 viewController.present(alertController, animated: true, completion: {})
             }
         }
         
         //    viewController.present(alertController, animated: true, completion: nil)
     }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
           let size = image.size
           
           let widthRatio  = targetSize.width  / size.width
           let heightRatio = targetSize.height / size.height
           
           // Figure out what our orientation is, and use that to form the rectangle
           var newSize: CGSize
           if(widthRatio > heightRatio) {
               newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
           } else {
               newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
           }
           
           // This is the rect that we've calculated out and this is what is actually used below
           let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
           
           // Actually do the resizing to the rect using the ImageContext stuff
           UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
           image.draw(in: rect)
           let newImage = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext()
           
           return newImage!
       }
     
    class func drawDashedLine(_ point1: CGPoint,point2: CGPoint,color: UIColor){
        let  path = UIBezierPath()
        
        path.move(to: point1)
        
        path.addLine(to: point2)
        
        let  dashes: [ CGFloat ] = [ 16.0, 32.0 ]
        path.setLineDash(dashes, count: dashes.count, phase: 0.0)
        path.lineWidth = 8.0
       // path.lineCapStyle = .round
        color.setFill()
        path.stroke()
        
        
    }
    
    class func drawDashesLine(p0: CGPoint,p1: CGPoint,view: UIView,color: UIColor){
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = color.cgColor
        
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [7, 3] // 7 is the length of dash, 3 is length of the gap.
        
        let path = CGMutablePath()
        path.addLines(between: [p0, p1])
        shapeLayer.path = path
        view.layer.addSublayer(shapeLayer)
    }
}


final class CrashLogger {

    static let shared = CrashLogger()

    private init() { }

    func logEvent(_ event: String, withData data: [String: CustomStringConvertible]) {
        let dataString = data.reduce("Event: \(event): ", { (result, element: (key: String, value: CustomStringConvertible)) -> String in
            return result + " (" + element.key + ": " + String(describing: element.value) + " )"
        })
        logEvent(dataString)
    }

    private func logEvent(_ message: String) {
        CLSLogv("%@", getVaList([message]))
    }
}

func callAnalyticsEvent(eventName: String,desc: [String:Any]) {   
    Analytics.logEvent(eventName, parameters: desc)
}
