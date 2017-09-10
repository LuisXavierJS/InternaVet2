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
    dynamic fileprivate(set) var dogHouseId: String?
    dynamic var hospitalizationTime: Double = 0
    
    func getOwner() -> Owner? {
        guard let id = self.ownerId else {return nil}
        return SessionController.currentUser?.owners.filter({$0.udid == id}).first
    }
    
    func setAndSaveOwner(_ owner: Owner) {
        self.ownerId = owner.udid
        SessionController.currentUser?.addIfPossibleAndSaveOwner(owner)
    }
    
    func setAndSaveDogHouse(_ dogHouse: DogHouse) {
        self.dogHouseId = dogHouse.udid
        dogHouse.patientId = self.udid
    }
    
    func getDogHouse() -> DogHouse? {
        guard let id = self.dogHouseId else {return nil}
        return SessionController.currentUser?.dogHouses.filter({$0.udid == id}).first
    }
}

class DogHouse: StorageItem {
    dynamic var dogHouserNumber: Int = 0
    dynamic fileprivate(set) var patientId: String?
    
    func getPatient() -> Patient? {
        guard let id = self.patientId else {return nil}
        return SessionController.currentUser?.patients.filter({$0.udid == id}).first
    }
}
