//
//  ViewController.swift
//  InternaVet2
//
//  Created by Jorge Luis on 13/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    weak var tabBarBackgroundView: UIImageView?
    
    var session = SessionController.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.setupViews()
        self.viewControllers?.forEach({
            ($0 as? SessionControllerManagerProtocol)?.sessionController = self.session
        })
    }

    func setupViews(){
        let backgroundImageView = UIImageView()
        backgroundImageView.backgroundColor = Colors.darkGreen
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.bounds = self.tabBar.bounds
        self.tabBar.insertSubview(backgroundImageView, at: 0)
        self.tabBar.unselectedItemTintColor = Colors.lightGreen
        self.tabBarBackgroundView = backgroundImageView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tabBarBackgroundView?.frame = self.tabBar.bounds
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.tabBarBackgroundView?.frame = self.tabBar.bounds
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {        
        let fromView: UIView = tabBarController.selectedViewController!.view
        let toView  : UIView = viewController.view
        if fromView == toView {return false}
        UIView.transition(from: fromView, to: toView, duration: 0.3, options: UIViewAnimationOptions.transitionCrossDissolve) { _ in}
        return true
    }

}

