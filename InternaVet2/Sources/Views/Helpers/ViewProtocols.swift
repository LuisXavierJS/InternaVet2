//
//  ContentView.swift
//  InternaVet2
//
//  Created by Jorge Luis on 13/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit


protocol BorderedView {
    var lineColor: UIColor {get set}
    var lineWidth: CGFloat {get set}
}
extension BorderedView {
    func drawBorder(in rect: CGRect){
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


