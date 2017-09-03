//
//  CreateNewPatient.swift
//  InternaVet2
//
//  Created by Jorge Luis on 01/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class CreateNewPatientViewController: UIViewController {
    @IBOutlet weak var text: UITextField!
    @IBOutlet weak var arrow: SelectionSliderView! {
        didSet{
            arrow.items = ["Primeiro item", "Segundo item", "Terceiro item gigantesco Terceiro item gigantesco Terceiro item gigantesco"]
        }
    }
    
    @IBAction func buttonTaped(){        
            print("hey")
    }
}
