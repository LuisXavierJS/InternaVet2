//
//  Partner.swift
//  InternaVet2
//
//  Created by Jorge Luis on 08/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import Foundation
import FileKit

@objc(Owner)
class Owner: StorageItem {
    dynamic var name: String?
    dynamic var email: String?
    dynamic var celular: String?
    dynamic var telefone: String?
    dynamic var endereco: String?
}
