//
//  RatePopUpViewController.swift
//  MoveIt
//
//  Created by Dushyant on 19/12/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class RatePopUpViewController: UIViewController {
    
    var moveInfo : MoveDetailsModel?
    
    @IBOutlet weak var bkView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var selectedRatingIndex = 0
   
    @IBOutlet weak var rateTipButton: UIButton!
    
    var viewRatting:AppRattingViewView!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        

        let urlString = moveInfo?.valid_customer_photo_url
        if urlString != nil{
            userImgView.af.setImage(withURL: urlString!)
        }

        userNameLabel.text = moveInfo?.valid_customer_name
        
        titleLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 15.0)
        userNameLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 15.0)
        rateTipButton.titleLabel?.font = UIFont.josefinSansSemiBoldFontWithSize(size: 15.0)
        
        userImgView.layer.cornerRadius = 30.0 * screenHeightFactor
        bkView.layer.cornerRadius = 15.0 * screenHeightFactor
        
        
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        self.getCustomerRatingsStatus()
    }
    
    @IBAction func rateAction(_ sender: Any) {
        saveRatings()
      //  self.dismiss(animated: true, completion: nil)
    }
    func saveRatings(){
    
        let params = ["request_id":moveInfo!.request_id! , "customer_id":moveInfo!.customer_id!, "review_description":"", "rating":(selectedRatingIndex + 1)] as [String : Any]
        callAnalyticsEvent(eventName: "moveit_customer_review", desc: ["description":"job id: \(moveInfo!.request_id!) that helper given review to customer : \(moveInfo!.customer_id!)"])
        CommonAPIHelper.saveRatings(VC: self, params: params) { (res, err, isExe) in
            if isExe{
                self.dismiss(animated: true, completion: nil)
            //    self.ratingsDelegate?.ratingsAdded()
                UIApplication.shared.keyWindow?.rootViewController!.view.makeToast("Your information submitted successfully.")
            }
        }
    }
    
    func getCustomerRatingsStatus(){
        CommonAPIHelper.getHelperAppRating(VC: self, move_id: (moveInfo?.request_id)!, completetionBlock: { (result, error, isexecuted) in
                     
            DispatchQueue.main.async {
                if error != nil{
                    return
                }
                else {
                    let is_rated:Int = result!["is_rated"] as? Int ?? 0
                    
                    if(is_rated == 0) {
                        self.viewRatting = AppRattingViewView.init(frame: .zero)
                        self.viewRatting.selfVC = self
                        self.viewRatting.request_id = (self.moveInfo?.request_id)!
                        self.view?.addSubview(self.viewRatting)
                    } else {
                    }
                }
            }
        })
    }

}
extension RatePopUpViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RatingCollectionViewCell", for: indexPath) as! RatingCollectionViewCell
       
        if indexPath.item <= selectedRatingIndex{
            cell.imgView.image = UIImage.init(named: "rating_star_selected")
        }
        else{
            cell.imgView.image = UIImage.init(named: "rating_star_unselected")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          return CGSize.init(width: 30.0 * screenWidthFactor, height: 30.0 * screenWidthFactor)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           
        selectedRatingIndex = indexPath.item
        collectionView.reloadData()
    }
}
