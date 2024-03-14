//
//  W9FormViewController.swift
//  MoveIt
//
//  Created by Dilip Saket on 06/01/22.
//  Copyright © 2022 Jyoti. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import GooglePlaces

class W9FormViewController: UIViewController, UITextFieldDelegate, W9PendingViewControllerDelegate, UITextViewDelegate{

    var isReject:Bool = false
    var isFromProfile:Bool = false
    var isReminder:Bool = false
    
    let scrlView = UIScrollView()
    
    let lblMainTitle = UILabel()
    let lblRejected = UILabel()
    
    //Section 1
    let lblName = UILabel()
    let txtFieldName = UITextField()
    
    //Section 2
    let lblBussinessName = UILabel()
    let txtFieldBussinessName = UITextField()
    
    //Section 3
    let lblTaxClassification = UILabel()
    let btnLLC = UIButton()
    let btnCCorporation = UIButton()
    let btnSCorporation = UIButton()
    let btnPartnership = UIButton()
    let btnTrustEstate = UIButton()
    let btnLimitedCompany = UIButton()
    
    let lblCSP = UILabel()
    let txtFieldTaxClassification = UITextField()
    let lblTaxNote = UILabel()
    
    let btnOther = UIButton()
    let btnSeeInstruction = UIButton()
    
    //Section 4
    
    let lblExemptPayeeCode = UILabel()
    var lblTempPayee = UILabel()
    let txtFieldExemptPayeeCode = UITextField()
    
    
    let lblFATCA = UILabel()
    let txtFieldFATCA = UITextField()
    let lblTempOutsideUS = UILabel()
    let lblExemptionNote = UILabel()
    
    //Section 5
    let lblAdddress = UILabel()
    let txtViewAdddress = JVFloatLabeledTextView()
    let PLACEHOLDER_TEXT = "Enter Address"

    //Section 6
    let lblCity = UILabel()
    let txtFieldCity = UITextField()
    
    let lblState = UILabel()
    let txtFieldState = UITextField()
    
    let lblZipcode = UILabel()
    let txtFieldZipcode = UITextField()
    
    //Section 7
    let lblAccountNumber = UILabel()
    let txtFieldAccountNumber = UITextField()
    
    let lblNameAddress = UILabel()
    let txtViewNameAddress = JVFloatLabeledTextView()
    
    //Section 8
    let lblTaxPayer = UILabel()
    let lblTaxPayerNote = UILabel()
    
    let lblSocialSecurity = UILabel()
    let txtFieldSocialSecurity = UITextField()
    
    let imgViewOR = UIImageView()
    
    let lblSocialEmployer = UILabel()
    let txtFieldSocialEmployer = UITextField()
    
    let btnSUBMIT = UIButton()
    
    var individual = 0
    var c_corporation = 0
    var s_corporation = 0
    var partnership = 0
    var trust = 0
    var limited_liability_company = 0
    var other = 0

    
    var status:Int = 0
    var is_verified:Int = 0
    var message:String = ""
    var helper_signature:String = ""
    var fw9Form:String = ""
    var fw9FormDownload:String = ""
    
    var resultData:[String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
//        if isFromRemind{
//            let leftBarButtonItem = StaticHelper.leftBarButtonWithImageNamed(imageName: "backward_arrow_icon", vc: self)
//            self.navigationItem.leftBarButtonItems = [leftBarButtonItem]
//            self.getHelperW9FormDetailAPICall()
//            return
//        }
        
        if(isFromProfile == false) {
            self.navigationItem.setHidesBackButton(true, animated: true)
        } else {
            let leftBarButtonItem = StaticHelper.leftBarButtonWithImageNamed(imageName: "backward_arrow_icon", vc: self)
            self.navigationItem.leftBarButtonItems = [leftBarButtonItem]
        }
        
        if(isFromProfile == true) {
            self.getHelperW9FormDetailAPICall()
        } else {
            self.checkProfileForNewUser()
        }
    }
    

    func screenDesigning() {
        
//        Main Title
//        color   #2F2C3D   14sdp
//
//        option title
//        color #808080  12sdp
//
//        texfield
//        heading #2F2C3D   12sdp
//        editext #2F2C3D 12sdp
//
//        notes
//        #A8AFBA   10sdp

        let xRef:CGFloat = 20.0
        var yRef:CGFloat = 10.0
        let ySpace:CGFloat = 10.0
        
        let width:CGFloat = SCREEN_WIDTH-xRef-xRef
        let height:CGFloat = 50.0
        let heightLabel:CGFloat = 20.0
        
        let colorTitle = UIColor.init(_colorLiteralRed: 47/255.0, green: 44/255.0, blue: 61/255.0, alpha: 1.0)
        let colorTxtField = UIColor.init(_colorLiteralRed: 47/255.0, green: 44/255.0, blue: 61/255.0, alpha: 1.0)
        let colorNote = UIColor.init(_colorLiteralRed: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0)
        
        let fontTitle = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        let fontTxtField = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        //let fontNote = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        
        scrlView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        scrlView.backgroundColor = .white
        self.view.addSubview(scrlView)

        lblMainTitle.frame = CGRect(x: xRef, y: yRef, width: width, height: height+30)
        lblMainTitle.text = "Request for Taxpayer Identification Number and Certification"
        lblMainTitle.numberOfLines = 2
        lblMainTitle.textAlignment = .center
        lblMainTitle.font = UIFont.josefinSansSemiBoldFontWithSize(size: 16.0)
        lblMainTitle.textColor = UIColor.black
        scrlView.addSubview(lblMainTitle)
        
        yRef = yRef+lblMainTitle.frame.size.height+ySpace
        
        lblRejected.frame = CGRect(x: xRef, y: yRef, width: width, height: height+30)
        lblRejected.text = self.message
        lblRejected.numberOfLines = 0
        lblRejected.backgroundColor = darkPinkColor
        lblRejected.textAlignment = .center
        lblRejected.font = UIFont.josefinSansRegularFontWithSize(size: 15.0)
        lblRejected.textColor = UIColor.black
        scrlView.addSubview(lblRejected)
        lblRejected.frame = CGRect(x: xRef, y: yRef, width: width, height: ySpace+ySpace+(heightLabel*CGFloat(lblName.calculateMaxLines())))

        if(isReject == true) {
            yRef = yRef+lblRejected.frame.size.height+ySpace
            lblRejected.isHidden = false
        } else {
            lblRejected.isHidden = true
        }
        
        //Section 1
        lblName.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel)
        lblName.text = "1. Name (as shown on your income tax return)."
        lblName.font = fontTitle
        lblName.textColor = colorTitle
        scrlView.addSubview(lblName)
        
