//
//  Strings.swift
//  InternaVet2
//
//  Created by Jorge Luis on 11/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import Foundation

fileprivate func LocStr(key: String) -> String {
    return NSLocalizedString(key, comment: "")
}

struct Words {
    static let yes = LocStr(key: "yes")
    static let no = LocStr(key: "no")
    static let hour = LocStr(key: "hour")
    static let day = LocStr(key: "day")
    static let month = LocStr(key: "month")
    static let year = LocStr(key: "year")
    static let dog = LocStr(key: "dog")
    static let cat = LocStr(key: "cat")
    static let micrograms = LocStr(key: "micrograms")
    static let miligrams = LocStr(key: "miligrams")
    static let grams = LocStr(key: "grams")
    static let kilograms = LocStr(key: "kilograms")
    static let female = LocStr(key: "female")
    static let male = LocStr(key: "male")
}
