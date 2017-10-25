//
//  Date+Helpers.swift
//  InternaVet2
//
//  Created by Jorge Luis on 24/10/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import Foundation

extension Date {
    func formatted(_ format: String = "dd/MM/yyyy HH:mm") -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
