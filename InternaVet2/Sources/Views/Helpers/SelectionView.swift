//
//  CustomButton.swift
//  InternaVet2
//
//  Created by Jorge Luis on 22/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

@IBDesignable
class SelectionButtonView: ContentView {
    @IBInspectable var lineColor: UIColor = Colors.lightGreen
    @IBInspectable var lineWidth: CGFloat = 1
    @IBInspectable var arrowsMainColor: UIColor = Colors.darkGreen{didSet{self.setArrowsDisplay()}}
    @IBInspectable var arrowsBaseColor: UIColor = Colors.lightGreen{didSet{self.setArrowsDisplay()}}
    @IBInspectable var arrowsWidth: CGFloat = 4{didSet{self.setArrowsDisplay()}}
    @IBInspectable var arrowsSize: CGSize = CGSize(width: 20, height: 25){didSet{self.setArrowsDisplay()}}
    
    fileprivate(set) var leftArrow: ArrowTouchableView = ArrowTouchableView(ArrowDirection.left)
    fileprivate(set) var rightArrow: ArrowTouchableView = ArrowTouchableView(ArrowDirection.right)
    
    private func setArrowsDisplay() {
        self.setupArrowsLayout()
        self.setupArrowsFrames()
        self.leftArrow.setNeedsDisplay()
        self.rightArrow.setNeedsDisplay()
    }
    
    private func setupArrow(arrow: ArrowView) {
        arrow.mainArrowColor = self.arrowsMainColor
        arrow.baseArrowColor = self.arrowsBaseColor
        arrow.middleLineColor = UIColor.clear
        arrow.lineColor = UIColor.clear
        arrow.lineWidth = self.arrowsWidth
        arrow.backgroundColor = UIColor.clear
    }
    
    private func setupArrowsFrames(){
        self.leftArrow.frame = self.arrowsSize.toRect().aligned([.verticallyCentralized(0),.left(5)], in: self.bounds)
        self.rightArrow.frame = self.arrowsSize.toRect().aligned([.verticallyCentralized(0),.right(-5)], in: self.bounds)
    }
    
    private func setupArrowsLayout(){
        self.setupArrow(arrow: self.leftArrow)
        self.setupArrow(arrow: self.rightArrow)
    }
    
    override func setupViews() {
        self.setupArrowsLayout()
        self.addSubview(self.leftArrow)
        self.addSubview(self.rightArrow)
    }
    
    override func setupFrames() {
        self.setupArrowsFrames()
    }
    
    override func draw(_ rect: CGRect) {
        let con = UIGraphicsGetCurrentContext()
        con?.setLineWidth(self.lineWidth)
        con?.setStrokeColor(self.lineColor.cgColor)
        con?.addLineInPath(for: rect, alignedIn: .top(0))
        con?.addLineInPath(for: rect, alignedIn: .bottom(0))
        con?.strokePath()        
    }
}