        lblName.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblName.calculateMaxLines()))
        
        yRef = yRef+lblName.frame.size.height
        
        txtFieldName.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        txtFieldName.placeholder = "Enter Name"
        txtFieldName.layer.cornerRadius = 5.0
        txtFieldName.layer.borderWidth = 1.0
        txtFieldName.layer.borderColor = UIColor.gray.cgColor
        txtFieldName.setLeftPaddingPoints(15)
        txtFieldName.textColor = colorTxtField
        txtFieldName.font = fontTxtField
        scrlView.addSubview(txtFieldName)
        
        yRef = yRef+txtFieldName.frame.size.height+ySpace+ySpace
        
        //Section 2
        lblBussinessName.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel)
        lblBussinessName.text = "2. Business name/disregarded entity name, if different from above."
        lblBussinessName.font = fontTitle
        lblBussinessName.numberOfLines = 0
        lblBussinessName.textColor = colorTitle
        scrlView.addSubview(lblBussinessName)
        lblBussinessName.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblBussinessName.calculateMaxLines()))
        
        yRef = yRef+lblBussinessName.frame.size.height
        
        txtFieldBussinessName.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        txtFieldBussinessName.placeholder = "Business Name"
        txtFieldBussinessName.layer.cornerRadius = 5.0
        txtFieldBussinessName.layer.borderWidth = 1.0
        txtFieldBussinessName.layer.borderColor = UIColor.gray.cgColor
        txtFieldBussinessName.setLeftPaddingPoints(15)
        txtFieldBussinessName.textColor = colorTxtField
        txtFieldBussinessName.font = fontTxtField
        scrlView.addSubview(txtFieldBussinessName)
        
        yRef = yRef+txtFieldBussinessName.frame.size.height+ySpace+ySpace
        
        //Section 3
        lblTaxClassification.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel)
        lblTaxClassification.text = "3. Check appropriate box for federal tax classification of the person whose name is entered on line 1. Check only one of the following seven boxes."
        lblTaxClassification.font = fontTitle
        lblTaxClassification.numberOfLines = 0
        lblTaxClassification.textColor = colorTitle
        scrlView.addSubview(lblTaxClassification)
        lblTaxClassification.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblTaxClassification.calculateMaxLines()))
        
        yRef = yRef+lblTaxClassification.frame.size.height
                
        btnLLC.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        btnLLC.backgroundColor = .clear
        btnLLC.setImage(UIImage.init(named: "radio_unslct_btn"), for: .normal)
        btnLLC.setImage(UIImage.init(named: "radio_slct_btn_pink"), for: .selected)
        btnLLC.setTitle("Individual/sole proprietor or single-member LLC", for: .normal)
        btnLLC.titleLabel!.font = fontTxtField
        btnLLC.titleLabel?.numberOfLines = 0
        btnLLC.setTitleColor(colorNote, for: .normal)
        btnLLC.moveImageLeftTextCenter()
        scrlView.addSubview(btnLLC)
        btnLLC.addTarget(self, action: #selector(taxClassificationOptionClicked(_:)), for: .touchDown)
        
        yRef = yRef+btnLLC.frame.size.height
        
        btnCCorporation.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        btnCCorporation.backgroundColor = .clear
        btnCCorporation.setImage(UIImage.init(named: "radio_unslct_btn"), for: .normal)
        btnCCorporation.setImage(UIImage.init(named: "radio_slct_btn_pink"), for: .selected)
        btnCCorporation.setTitle("C Corporation", for: .normal)
        btnCCorporation.titleLabel!.font = fontTxtField
        btnCCorporation.titleLabel?.numberOfLines = 0
        btnCCorporation.setTitleColor(colorNote, for: .normal)
        btnCCorporation.moveImageLeftTextCenter()
        scrlView.addSubview(btnCCorporation)
        btnCCorporation.addTarget(self, action: #selector(taxClassificationOptionClicked(_:)), for: .touchDown)
        
        yRef = yRef+btnCCorporation.frame.size.height
        
        btnSCorporation.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        btnSCorporation.backgroundColor = .clear
        btnSCorporation.setImage(UIImage.init(named: "radio_unslct_btn"), for: .normal)
        btnSCorporation.setImage(UIImage.init(named: "radio_slct_btn_pink"), for: .selected)
        btnSCorporation.setTitle("S Corporation", for: .normal)
        btnSCorporation.titleLabel!.font = fontTxtField
        btnSCorporation.titleLabel?.numberOfLines = 0
        btnSCorporation.setTitleColor(colorNote, for: .normal)
        btnSCorporation.moveImageLeftTextCenter()
        scrlView.addSubview(btnSCorporation)
        btnSCorporation.addTarget(self, action: #selector(taxClassificationOptionClicked(_:)), for: .touchDown)
        
        yRef = yRef+btnSCorporation.frame.size.height
        
        btnPartnership.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        btnPartnership.backgroundColor = .clear
        btnPartnership.setImage(UIImage.init(named: "radio_unslct_btn"), for: .normal)
        btnPartnership.setImage(UIImage.init(named: "radio_slct_btn_pink"), for: .selected)
        btnPartnership.setTitle("Partnership", for: .normal)
        btnPartnership.titleLabel!.font = fontTxtField
        btnPartnership.titleLabel?.numberOfLines = 0
        btnPartnership.setTitleColor(colorNote, for: .normal)
        btnPartnership.moveImageLeftTextCenter()
        scrlView.addSubview(btnPartnership)
        btnPartnership.addTarget(self, action: #selector(taxClassificationOptionClicked(_:)), for: .touchDown)
        
        yRef = yRef+btnSCorporation.frame.size.height
        
        btnTrustEstate.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        btnTrustEstate.backgroundColor = .clear
        btnTrustEstate.setImage(UIImage.init(named: "radio_unslct_btn"), for: .normal)
        btnTrustEstate.setImage(UIImage.init(named: "radio_slct_btn_pink"), for: .selected)
        btnTrustEstate.setTitle("Trust/estate", for: .normal)
        btnTrustEstate.titleLabel!.font = fontTxtField
        btnTrustEstate.titleLabel?.numberOfLines = 0
        btnTrustEstate.setTitleColor(colorNote, for: .normal)
        btnTrustEstate.moveImageLeftTextCenter()
        scrlView.addSubview(btnTrustEstate)
        btnTrustEstate.addTarget(self, action: #selector(taxClassificationOptionClicked(_:)), for: .touchDown)
        
        yRef = yRef+btnTrustEstate.frame.size.height

        btnLimitedCompany.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        btnLimitedCompany.backgroundColor = .clear
        btnLimitedCompany.setImage(UIImage.init(named: "radio_unslct_btn"), for: .normal)
        btnLimitedCompany.setImage(UIImage.init(named: "radio_slct_btn_pink"), for: .selected)
        btnLimitedCompany.setTitle("Limited liability company", for: .normal)
        btnLimitedCompany.titleLabel!.font = fontTxtField
        btnLimitedCompany.titleLabel?.numberOfLines = 0
        btnLimitedCompany.setTitleColor(colorNote, for: .normal)
        btnLimitedCompany.moveImageLeftTextCenter()
        scrlView.addSubview(btnLimitedCompany)
        btnLimitedCompany.addTarget(self, action: #selector(taxClassificationOptionClicked(_:)), for: .touchDown)
        
        yRef = yRef+btnLimitedCompany.frame.size.height

        lblCSP.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel)
        lblCSP.text = "Enter the tax classification (C=C corporation, S=S corporation, P=Partnership)"
        lblCSP.font = fontTitle
        lblCSP.numberOfLines = 0
        lblCSP.textColor = colorNote
        scrlView.addSubview(lblCSP)
        lblCSP.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblCSP.calculateMaxLines()))
        
        yRef = yRef+lblCSP.frame.size.height
        
        txtFieldTaxClassification.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        txtFieldTaxClassification.delegate = self
        txtFieldTaxClassification.placeholder = "Tax Classifictaion"
        txtFieldTaxClassification.layer.cornerRadius = 5.0
        txtFieldTaxClassification.layer.borderWidth = 1.0
        txtFieldTaxClassification.layer.borderColor = UIColor.gray.cgColor
        txtFieldTaxClassification.setLeftPaddingPoints(15)
        txtFieldTaxClassification.textColor = colorTxtField
        txtFieldTaxClassification.font = fontTxtField
        scrlView.addSubview(txtFieldTaxClassification)
        
        yRef = yRef+txtFieldTaxClassification.frame.size.height+ySpace

        lblTaxNote.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel)
        lblTaxNote.text = "Note: Check the appropriate box in the line above for the tax classification of the single-member owner. Do not check LLC if the LLC is classified as a single-member LLC that is disregarded from the owner unless the owner of the LLC is another LLC that is not disregarded from the owner for U.S. federal tax purposes. Otherwise, a single-member LLC that is disregarded from the owner should check the appropriate box for the tax classification of its owner."
        lblTaxNote.font = fontTitle
        lblTaxNote.numberOfLines = 0
        lblTaxNote.textColor = colorNote
        scrlView.addSubview(lblTaxNote)
        lblTaxNote.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblTaxNote.calculateMaxLines()))
        
        yRef = yRef+lblTaxNote.frame.size.height

        
        btnOther.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        btnOther.backgroundColor = .clear
        btnOther.setImage(UIImage.init(named: "radio_unslct_btn"), for: .normal)
        btnOther.setImage(UIImage.init(named: "radio_slct_btn_pink"), for: .selected)
        btnOther.setTitle("Other", for: .normal)
        btnOther.titleLabel!.font = fontTxtField
        btnOther.titleLabel?.numberOfLines = 0
        btnOther.setTitleColor(colorNote, for: .normal)
        btnOther.moveImageLeftTextCenter()
        scrlView.addSubview(btnOther)
        btnOther.addTarget(self, action: #selector(taxClassificationOptionClicked(_:)), for: .touchDown)
        
        yRef = yRef+btnOther.frame.size.height
        
        btnSeeInstruction.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        btnSeeInstruction.backgroundColor = .clear
        btnSeeInstruction.setTitle("See Instruction", for: .normal)
        btnSeeInstruction.titleLabel!.font = fontTxtField
        btnSeeInstruction.titleLabel?.numberOfLines = 0
        btnSeeInstruction.setTitleColor(.red, for: .normal)
        btnSeeInstruction.moveImageLeftTextCenter()
        scrlView.addSubview(btnSeeInstruction)
        btnSeeInstruction.addTarget(self, action: #selector(btnSeeInstructionClicked), for: .touchDown)
        
        let yourAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.red,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ] // .double.rawValue, .thick.rawValue
               
        let attributeString = NSMutableAttributedString(
                string: "See Instruction",
                attributes: yourAttributes
             )
        btnSeeInstruction.setAttributedTitle(attributeString, for: .normal)

        //Section 4
        
        yRef = yRef+btnSeeInstruction.frame.size.height
        
        lblExemptPayeeCode.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel)
        lblExemptPayeeCode.text = "4. Exemptions (codes apply only to certain entities, not individuals; see instructions on page 3):"
        lblExemptPayeeCode.numberOfLines = 0
        lblExemptPayeeCode.font = fontTitle
        lblExemptPayeeCode.textColor = colorTitle
        scrlView.addSubview(lblExemptPayeeCode)
        
        lblExemptPayeeCode.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblExemptPayeeCode.calculateMaxLines()))
        
        yRef = yRef+lblExemptPayeeCode.frame.size.height+ySpace
                
        lblTempPayee.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel)
        lblTempPayee.text = "Exempt payee code (if any)"
        lblTempPayee.font = fontTitle
        lblTempPayee.textColor = colorNote
        scrlView.addSubview(lblTempPayee)

        yRef = yRef+lblTempPayee.frame.size.height
        
        txtFieldExemptPayeeCode.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        txtFieldExemptPayeeCode.placeholder = "Payee Code"
        txtFieldExemptPayeeCode.layer.cornerRadius = 5.0
        txtFieldExemptPayeeCode.layer.borderWidth = 1.0
        txtFieldExemptPayeeCode.layer.borderColor = UIColor.gray.cgColor
        txtFieldExemptPayeeCode.setLeftPaddingPoints(15)
        txtFieldExemptPayeeCode.textColor = colorTxtField
        txtFieldExemptPayeeCode.font = fontTxtField
        scrlView.addSubview(txtFieldExemptPayeeCode)
        
        yRef = yRef+txtFieldExemptPayeeCode.frame.size.height+ySpace
        
        lblFATCA.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel)
        lblFATCA.text = "Exemption from FATCA reporting code (if any)"
        lblFATCA.font = fontTitle
        lblFATCA.textColor = colorNote
        scrlView.addSubview(lblFATCA)
        lblFATCA.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblExemptPayeeCode.calculateMaxLines()))

        
        yRef = yRef+lblFATCA.frame.size.height
        
        txtFieldFATCA.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        txtFieldFATCA.placeholder = "Reporting Code"
        txtFieldFATCA.layer.cornerRadius = 5.0
        txtFieldFATCA.layer.borderWidth = 1.0
        txtFieldFATCA.layer.borderColor = UIColor.gray.cgColor
        txtFieldFATCA.setLeftPaddingPoints(15)
        txtFieldFATCA.textColor = colorTxtField
        txtFieldFATCA.font = fontTxtField
        scrlView.addSubview(txtFieldFATCA)
        
        yRef = yRef+txtFieldFATCA.frame.size.height

        
        lblTempOutsideUS.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel)
        lblTempOutsideUS.text = "(Applies to accounts maintained outside the U.S.)"
        lblTempOutsideUS.adjustsFontSizeToFitWidth = true
        lblTempOutsideUS.font = fontTitle
        lblTempOutsideUS.textColor = colorNote
        scrlView.addSubview(lblTempOutsideUS)

        yRef = yRef+lblTempOutsideUS.frame.size.height+ySpace
        
        //Section 5
        
        lblAdddress.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel)
        lblAdddress.text = "5. Address (number, street, and apt. or suite no.) See instructions."
        lblAdddress.numberOfLines = 0
        lblAdddress.font = fontTitle
        lblAdddress.textColor = colorTitle
        scrlView.addSubview(lblAdddress)
        
        lblAdddress.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblAdddress.calculateMaxLines()))
        
        yRef = yRef+lblAdddress.frame.size.height
        
        txtViewAdddress.frame = CGRect(x: xRef, y: yRef, width: width, height: height+height)

        txtViewAdddress.placeholder = PLACEHOLDER_TEXT
        txtViewAdddress.layer.cornerRadius = 5.0
        txtViewAdddress.layer.borderWidth = 1.0
        txtViewAdddress.layer.borderColor = UIColor.gray.cgColor
        txtViewAdddress.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
