//
//  FullfillVerificationInput.swift
//  InternaVet2
//
//  Created by Jorge Luis on 21/10/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import Foundation

protocol CustomInputFieldProtocol: class {    
    var isFullfilled: Bool {get}
    
    func getInputValue() -> String
    func setInputValue(newValue: String)
}
