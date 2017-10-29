//
//  FullfillVerificationInput.swift
//  InternaVet2
//
//  Created by Jorge Luis on 21/10/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

protocol CustomInputFieldProtocol: class {    
    var isFullfilled: Bool {get}
    
    func getInputValue() -> String
    func setInputValue(newValue: String)
    
    func setInvalidState()
    func setValidState()
    func updateFullfilledState() -> Bool
}

extension CustomInputFieldProtocol where Self:BorderedView{    
    func updateFullfilledState() -> Bool {
        let isFullfilled = self.isFullfilled
        if isFullfilled {
            self.setValidState()
        }else{
            self.setInvalidState()
        }
        return isFullfilled
    }
}
