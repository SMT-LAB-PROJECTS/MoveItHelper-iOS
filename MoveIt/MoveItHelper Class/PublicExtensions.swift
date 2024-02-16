//
//  PublicExtensions.swift
//  Move It Customer
//
//  Created by Dushyant on 27/04/19.
//  Copyright © 2019 Agicent Technologies. All rights reserved.
//

import UIKit

extension UIApplication {

    func applicationVersion() -> String {

        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }

    func applicationBuild() -> String {

        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    }

    func versionBuild() -> String {

        let version = self.applicationVersion()
        let build = self.applicationBuild()

        return "v\(version)(\(build))"
    }
}

extension UITextView{

    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
    func setUnderLine(_ view: UIView, color: UIColor? = UIColor.lightGray){
        let finalTag = 100 + self.tag
        if let v = view.viewWithTag(finalTag){
            v.removeFromSuperview()
        }
        let underlineView = UIView.init(frame: CGRect.init(x: self.frame.origin.x, y: (self.frame.size.height + self.frame.origin.y), width: self.bounds.width, height: 1))
        underlineView.tag = finalTag
        underlineView.backgroundColor = color
        view.addSubview(underlineView)
    }
}

extension UITextField {
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
    
    func setUnderLine(_ view: UIView, color: UIColor? = UIColor.lightGray){
        let finalTag = 100 + self.tag
        if let v = view.viewWithTag(finalTag){
            v.removeFromSuperview()
        }
        let underlineView = UIView.init(frame: CGRect.init(x: self.frame.origin.x, y: (self.frame.size.height + self.frame.origin.y), width: self.bounds.width, height: 1))
        underlineView.tag = finalTag
        underlineView.backgroundColor = color
        view.addSubview(underlineView)
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    func setLeftPaddingWithImage(_ amount:CGFloat,image: UIImage) {
        let paddingView = UIView(frame: CGRect(x: 20, y: 0, width: amount, height: self.frame.size.height))
        let imageView = UIImageView(frame: CGRect(x: 20, y: 0, width: 20, height: self.frame.size.height))
        
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        let rightView = UIView.init(frame: CGRect.init(x: 20, y: 0, width: 20 + amount, height: self.frame.size.height))
        rightView.addSubview(imageView)
        rightView.addSubview(paddingView)
        self.leftView = rightView
        self.leftViewMode = .always
    }
    func setRightPaddingWithImage(_ amount:CGFloat,image: UIImage) {
        let paddingView = UIView(frame: CGRect(x: 20, y: 0, width: amount, height: self.frame.size.height))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.size.height))
        imageView.image = image
        imageView.contentMode = .center
        let rightView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 20 + amount, height: self.frame.size.height))
        rightView.addSubview(imageView)
        rightView.addSubview(paddingView)
        self.rightView = rightView
        self.rightViewMode = .always
    }
    func setRightCaret(_ amount:CGFloat,image: UIImage) {
        let paddingView = UIView(frame: CGRect(x: 20, y: 0, width: amount, height: self.frame.size.height))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.size.height))
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        let rightView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 20 + amount, height: self.frame.size.height))
        rightView.addSubview(imageView)
        rightView.addSubview(paddingView)
        self.rightView = rightView
        self.rightViewMode = .always
    }
    func setRightPaddingwithImagePoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 20, y: 0, width: amount, height: self.frame.size.height))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.size.height))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "tag_search_icon")
        imageView.image = image
        let rightView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 20 + amount, height: self.frame.size.height))
        rightView.addSubview(imageView)
        rightView.addSubview(paddingView)
        self.rightView = rightView
        self.rightViewMode = .always
    }
    func setLeftPaddingwithImagePoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        let imageView = UIImageView(frame: CGRect(x: amount, y: 0, width: 20, height: self.frame.size.height))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "tag_search_icon")
        imageView.image = image
        let rightView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 20 + amount, height: self.frame.size.height))
        rightView.addSubview(imageView)
        rightView.addSubview(paddingView)
        self.leftView = rightView
        self.leftViewMode = .always
    }
}

extension UIButton{
    func setSpacing() {
        
            let spacing = 10 // the amount of spacing to appear between image and title
         //   self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: CGFloat(spacing))
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: CGFloat(spacing), bottom: 0, right: 0)
    }
    
    func swapButtonPosition() {
        
        if let imageView = imageView, let titleLabel = titleLabel {
            let padding: CGFloat = 10
            imageEdgeInsets = UIEdgeInsets(top: 5, left: titleLabel.frame.size.width+padding, bottom: 5, right: -titleLabel.frame.size.width-padding)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageView.frame.width, bottom: 0, right: imageView.frame.width)
        }
        
    }
}
extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func roundCorners1(with CACornerMask: CACornerMask, radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [CACornerMask]
    }
}

extension Date{
    func formattedDateString() -> String{
        let dateFormate = DateFormatter.init()
        dateFormate.dateFormat = "EEE, MMM dd"
        dateFormate.locale = NSLocale.current
        let stringDate = dateFormate.string(from: self)
        return stringDate
    }
    
