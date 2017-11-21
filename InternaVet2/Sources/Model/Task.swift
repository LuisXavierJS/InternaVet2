//
//  Task.swift
//  InternaVet2
//
//  Created by Jorge Luis on 16/11/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import Foundation

@objc(Task)
class Task: StorageItem {
    dynamic var identifier: String?
    dynamic var patientIdentifier: String?
    dynamic var name: String?
    dynamic var type: String?
    dynamic var begin: Date?
    dynamic var end: Date?
    dynamic var observations: String?
    dynamic var dosage: String?
    dynamic var dosageType: String?
    
    func getNextApplication() -> Date? {
        return nil
    }
    
    func getPatient() -> Patient? {
        return nil
    }
}
