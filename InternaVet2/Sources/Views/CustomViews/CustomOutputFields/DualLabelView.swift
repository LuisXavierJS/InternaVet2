//
//  DualLabelField.swift
//  InternaVet2
//
//  Created by Jorge Luis on 10/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

@IBDesignable
class DualLabelView: ContentView {
    @IBInspectable var titleLabelText: String = ""{ didSet{ self.firsLabel.text = titleLabelText } }
    @IBInspectable var labelSize: CGFloat = DefaultValues.medium {
        didSet {
            self.firsLabel.font = UIFont.systemFont(ofSize: self.labelSize)
            self.secondLabel.font = UIFont.systemFont(ofSize: self.labelSize)
        }
    }
    @IBInspectable var labelColor: UIColor = Colors.darkGreen{
        didSet {
            self.firsLabel.textColor = self.labelColor
            self.updateValueLabelColors()
        }
    }
    @IBInspectable var valueLabelText: String = ""{ didSet{ self.secondLabel.text = valueLabelText;self.updateValueLabelColors() } }
    @IBInspectable var placeholderText: String = ""{ didSet{ self.secondLabel.text = placeholderText;self.updateValueLabelColors() } }
    @IBInspectable var placeholderColor: UIColor = Colors.lightGreen{ didSet{ self.updateValueLabelColors() } }
    
    weak var firsLabel: UILabel!
    weak var secondLabel: UILabel!
    
    private var _firstLabelColor: UIColor = Colors.darkGreen
    private var _secondLabelColor: UIColor = Colors.lightGreen
    
    override func setupViews() {
        func createAndSetupLabel() -> UILabel {
            let label = UILabel()
            label.textColor = self.labelColor
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: self.labelSize)
            label.backgroundColor = UIColor.clear
            self.addSubview(label)
            return label
        }
        self.firsLabel = createAndSetupLabel()
        self.firsLabel.textAlignment = .left
        self.secondLabel = createAndSetupLabel()
        self.secondLabel.textAlignment = .right
        self.updateValueLabelColors()
    }
    
    override func setupFrames() {
        self.firsLabel.frame = self.bounds
        self.secondLabel.frame = self.bounds
    }
    
    func beginTouchAnimation(){
        self._firstLabelColor = self.firsLabel.textColor
        self._secondLabelColor = self.secondLabel.textColor
        self.firsLabel.textColor = self.firsLabel.textColor.withBrightness(75/255)
        self.secondLabel.textColor = self.secondLabel.textColor.withBrightness(75/255)
    }
    
    func endTouchAnimation(){
        self.firsLabel.textColor = self._firstLabelColor
        self.secondLabel.textColor = self._secondLabelColor
    }
    
    func updateValueLabelColors() {
        self.secondLabel.text = self.valueLabelText.isEmpty ? self.placeholderText : self.valueLabelText
        self.secondLabel.textColor = self.secondLabel.text == self.placeholderText ? self.placeholderColor : self.labelColor
    }
}
