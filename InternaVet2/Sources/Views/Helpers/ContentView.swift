//
//  ContentView.swift
//  InternaVet2
//
//  Created by Jorge Luis on 13/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class ContentView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()
    }
    
    func setupViews() {
        self.backgroundColor = Colors.mainLight
    }

}
