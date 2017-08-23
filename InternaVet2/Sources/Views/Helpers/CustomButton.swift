//
//  CustomButton.swift
//  InternaVet2
//
//  Created by Jorge Luis on 22/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    func setupViews(){
        self.layer.borderColor = Colors.lightGreen.cgColor
        self.layer.borderWidth = 1
        self.layer.shadowColor = Colors.darkGreen.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
    }
}
