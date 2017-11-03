//
//  BaseRegisterViewController.swift
//  InternaVet2
//
//  Created by Jorge Luis on 12/10/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class BaseRegisterViewController: UIViewController, SessionControllerManagerProtocol {
    weak var sessionController: SessionController!
        
    override func show(_ vc: UIViewController, sender: Any?) {
        self.trySetSession(on: vc)
        super.show(vc, sender: sender)
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        self.trySetSession(on: viewControllerToPresent)
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
}
