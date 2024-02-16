//
//  ReceiveMessagesTableViewCell.swift
//  MoveIt
//
//  Created by Dushyant on 09/07/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class ReceiveMessagesTableViewCell: UITableViewCell {

    @IBOutlet weak var bkView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var widthConst: NSLayoutConstraint!
    
    var stringMessage = ""
    var arrayString :[String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        messageLabel.font = UIFont.josefinSansRegularFontWithSize(size: 14.0)
        timeLabel.font = UIFont.josefinSansSemiBoldFontWithSize(size: 10.0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bkView.layer.cornerRadius = 5.0 * screenHeightFactor

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    
    func messageDisplayWay(message:String){
        stringMessage = message
        let detectorType: NSTextCheckingResult.CheckingType = [.link]//[.address, .phoneNumber, .link, .date]
        do {
           let detector = try NSDataDetector(types: detectorType.rawValue)
           let results = detector.matches(in: stringMessage, options: [], range:
           NSRange(location: 0, length: stringMessage.utf16.count))

           for result in results {
             if let range = Range(result.range, in: stringMessage) {
                 arrayString.append("\(stringMessage[range])")
             }
           }
         } catch {
            print("handle error")
         }
        let formattedText = String.format(strings: arrayString,
                                            boldFont: UIFont.josefinSansRegularFontWithSize(size: 14.0),
                                            boldColor: lightBlueColor,
                                            inString: stringMessage,
                                            font: UIFont.josefinSansRegularFontWithSize(size: 14.0),
                                            color: UIColor.black)
        
        messageLabel.attributedText = stringMessage.htmlToAttributedString()
        messageLabel.numberOfLines = 0
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTermTapped))
        messageLabel.addGestureRecognizer(tap)
        messageLabel.isUserInteractionEnabled = true
        
    }
    @objc func handleTermTapped(gesture: UITapGestureRecognizer) {
        let termString = stringMessage as NSString
        let tapLocation = gesture.location(in: messageLabel)
        let index = messageLabel.indexOfAttributedTextCharacterAtPoint(point: tapLocation)

        if arrayString.count > 0{
            for resultString in arrayString {
                if checkRange(termString.range(of: resultString), contain: index) {
                    var url = URL(string: "\(resultString)")
                    url = url?.sanitise
                    if UIApplication.shared.canOpenURL(url!) {
                         UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                    }
                }
            }
        }
    }
    func checkRange(_ range: NSRange, contain index: Int) -> Bool {
        return index > range.location && index < range.location + range.length
    }
}
