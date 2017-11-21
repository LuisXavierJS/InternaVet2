//
//  MainListDatasource.swift
//  InternaVet2
//
//  Created by Jorge Luis on 21/11/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class MainListDatasource<CellType: UITableViewCell&JSExpansableCellProtocol>: JSGenericExpansableCellTableController<CellType> {
    
    override func didSetTableView() {
        self.tableView?.separatorStyle = .none
        self.tableView?.sectionHeaderHeight = 0
        self.tableView?.estimatedSectionHeaderHeight = 0
        self.tableView?.sectionFooterHeight = 0
        self.tableView?.estimatedSectionFooterHeight = 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
        cell.contentView.subviews.sorted(by: {$0.frame.origin.y < $1.frame.origin.y}).first?.backgroundColor = indexPath.row % 2 == 0 ? Colors.mainLight : Colors.lightGreen
    }
}
