//
//  Bool+Helpers.swift
//  InternaVet2
//
//  Created by Jorge Luis on 24/10/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import Foundation

extension Bool {
    var semantic: String {
        return self ? Words.yes : Words.no
    }
}
