//
//  User.swift
//  InternaVet2
//
//  Created by Jorge Luis on 09/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import Foundation
import FileKit

@objc(User)
class User: StorageItem, NameableStorageItem {
    dynamic var username: String?
    dynamic var patients: [Patient] = []
    dynamic var owners: [Owner] = []
    dynamic var dogHouses: [DogHouse] = []
    
    var fileName: String {
        return nameConstructor(attributes: ["udid":self.udid])
    }
    
    static func localPathOnStorage(from root: Path) -> Path {
        return root + "Users"
    }
    
}
