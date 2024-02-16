//
//  PopupReason.swift
//  MoveIt
//
//  Created by Govind Kumar Patidar on 12/05/22.
//  Copyright © 2022 Jyoti. All rights reserved.
//


import UIKit
import Foundation
protocol PopupReasonListVCDelegateT: AnyObject {
    func getIndxList(isSubmit:Bool, indexOfMoveId:Int, strReason:String)
}
class PopupReason: UIView, UITextViewDelegate {
    // MARK: - Outlate's....
    @IBOutlet var contentView: UIView!
  
    @IBOutlet weak var btnBackGround: UIButton!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var btnSubmit: UIButton!
    
    
    @IBOutlet weak var tblView: UITableView!

    @IBOutlet weak var popupViewHeightConstraint: NSLayoutConstraint!
    
    
    var titleList: [String] = []
    var selectedIndex:Int?
    var indexOfMoveId:Int?
    var stringReason = ""
    var reasonArray : [String] = []
    var manualReasonObject : [String:Any] = [:]
    var numberOfCharsMin:Int = 15
    var numberOfCharsMax:Int = 5000
    var numberOfCharsMessageMin:String = "minimum 15 characters are required"
    var numberOfCharsMessageMax:String = "maximum 5000 characters are required"

    weak var delegate : PopupReasonListVCDelegateT!
    
    // MARK: - View's method's ....
    override init(frame: CGRect) {
        super.init(frame: frame)
        commanInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commanInit()
    }
    private func commanInit(){
        shwoAnimate()
        //preViewConfig()
    }

    
    // MARK: - Required method's ....
    func preViewConfig(){
        contentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        popUpView.layer.cornerRadius = 10
        popUpView.layer.shadowOpacity = 0.9
        popUpView.backgroundColor = UIColor.white
        popUpView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        popUpView.layer.masksToBounds = true
        txtView.layer.cornerRadius = 10.0

        txtView.layer.borderColor = darkPinkColor.cgColor
        txtView.layer.borderWidth = 0.8
        txtView.text = PlaceHolderMessages.txtViewReasonMessage
        txtView.textColor = UIColor.lightGray
        txtView.isHidden = true
        txtView.delegate = self
        titleView.layer.masksToBounds = true
       
        lblTitle.font = UIFont.josefinSansSemiBoldFontWithSize(size: 15.0)
        lblTitle.text = kStringPermission.popupTitleText
        btnSubmit.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 15.0)
        txtView.font = UIFont.josefinSansRegularFontWithSize(size: 13.0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            self.titleView.roundCorners(corners: [.topLeft,.topRight], radius: 10)
            self.btnSubmit.layer.cornerRadius = 20.0
            self.btnSubmit.layer.masksToBounds = true
            print("Reason array \(self.reasonArray)")
//          self.tblView.register(PopupReasonTblViewCell.self, forCellReuseIdentifier: "cell")
            self.tblView.register(UINib(nibName: "PopupReasonTblViewCell", bundle: nil), forCellReuseIdentifier: "PopupReasonTblViewCell")
            self.titleList = reasonArray
//            popupViewHeightConstraint.constant = CGFloat(50 * (self.titleList.count)) + 150
            txtView.isHidden = false
            popupViewHeightConstraint.constant = 225//CGFloat(50 * (self.titleList.count)) +

//            self.tblView.reloadData()
            if (self.manualReasonObject["min_length"]) != nil{
                self.numberOfCharsMin = ((self.manualReasonObject["min_length"] as? Int)!)}
            if (self.manualReasonObject["min_message"]) != nil{
                self.numberOfCharsMessageMin = ((self.manualReasonObject["min_message"] as? String)!)}

        }
    }
    @objc func keyboardWillShow(notification: NSNotification) {
            
        guard ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil else {
           // if keyboard size is not available for some reason, dont do anything
           return
        }
        let tempValue = (55 * (1))//self.titleList.count
      // move the root view up by the distance of keyboard height
        self.contentView.frame.origin.y = 0 - CGFloat(tempValue) //keyboardSize.height
    }

    @objc func keyboardWillHide(notification: NSNotification) {
      // move back the root view origin to zero
      self.contentView.frame.origin.y = 0
    }
