//
//  User.swift
//  InternaVet2
//
//  Created by Jorge Luis on 09/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import Foundation
import FileKit

class User: StorageItem, NameableStorageItem {
    dynamic var username: String?
    dynamic private(set) var patients: [Patient] = []
    dynamic private(set) var owners: [Owner] = []
    
    var fileName: String {
        return nameConstructor(attributes: ["udid":self.udid])
    }
    
    static func localPathOnStorage(from root: Path) -> Path {
        return root + "Users"
    }
    
    func addIfPossibleAndSavePatient(_ patient: Patient) {
        if !self.patients.contains(where: {patient.udid == $0.udid}) {
            self.patients.append(patient)
        }
        SessionController.context.save(self)
    }
    
    func getPatient(ofId id: String) -> Patient? {
        return self.patients.filter({$0.udid == id}).first
    }
    
    func addIfPossibleAndSaveOwner(_ owner: Owner) {
        if !self.owners.contains(where: {$0.udid == owner.udid}) {
            self.owners.append(owner)
        }
        SessionController.context.save(self)
    }
    
    func getOwner(ofId id: String) -> Owner? {
        return self.owners.filter({$0.udid == id}).first
    }
}
