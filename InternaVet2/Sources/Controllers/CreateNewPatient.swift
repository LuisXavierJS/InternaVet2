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
    @IBOutlet weak var arrow: ArrowView!
    
    @IBAction func buttonTaped(){        
        if let number = Double(text.text!) {
            self.arrow.degree = CGFloat(number)
            self.arrow.setNeedsDisplay()
        }
        
    }
}
