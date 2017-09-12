//
//  PatientTableViewCell.swift
//  InternaVet2
//
//  Created by Jorge Luis on 11/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit


class PatientTableViewCell: UITableViewCell {
    @IBOutlet weak var specieLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dogHoseLabel: UILabel!
    @IBOutlet weak var raceLabel: UILabel!
    
    @IBOutlet weak var hospitalizationTimeLabel: ValuedUILabel!
    @IBOutlet weak var ageLabel: ValuedUILabel!
    @IBOutlet weak var isDiedLabel: ValuedUILabel!
    @IBOutlet weak var isCastratedLabel: ValuedUILabel!
    @IBOutlet weak var genderLabel: ValuedUILabel!
    @IBOutlet weak var ownerLabel: ValuedUILabel!
    @IBOutlet weak var registerLabel: ValuedUILabel!
    @IBOutlet weak var chipLabel: ValuedUILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
