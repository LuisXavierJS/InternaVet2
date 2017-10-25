//
//  UITableView+Helpers.swift
//  InternaVet2
//
//  Created by Jorge Luis on 24/10/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

extension UITableView {
    func registerCell<CellType: UITableViewCell>(forCellType type: CellType.Type) {
        self.register(CellType.self, forCellReuseIdentifier: CellType.className())
    }
    
    func setDataSourceAndDelegate(_ datasource: (UITableViewDelegate&UITableViewDataSource)?){
        self.dataSource = datasource
        self.delegate = datasource
    }
    
    func setDataSourceAndDelegate(jsController datasource: JSTableViewControllerProtocol){
        self.dataSource = datasource.delegateDatasource
        self.delegate = datasource.delegateDatasource
    }
}
