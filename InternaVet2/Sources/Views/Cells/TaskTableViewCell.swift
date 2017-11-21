//
//  TaskTableViewCell.swift
//  InternaVet2
//
//  Created by Jorge Luis on 17/11/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell, JSExpansableCellProtocol {
    typealias DataType = Task
    
    static var collapsedHeight: CGFloat { return 45 }
    
    @IBOutlet weak var expandedBodyView: UIView!
    @IBOutlet weak var hourAndDoghouseLabel: UILabel!
    @IBOutlet weak var taskTypeLabel: UILabel!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var intervalLabel: UILabel!
    @IBOutlet weak var beginDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    
    var expandedHeight: CGFloat { return self.expandedBodyView.frame.maxY }
    
    func setup(_ object: Task) {
        self.hourAndDoghouseLabel.text = "\(object.getNextApplication()?.formatted(DateFormat.hour) ?? "") - Leito \(object.getPatient()?.dogHouseNumber ?? "")"
        self.taskNameLabel.text = object.name
        self.taskTypeLabel.text = object.type
        self.patientNameLabel.text = object.getPatient()?.name
        self.intervalLabel.text = "\(object.interval)"
    }
}
