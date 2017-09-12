//
//  PatientTableViewCell.swift
//  InternaVet2
//
//  Created by Jorge Luis on 11/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit


class PatientTableViewCell: UITableViewCell, JSSetupableCellProtocol {
    typealias DataType = Patient
    
    @IBOutlet weak var specieLabel: UILabel!
    @IBOutlet weak var raceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dogHoseLabel: ValuedUILabel!
    
    @IBOutlet weak var hospitalizationTimeLabel: ValuedUILabel!
    @IBOutlet weak var ageLabel: ValuedUILabel!
    @IBOutlet weak var isDiedLabel: ValuedUILabel!
    @IBOutlet weak var isCastratedLabel: ValuedUILabel!
    @IBOutlet weak var genderLabel: ValuedUILabel!
    @IBOutlet weak var ownerLabel: ValuedUILabel!
    @IBOutlet weak var recordLabel: ValuedUILabel!
    @IBOutlet weak var chipLabel: ValuedUILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(_ object: Patient) {
        self.specieLabel.text = object.specie
        self.nameLabel.text = object.name
        self.dogHoseLabel.text = object.dogHouseId
        self.raceLabel.text = object.race
        
        self.hospitalizationTimeLabel.text = object.hospitalizationTime
        self.ageLabel.text = object.age
        self.isDiedLabel.text = object.isDead.semantic
        self.isCastratedLabel.text = object.isCastrated.semantic
        self.genderLabel.text = object.gender
        self.ownerLabel.text = object.getOwner()?.name
        self.recordLabel.text = object.record
        self.chipLabel.text = object.chip
    }

}
