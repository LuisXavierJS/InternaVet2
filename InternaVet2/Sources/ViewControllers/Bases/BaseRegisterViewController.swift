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

class BaseRegisterViewController: BaseViewController {
    
    func allFieldsFullfilled() -> Bool {
        return false
    }
    
    func performSave() {
        
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if self.allFieldsFullfilled() {
            self.performSave()
            self.performReturn()
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.performReturn()
    }
}
