//
//  Session.swift
//  InternaVet2
//
//  Created by Jorge Luis on 20/10/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import Foundation
import FileKit

class Session: StorageItem, NameableStorageItem {
    
    var fileName: String {
        return "Session"
    }
    
    static func localPathOnStorage(from root: Path) -> Path {
        return root
    }
}
