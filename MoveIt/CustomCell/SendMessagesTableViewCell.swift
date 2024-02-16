//
//  SendMessagesTableViewCell.swift
//  MoveIt
//
//  Created by Dushyant on 09/07/19.
//  Copyright © 2019 Jyoti. All rights reserved.
//

import UIKit

class SendMessagesTableViewCell: UITableViewCell {

    @IBOutlet weak var bkView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var widthConst: NSLayoutConstraint!
    
    
    var stringMessage = ""
    var arrayString :[String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        messageLabel.font = UIFont.josefinSansRegularFontWithSize(size: 14.0)
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
        messageLabel.attributedText = formattedText
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

extension String {
    static func format(strings: [String],
                    boldFont: UIFont = UIFont.josefinSansRegularFontWithSize(size: 14.0),
                    boldColor: UIColor = lightBlueColor,
                    inString string: String,
                    font: UIFont = UIFont.josefinSansRegularFontWithSize(size: 14.0),
                    color: UIColor = UIColor.black) -> NSAttributedString {
        let attributedString =
            NSMutableAttributedString(string: string,
                                    attributes: [
                                        NSAttributedString.Key.font: font,
                                        NSAttributedString.Key.foregroundColor: color])
        let boldFontAttribute = [NSAttributedString.Key.font: boldFont, NSAttributedString.Key.foregroundColor: boldColor]
        for bold in strings {
            attributedString.addAttributes(boldFontAttribute, range: (string as NSString).range(of: bold))
        }
        return attributedString
    }
    func htmlAttributedString() -> NSAttributedString? {
           guard let data = self.data(using: .utf8) else {
               return nil
           }
           
        return try? NSAttributedString(
               data: data,
               options: [.documentType: NSAttributedString.DocumentType.html],
               documentAttributes: nil
           )
       }
    func htmlToAttributedString(fontName: String = "JosefinSans-Regular", fontSize: CGFloat = 14.0) -> NSAttributedString? {
        var sizeOfFont : CGFloat?
        
        if IS_IPHONE_4_OR_LESS {
            sizeOfFont = fontSize - 2.0
        }
        if IS_IPHONE_5 {
            sizeOfFont = fontSize
        }
        if IS_IPHONE_6 {
            sizeOfFont = fontSize + 3.0
        }
        if IS_IPHONE_6P {
            sizeOfFont = fontSize + 4.0
        }
        if IS_IPHONE_X {
            sizeOfFont = fontSize + 4.0
        }
        if IS_IPHONE_XSMax {
            sizeOfFont = fontSize + 4.0
        }
        if IS_IPAD_PRO_1024{
            sizeOfFont = fontSize + 12.0;
        }else if (IS_IPAD_PRO_1112){
            sizeOfFont = fontSize + 10.0;
        }else if (IS_IPAD_PRO_1366){
            sizeOfFont = fontSize + 20.0;
        }else  if IS_IPHONE_XIII || IS_IPHONE_XIIIPROMAX{
            sizeOfFont = fontSize + 4
        }
        if sizeOfFont == nil{
            sizeOfFont = fontSize
        }
        
        let style = "<style>body { font-family: '\(fontName)'; font-size:\(fontSize + 3.0)px; }</style>"
          guard let data = (self + style).data(using: .utf8) else {
              return nil
          }
          return try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
      }
}
extension UILabel {
    func indexOfAttributedTextCharacterAtPoint(point: CGPoint) -> Int {
        assert(self.attributedText != nil, "This method is developed for attributed string")
        let textStorage = NSTextStorage(attributedString: self.attributedText!)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: self.frame.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = self.numberOfLines
        textContainer.lineBreakMode = self.lineBreakMode
        layoutManager.addTextContainer(textContainer)

        let index = layoutManager.characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return index
    }
}

extension URL {
    var sanitise: URL {
        var url:String = self.path
        if let components = URLComponents(url: self, resolvingAgainstBaseURL: false) {
            if components.scheme == nil {
                url = "http://" + "\(url)"
                return URL(string: url) ?? self
            }
            return self
        }
        return self
    }
}
