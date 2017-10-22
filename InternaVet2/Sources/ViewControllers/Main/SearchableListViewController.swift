//
//  SearchableListViewController.swift
//  InternaVet2
//
//  Created by Jorge Luis on 08/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class SearchableListViewController: BaseListViewController, UITextFieldDelegate {
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var listTableView: UITableView!
    
    @IBOutlet weak var textfieldHeightConstraint: NSLayoutConstraint!
    
    private(set) var originalListItems: [SearchableItem] = []
    lazy var listDatasource: JSGenericTableController<SearchResultCell> = JSGenericTableController<SearchResultCell>(tableView: self.listTableView)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegates()
    }
    
    func setList(items: [SearchableItem]) {
        self.originalListItems = items
        self.listDatasource.items = [items]
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = NSString(string:textField.text!).replacingCharacters(in: range, with: string)
        if !newText.isEmpty {
            self.listDatasource.items = [self.originalListItems.filter({$0.shouldResult(for: newText)})]
            self.listTableView.reloadData()
        }
        return true
    }
    
    @IBAction func confirmButtonTapped() {
        
    }
    
    @IBAction func backButtonTapped() {
        
    }
    
    fileprivate func performConfirmation() {
        
    }

    fileprivate func setDelegates() {
        self.listTableView.delegate = self.listDatasource.delegateDatasource
        self.listTableView.dataSource = self.listDatasource.delegateDatasource
        self.searchTextfield.delegate = self
    }
    
}
