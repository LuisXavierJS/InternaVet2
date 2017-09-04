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
        self.borderStyle = .none
        self.layer.cornerRadius = 3
        self.layer.borderWidth = 0.4
        self.layer.shadowOffset = CGSize(width: 1, height: 2)
        self.layer.shadowColor = Colors.darkGreen.cgColor
        self.layer.borderColor = Colors.clearLightGreen.cgColor
        
        self.placeholderColor = Colors.clearLightGreen
        self.floatingLabelTextColor = Colors.darkGreen
        self.floatingLabelActiveTextColor = Colors.lightGreen
        self.floatingLabelYPadding = 2
        self.floatingLabelFont = self.floatingLabelFont.withSize(7)
        self.font = UIFont.systemFont(ofSize: 12)
        self.backgroundColor = Colors.mainLight
        
        self.clipsToBounds = true
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = self.textRectForBounds(b:bounds)
        return self.text!.isEmpty ? rect : rect.insetBy(top:5)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRectForBounds(b:bounds)
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
