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
    @IBInspectable var bottomBorder: Bool = false
    @IBInspectable var topBorder: Bool = false
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
    
    var isFullfilled: Bool { return true }
    
    func getFullfilled() -> Bool {
        let fullfilled = self.isFullfilled
        self.lineColor = fullfilled ? Colors.lightGreen : UIColor.red
        self.setNeedsDisplay()
        return fullfilled
    }
}

//abstract class!
class BorderedArrowViewField: BorderedView {
    @IBInspectable var fieldIndent: CGFloat = 15{ didSet{ self.setupFrames() } }
    @IBInspectable var spaceBetween: CGFloat = 10{ didSet{ self.setupFrames() } }
    @IBInspectable var selRightMargin: CGFloat = 5{ didSet{ self.setupFrames() } }
    
    weak var field: UIView!{
        assertionFailure("MUST IMPLEMENT A FIELD ON SUBCLASS!")
        return nil
    }
    var fieldRelativeSize: CGFloat {
        return 0.5
    }
    weak var arrowsView: DoubleArrowsView!
    
    func createArrowView() -> DoubleArrowsView! {
        assertionFailure("MUST IMPLEMENT A FIELD ON SUBCLASS!")
        return nil
    }
    
    override func setupViews() {
        super.setupViews()
        let arrowView = self.createArrowView()!
        self.addSubview(arrowView)
        self.arrowsView = arrowView
        self.addSubview(self.field)
    }
    
    override func setupFrames() {
        super.setupFrames()
        self.field.frame = self.bounds.insetBy(dx: 0, dy: self.lineWidth)
            .with(width: self.bounds.width*self.fieldRelativeSize - self.fieldIndent/2 - self.spaceBetween/2 - self.selRightMargin/2)
            .aligned([.left(self.fieldIndent)], in: self.bounds)
        
        self.arrowsView.frame = self.bounds
            .insetBy(dx: 0, dy: self.lineWidth)
            .with(width: self.bounds.width*(1 - self.fieldRelativeSize) - self.fieldIndent/2 - self.spaceBetween/2 - self.selRightMargin/2)
            .aligned([.right(-self.selRightMargin)], in: self.bounds)
    }
    
    override func prepareForInterfaceBuilder() {
        self.arrowsView.prepareForInterfaceBuilder()
    }
}


@IBDesignable
class BorderedTextFieldView: BorderedView {
    @IBInspectable var dxInsets: CGFloat = 10 {didSet{self.setupFrames()}}
    @IBInspectable var dyInsets: CGFloat = 5 {didSet{self.setupFrames()}}
    @IBInspectable var placeholder: String = ""{didSet{self.textField.placeholder = self.placeholder}}    
    @IBInspectable var textColor: UIColor = Colors.darkGreen { didSet{ self.textField.textColor = self.textColor } }
    @IBInspectable var placeholderColor: UIColor = Colors.darkGreen.withAlphaComponent(0.5){ didSet{ self.textField.placeholderColor = self.placeholderColor } }
    @IBInspectable var floatingLabelTextColor: UIColor = Colors.darkGreen{ didSet{ self.textField.floatingLabelTextColor = self.floatingLabelTextColor } }
    @IBInspectable var floatingLabelActiveTextColor: UIColor = Colors.lightGreen{ didSet{ self.textField.floatingLabelActiveTextColor = self.floatingLabelActiveTextColor } }
    
    weak var textField: CustomFloatTextField!
    
    func createTextField() -> CustomFloatTextField {
        return CustomFloatTextField()
    }
    
    override func setupViews() {
        super.setupViews()
        let textField = self.createTextField()
        self.textField = textField
        self.addSubview(self.textField)
    }
    
    override func setupFrames() {
        super.setupFrames()
        self.textField.frame = self.bounds.insetBy(dx: self.dxInsets, dy: self.dyInsets)
    }
}
