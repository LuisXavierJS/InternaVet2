//
//  ContentView.swift
//  InternaVet2
//
//  Created by Jorge Luis on 30/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit


class ContentView: UIView {
    var lastLayoutedFrame: CGRect = CGRect.zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()
    }
    
    func setupViews() {}
    
    func setupFrames() {}
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.frame != self.lastLayoutedFrame {
            self.setupFrames()
        }
        self.lastLayoutedFrame = self.frame
    }
    
}

