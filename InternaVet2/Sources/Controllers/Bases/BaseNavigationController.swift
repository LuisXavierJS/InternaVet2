//
//  BaseNavigationController.swift
//  InternaVet2
//
//  Created by Jorge Luis on 17/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class BaseNavigationController : UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customizeNavigationBar()
    }
    
    func customizeNavigationBar(){
        self.navigationBar.barTintColor = Colors.darkGreen
        self.navigationBar.tintColor = Colors.mainLight
        self.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 20, weight: UIFontWeightMedium), NSForegroundColorAttributeName:Colors.mainLight]
//        self.navigationBar.setBackgroundImage(UIImage(named:"top_grass_blur_field"), for: UIBarMetrics.default)
    }
}
