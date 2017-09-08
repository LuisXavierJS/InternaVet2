//
//  CustomButton.swift
//  InternaVet2
//
//  Created by Jorge Luis on 30/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

@IBDesignable
class BorderedView: ContentView {
    @IBInspectable var lineColor: UIColor = Colors.lightGreen
    @IBInspectable var lineWidth: CGFloat = 1
    @IBInspectable var bottomBorder: Bool = true
    @IBInspectable var topBorder: Bool = true
    @IBInspectable var leftBorder: Bool = false
    @IBInspectable var rightBorder: Bool = false
    
    override func draw(_ rect: CGRect) {
        let con = UIGraphicsGetCurrentContext()
        
        con?.setLineWidth(self.lineWidth)
        con?.setStrokeColor(self.lineColor.cgColor)
        if self.bottomBorder {
            con?.addLineInPath(for: rect, alignedIn: .bottom(0))
        }
        if self.topBorder {
            con?.addLineInPath(for: rect, alignedIn: .top(0))
        }
        if self.leftBorder {
            con?.addLineInPath(for: rect, alignedIn: .left(0))
        }
        if self.rightBorder {
            con?.addLineInPath(for: rect, alignedIn: .right(0))
        }
        con?.strokePath()        
    }
}
