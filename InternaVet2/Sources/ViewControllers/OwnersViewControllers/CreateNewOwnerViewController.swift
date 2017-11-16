//
//  CreateNewOwnerViewController.swift
//  InternaVet2
//
//  Created by Jorge Luis on 13/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class CreateNewOwnerViewController: BaseRegisterViewController, EntityServerProtocol {
    @IBOutlet weak var nameTextfield: CustomFloatTextField!
    @IBOutlet weak var emailTextfield: CustomFloatTextField!
    @IBOutlet weak var phoneTextfield: CustomFloatTextField!
    @IBOutlet weak var homephoneTextfield: CustomFloatTextField!
    @IBOutlet weak var addressTextfield: CustomFloatTextField!
    
    weak var delegate: EntityConsumerProtocol?
    
    weak var editingOwner: Owner?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func allFieldsFullfilled() -> Bool {
        return [self.nameTextfield,
                self.emailTextfield,
                self.phoneTextfield,
                self.homephoneTextfield,
                self.addressTextfield].reduce(true, {
                    let fieldIsFullfilled = $0.1?.updateFullfilledState() ?? true
                    return $0.0 && fieldIsFullfilled
                })
    }
    
    override func performSave() {
        let owner = self.editingOwner ?? Owner()
        owner.celular = self.phoneTextfield.text
        owner.name = self.nameTextfield.text
        owner.email = self.emailTextfield.text
        owner.telefone = self.homephoneTextfield.text
        owner.endereco = self.addressTextfield.text
        if self.editingOwner == nil {
            owner.identifier = UUID().uuidString
            self.sessionController.currentUser?.owners.append(owner)
        }
        self.sessionController.saveContext()
        self.delegate?.createdItem(owner, for: self)
    }

    private func setEditingOwner() {
        self.nameTextfield.text = self.editingOwner?.name
        self.emailTextfield.text = self.editingOwner?.email
        self.phoneTextfield.text = self.editingOwner?.celular
        self.homephoneTextfield.text = self.editingOwner?.telefone
        self.addressTextfield.text = self.editingOwner?.endereco
    }
}
