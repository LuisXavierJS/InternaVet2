 //
//  ValuedUILabel.swift
//  InternaVet2
//
//  Created by Jorge Luis on 10/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

@IBDesignable
class ValuedUILabel: UILabel {
    @IBInspectable var alwaysShowTitle: Bool = false
    @IBInspectable var title: String = "" {
        didSet {
            self.setValue(self.text ?? (self.alwaysShowTitle ? " " : "") )
        }
    }
    
    override var text: String? {
        get {
            if let titleRange = super.text?.range(of: self.title) {
                return super.text?.replacingCharacters(in: titleRange, with: (self.alwaysShowTitle ? " " : ""))
            }else {
                return super.text
            }
        }
        
        set {
            self.setValue(newValue ?? (self.alwaysShowTitle ? " " : ""))
        }
    }
    
    func setValue(_ text: String) {
        let titleAttrStr = NSAttributedString(string: self.title, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: self.font.pointSize, weight: UIFontWeightMedium)])
        let valueAttrStr = NSAttributedString(string: text, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: self.font.pointSize)])
        let attrStr = NSMutableAttributedString()
        attrStr.append(titleAttrStr)
        attrStr.append(valueAttrStr)
        self.attributedText = attrStr
    }
}
