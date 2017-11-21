//
//  Defaults.swift
//  InternaVet2
//
//  Created by Jorge Luis on 17/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

struct DefaultValues {
    static let standardUsername = "standard_user"
    static let mediumFontSize: CGFloat = 15
    static let numberOfDogHouses = 45
    static let minimumHospitalizationDate = Date()
    static let maximumHospitalizationDate = Date().addingTimeInterval(60*60*24*30)
}


struct DateFormat {
    static let date = "dd/MM/yyyy"
    static let hour = "HH:mm"
    static let dateAndHour = "dd/MM/yyyy HH:mm"
}
