//
//  BaseViewController.swift
//  InternaVet2
//
//  Created by Jorge Luis on 17/11/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit


enum ReturnMode {
    case dismiss
    case pop
    case popTo(viewController: UIViewController)
}

class BaseViewController: UIViewController, SessionControllerManagerProtocol {
    weak var sessionController: SessionController!
    
    var returnMode: ReturnMode = .dismiss

    override func show(_ vc: UIViewController, sender: Any?) {
        self.trySetSession(on: vc)
        super.show(vc, sender: sender)
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        self.trySetSession(on: viewControllerToPresent)
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    func performReturn() {
        switch self.returnMode {
        case .dismiss:
            self.navigationController?.dismiss(animated: true, completion: nil)
        case .pop:
            self.navigationController?.popViewController(animated: true)
        case .popTo(let viewController):
            self.navigationController?.popToViewController(viewController, animated: true)
        }
    }
    
}