//        txtViewAdddress.setLeftPaddingPoints(15)
        txtViewAdddress.textColor = colorTxtField
        txtViewAdddress.font = fontTxtField
        txtViewAdddress.delegate = self
        scrlView.addSubview(txtViewAdddress)
        
        yRef = yRef+txtViewAdddress.frame.size.height+ySpace+ySpace

        //Section 6
        lblCity.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel)
        lblCity.text = "6. City"
        lblCity.font = fontTitle
        lblCity.numberOfLines = 0
        lblCity.textColor = colorTitle
        scrlView.addSubview(lblCity)
        
        lblCity.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblCity.calculateMaxLines()))
        
        yRef = yRef+lblCity.frame.size.height
        
        txtFieldCity.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        txtFieldCity.placeholder = "City"
        txtFieldCity.layer.cornerRadius = 5.0
        txtFieldCity.layer.borderWidth = 1.0
        txtFieldCity.layer.borderColor = UIColor.gray.cgColor
        txtFieldCity.setLeftPaddingPoints(15)
        txtFieldCity.textColor = colorTxtField
        txtFieldCity.font = fontTxtField
        scrlView.addSubview(txtFieldCity)
        
        yRef = yRef+txtFieldCity.frame.size.height+ySpace+ySpace

        lblState.frame = CGRect(x: xRef, y: yRef, width: (width/2.0)-(xRef/2.0), height: heightLabel)
        lblState.text = "State"
        lblState.font = fontTitle
        lblState.numberOfLines = 0
        lblState.textColor = colorTitle
        scrlView.addSubview(lblState)
        lblState.frame = CGRect(x: xRef, y: yRef, width: (width/2.0)-(xRef/2.0), height: heightLabel*CGFloat(lblState.calculateMaxLines()))
        
        lblZipcode.frame = CGRect(x: xRef+lblState.frame.size.width+xRef, y: yRef, width: (width/2.0)-(xRef/2.0), height: heightLabel)
        lblZipcode.text = "Zipcode"
        lblZipcode.font = fontTitle
        lblZipcode.numberOfLines = 0
        lblZipcode.textColor = colorTitle
        scrlView.addSubview(lblZipcode)
        lblZipcode.frame = CGRect(x: xRef+lblState.frame.size.width+xRef, y: yRef, width: (width/2.0)-xRef, height: heightLabel*CGFloat(lblZipcode.calculateMaxLines()))
        
        yRef = yRef+lblZipcode.frame.size.height
        
        txtFieldState.frame = CGRect(x: xRef, y: yRef, width: (width/2.0)-(xRef/2.0), height: height)
        txtFieldState.placeholder = "State"
        txtFieldState.layer.cornerRadius = 5.0
        txtFieldState.layer.borderWidth = 1.0
        txtFieldState.layer.borderColor = UIColor.gray.cgColor
        txtFieldState.setLeftPaddingPoints(15)
        txtFieldState.textColor = colorTxtField
        txtFieldState.font = fontTxtField
        scrlView.addSubview(txtFieldState)
        
        txtFieldZipcode.frame = CGRect(x: xRef+txtFieldState.frame.size.width+xRef, y: yRef, width: (width/2.0)-(xRef/2.0), height: height)
        txtFieldZipcode.placeholder = "Zipcoce"
        txtFieldZipcode.layer.cornerRadius = 5.0
        txtFieldZipcode.layer.borderWidth = 1.0
        txtFieldZipcode.layer.borderColor = UIColor.gray.cgColor
        txtFieldZipcode.setLeftPaddingPoints(15)
        txtFieldZipcode.textColor = colorTxtField
        txtFieldZipcode.font = fontTxtField
        scrlView.addSubview(txtFieldZipcode)

        
        yRef = yRef+txtFieldState.frame.size.height+ySpace+ySpace
        
        //Section 7
        
        lblAccountNumber.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel)
        lblAccountNumber.text = "7. List account number(s) here (optional)"
        lblAccountNumber.font = fontTitle
        lblAccountNumber.numberOfLines = 0
        lblAccountNumber.textColor = colorTitle
        scrlView.addSubview(lblAccountNumber)
        lblAccountNumber.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblState.calculateMaxLines()))
        
        yRef = yRef+lblAccountNumber.frame.size.height
        
        txtFieldAccountNumber.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        txtFieldAccountNumber.placeholder = "Enter Account"
        txtFieldAccountNumber.layer.cornerRadius = 5.0
        txtFieldAccountNumber.layer.borderWidth = 1.0
        txtFieldAccountNumber.layer.borderColor = UIColor.gray.cgColor
        txtFieldAccountNumber.setLeftPaddingPoints(15)
        txtFieldAccountNumber.textColor = colorTxtField
        txtFieldAccountNumber.font = fontTxtField
        txtFieldAccountNumber.keyboardType = .numberPad
        scrlView.addSubview(txtFieldAccountNumber)
        
        yRef = yRef+txtFieldAccountNumber.frame.size.height+ySpace+ySpace
        
        lblNameAddress.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel)
        lblNameAddress.text = "Requester’s name and address (optional)"
        lblNameAddress.font = fontTitle
        lblNameAddress.numberOfLines = 0
        lblNameAddress.textColor = colorTitle
        scrlView.addSubview(lblNameAddress)
        lblNameAddress.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblNameAddress.calculateMaxLines()))
        
        yRef = yRef+lblNameAddress.frame.size.height
        
        txtViewNameAddress.frame = CGRect(x: xRef, y: yRef, width: width, height: height+height)
        txtViewNameAddress.placeholder = "Enter Requester Detail"
        txtViewNameAddress.layer.cornerRadius = 5.0
        txtViewNameAddress.layer.borderWidth = 1.0
        txtViewNameAddress.layer.borderColor = UIColor.gray.cgColor
        txtViewNameAddress.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
