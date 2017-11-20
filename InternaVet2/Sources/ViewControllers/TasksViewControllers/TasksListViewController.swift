//
//  TasksListViewController.swift
//  InternaVet2
//
//  Created by Jorge Luis on 12/10/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class TaskListViewController: BaseListViewController {
    
    var tableDatasource: JSGenericExpansableCellTableController<TaskTableViewCell>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableDatasource = JSGenericExpansableCellTableController(tableView: self.tableView)
        self.tableView.setDataSourceAndDelegate(self.tableDatasource.delegateDatasource)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableDatasource.items = [self.sessionController.currentUser?.patients.reduce([], {return [$0.0,$0.1.tasks].flatMap({$0})}) ?? []]
        self.tableView.reloadData()
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        if let taskCtrlr: UINavigationController = CreateNewTaskViewController.instantiate(nil) as? UINavigationController {
            self.navigationController?.present(taskCtrlr, animated: true, completion: nil)
        }
    }
}
