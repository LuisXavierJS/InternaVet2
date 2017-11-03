//
//  SearchableItemProtocol.swift
//  InternaVet2
//
//  Created by Jorge Luis on 03/11/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit


protocol SearchableItem: class {
    func resultItemTitle() -> String
    func resultItemImage() -> UIImage?
    func shouldResult(for query: String) -> Bool
}

extension SearchableItem {
    func resultItemImage() -> UIImage? {
        return nil
    }
}

class SearchableItemM: SearchableItem {
    let value: String
    
    init(_ new: Float) {
        self.value = "\(new)"
    }
    
    init(_ new: Double) {
        self.value = "\(new)"
    }
    
    init(_ new: Int) {
        self.value = "\(new)"
    }
    
    init(_ new: String) {
        self.value = "\(new)"
    }
    
    func resultItemTitle() -> String {
        return self.value
    }
    
    func shouldResult(for query: String) -> Bool {
        return self.value.contains(query)
    }
    
    
}