    func formattedTimeString()-> String{
        let dateFormate = DateFormatter.init()
        dateFormate.dateFormat = "hh:mm a"
        dateFormate.locale = NSLocale.current
        let stringDate = dateFormate.string(from: self)
        return stringDate
    }
    func timeString(with formate: String)-> String{
        let dateFormate = DateFormatter.init()
        dateFormate.dateFormat = formate
        dateFormate.locale = NSLocale.current
        let stringDate = dateFormate.string(from: self)
        return stringDate
    }
    
    func dateString(with formate: String)-> String{
        let dateFormate = DateFormatter.init()
        dateFormate.dateFormat = formate
        dateFormate.locale = NSLocale.current
        let stringDate = dateFormate.string(from: self)
        return stringDate
    }
}

extension String{
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
   
    func calculateHeightofText(_ width: CGFloat,font: UIFont) -> CGFloat{
        
        let textView = UITextView.init(frame: CGRect.init(x: 0, y: 0, width: width, height: 100))
        textView.text = self
        textView.font = font
  
        return textView.contentSize.height
    }
    
    func height(withConstrainedHeight width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func formattedTimeFromString() -> Date{
        let dateFormate = DateFormatter.init()
        dateFormate.dateFormat = "HH:mm"
        let date = dateFormate.date(from: self)
        return date!
    }
    
    func formattedDateFromString()-> String{
        let dateFormate = DateFormatter.init()
        dateFormate.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let date = (dateFormate.date(from: self))!
        return date.formattedDateString()
    }
    
    func formattedDateFromString(_ identifier: String)-> String{
          let dateFormate = DateFormatter.init()
          dateFormate.dateFormat = identifier
          let date = (dateFormate.date(from: self))!
          return date.dateString(with: "MM-dd-yyyy hh:mm a")
      }
    
}


extension Date {
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        let currentCalendar = Calendar.current
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        return end - start
    }
}

private var handle: UInt8 = 0;

extension UIBarButtonItem {
    private var badgeLayer: CAShapeLayer? {
        if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
            return b as? CAShapeLayer
        } else {
            return nil
        }
    }
    
    func setBadge(text: String?, withOffsetFromTopRight offset: CGPoint = CGPoint.zero, andColor color:UIColor = UIColor.red, andFilled filled: Bool = true, andFontSize fontSize: CGFloat = 9)
    {
        badgeLayer?.removeFromSuperlayer()
        
        if (text == nil || text == "") {
            return
        }
        
        addBadge(text: text!, withOffset: offset, andColor: color, andFilled: filled)
    }
    
    private func addBadge(text: String, withOffset offset: CGPoint = CGPoint.zero, andColor color: UIColor = UIColor.red, andFilled filled: Bool = true, andFontSize fontSize: CGFloat = 9)
    {
        guard let view = self.value(forKey: "view") as? UIView else { return }
        
        var font = UIFont.josefinSansBoldFontWithSize(size: fontSize)//UIFont.systemFont(ofSize:fontSize)
    
        if #available(iOS 9.0, *) { font = UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: UIFont.Weight.regular) }
        let badgeSize = text.size(withAttributes: [NSAttributedString.Key.font: font])
        
        // Initialize Badge
        let badge = CAShapeLayer()
        
        let height = badgeSize.height;
        var width = badgeSize.width + 2 /* padding */
        
        //make sure we have at least a circle
        if (width < height) {
            width = height
        }
        //x position is offset from right-hand side
        let x = view.frame.width - width + offset.x
        
        let badgeFrame = CGRect(origin: CGPoint(x: x, y: offset.y), size: CGSize(width: width+5, height: height+5))
        
        //badge. drawRoundedRect(rect: badgeFrame, andColor: color, filled: filled)
        badge.path = UIBezierPath(roundedRect: badgeFrame, cornerRadius: 8).cgPath
        badge.fillColor = UIColor.red.cgColor
        
        // Initialiaze Badge's label
        let label = CATextLayer()
        label.frame = CGRect(x: x, y: offset.y+2.5, width: width+5, height: height+5)
        label.string = text
        label.alignmentMode = CATextLayerAlignmentMode.center
        label.font = font
        label.fontSize = font.pointSize
        
        label.foregroundColor = filled ? UIColor.white.cgColor : color.cgColor
        label.backgroundColor = UIColor.clear.cgColor
        label.contentsScale = UIScreen.main.scale
        badge.addSublayer(label)
        
        view.layer.addSublayer(badge)
        
        // Save Badge as UIBarButtonItem property
        objc_setAssociatedObject(self, &handle, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func removeBadge() {
        badgeLayer?.removeFromSuperlayer()
    }
}
extension UIViewController {

  func presentAlert(withTitle title: String, message : String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default) { action in
        print("")
    }
    alertController.addAction(OKAction)
    self.present(alertController, animated: true, completion: nil)
  }
}