//        txtViewNameAddress.setLeftPaddingPoints(15)
        txtViewNameAddress.textColor = colorTxtField
        txtViewNameAddress.font = fontTxtField
        scrlView.addSubview(txtViewNameAddress)
        
        yRef = yRef+txtViewNameAddress.frame.size.height+ySpace+ySpace
        
        //Section 8
        
        lblTaxPayer.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel)
        lblTaxPayer.text = "Taxpayer Identification Number (TIN)"
        lblTaxPayer.font = fontTitle
        lblTaxPayer.numberOfLines = 0
        lblTaxPayer.textColor = colorTitle
        scrlView.addSubview(lblTaxPayer)
        lblTaxPayer.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblTaxPayer.calculateMaxLines()))
        
        yRef = yRef+lblTaxPayer.frame.size.height

        lblTaxPayerNote.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel)
        lblTaxPayerNote.text = "Enter your TIN in the appropriate box. The TIN provided must match the name given on line 1 to avoid backup withholding. For individuals, this is generally your social security number (SSN). However, for a resident alien, sole proprietor, or disregarded entity, see the instructions for Part I, later. For other entities, it is your employer identification number (EIN). If you do not have a number, see How to get a TIN, later.\n\nNote: If the account is in more than one name, see the instructions for line 1. Also see What Name and Number To Give the Requester for guidelines on whose number to enter."
        lblTaxPayerNote.font = fontTitle
        lblTaxPayerNote.numberOfLines = 0
        lblTaxPayerNote.textColor = colorNote
        scrlView.addSubview(lblTaxPayerNote)
        lblTaxPayerNote.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblTaxPayerNote.calculateMaxLines()))
        
        yRef = yRef+lblTaxPayerNote.frame.size.height

        lblSocialSecurity.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel)
        lblSocialSecurity.text = "Social security number"
        lblSocialSecurity.font = fontTitle
        lblSocialSecurity.numberOfLines = 0
        lblSocialSecurity.textColor = colorTitle
        scrlView.addSubview(lblSocialSecurity)
        lblSocialSecurity.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblSocialSecurity.calculateMaxLines()))
        
        yRef = yRef+lblSocialSecurity.frame.size.height

        txtFieldSocialSecurity.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        txtFieldSocialSecurity.placeholder = "Enter Social security number"
        txtFieldSocialSecurity.delegate = self
        txtFieldSocialSecurity.layer.cornerRadius = 5.0
        txtFieldSocialSecurity.layer.borderWidth = 1.0
        txtFieldSocialSecurity.layer.borderColor = UIColor.gray.cgColor
        txtFieldSocialSecurity.setLeftPaddingPoints(15)
        txtFieldSocialSecurity.textColor = colorTxtField
        txtFieldSocialSecurity.font = fontTxtField
        txtFieldSocialSecurity.keyboardType = .numberPad
        scrlView.addSubview(txtFieldSocialSecurity)
        
        yRef = yRef+txtFieldSocialSecurity.frame.size.height+ySpace+ySpace
        
        imgViewOR.frame = CGRect(x: (SCREEN_WIDTH-268)/2.0, y: yRef, width: 268, height: 24)
        imgViewOR.image = UIImage.init(named: "OR")
        scrlView.addSubview(imgViewOR)
        
        yRef = yRef+imgViewOR.frame.size.height+ySpace+ySpace

        lblSocialEmployer.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel)
        lblSocialEmployer.text = "Employer identification number"
        lblSocialEmployer.font = fontTitle
        lblSocialEmployer.numberOfLines = 0
        lblSocialEmployer.textColor = colorTitle
        scrlView.addSubview(lblSocialEmployer)
        lblSocialEmployer.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblSocialEmployer.calculateMaxLines()))
        
        yRef = yRef+lblSocialSecurity.frame.size.height

        txtFieldSocialEmployer.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        txtFieldSocialEmployer.placeholder = "Enter Employer identification number"
        txtFieldSocialEmployer.delegate = self
        txtFieldSocialEmployer.layer.cornerRadius = 5.0
        txtFieldSocialEmployer.layer.borderWidth = 1.0
        txtFieldSocialEmployer.layer.borderColor = UIColor.gray.cgColor
        txtFieldSocialEmployer.setLeftPaddingPoints(15)
        txtFieldSocialEmployer.textColor = colorTxtField
        txtFieldSocialEmployer.font = fontTxtField
        txtFieldSocialEmployer.keyboardType = .numberPad
        scrlView.addSubview(txtFieldSocialEmployer)
        
        yRef = yRef+txtFieldSocialEmployer.frame.size.height+ySpace+ySpace
                 
        
        btnSUBMIT.setBackgroundImage(UIImage.init(named: "btn_gradient"), for: .normal)
        btnSUBMIT.frame = CGRect(x: 2*xRef, y: yRef, width: width-xRef-xRef, height: 60)
        btnSUBMIT.setTitle("SUBMIT", for: .normal)
        btnSUBMIT.titleLabel?.font = UIFont.josefinSansRegularFontWithSize(size: 17.0)
        btnSUBMIT.setTitleColor(.black, for: .normal)
        btnSUBMIT.addTarget(self, action: #selector(self.btnSUBMITClicked), for: .touchDown)
//        btnUpdate.addTarget(viewUpdateBG, action: #selector(viewUpdateBG.removeFromSuperview), for: .touchDown)
        scrlView.addSubview(btnSUBMIT)

        yRef = yRef+btnSUBMIT.frame.size.height+ySpace+ySpace
        
        yRef = yRef+100
        scrlView.contentSize = CGSize(width: scrlView.frame.size.width, height: yRef)
        
        self.hideLimitedLibilityCompany()
    }

    func hideLimitedLibilityCompany() {

        let xRef:CGFloat = 20.0
        var yRef:CGFloat = 10.0
        let ySpace:CGFloat = 10.0
        
        let width:CGFloat = SCREEN_WIDTH-xRef-xRef
        let height:CGFloat = 50.0
        let heightLabel:CGFloat = 20.0
                
        scrlView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        lblMainTitle.frame = CGRect(x: xRef, y: yRef, width: width, height: height+30)
        yRef = yRef+lblMainTitle.frame.size.height+ySpace
        
        if(isReject == true) {
            lblRejected.frame = CGRect(x: xRef, y: yRef, width: width, height: ySpace+ySpace+(heightLabel*CGFloat(lblName.calculateMaxLines())))
            yRef = yRef+lblRejected.frame.size.height+ySpace
            lblRejected.isHidden = false
        } else {
            lblRejected.isHidden = true
        }
        
        //Section 1
        lblName.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblName.calculateMaxLines()))
        yRef = yRef+lblName.frame.size.height
        
        txtFieldName.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        yRef = yRef+txtFieldName.frame.size.height+ySpace+ySpace
        
        //Section 2
        lblBussinessName.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblBussinessName.calculateMaxLines()))
        yRef = yRef+lblBussinessName.frame.size.height
        
        txtFieldBussinessName.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        yRef = yRef+txtFieldBussinessName.frame.size.height+ySpace+ySpace
        
        //Section 3
        lblTaxClassification.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblTaxClassification.calculateMaxLines()))
        yRef = yRef+lblTaxClassification.frame.size.height
                
        btnLLC.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        yRef = yRef+btnLLC.frame.size.height
        
        btnCCorporation.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        yRef = yRef+btnCCorporation.frame.size.height
        
        btnSCorporation.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        yRef = yRef+btnSCorporation.frame.size.height
        
        btnPartnership.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        yRef = yRef+btnSCorporation.frame.size.height
        
        btnTrustEstate.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        yRef = yRef+btnTrustEstate.frame.size.height

        btnLimitedCompany.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        yRef = yRef+btnLimitedCompany.frame.size.height

        lblCSP.isHidden = true
        txtFieldTaxClassification.isHidden = true

