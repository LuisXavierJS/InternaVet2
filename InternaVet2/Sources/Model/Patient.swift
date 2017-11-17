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
class Patient: StorageItem, SearchableItem {
    dynamic var ownerId: String?
    dynamic var identifier: String?
    dynamic var name: String?
    dynamic var specie: String?
    dynamic var race: String?
    dynamic var age: String?
    dynamic var chip: String?
    dynamic var record: String?
    dynamic var gender: String?
    dynamic var isCastrated: Bool = false
    dynamic var isDead: Bool = false
    dynamic var dogHouseNumber: String?
    dynamic var hospitalizationTime: String?
    dynamic var tasks: [Task] = []
    
    func getHospitalizationTimeInterval() -> TimeInterval {
        assertionFailure("MUST CONVERT hospitalizationTime: String TO TIME INTERVAL!")
        return 0
    }
    
    func resultItemTitle() -> String {
        return self.name ?? "-"
    }
    
    func shouldResult(for query: String) -> Bool {
        return self.resultItemTitle().localizedCaseInsensitiveContains(query)
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
