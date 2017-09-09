//
//  Partner.swift
//  InternaVet2
//
//  Created by Jorge Luis on 08/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import Foundation
import FileKit

class Owner: StorageItem, NameableStorageItem {
    static func localPathOnStorage(from root: Path) -> Path {
        return root + "Owners"
    }
    
    var fileName: String {
        return nameConstructor(attributes: ["udid":self.udid])
    }
    
    dynamic var name: String?
    dynamic var email: String?
    
    
}
