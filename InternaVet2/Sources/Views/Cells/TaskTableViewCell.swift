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
    
    static var collapsedHeight: CGFloat { return 97 }
    
    var expandedHeight: CGFloat { return 200 }
    
    func setup(_ object: Task) {
        
    }
}
