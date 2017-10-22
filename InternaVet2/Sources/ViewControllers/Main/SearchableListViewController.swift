//
//  SearchableListViewController.swift
//  InternaVet2
//
//  Created by Jorge Luis on 08/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class SearchableListViewController: BaseListViewController {
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var listTableView: UITableView! {
        didSet{
            self.listTableView.delegate = self.listDatasource.delegateDatasource
            self.listTableView.dataSource = self.listDatasource.delegateDatasource
        }
    }
    
    lazy var listDatasource: JSGenericTableController<SearchResultCell> = JSGenericTableController<SearchResultCell>(tableView: self.listTableView)
    
    @IBOutlet weak var textfieldHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
