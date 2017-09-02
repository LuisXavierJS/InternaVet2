//
//  CustomButton.swift
//  InternaVet2
//
//  Created by Jorge Luis on 30/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

@IBDesignable
class CustomButton: UIButton {
    @IBInspectable var lineColor: UIColor = Colors.lightGreen
    @IBInspectable var lineWidth: CGFloat = 1
    
    override func draw(_ rect: CGRect) {
        let con = UIGraphicsGetCurrentContext()
        
        con?.setLineWidth(self.lineWidth)
        con?.setStrokeColor(self.lineColor.cgColor)    
        con?.addLineInPath(for: rect, alignedIn: .top(0))
        con?.addLineInPath(for: rect, alignedIn: .bottom(0))
        con?.strokePath()        
    }
}
