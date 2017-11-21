//
//  PatientsListViewController.swift
//  InternaVet2
//
//  Created by Jorge Luis on 10/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class PatientsListViewController: BaseListViewController, JSTableViewControllerListener {
    
    var tableDatasource: MainListDatasource<PatientTableViewCell>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableDatasource = MainListDatasource(tableView: self.tableView)
        self.tableDatasource.delegateDatasource.listener = self
        self.tableView.setDataSourceAndDelegate(self.tableDatasource.delegateDatasource)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableDatasource.items = [self.sessionController.currentUser?.patients ?? []]
        self.tableView.reloadData()
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        if let patientCtrlr: UINavigationController = CreateNewPatientViewController.instantiate(nil) as? UINavigationController {
            self.navigationController?.present(patientCtrlr, animated: true, completion: nil)
        }
    }
    
}
