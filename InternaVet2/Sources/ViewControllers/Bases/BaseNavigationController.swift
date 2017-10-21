//
//  BaseNavigationController.swift
//  InternaVet2
//
//  Created by Jorge Luis on 17/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class BaseNavigationController : UINavigationController, SessionControllerManagerProtocol {
    weak var sessionController: SessionController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customizeNavigationBar()
        self.viewControllers.forEach({self.trySetSession(on: $0)})
    }
    
    func customizeNavigationBar(){
        self.navigationBar.barTintColor = Colors.darkGreen
        self.navigationBar.tintColor = Colors.mainLight
        self.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 20, weight: UIFontWeightMedium), NSForegroundColorAttributeName:Colors.mainLight]
    }
    
    override func show(_ vc: UIViewController, sender: Any?) {
        self.trySetSession(on: vc)
        super.show(vc, sender: sender)
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        self.trySetSession(on: viewControllerToPresent)
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        viewControllers.forEach({self.trySetSession(on: $0)})
        super.setViewControllers(viewControllers, animated: animated)
    }
}
