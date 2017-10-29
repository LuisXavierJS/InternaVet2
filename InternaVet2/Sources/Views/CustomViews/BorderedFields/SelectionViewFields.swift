//
//  LabeledSelectionViewField.swift
//  InternaVet2
//
//  Created by Jorge Luis on 03/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit



@IBDesignable
class LabeledSelectionViewField: SelectionArrowViewField {
    @IBInspectable var labelText: String = ""{ didSet{ self.label.text = labelText } }
    @IBInspectable var labelSize: CGFloat = DefaultValues.medium{ didSet{ self.label.font = UIFont.systemFont(ofSize: self.labelSize) } }
    @IBInspectable var labelColor: UIColor = Colors.darkGreen{ didSet{ self.label.textColor = self.labelColor } }    
    
    private weak var label: UILabel!
    
    override weak var field: UIView! {
        return self.label
    }
    
    override func setupViews() {
        let lab = UILabel()
        self.label = lab
        super.setupViews()
        self.label.textColor = self.labelColor
        self.label.numberOfLines = 0
        self.label.font = UIFont.systemFont(ofSize: self.labelSize)
    }    

}

@IBDesignable
class TextSelectionViewField: SelectionArrowViewField, CustomInputFieldProtocol {
    @IBInspectable var placeholder: String = "" { didSet{ self.textField.placeholder = self.placeholder } }
    @IBInspectable var textColor: UIColor = Colors.darkGreen { didSet{ self.textField.textColor = self.textColor } }
    @IBInspectable var placeholderColor: UIColor = Colors.darkGreen.withAlphaComponent(0.5){ didSet{ self.textField.placeholderColor = self.placeholderColor } }
    @IBInspectable var floatingLabelTextColor: UIColor = Colors.darkGreen{ didSet{ self.textField.floatingLabelTextColor = self.floatingLabelTextColor } }
    @IBInspectable var floatingLabelActiveTextColor: UIColor = Colors.lightGreen{ didSet{ self.textField.floatingLabelActiveTextColor = self.floatingLabelActiveTextColor } }
    
    private(set) weak var textField: CustomFloatTextField!
    
    override weak var field: UIView! {
        return self.textField
    }
    
    override func setupViews() {
        let text = CustomFloatTextField()
        self.textField = text
        super.setupViews()
        self.textField.textAlignment = .center
        self.textField.placeholderColor = self.placeholderColor
        self.textField.floatingLabelTextColor = self.floatingLabelTextColor
        self.textField.floatingLabelActiveTextColor = self.floatingLabelActiveTextColor
        self.textField.textColor = self.textColor        
    }
    
    override func setupFrames() {
        super.setupFrames()
        self.textField.frame = self.textField.frame.insetBy(dx: 0, dy: 5)
    }
    
    var isFullfilled: Bool {
        return !(self.textField.text?.isEmpty ?? true)
    }
    
    func getInputValue() -> String {
        return self.textField.text!
    }
    
    func setInputValue(newValue: String) {
        self.textField.text = newValue
    }
    
    func setInvalidState() {
        self.textField.setupBorder(color: UIColor.red)
    }
    
    func setValidState() {
        self.textField.setupBorder()
    }
    
}

//abstract class!
class SelectionArrowViewField: BorderedArrowViewField, SelectionSliderViewDelegateProtocol {
    @IBInspectable var selLabelVerticalPadding: CGFloat = 1{ didSet{ self.selectionView.labelVerticalPadding = self.selLabelVerticalPadding } }
    @IBInspectable var selTextColor: UIColor = Colors.lightGreen{ didSet{ self.selectionView.textColor = self.selTextColor } }
    @IBInspectable var selFontSize: CGFloat = DefaultValues.medium{ didSet{ self.selectionView.fontSize = self.selFontSize } }
    @IBInspectable var selHiddingColor: UIColor = UIColor.white{ didSet{ self.selectionView.hiddingColor = self.selHiddingColor } }
    @IBInspectable var selHiddingLocation: CGFloat = -10{ didSet{ self.selectionView.hiddingLocation = self.selHiddingLocation } }
    
    var selectionOptions: [String] {
        set {
            self.selectionView.items = newValue
        }
        get {
            return self.selectionView.items
        }
    }
    
    weak var selectionView: SelectionSliderView! {
        return self.arrowsView as! SelectionSliderView
    }
    
    override func createArrowView() -> DoubleArrowsView! {
        return SelectionSliderView()
    }
    
    override func setupViews() {
        super.setupViews()
        self.selectionView.labelVerticalPadding = self.selLabelVerticalPadding
        self.selectionView.textColor = self.selTextColor
        self.selectionView.fontSize = self.selFontSize
        self.selectionView.hiddingColor = self.selHiddingColor
        self.selectionView.hiddingLocation = self.selHiddingLocation
        self.selectionView.delegate = self
    }
    
}
