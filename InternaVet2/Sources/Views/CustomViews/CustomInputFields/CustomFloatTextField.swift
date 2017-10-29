//
//  CustomFloatTextField.swift
//  InternaVet2
//
//  Created by Jorge Luis on 13/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import InputMask

class CustomFloatTextField: JVFloatLabeledTextField {
    @IBInspectable var maskText: String? = nil {
        didSet{
            self.updateMask()
        }
    }
    
    var maskDelegate: MaskedTextFieldDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()
    }
    
    func setupViews(){
        self.setupBorder()
        
        self.placeholderColor = Colors.darkGreen.withAlphaComponent(0.5)
        self.floatingLabelTextColor = Colors.darkGreen
        self.floatingLabelActiveTextColor = Colors.lightGreen
        self.floatingLabelYPadding = 2
        self.floatingLabelFont = self.floatingLabelFont.withSize(11)
        self.font = UIFont.systemFont(ofSize: DefaultValues.medium)
        self.backgroundColor = Colors.mainLight                
        
        self.clipsToBounds = true
    }
    
    func setupBorder(color: UIColor = Colors.darkGreen) {
        self.borderStyle = .none
        self.layer.cornerRadius = 3
        self.layer.borderWidth = 0.4
        self.layer.borderColor = color.cgColor
        self.layer.shadowColor = UIColor.clear.cgColor
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = self.textRectForBounds(b:bounds)
        return self.text!.isEmpty ? rect : rect.insetBy(top:5)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = self.textRectForBounds(b:bounds)
        return self.text!.isEmpty ? rect : rect.insetBy(top:5)
    }
    
    fileprivate func textRectForBounds(b bounds: CGRect) -> CGRect {
        let needsTextRepositioning = !(self.text?.isEmpty ?? false)
        let topYDelta: CGFloat = needsTextRepositioning ? 4 : 0
        return bounds.insetBy(dx: 5, dy: 0).insetBy(left: topYDelta)
    }
    
    fileprivate func updateMask() {
        if let mask = maskText {
            self.maskDelegate = MaskedTextFieldDelegate(format: mask)
            self.delegate = self.maskDelegate
        }
    }
}
