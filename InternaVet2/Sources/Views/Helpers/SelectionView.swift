//
//  CustomButton.swift
//  InternaVet2
//
//  Created by Jorge Luis on 22/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

@IBDesignable
class SelectionButton: UIView {
    @IBInspectable var lineColor: UIColor = Colors.lightGreen
    @IBInspectable var lineWidth: CGFloat = 1
    
    override func draw(_ rect: CGRect) {
        let con = UIGraphicsGetCurrentContext()
        
        con?.setLineWidth(self.lineWidth)
        con?.setStrokeColor(self.lineColor.cgColor)
        con?.move(to: CGPoint(x:0,y:0))
        con?.addLine(to: CGPoint(x:rect.maxX,y:0))
        con?.move(to: CGPoint(x:0,y:rect.maxY))
        con?.addLine(to: CGPoint(x:rect.maxX,y:rect.maxY))
        con?.strokePath()        
    }
}