//    func showInView(aView:UIView, titleListArray: [String], animated:Bool){
//        aView.addSubview(view)
////        lblTitle.text = title
//        titleList = titleListArray
//        calculateThePopUPHeight()
////        shwoAnimate()
//        self.preViewConfig()
//
//    }
    
    func shwoAnimate(){
        Bundle.main.loadNibNamed(XIBNibNamed.popupReason, owner: self, options: nil)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.addSubview(self.contentView)
        self.preViewConfig()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)


    }
    
    func removeAnimate(){
        
        UIView.animate(withDuration: 0.25, animations: {
            self.contentView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.contentView.alpha = 0.0
        }) { finished in
            if finished {
//                self.contentView.removeFromSuperview()
            }
        }

    }
    
    // MARK: - Action's ....
    @IBAction func submitButtonTapped(_ sender: Any) {
//       self.delegate.getIndxList(indx: indexPath.row)

        if (txtView.text == PlaceHolderMessages.txtViewReasonMessage) || (txtView.text == ""){
            let windows = UIApplication.shared.windows
            windows.last?.makeToast(AlertMessages.pleaseEnterReasonMessage)
        }else if txtView.text.count < numberOfCharsMin{
            let windows = UIApplication.shared.windows
            windows.last?.rootViewController!.view.makeToast(numberOfCharsMessageMin)
        }else{
            stringReason = txtView.text
            removeAnimate()
            self.delegate.getIndxList(isSubmit: true, indexOfMoveId: self.indexOfMoveId!, strReason: stringReason)
        }
        
        
//        if selectedIndex == nil{
//            self.contentView.makeToast(AlertMessages.pleaseSelectReasonMessage)
//        }else if selectedIndex == (titleList.count - 1){
//
//            if (txtView.text == PlaceHolderMessages.txtViewReasonMessage) || (txtView.text == ""){
//                    self.contentView.makeToast(AlertMessages.pleaseEnterReasonMessage)
//            }else{
//                stringReason = txtView.text
//                removeAnimate()
//                self.delegate.getIndxList(isSubmit: true, indexOfMoveId: self.indexOfMoveId!, strReason: stringReason)
//            }
//        } else{
//            removeAnimate()
//            self.delegate.getIndxList(isSubmit: true, indexOfMoveId: self.indexOfMoveId!, strReason: stringReason)
//
//        }
    }
    @IBAction func outSideButtonTapped(_ sender: Any) {
        removeAnimate()
        self.delegate.getIndxList(isSubmit: false, indexOfMoveId: self.indexOfMoveId!,strReason: stringReason)
    }
    @objc private func tblCellButtonTapped(_ sender: UIButton?) {
        print("Cell button pressed ........")
        self.contentView.endEditing(true)
        self.selectedIndex = sender?.tag
            if txtView.textColor == UIColor.lightGray{
                txtView.text = PlaceHolderMessages.txtViewReasonMessage
                self.stringReason = ""
            }
            txtView.isHidden = false
            popupViewHeightConstraint.constant = 225//CGFloat(50 * (self.titleList.count)) +
            txtView.selectedTextRange = txtView.textRange(from: txtView.beginningOfDocument, to: txtView.beginningOfDocument)
            if txtView.text != PlaceHolderMessages.txtViewReasonMessage{
                stringReason = txtView.text
            }
        
//        popupViewHeightConstraint.constant = CGFloat(50 * (self.titleList.count)) + 150
//        txtView.isHidden = true
//        self.tblView.reloadData()
//        self.stringReason = String(titleList[self.selectedIndex!])
//        if sender?.tag == (titleList.count - 1){
//            if txtView.textColor == UIColor.lightGray{
//                txtView.text = PlaceHolderMessages.txtViewReasonMessage
//                self.stringReason = ""
//            }
//            txtView.isHidden = false
//            popupViewHeightConstraint.constant = CGFloat(50 * (self.titleList.count)) + 225
//            txtView.selectedTextRange = txtView.textRange(from: txtView.beginningOfDocument, to: txtView.beginningOfDocument)
//            if txtView.text != PlaceHolderMessages.txtViewReasonMessage{
//                stringReason = txtView.text
//            }
//        }
    }

}

extension PopupReason{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = PlaceHolderMessages.txtViewReasonMessage
            textView.textColor = UIColor.lightGray
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            txtView.text = PlaceHolderMessages.txtViewReasonMessage
            txtView.textColor = UIColor.lightGray
            txtView.selectedTextRange = txtView.textRange(from: txtView.beginningOfDocument, to: txtView.beginningOfDocument)
        }
        // replacement string
         else if txtView.textColor == UIColor.lightGray && !text.isEmpty {
             txtView.textColor = UIColor.black
             txtView.text = text
             stringReason = text
//             if(updatedText.count > self.numberOfCharsMax && range.length == 0) {
//                 print("Please summarize in 20 characters or less")
//                 self.contentView.makeToast(numberOfCharsMessageMax)
//                    return false;
//             }
        }

        // For every other case, the text should change with the usual
        // behavior...
        else {
            return true
        }

        // ...otherwise return false since the updates have already
        // been made
        return false
    }
}

extension PopupReason:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if titleList.count > 0{
            return titleList.count

        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PopupReasonTblViewCell", for: indexPath) as? PopupReasonTblViewCell{
//            cell = Bundle.main.loadNibNamed("cell", owner: self, options: nil) as! PopupReasonTblViewCell
            cell.lblTitle.text = titleList[indexPath.row]
            cell.imgCheck.image = UIImage(named: AssetsNames.uncheckIcon)
            cell.btnCell.tag = indexPath.row
            cell.btnCell.addTarget(self, action: #selector(tblCellButtonTapped(_:)), for: .touchUpInside)
            if indexPath.row == selectedIndex{
                cell.imgCheck.image = UIImage(named: AssetsNames.checkIcon)
            }
            return cell
        }
        return UITableViewCell()
    }
}
