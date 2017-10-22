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

class TableViewDelegateDatasource: JSTableViewDelegateDatasource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.delegate.tableView?(tableView, heightForRowAt: indexPath) ?? 44
    }
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
    
    init(_ tableView: UITableView) {
        super.init(tableView: tableView)
    }
    
    override func createDelegateDatasourceObject() -> JSTableViewDelegateDatasource {
        return TableViewDelegateDatasource()
    }
    
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
            return (self.tableView?.cellForRow(at: indexPath) as? CellType)?.expandedHeight ?? CellType.collapsedHeight
        }        
        return cellIsShowing ? expandedHeight() : CellType.collapsedHeight
    }
}

