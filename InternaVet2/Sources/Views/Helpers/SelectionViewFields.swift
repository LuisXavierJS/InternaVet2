//
//  LabeledSelectionViewField.swift
//  InternaVet2
//
//  Created by Jorge Luis on 03/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit


@IBDesignable
class LabeledSelectionViewField: SelectionViewField {
    @IBInspectable var labelText: String = ""{ didSet{ self.label.text = labelText } }
    @IBInspectable var labelSize: CGFloat = 14{ didSet{ self.label.font = UIFont.systemFont(ofSize: self.labelSize) } }
    @IBInspectable var labelColor: UIColor = Colors.darkGreen{ didSet{ self.label.textColor = self.labelColor } }    
    
    private var label: UILabel = UILabel()
    
    override weak var field: UIView! {
        return self.label
    }
    
    override func setupViews() {
        super.setupViews()
        self.label.textColor = self.labelColor
        self.label.numberOfLines = 0
        self.label.font = UIFont.systemFont(ofSize: self.labelSize)
    }    

}

@IBDesignable
class TextSelectionViewField: SelectionViewField {
    @IBInspectable var placeholder: String = "" { didSet{ self.textField.placeholder = self.placeholder } }
    @IBInspectable var textColor: UIColor = Colors.darkGreen { didSet{ self.textField.textColor = self.textColor } }
    @IBInspectable var placeholderColor: UIColor = Colors.darkGreen{ didSet{ self.textField.placeholderColor = self.placeholderColor } }
    @IBInspectable var floatingLabelTextColor: UIColor = Colors.darkGreen{ didSet{ self.textField.floatingLabelTextColor = self.floatingLabelTextColor } }
    @IBInspectable var floatingLabelActiveTextColor: UIColor = Colors.lightGreen{ didSet{ self.textField.floatingLabelActiveTextColor = self.floatingLabelActiveTextColor } }
    
    private var textField: CustomFloatTextField = CustomFloatTextField()
    
    override var field: UIView! {
        return self.textField
    }
    
    override func setupViews() {
        super.setupViews()
        self.textField.placeholderColor = self.placeholderColor
        self.textField.floatingLabelTextColor = self.floatingLabelTextColor
        self.textField.floatingLabelActiveTextColor = self.floatingLabelActiveTextColor
        self.textField.textColor = self.textColor
        
    }
    
    override func setupFrames() {
        super.setupFrames()
        self.textField.frame = self.textField.frame.insetBy(dx: 0, dy: 5)
    }
}


class SelectionViewField: BorderedView, SelectionSliderViewDelegateProtocol {
    @IBInspectable var fieldIndent: CGFloat = 15{ didSet{ self.setupFrames() } }
    @IBInspectable var spaceBetween: CGFloat = 10{ didSet{ self.setupFrames() } }
    @IBInspectable var selLabelVerticalPadding: CGFloat = 1{ didSet{ self.selectionView.labelVerticalPadding = self.selLabelVerticalPadding } }
    @IBInspectable var selTextColor: UIColor = Colors.lightGreen{ didSet{ self.selectionView.textColor = self.selTextColor } }
    @IBInspectable var selFontSize: CGFloat = 14{ didSet{ self.selectionView.fontSize = self.selFontSize } }
    @IBInspectable var selHiddingColor: UIColor = UIColor.white{ didSet{ self.selectionView.hiddingColor = self.selHiddingColor } }
    @IBInspectable var selHiddingLocation: CGFloat = 5{ didSet{ self.selectionView.hiddingLocation = self.selHiddingLocation } }
    @IBInspectable var selRightMargin: CGFloat = 5{ didSet{ self.setupFrames() } }
    
    weak var field: UIView!{
        assertionFailure("MUST IMPLEMENT A FIELD ON SUBCLASS!")
        return nil
    }
    var fieldRelativeSize: CGFloat {
        return 0.4
    }
    var selectionView: SelectionSliderView = SelectionSliderView()
    
    override func setupViews() {
        super.setupViews()
        self.selectionView.delegate = self
        self.addSubview(self.selectionView)
        self.addSubview(self.field)
    }
    
    override func setupFrames() {
        super.setupFrames()
        self.field.frame = self.bounds.insetBy(dx: 0, dy: self.lineWidth)
            .with(width: self.bounds.width*self.fieldRelativeSize - self.fieldIndent/2 - self.spaceBetween/2 - self.selRightMargin/2)
            .aligned([.left(self.fieldIndent)], in: self.bounds)
        
        self.selectionView.frame = self.bounds
            .insetBy(dx: 0, dy: self.lineWidth)
            .with(width: self.bounds.width*(1 - self.fieldRelativeSize) - self.fieldIndent/2 - self.spaceBetween/2 - self.selRightMargin/2)
            .aligned([.right(-self.selRightMargin)], in: self.bounds)
    }
    
    override func prepareForInterfaceBuilder() {
        self.selectionView.prepareForInterfaceBuilder()
    }
}
