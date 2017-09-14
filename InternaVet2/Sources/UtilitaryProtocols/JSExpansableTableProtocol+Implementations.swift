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
    static var expandedHeight: CGFloat {get}
}

class TableViewDelegateDatasource: JSTableViewDelegateDatasource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.delegate.tableView?(tableView, heightForRowAt: indexPath) ?? 44
    }
}

class JSGenericExpansableCellTableController<CellType: JSExpansableCellProtocol>:JSGenericTableController<CellType> where CellType: UITableViewCell{
    struct CellVisibilityState {
        var isShowing: Bool = false
        var height: CGFloat {return !self.isShowing ? CellType.collapsedHeight : CellType.expandedHeight}
    }
    
    override var items: [[DataType]] {
        get { return super.items }
        set { super.items = newValue;
            self.cellsVisibilityState = newValue[0].map({_ in CellVisibilityState()}) }
    }
    
    var cellsVisibilityState: [CellVisibilityState] = []
    
    init(_ tableView: UITableView) {
        super.init(tableView: tableView)
    }
    
    override func createDelegateDatasourceObject() -> JSTableViewDelegateDatasource {
        return TableViewDelegateDatasource()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.cellsVisibilityState[indexPath.row].isShowing = !self.cellsVisibilityState[indexPath.row].isShowing
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellsVisibilityState[indexPath.row].height
    }
}

