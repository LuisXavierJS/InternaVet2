//
//  CustomFloatTextField.swift
//  InternaVet2
//
//  Created by Jorge Luis on 13/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class CustomFloatTextField: JVFloatLabeledTextField {

    func setupViews(){
        self.borderStyle = .none
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 2
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowColor = Colors.darkGreen.cgColor
        self.layer.borderColor = Colors.lightGreen.cgColor
        self.clipsToBounds = true
        self.backgroundColor = Colors.mainLight
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 5, dy: 0)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 5, dy: 0)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()
    }
}
