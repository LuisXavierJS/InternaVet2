//
//  TasksListViewController.swift
//  InternaVet2
//
//  Created by Jorge Luis on 12/10/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class TaskListViewController: BaseListViewController {
    @IBAction func addButtonTapped(_ sender: Any) {
        if let taskCtrlr: UINavigationController = CreateNewTaskViewController.instantiate(nil) as? UINavigationController {
            self.navigationController?.present(taskCtrlr, animated: true, completion: nil)
        }
    }
}
