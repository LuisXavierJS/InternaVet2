//
//  BaseRegisterViewController.swift
//  InternaVet2
//
//  Created by Jorge Luis on 12/10/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

protocol EntityConsumerProtocol: class {
    func createdItem(_ item: StorageItem, for: EntityServerProtocol) -> Void
}

protocol EntityServerProtocol: class {
    weak var delegate: EntityConsumerProtocol? {get set}
}

typealias RegisterViewController = EntityServerProtocol&UIViewController

class BaseRegisterViewController: UIViewController, SessionControllerManagerProtocol {
    @IBInspectable var dissmissWhenSave: Bool = true
    
    weak var sessionController: SessionController!
        
    override func show(_ vc: UIViewController, sender: Any?) {
        self.trySetSession(on: vc)
        super.show(vc, sender: sender)
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        self.trySetSession(on: viewControllerToPresent)
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    func allFieldsFullfilled() -> Bool {
        return false
    }
    
    func performSave() {
        
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if self.allFieldsFullfilled() {
            self.performSave()
            if self.dissmissWhenSave {
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
