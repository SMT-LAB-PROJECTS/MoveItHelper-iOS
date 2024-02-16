//
//  SignUpStep3VC.swift
//  MoveIt
//
//  Created by Jyoti Negi on 02/05/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit
import AVFoundation

class SignUpStep3VC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var headersignUpLabel: UILabel!
    @IBOutlet weak var step3Label: UILabel!
    @IBOutlet weak var step3Tableview: UITableView!
    @IBOutlet weak var step3TableContentView: UIView!
    @IBOutlet weak var step3OuterView: UIView!
    
    @IBOutlet weak var uploadPhotoLabel: UILabel!
    @IBOutlet weak var uploadImageOuterView: UIView!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var takeAMinuteLabel: UILabel!
    @IBOutlet weak var photosVehicleLabel: UILabel!
    @IBOutlet weak var needToUploadLabel: UILabel!
  
    @IBOutlet weak var photosCollectionview: UICollectionView!
    @IBOutlet weak var submitButtonOutlet: UIButton!
    
     let imgPicker = UIImagePickerController()
     var profileImageObj: UIImage!
       
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpUI()
    
    }

    func setUpUI(){
       
        headersignUpLabel.font = UIFont.josefinSansRegularFontWithSize(size: 14.0)
        step3Label.font = UIFont.josefinSansRegularFontWithSize(size: 12.0)
        uploadPhotoLabel.font = UIFont.josefinSansRegularFontWithSize(size: 14.0)
        takeAMinuteLabel.font = UIFont.josefinSansRegularFontWithSize(size: 10.0)
        photosVehicleLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        submitButtonOutlet.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 14.0)
        
        imgPicker.delegate = self
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        
        step3OuterView.layer.cornerRadius = 10.0
        step3OuterView.layer.masksToBounds = true
       
        step3TableContentView.frame.size.height = 600 * UIScreen.main.bounds.size.height/568
        
        submitButtonOutlet.layer.cornerRadius = (submitButtonOutlet.frame.size.height/2.0)
        submitButtonOutlet.layer.masksToBounds = true
        
        uploadImageOuterView.layer.cornerRadius = uploadImageOuterView.frame.size.width/2
        uploadImageOuterView.layer.masksToBounds = true
        
        photoImageView.layer.cornerRadius = photoImageView.frame.size.width/2
        photoImageView.layer.masksToBounds = true
        
    }
    
    
    @IBAction func signStep3BackButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {        
        let signStep4 = self.storyboard?.instantiateViewController(withIdentifier: "SignUpStep4VC") as! SignUpStep4VC
        self.navigationController?.pushViewController(signStep4, animated: true)
    }
    
    
    //#MARK:- UploadImageMethod
    
    @IBAction func uploadPhotoButtonPressed(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Choose from your choice", message: nil, preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: "Camera", style: .default) { (action:UIAlertAction) in
            self.openCamera()
        }
        
        let action2 = UIAlertAction(title: "Gallery", style: .default) { (action:UIAlertAction) in
            self.openGallery()
        }
        
        let action3 = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
            self.dismiss(animated: true, completion: {})
        }
        
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        actionSheet.addAction(action3)
        
        DispatchQueue.main.async {
            if UIDevice.current.userInterfaceIdiom == .pad{
                if let popoverController = actionSheet.popoverPresentationController {
                    popoverController.sourceView = self.view
                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                    popoverController.permittedArrowDirections = []
                }
                self.present(actionSheet, animated: true, completion: nil)
            }
            else if UIDevice.current.userInterfaceIdiom == .phone {
                self.present(actionSheet, animated: true, completion: {})
            }
        }
    }
    
    func openCamera() {
        
        
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            //already authorized
            
            imgPicker.allowsEditing = false
            imgPicker.sourceType = UIImagePickerController.SourceType.camera
            imgPicker.cameraCaptureMode = .photo
            imgPicker.modalPresentationStyle = .fullScreen
            present(imgPicker,animated: true,completion: nil)
        }
            
        else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    
                    return
                }
                else {
                    self.alertPromptToAllowCameraAccessViaSetting()
                }
            })
        }
    }
    
    func openGallery(){
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            imgPicker.allowsEditing = false
            imgPicker.sourceType = .photoLibrary
            imgPicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            present(imgPicker, animated: true, completion: nil)
        }
    }
    
    
    //MARK:- Allow Camera in settings
    
    func alertPromptToAllowCameraAccessViaSetting() {
        
        let alert = UIAlertController(
            title: nil,
            message: "Camera Permission is required for uploading Profile Picture.",
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { alert in
            if AVCaptureDevice.devices(for: AVMediaType.video).count > 0 {
                AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
                }
            }
            }
        )
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { alert in
            if AVCaptureDevice.devices(for: AVMediaType.video).count > 0 {
                AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
                    DispatchQueue.main.async() {
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                    print("Settings opened: \(success)") // Prints true
                                })
                            } else {
                                // Fallback on earlier versions
                                if UIApplication.shared.canOpenURL(settingsUrl) {
                                    UIApplication.shared.openURL(settingsUrl)
                                }
                                
                            }
                        }
                        
                    } }
            }
        })
        
        
        present(alert, animated: true, completion: nil)
    }
    
    //*********************************************************
    // MARK :-- UIImagepicker Delegates Methods
    //*********************************************************
    
    
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
         var image : UIImage!
         
         if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
         {
         image = img
         
         }
         else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
         {
         image = img
         }
         //        guard let selectedImage = info[.originalImage] as? UIImage else {
         //            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
         //        }
         profileImageObj = image
        // photoImageView.contentMode = .scaleAspectFill
       //  photoImageView.image = image
         dismiss(animated:true, completion: nil)
        
        self.photosCollectionview.reloadData()
 
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UploadPhotoCell
        
        cell.layer.cornerRadius = 5.0
        cell.layer.borderColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1).cgColor
        cell.layer.borderWidth = 1.0
        cell.layer.masksToBounds = true
        
        if(profileImageObj != nil){
        cell.uploadphotoImageView.image = profileImageObj
        cell.captureIcon.isHidden = true
        }
        
        
        return cell
    }
    
   /* func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGSize.init(width: collectionView.bounds.width/3.0 - 10, height: collectionView.bounds.width/3.0 - 10)
        return size
    }*/
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        
        
    }
    
  
}