//        lblCSP.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblCSP.calculateMaxLines()))
//        yRef = yRef+lblCSP.frame.size.height
//
//        txtFieldTaxClassification.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
//        yRef = yRef+txtFieldTaxClassification.frame.size.height+ySpace

        lblTaxNote.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblTaxNote.calculateMaxLines()))
        yRef = yRef+lblTaxNote.frame.size.height
        
        btnOther.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        yRef = yRef+btnOther.frame.size.height
        
        btnSeeInstruction.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        yRef = yRef+btnSeeInstruction.frame.size.height
        
        //Section 4
        
        lblExemptPayeeCode.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblExemptPayeeCode.calculateMaxLines()))
        yRef = yRef+lblExemptPayeeCode.frame.size.height+ySpace
                
        lblTempPayee.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel)
        yRef = yRef+lblTempPayee.frame.size.height
        
        txtFieldExemptPayeeCode.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        yRef = yRef+txtFieldExemptPayeeCode.frame.size.height+ySpace
        
        lblFATCA.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblExemptPayeeCode.calculateMaxLines()))
        yRef = yRef+lblFATCA.frame.size.height
        
        txtFieldFATCA.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        yRef = yRef+txtFieldFATCA.frame.size.height

        lblTempOutsideUS.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel)
        yRef = yRef+lblTempOutsideUS.frame.size.height+ySpace
        
        //Section 5
        lblAdddress.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblAdddress.calculateMaxLines()))
        yRef = yRef+lblAdddress.frame.size.height
        
        txtViewAdddress.frame = CGRect(x: xRef, y: yRef, width: width, height: height+height)
        yRef = yRef+txtViewAdddress.frame.size.height+ySpace+ySpace

        //Section 6
        lblCity.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblCity.calculateMaxLines()))
        yRef = yRef+lblCity.frame.size.height
        
        txtFieldCity.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        yRef = yRef+txtFieldCity.frame.size.height+ySpace+ySpace

        lblState.frame = CGRect(x: xRef, y: yRef, width: (width/2.0)-(xRef/2.0), height: heightLabel*CGFloat(lblState.calculateMaxLines()))
        lblZipcode.frame = CGRect(x: xRef+lblState.frame.size.width+xRef, y: yRef, width: (width/2.0)-xRef, height: heightLabel*CGFloat(lblZipcode.calculateMaxLines()))
        yRef = yRef+lblZipcode.frame.size.height
        
        txtFieldState.frame = CGRect(x: xRef, y: yRef, width: (width/2.0)-(xRef/2.0), height: height)
        txtFieldZipcode.frame = CGRect(x: xRef+txtFieldState.frame.size.width+xRef, y: yRef, width: (width/2.0)-(xRef/2.0), height: height)
        yRef = yRef+txtFieldState.frame.size.height+ySpace+ySpace
        
        //Section 7
        lblAccountNumber.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblState.calculateMaxLines()))
        yRef = yRef+lblAccountNumber.frame.size.height
        
        txtFieldAccountNumber.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        yRef = yRef+txtFieldAccountNumber.frame.size.height+ySpace+ySpace
        
        lblNameAddress.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblNameAddress.calculateMaxLines()))
        yRef = yRef+lblNameAddress.frame.size.height
        
        txtViewNameAddress.frame = CGRect(x: xRef, y: yRef, width: width, height: height+height)
        yRef = yRef+txtViewNameAddress.frame.size.height+ySpace+ySpace
        
        //Section 8
        lblTaxPayer.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblTaxPayer.calculateMaxLines()))
        yRef = yRef+lblTaxPayer.frame.size.height

        lblTaxPayerNote.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblTaxPayerNote.calculateMaxLines()))
        yRef = yRef+lblTaxPayerNote.frame.size.height

        lblSocialSecurity.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblSocialSecurity.calculateMaxLines()))
        yRef = yRef+lblSocialSecurity.frame.size.height

        txtFieldSocialSecurity.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        yRef = yRef+txtFieldSocialSecurity.frame.size.height+ySpace+ySpace
        
        imgViewOR.frame = CGRect(x: (SCREEN_WIDTH-268)/2.0, y: yRef, width: 268, height: 24)
        yRef = yRef+imgViewOR.frame.size.height+ySpace+ySpace

        lblSocialEmployer.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblSocialEmployer.calculateMaxLines()))
        yRef = yRef+lblSocialSecurity.frame.size.height

        txtFieldSocialEmployer.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        yRef = yRef+txtFieldSocialEmployer.frame.size.height+ySpace+ySpace
                                 
        btnSUBMIT.frame = CGRect(x: 2*xRef, y: yRef, width: width-xRef-xRef, height: 60)
        yRef = yRef+btnSUBMIT.frame.size.height+ySpace+ySpace
        
        yRef = yRef+100
        scrlView.contentSize = CGSize(width: scrlView.frame.size.width, height: yRef)
    }
    
    func showLimitedLibilityCompany() {

        let xRef:CGFloat = 20.0
        var yRef:CGFloat = 10.0
        let ySpace:CGFloat = 10.0
        
        let width:CGFloat = SCREEN_WIDTH-xRef-xRef
        let height:CGFloat = 50.0
        let heightLabel:CGFloat = 20.0
        
        scrlView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        lblMainTitle.frame = CGRect(x: xRef, y: yRef, width: width, height: height+30)
        yRef = yRef+lblMainTitle.frame.size.height+ySpace
        
        if(isReject == true) {
            lblRejected.frame = CGRect(x: xRef, y: yRef, width: width, height: ySpace+ySpace+(heightLabel*CGFloat(lblName.calculateMaxLines())))
            yRef = yRef+lblRejected.frame.size.height+ySpace
            lblRejected.isHidden = false
        } else {
            lblRejected.isHidden = true
        }

        //Section 1
        lblName.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblName.calculateMaxLines()))
        yRef = yRef+lblName.frame.size.height
        
        txtFieldName.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        yRef = yRef+txtFieldName.frame.size.height+ySpace+ySpace
        
        //Section 2
        lblBussinessName.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblBussinessName.calculateMaxLines()))
        yRef = yRef+lblBussinessName.frame.size.height
        
        txtFieldBussinessName.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        yRef = yRef+txtFieldBussinessName.frame.size.height+ySpace+ySpace
        
        //Section 3
        lblTaxClassification.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblTaxClassification.calculateMaxLines()))
        yRef = yRef+lblTaxClassification.frame.size.height
                
        btnLLC.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        yRef = yRef+btnLLC.frame.size.height
        
        btnCCorporation.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        yRef = yRef+btnCCorporation.frame.size.height
        
        btnSCorporation.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        yRef = yRef+btnSCorporation.frame.size.height
        
        btnPartnership.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        yRef = yRef+btnSCorporation.frame.size.height
        
        btnTrustEstate.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        yRef = yRef+btnTrustEstate.frame.size.height

        btnLimitedCompany.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        yRef = yRef+btnLimitedCompany.frame.size.height

        lblCSP.isHidden = false
        txtFieldTaxClassification.isHidden = false

        lblCSP.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblCSP.calculateMaxLines()))
        yRef = yRef+lblCSP.frame.size.height

        txtFieldTaxClassification.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        yRef = yRef+txtFieldTaxClassification.frame.size.height+ySpace

        lblTaxNote.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblTaxNote.calculateMaxLines()))
        yRef = yRef+lblTaxNote.frame.size.height
        
        btnOther.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        yRef = yRef+btnOther.frame.size.height
        
        btnSeeInstruction.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        yRef = yRef+btnSeeInstruction.frame.size.height
        
        //Section 4
        
        lblExemptPayeeCode.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblExemptPayeeCode.calculateMaxLines()))
        yRef = yRef+lblExemptPayeeCode.frame.size.height+ySpace
                
        lblTempPayee.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel)
        yRef = yRef+lblTempPayee.frame.size.height
        
        txtFieldExemptPayeeCode.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        yRef = yRef+txtFieldExemptPayeeCode.frame.size.height+ySpace
        
        lblFATCA.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblExemptPayeeCode.calculateMaxLines()))
        yRef = yRef+lblFATCA.frame.size.height
        
        txtFieldFATCA.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        yRef = yRef+txtFieldFATCA.frame.size.height

        lblTempOutsideUS.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel)
        yRef = yRef+lblTempOutsideUS.frame.size.height+ySpace
        
        //Section 5
        lblAdddress.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblAdddress.calculateMaxLines()))
        yRef = yRef+lblAdddress.frame.size.height
        
        txtViewAdddress.frame = CGRect(x: xRef, y: yRef, width: width, height: height+height)
        yRef = yRef+txtViewAdddress.frame.size.height+ySpace+ySpace

        //Section 6
        lblCity.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblCity.calculateMaxLines()))
        yRef = yRef+lblCity.frame.size.height
        
        txtFieldCity.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        yRef = yRef+txtFieldCity.frame.size.height+ySpace+ySpace

        lblState.frame = CGRect(x: xRef, y: yRef, width: (width/2.0)-(xRef/2.0), height: heightLabel*CGFloat(lblState.calculateMaxLines()))
        lblZipcode.frame = CGRect(x: xRef+lblState.frame.size.width+xRef, y: yRef, width: (width/2.0)-xRef, height: heightLabel*CGFloat(lblZipcode.calculateMaxLines()))
        yRef = yRef+lblZipcode.frame.size.height
        
        txtFieldState.frame = CGRect(x: xRef, y: yRef, width: (width/2.0)-(xRef/2.0), height: height)
        txtFieldZipcode.frame = CGRect(x: xRef+txtFieldState.frame.size.width+xRef, y: yRef, width: (width/2.0)-(xRef/2.0), height: height)
        yRef = yRef+txtFieldState.frame.size.height+ySpace+ySpace
        
        //Section 7
        lblAccountNumber.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblState.calculateMaxLines()))
        yRef = yRef+lblAccountNumber.frame.size.height
        
        txtFieldAccountNumber.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        yRef = yRef+txtFieldAccountNumber.frame.size.height+ySpace+ySpace
        
        lblNameAddress.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblNameAddress.calculateMaxLines()))
        yRef = yRef+lblNameAddress.frame.size.height
        
        txtViewNameAddress.frame = CGRect(x: xRef, y: yRef, width: width, height: height+height)
        yRef = yRef+txtViewNameAddress.frame.size.height+ySpace+ySpace
        
        //Section 8
        lblTaxPayer.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblTaxPayer.calculateMaxLines()))
        yRef = yRef+lblTaxPayer.frame.size.height

        lblTaxPayerNote.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblTaxPayerNote.calculateMaxLines()))
        yRef = yRef+lblTaxPayerNote.frame.size.height

        lblSocialSecurity.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblSocialSecurity.calculateMaxLines()))
        yRef = yRef+lblSocialSecurity.frame.size.height

        txtFieldSocialSecurity.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        yRef = yRef+txtFieldSocialSecurity.frame.size.height+ySpace+ySpace
        
        imgViewOR.frame = CGRect(x: (SCREEN_WIDTH-268)/2.0, y: yRef, width: 268, height: 24)
        yRef = yRef+imgViewOR.frame.size.height+ySpace+ySpace

        lblSocialEmployer.frame = CGRect(x: xRef, y: yRef, width: width, height: heightLabel*CGFloat(lblSocialEmployer.calculateMaxLines()))
        yRef = yRef+lblSocialSecurity.frame.size.height

        txtFieldSocialEmployer.frame = CGRect(x: xRef, y: yRef, width: width, height: height)
        yRef = yRef+txtFieldSocialEmployer.frame.size.height+ySpace+ySpace
                                 
        btnSUBMIT.frame = CGRect(x: 2*xRef, y: yRef, width: width-xRef-xRef, height: 60)
        yRef = yRef+btnSUBMIT.frame.size.height+ySpace+ySpace
        
        yRef = yRef+100
        scrlView.contentSize = CGSize(width: scrlView.frame.size.width, height: yRef)
    }
        
    func setParameters() {
                        
        lblRejected.text = self.message
        
        //Section 1
        txtFieldName.text = self.resultData["name"] as? String ?? ""
        txtFieldBussinessName.text = self.resultData["business_name"] as? String ?? ""
        
        //Section 2
        txtFieldTaxClassification.text = self.resultData["tax_classification"] as? String ?? ""
        
        //Section 3
        btnLLC.isSelected = self.individual.boolValue
        btnCCorporation.isSelected = self.c_corporation.boolValue
        btnSCorporation.isSelected = self.s_corporation.boolValue
        btnPartnership.isSelected = self.partnership.boolValue
        btnTrustEstate.isSelected = self.trust.boolValue
        btnLimitedCompany.isSelected = self.limited_liability_company.boolValue
                
        btnOther.isSelected = self.other.boolValue
        
        //Section 4
        txtFieldExemptPayeeCode.text = self.resultData["payee_code"] as? String ?? ""
        txtFieldFATCA.text = self.resultData["reporting_code"] as? String ?? ""
    
        //Section 5
        txtViewAdddress.text = self.resultData["address"] as? String ?? ""
        
        //Section 6
        txtFieldCity.text = self.resultData["city"] as? String ?? ""
        txtFieldState.text = self.resultData["state"] as? String ?? ""
        txtFieldZipcode.text = self.resultData["zipcode"] as? String ?? ""
                
        //Section 7
        txtFieldAccountNumber.text = self.resultData["account_number"] as? String ?? ""
        txtViewNameAddress.text = self.resultData["requester_name_address"] as? String ?? ""
        
        //Section 8
        txtFieldSocialSecurity.text = self.resultData["ss_number"] as? String ?? ""
        txtFieldSocialEmployer.text = self.resultData["sei_number"] as? String ?? ""        
    }
    
    @objc func taxClassificationOptionClicked(_ sender:UIButton) {
        
        btnLLC.isSelected = false
        btnCCorporation.isSelected = false
        btnSCorporation.isSelected = false
        btnPartnership.isSelected = false
        btnTrustEstate.isSelected = false
        btnLimitedCompany.isSelected = false
        btnOther.isSelected = false
        
        individual = 0
        c_corporation = 0
        s_corporation = 0
        partnership = 0
        trust = 0
        limited_liability_company = 0
        other = 0
        
        txtFieldTaxClassification.isHidden = true
        if(sender == btnLLC) {
            individual = 1
        } else if(sender == btnCCorporation) {
            c_corporation = 1
        } else if(sender == btnSCorporation) {
            s_corporation = 1
        } else if(sender == btnPartnership) {
            partnership = 1
        } else if(sender == btnTrustEstate) {
            trust = 1
        } else if(sender == btnLimitedCompany) {
            txtFieldTaxClassification.isHidden = false
            limited_liability_company = 1
        } else {
            other = 1
        }

        if(limited_liability_company == 1) {
            self.showLimitedLibilityCompany()
        } else {
            self.hideLimitedLibilityCompany()
        }
        
        sender.isSelected = true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtViewAdddress == textView && txtViewAdddress.placeholder == PLACEHOLDER_TEXT{
            self.txtFieldAccountNumber.becomeFirstResponder()

            let autocompleteController = GMSAutocompleteViewController()
                  autocompleteController.delegate = self
                    
                    // Specify the place data types to return.
                    let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt64(GMSPlaceField.name.rawValue) |
                        UInt64(GMSPlaceField.placeID.rawValue) | (GMSPlaceField.coordinate.rawValue)  |
                                                                (GMSPlaceField.formattedAddress.rawValue) )
                    autocompleteController.placeFields = fields
                    autocompleteController.modalTransitionStyle = .crossDissolve
                    // Display the autocomplete view controller.
                    present(autocompleteController, animated: true, completion: nil)
//            return false
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if txtFieldTaxClassification == textField{
            if(txtFieldTaxClassification.text != "" && string != "") {
    //            txtFieldTaxClassification.text = string.uppercased()
                return false
            }
        }
        if(txtFieldTaxClassification == textField) {
            if(string.lowercased() == "c" || string.lowercased() == "s" || string.lowercased() == "p" || string.lowercased() == ""){
                return true
            }
        }
        
        if(txtFieldSocialSecurity == textField || txtFieldSocialEmployer == textField) {
            let maxLength = 9
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }

        return false
    }

    @objc func btnSeeInstructionClicked() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let webVC = storyBoard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        webVC.titleString = "W-9 form"
        webVC.urlString = self.fw9Form
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
    @objc func leftButtonPressed(_ selector: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnSUBMITClicked() {
        
        //Section 1
        txtFieldName.text = txtFieldName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        txtFieldBussinessName.text = txtFieldBussinessName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Section 3
        txtFieldTaxClassification.text = txtFieldTaxClassification.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
        //Section 4
        txtFieldExemptPayeeCode.text = txtFieldExemptPayeeCode.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        txtFieldFATCA.text = txtFieldFATCA.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Section 5
        txtViewAdddress.text = txtViewAdddress.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Section 6
        txtFieldCity.text = txtFieldCity.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        txtFieldState.text = txtFieldState.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        txtFieldZipcode.text = txtFieldZipcode.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Section 7
        txtFieldAccountNumber.text = txtFieldAccountNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        txtViewNameAddress.text = txtViewNameAddress.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Section 8
        txtFieldSocialSecurity.text = txtFieldSocialSecurity.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        txtFieldSocialEmployer.text = txtFieldSocialEmployer.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        //
        let name = txtFieldName.text!
        //OPTIONL
        let business_name = txtFieldBussinessName.text!
        let payee_code = txtFieldExemptPayeeCode.text!
        let address = txtViewAdddress.text!
        let city = txtFieldCity.text!
        let state = txtFieldState.text!
        let zipcode = txtFieldZipcode.text!
        
        //OPTIONAL
        let account_number = txtFieldAccountNumber.text!
        //OPTIONAL
        let requester_name_address = txtViewNameAddress.text!
        
        let reporting_code = txtFieldFATCA.text!
        let ss_number = txtFieldSocialSecurity.text!
        let sei_number = txtFieldSocialEmployer.text!
        
        let tax_classification = txtFieldTaxClassification.text!
        
        if(name == "") {
            self.view.makeToast("Please enter the name.")
            return
        }
        if((individual+c_corporation+s_corporation+partnership+trust+limited_liability_company+other) == 0) {
            self.view.makeToast("Please select federal tax classification.")
            return
        }
//        if(business_name == "") {
//            self.view.makeToast("Please enter the business name.")
//            return
//        }
//        if(payee_code == "") {
//            self.view.makeToast("Please enter the payee code.")
//            return
//        }
        if(address == "") {
            self.view.makeToast("Please enter the address.")
            return
        }
        if(city == "") {
            self.view.makeToast("Please enter the city.")
            return
        }
        if(state == "") {
            self.view.makeToast("Please enter the state.")
            return
        }
        if(zipcode == "") {
            self.view.makeToast("Please enter the zipcode.")
            return
        }
//        if(reporting_code == "") {
//            self.view.makeToast("Please enter the reporting code.")
//            return
//        }
        if(ss_number == "" && sei_number == "") {
            self.view.makeToast("Please enter \"Social security number\" OR \" Employer identification number\".")
            return
        } else if(ss_number.count != 9 && sei_number.count != 9) {
            self.view.makeToast("Please enter 9 digit \"Social security number\" OR \" Employer identification number\".")
            return
        }
        
        //account_number_2
        let parameters:[String:Any] = ["name": name, "business_name": business_name, "payee_code": payee_code, "address": address, "city": city, "state": state, "zipcode": zipcode, "account_number": account_number, "account_number_2": "", "requester_name_address": requester_name_address, "reporting_code": reporting_code, "ss_number": ss_number, "sei_number": sei_number, "individual": individual, "c_corporation": c_corporation, "s_corporation": s_corporation, "partnership": partnership, "trust": trust, "limited_liability_company": limited_liability_company, "other": other, "tax_classification": tax_classification] as [String:Any]
        

        print("W9 parameters = ", parameters)
        self.saveHelperW9FormDetailAPICall(parameters: parameters)
    }

    //MARK: - API
    func saveHelperW9FormDetailAPICall(parameters:[String:Any]) {
        
        StaticHelper.shared.startLoader(self.view)
        CommonAPIHelper.saveHelperW9FormDetailAPICall(VC: self, params: parameters, completetionBlock: { (result, error, isexecuted) in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                StaticHelper.shared.stopLoader()
                
                if error != nil {
                    
                    return
                } else {
                    self.gotoFilledW9Form()
                    return
                }
            }
        })
    }
    
    func getHelperW9FormDetailAPICall() {
        
        StaticHelper.shared.startLoader(self.view)

        CommonAPIHelper.getHelperW9FormDetailAPICall(VC: self, completetionBlock: { (result, error, isexecuted) in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                StaticHelper.shared.stopLoader()
                
                if error != nil {
                    
                    return
                } else {
                    self.setNavigationTitle("W-9 form")
                    print("result = ", result)
                    self.resultData = result ?? [:]
                    
                    self.status = result?["status"] as? Int ?? 0
                    self.is_verified = result?["is_verified"] as? Int ?? 0
                    self.message = result?["message"] as? String ?? ""
                    self.helper_signature = result?["helper_signature"] as? String ?? ""
                    self.fw9Form = result?["fw9Form"] as? String ?? ""
                    self.fw9FormDownload = result?["fw9FormDownload"] as? String ?? ""
                    
                    self.individual = result?["individual"] as? Int ?? 0
                    self.c_corporation = result?["c_corporation"] as? Int ?? 0
                    self.s_corporation = result?["s_corporation"] as? Int ?? 0
                    self.partnership = result?["partnership"] as? Int ?? 0
                    self.trust = result?["trust"] as? Int ?? 0
                    self.limited_liability_company = result?["limited_liability_company"] as? Int ?? 0
                    self.other = result?["other"] as? Int ?? 0
                    
                    self.setParameters()
                    self.checkStatusAndProceed()
                    return
                }
            }
        })
    }
    
    func checkStatusAndProceed() {
    
        if(status == 0) {
            self.screenDesigning()
        } else if(status == 1) {
            if(is_verified == 0) {//Pending
                if(isFromProfile == true){
                    self.gotoPendingVerificationVC()
                } else {
                    appDelegate.gotoHomeVC()
                }
            } else if(is_verified == 1) {//Approve
                if(isFromProfile == true){
                    self.gotoApproveW9Form()
                } else {
                    appDelegate.gotoHomeVC()
                }
            } else if(is_verified == 2) {//Reject
                
                self.gotoRejectVerificationVC()
            }
        }
    }
    
    func checkProfileForNewUser() {
        StaticHelper.shared.startLoader(self.view)
        CommonAPIHelper.getProfile(VC: self) { (res, err, isExecuted) in            
            DispatchQueue.main.async {
                StaticHelper.shared.stopLoader()
                if isExecuted {
                    profileInfo =  HelperDetailsModel.init(profileDict: res!)
                                        
                    if(profileInfo?.is_new == 1) {
                        self.getHelperW9FormDetailAPICall()
                    } else {
                        appDelegate.gotoHomeVC()
                    }
                } else {
                    
                }
            }
        }
    }
    
    //MARK:- Navigation
    func gotoPendingVerificationVC() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let w9PendingVC = storyBoard.instantiateViewController(withIdentifier: "W9PendingViewController") as! W9PendingViewController
        w9PendingVC.isFromProfile = self.isFromProfile
        w9PendingVC.isReminder = self.isReminder
        
        self.navigationController?.pushViewController(w9PendingVC, animated: false)
    }
    
    func gotoRejectVerificationVC() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let w9PendingVC = storyBoard.instantiateViewController(withIdentifier: "W9PendingViewController") as! W9PendingViewController
        w9PendingVC.isFromProfile = self.isFromProfile
        w9PendingVC.delegate = self
        w9PendingVC.isReject = true
        w9PendingVC.message = self.message
        w9PendingVC.isReminder = self.isReminder
        self.navigationController?.pushViewController(w9PendingVC, animated: false)
    }
        
    func gotoFilledW9Form() {
        //https://devadmin.gomoveit.com/fw9?auth_key=e870b489d55644beae4911afd26ecebe&timezone=Asia/Kolkata
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let webVC = storyBoard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        webVC.titleString = "W-9 form"
        webVC.isFromProfile = self.isFromProfile
        webVC.showSubmitButton = true
        webVC.showDownloadButton = false
        webVC.urlString = self.fw9Form+"?auth_key="+UserCache.userToken()!+"&timezone="+TimeZone.current.identifier
        self.navigationController?.pushViewController(webVC, animated: false)
    }
    
    func gotoApproveW9Form() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let webVC = storyBoard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        webVC.titleString = "W-9 form"
        webVC.showSubmitButton = false
        webVC.showDownloadButton = true
        webVC.w9FormDownloadURL = self.fw9FormDownload+"?auth_key="+UserCache.userToken()!+"&timezone="+TimeZone.current.identifier
        webVC.urlString = self.fw9Form+"?auth_key="+UserCache.userToken()!+"&timezone="+TimeZone.current.identifier
        self.navigationController?.pushViewController(webVC, animated: false)
    }
    
    
                
    //MARK: - W9PendingViewControllerDelegate
    func resubmitRejectedForm() {
        self.isReject = true
        self.screenDesigning()
        self.setParameters()
    }

}
extension UILabel {
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
}

