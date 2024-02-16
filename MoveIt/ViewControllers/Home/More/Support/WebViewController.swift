//
//  WebViewController.swift
//  MoveIt
//
//  Created by Dushyant on 20/07/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var bottomSpaceWebView: NSLayoutConstraint!
    
    var isFromProfile:Bool = false
    var showSubmitButton:Bool = false
    var showDownloadButton:Bool = false
    var isComeFromAgreement:Bool = false
    var w9FormDownloadURL = ""
    
    var titleString = ""
    var urlString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(titleString)

        let leftBarButtonItem = StaticHelper.leftBarButtonWithImageNamed(imageName: "backward_arrow_icon", vc: self)
        let urlreq = URLRequest.init(url: URL.init(string: urlString)!)
        webView.load(urlreq)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        
        if(urlString.contains("auth_key") == true) {
            if(showSubmitButton == true){
                let rightBarButton = StaticHelper.rightBarButtonWithText(text: "SUBMIT", vc: self)
                self.navigationItem.rightBarButtonItem = rightBarButton
            } else if(showDownloadButton == true) {
                let rightBarButton = StaticHelper.rightBarButtonWithText(text: " Download ", vc: self)
                self.navigationItem.rightBarButtonItem = rightBarButton
            }
        }
    }

    @objc func leftButtonPressed(_ selector: UIButton){
        //
        if(urlString.contains("auth_key") == true) {
            if(showSubmitButton == false) {
                
                var isPopped:Bool = false
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: ProfileViewController.self) {
                        isPopped = true
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }

                if(isPopped == false) {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }        
    }
    
    @objc func rightTextPressed(_ selector: UIButton){
        
        if(showDownloadButton == true) {
            self.downloadAndSharePDFForm()
        } else {
            self.finalSubmissionW9FormAPICall()
        }
    }
    
    func downloadAndSharePDFForm(){
        //w9FormDownloadURL
        self.savePdf()
    }
    func savePdf(){
        if isComeFromAgreement{
            let tempStr = appDelegate.baseContentURL + kAPIMethods.download_agreement_mobile
            
            
//        https://dev.gomoveit.com/agreement-mobile?download=1
            
            let pdfURL:URL = URL(string: tempStr)!
            let pdfDoc = NSData(contentsOf:pdfURL)
            
            let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let paths = documentsUrl.appendingPathComponent("agreement.pdf")
            print("paths = ", paths)
            
            pdfDoc!.write(to: paths, atomically: true)
            //fileManager.createFile(atPath: paths.path, contents: pdfDoc as Data?, attributes: nil)
            self.loadPDFAndShare(paths)
        }else{
            let pdfURL:URL = URL(string: w9FormDownloadURL)!
            let pdfDoc = NSData(contentsOf:pdfURL)
            
            let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let paths = documentsUrl.appendingPathComponent("w9Form.pdf")
            print("paths = ", paths)
            
            pdfDoc!.write(to: paths, atomically: true)
            //fileManager.createFile(atPath: paths.path, contents: pdfDoc as Data?, attributes: nil)
            self.loadPDFAndShare(paths)
        }
       
    }
    
    func loadPDFAndShare(_ documentoPath:URL){

        print("documentoPath = ", documentoPath)
        let fileManager = FileManager.default

        if fileManager.fileExists(atPath: documentoPath.path) {
            let documento = NSData(contentsOfFile: documentoPath.path)
            let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [documento!], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            present(activityViewController, animated: true, completion: nil)
        } else {
            print("document was not found")
        }
    }
    
    func finalSubmissionW9FormAPICall() {
        
        StaticHelper.shared.startLoader(self.view)

        CommonAPIHelper.finalSubmissionW9FormAPICall(VC: self, completetionBlock: { (result, error, isexecuted) in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                StaticHelper.shared.stopLoader()
                
                if error != nil {
                    return
                } else {
                    if(self.isFromProfile == true) {
                        self.gotoPendingVerificationVC()
                    } else {
                        appDelegate.gotoHomeVC()
                    }
                    return
                }
            }
        })
    }
    
    func gotoPendingVerificationVC() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let w9PendingVC = storyBoard.instantiateViewController(withIdentifier: "W9PendingViewController") as! W9PendingViewController
        w9PendingVC.isFromProfile = self.isFromProfile
        self.navigationController?.pushViewController(w9PendingVC, animated: true)

    }

}
