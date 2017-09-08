//
//  CreateNewPatient.swift
//  InternaVet2
//
//  Created by Jorge Luis on 01/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class CreateNewPatientViewController: UIViewController, PushButtonProtocol {
    @IBOutlet weak var datePicker: DatePickerContainerView!
    @IBOutlet weak var button: BorderedButtonViewField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.button.delegate = self
    }
    
    func pushButtonWasTapped(_ button: PushButtonViewField) {
        self.datePicker.changeDatePickerVisibility()
        UIView.animate(withDuration: 0.25) { 
            self.view.layoutIfNeeded()
        }
    }
}
