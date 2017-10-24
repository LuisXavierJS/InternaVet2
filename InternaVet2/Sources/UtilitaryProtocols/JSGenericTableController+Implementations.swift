//
//  GenericTableController+Implementations.swift
//  InternaVet2
//
//  Created by Jorge Luis on 11/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import Foundation


//
//  GenericTableDatasource.swift
//  ColumnTableView
//
//  Created by Jorge Luis on 26/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit


protocol JSSetupableCellProtocol: class {
    associatedtype DataType
    func setup(_ object: DataType)
}

@objc protocol JSTableViewControllerProtocol: UITableViewDataSource, UITableViewDelegate {
    var delegateDatasource: JSTableViewDelegateDatasource! {get set}
}

class JSTableViewDelegateDatasource: NSObject, UITableViewDataSource, UITableViewDelegate {
    weak var delegate: JSTableViewControllerProtocol!
    weak var listener: UITableViewDelegate?
    
    //MARK: REQUIRED METHODS
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.delegate.numberOfSections?(in:tableView) ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.delegate.tableView(tableView,numberOfRowsInSection:section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.delegate.tableView(tableView,cellForRowAt:indexPath)
    }
    
    //MARK: OPTIONAL METHODS
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.listener?.tableView?(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.delegate.tableView?(tableView,viewForHeaderInSection:section)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self.delegate.tableView?(tableView,viewForFooterInSection:section)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return self.delegate.tableView?(tableView,editActionsForRowAt:indexPath)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return self.delegate.tableView?(tableView,editingStyleForRowAt:indexPath) ?? .none
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.listener?.tableView?(tableView, didSelectRowAt: indexPath)
        self.delegate.tableView?(tableView, didSelectRowAt: indexPath)
    }
    
}

class JSGenericTableController<CellType: JSSetupableCellProtocol>: NSObject, JSTableViewControllerProtocol where CellType: UITableViewCell {
    typealias DataType = CellType.DataType
    
    var items: [[DataType]] = []
    
    var delegateDatasource: JSTableViewDelegateDatasource!
    
    @discardableResult
    func setDelegateDatasourceObject() -> JSTableViewDelegateDatasource! {
        guard let delegate = self.delegateDatasource else {
            self.delegateDatasource = self.createDelegateDatasourceObject()
            return self.delegateDatasource
        }
        return delegate
    }
    
    func createDelegateDatasourceObject() -> JSTableViewDelegateDatasource {
        return JSTableViewDelegateDatasource()
    }
    
    fileprivate(set) weak var tableView: UITableView?
    
    var cellIdentifier: String {
        return CellType.className()
    }
    
    init<T:UITableView>(tableView: T){
        self.tableView = tableView
        super.init()
        self.setDelegateDatasourceObject()
        self.delegateDatasource.delegate = self
    }
    
    func reloadData(with items: [[DataType]]) {
        self.items = items
        self.tableView?.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                 for: indexPath) as! CellType
        cell.setup(self.items[indexPath.section][indexPath.row])
        return cell
    }
}
