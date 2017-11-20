//
//  PatientTableViewCell.swift
//  InternaVet2
//
//  Created by Jorge Luis on 11/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit


class PatientTableViewCell: UITableViewCell, JSExpansableCellProtocol {
    static var collapsedHeight: CGFloat { return 52 }

    var expandedHeight: CGFloat { return self.ownerLabel.superview?.frame.maxY ?? PatientTableViewCell.collapsedHeight }

    typealias DataType = Patient
    
    @IBOutlet weak var specieLabel: UILabel!
    @IBOutlet weak var raceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dogHoseLabel: ValuedUILabel!
    
    @IBOutlet weak var hospitalizationTimeLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(_ object: Patient) {
        self.specieLabel.text = object.race ?? "-"
        self.nameLabel.text = object.name ?? "-"
        self.dogHoseLabel.text = object.dogHouseNumber ?? "-"
        self.raceLabel.text = object.specie ?? "-"
        
        self.hospitalizationTimeLabel.text = object.hospitalizationTime ?? "-"
        self.ageLabel.text = object.age ?? "-"
        self.ownerLabel.text = object.ownerId ?? "-"
    }

}
