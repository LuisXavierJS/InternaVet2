//
//  Patient.swift
//  InternaVet2
//
//  Created by Jorge Luis on 09/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import Foundation
import FileKit

@objc(Patient)
class Patient: StorageItem {
    dynamic fileprivate(set) var ownerId: String?
    dynamic var name: String?
    dynamic var specie: String?
    dynamic var race: String?
    dynamic var age: String?
    dynamic var chip: String?
    dynamic var record: String?
    dynamic var gender: String?
    dynamic var isCastrated: Bool = false
    dynamic var isDead: Bool = false
    dynamic fileprivate(set) var dogHouseId: String?
    dynamic var hospitalizationTime: String?
    
    func getHospitalizationTimeInterval() -> TimeInterval {
        assertionFailure("MUST CONVERT hospitalizationTime: String TO TIME INTERVAL!")
        return 0
    }
    
}

@objc(DogHouse)
class DogHouse: StorageItem {
    dynamic var dogHouserNumber: Int = 0
    dynamic fileprivate(set) var patientId: String?
    
    convenience init(_ dogHouse: Int) {
        self.init()
        self.dogHouserNumber = dogHouse
    }
}
