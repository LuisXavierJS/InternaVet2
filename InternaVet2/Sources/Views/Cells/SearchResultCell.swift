//
//  SearchResultCell.swift
//  InternaVet2
//
//  Created by Jorge Luis on 22/10/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

protocol SearchableItem: class {
    
}

class SearchResultCell: UITableViewCell, JSSetupableCellProtocol {
    typealias DataType = SearchableItem
    
    func setup(_ object: SearchableItem) {
        
    }
}
