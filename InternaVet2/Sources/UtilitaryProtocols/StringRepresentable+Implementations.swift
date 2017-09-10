//
//  StringRepresentable+Implementations.swift
//  InternaVet2
//
//  Created by Jorge Luis on 10/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import Foundation

protocol StringRepresentable {
    var stringRepresentation: String {get}
}

extension String: StringRepresentable {
    var stringRepresentation: String { return self }
}

extension Date: StringRepresentable {
    var stringRepresentation: String { return self.formatted()}
    
    func formatted(_ format: String = "dd/MM/yyyy HH:mm") -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
