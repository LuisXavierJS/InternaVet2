//
//  TextSelectionViewField.swift
//  InternaVet2
//
//  Created by Jorge Luis on 13/11/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class TextSelectionViewField: ContentView, CustomInputFieldProtocol {
    @IBOutlet weak var textfield: CustomFloatTextField!
    @IBOutlet weak var selection: SelectionSliderView!
    
    var isFullfilled: Bool {
        return self.textfield.isFullfilled
    }
    
    func getInputValue() -> String {
        return self.textfield.getInputValue()
    }
    
    func setInputValue(newValue: String) {
        self.textfield.setInputValue(newValue: newValue)
    }
    
    func setInvalidState() {
        self.textfield.setInvalidState()
    }
    
    func setValidState() {
        self.textfield.setValidState()
    }
}
