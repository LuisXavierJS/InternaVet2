//
//  PatientsListViewController.swift
//  InternaVet2
//
//  Created by Jorge Luis on 10/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class PatientsListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var tableDatasource: PatientsTableController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableDatasource = PatientsTableController(self.tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableDatasource.items = [SessionController.currentUser?.patients ?? []]
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


class PatientsTableController:JSGenericTableController<PatientTableViewCell> {
    struct PatientVisibilityState {
        var isShowing: Bool = false
        var height: CGFloat {return self.isShowing ? 40 : 100}
    }
    
    override var items: [[Patient]] {
        get { return super.items }
        set { super.items = newValue;
            self.patientsVisibilityState = newValue.flatMap({_ in PatientVisibilityState()}) }
    }
    
    var patientsVisibilityState: [PatientVisibilityState] = []
    
    init(_ tableView: UITableView) {
        super.init(tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.patientsVisibilityState[indexPath.row].isShowing = !self.patientsVisibilityState[indexPath.row].isShowing
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.patientsVisibilityState[indexPath.row].height
    }
}
