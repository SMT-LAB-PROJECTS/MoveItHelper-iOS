//
//  CommuntityViewController.swift
//  MoveIt
//
//  Created by Dushyant on 28/05/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class CommuntityViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension CommuntityViewController: UITableViewDelegate,UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if [0,3,7].contains(indexPath.section){
            let textCell = tableView.dequeueReusableCell(withIdentifier: "CommunityTextContentTableViewCell", for: indexPath) as! CommunityTextContentTableViewCell
            return textCell
        }
        else if [1,4,8].contains(indexPath.section){
            let imgViewCell = tableView.dequeueReusableCell(withIdentifier: "CommunityImageContentTableViewCell", for: indexPath) as! CommunityImageContentTableViewCell
            return imgViewCell
        }
        else{
            let videoCell = tableView.dequeueReusableCell(withIdentifier: "CommunityVideoContentTableViewCell", for: indexPath) as! CommunityVideoContentTableViewCell
            return videoCell
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "CommunityHeaderTableViewCell") as! CommunityHeaderTableViewCell
        return headerCell
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "CommunityFooterTableViewCell") as! CommunityFooterTableViewCell
        return headerCell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0 * screenHeightFactor
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180.0 * screenHeightFactor
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60.0 * screenHeightFactor
    }
    
    
}
