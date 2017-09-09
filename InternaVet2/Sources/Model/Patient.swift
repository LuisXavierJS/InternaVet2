//
//  Patient.swift
//  InternaVet2
//
//  Created by Jorge Luis on 09/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import Foundation
import FileKit

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
    dynamic var dogHouse: String?
    dynamic var hospitalizationTime: Double = 0
    
    func getOwner() -> Owner? {
        guard let id = self.ownerId else {return nil}
        return SessionController.currentUser?.owners.filter({$0.udid == id}).first
    }
    
    func setAndSaveOwner(_ owner: Owner) {
        self.ownerId = owner.udid
        SessionController.currentUser?.addIfPossibleAndSaveOwner(owner)
    }
}