extension UIButton {
    func moveImageLeftTextCenter(imagePadding: CGFloat = 15.0){
        guard let imageViewWidth = self.imageView?.frame.width else{return}
        guard let titleLabelWidth = self.titleLabel?.intrinsicContentSize.width else{return}
        self.contentHorizontalAlignment = .left
        imageEdgeInsets = UIEdgeInsets(top: 0.0, left: imagePadding - imageViewWidth / 2, bottom: 0.0, right: 0.0)
        titleEdgeInsets = UIEdgeInsets(top: 0.0, left: imageViewWidth, bottom: 0.0, right: 0.0)
    }
}

extension Int {
    var boolValue: Bool { return self != 0 }
}
extension W9FormViewController:GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {

        txtViewAdddress.text = place.formattedAddress!
        print(place)
        

        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(place.formattedAddress!) { (placemarks, error) in
            if((error) != nil){
                print("Error", error ?? "")
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                print("Lat: \(coordinates.latitude) -- Long: \(coordinates.longitude)")
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                  
                    print(pm.locality,pm.subLocality,pm.name)
                    
                    self.txtFieldState.text = pm.administrativeArea
                    self.txtFieldCity.text = pm.locality
                    self.txtFieldZipcode.text = pm.postalCode

                    if pm.locality == nil || pm.administrativeArea == nil || pm.country  == nil{
                    }
                    else
                    {
                    }
                    
                }
            }
            else{
            }
            
        }
        self.view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
