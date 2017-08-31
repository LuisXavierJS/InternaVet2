//
//  CustomButton.swift
//  InternaVet2
//
//  Created by Jorge Luis on 30/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

@IBDesignable
class CustomButton: UIButton, BorderedView {
    @IBInspectable var lineColor: UIColor = Colors.lightGreen
    @IBInspectable var lineWidth: CGFloat = 1
    
    override func draw(_ rect: CGRect) {
        self.drawBorder(in: rect)
    }
}
