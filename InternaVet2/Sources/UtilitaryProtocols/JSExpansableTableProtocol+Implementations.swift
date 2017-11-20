//
//  JSExpansableTableProtocol+Implementations.swift
//  InternaVet2
//
//  Created by Jorge Luis on 13/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit


protocol JSExpansableCellProtocol: JSSetupableCellProtocol {
    static var collapsedHeight: CGFloat {get}
    var expandedHeight: CGFloat {get}
}

class JSGenericExpansableCellTableController<CellType: JSExpansableCellProtocol>:JSGenericTableController<CellType> where CellType: UITableViewCell{
    override var items: [[DataType]] {
        get { return super.items }
        set {
            super.items = newValue;
            self.cellsVisibilityState = [:]
            
        }
    }
    
    private(set) var cellsVisibilityState: [IndexPath:Bool] = [:]
    
    private var isPerformingExpandCollapse: Bool = false
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.cellsVisibilityState[indexPath] = !(self.cellsVisibilityState[indexPath] ?? false)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.getCellHeight(at: indexPath)
    }
    
    private func getCellHeight(at indexPath: IndexPath) -> CGFloat {
        let cellIsShowing = self.cellsVisibilityState[indexPath] ?? false
        func expandedHeight() -> CGFloat {
            self.isPerformingExpandCollapse = true
            let cellHeight = (self.tableView?.cellForRow(at: indexPath) as? CellType)?.expandedHeight ?? CellType.collapsedHeight
            self.isPerformingExpandCollapse = false
            return cellHeight
        }        
        return cellIsShowing && !self.isPerformingExpandCollapse ? expandedHeight() : CellType.collapsedHeight
    }
}

