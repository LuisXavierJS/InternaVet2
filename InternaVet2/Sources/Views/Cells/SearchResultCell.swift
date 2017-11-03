//
//  SearchResultCell.swift
//  InternaVet2
//
//  Created by Jorge Luis on 22/10/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell, JSSetupableCellProtocol {
    @IBOutlet weak var searchResultTitleLabel: UILabel!
    @IBOutlet weak var searchResultTitleImage: UIImageView!
    
    typealias DataType = SearchableItem
    
    func setup(_ object: SearchableItem) {
        self.searchResultTitleLabel.text = object.resultItemTitle()
        self.searchResultTitleImage.image = object.resultItemImage()
    }
}
