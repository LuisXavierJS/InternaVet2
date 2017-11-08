//
//  SearchableListViewController.swift
//  InternaVet2
//
//  Created by Jorge Luis on 08/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

typealias SearchableListChoosedCallback = ((_ item: SearchableItem) -> Void)
typealias SearchableListCreatedCallback = ((_ itemName: String) -> Void)

enum SearchMode {
    case autocompletion(type: AutoCompletionType)
    case itemList(list: [SearchableItem])
}

class SearchableListViewController: BaseListViewController, UITextFieldDelegate, UITableViewDelegate {
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var listTableView: UITableView!
    
    @IBOutlet weak var textfieldHeightConstraint: NSLayoutConstraint!
    
    private(set) var originalListItems: [SearchableItem] = []
    var listDatasource: JSGenericTableController<SearchResultCell>!
    
    private(set) var selectedIndex: IndexPath?
   
    private(set) var confirmChoosedItemCallback: SearchableListChoosedCallback?
    private(set) var confirmCreationItemCallback: SearchableListCreatedCallback?
    
    private var searchMode: SearchMode = .itemList(list: [])
    
    //MARK: Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDatasources()
        self.setDelegates()
    }
    
    //MARK: IBActions
    
    @IBAction func confirmButtonTapped() {
        self.navigationController?.popViewController(animated: true)
        self.performConfirmation()
    }
    
    @IBAction func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Public methods
    
    func setList(mode: SearchMode, didChooseItem: SearchableListChoosedCallback? = nil, didCreateItem: SearchableListCreatedCallback? = nil) {
        self.searchMode = mode
        self.searchTextfield?.text = ""
        switch self.searchMode {
        case .autocompletion(_):
            self.originalListItems = []
            self.listDatasource?.items = [[]]
        case .itemList(let list):
            self.originalListItems = list
            self.listDatasource?.items = [list]
        }
        self.setCallbacks(didChooseItem: didChooseItem, didCreateItem: didCreateItem)
    }
    
    //MARK: Delegate Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = NSString(string:textField.text!).replacingCharacters(in: range, with: string)
        if !newText.isEmpty {
            self.selectedIndex = nil
            self.listDatasource.items = [self.calculateNewListDatasourceItems(for:newText)]
            self.listTableView.reloadData()
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let oldSelected = self.selectedIndex
        self.selectedIndex = indexPath
        tableView.reloadRows(at: [self.selectedIndex,oldSelected].flatMap({$0}), with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = self.cellColor(at: indexPath)
    }

    //MARK: Fileprivate methods
    
    fileprivate func setDatasources() {
        self.listDatasource = JSGenericTableController<SearchResultCell>(tableView: self.listTableView)
        self.listDatasource.items = [self.originalListItems]
    }
    
    fileprivate func setDelegates() {
        self.listTableView.delegate = self.listDatasource.delegateDatasource
        self.listTableView.dataSource = self.listDatasource.delegateDatasource
        self.listDatasource.delegateDatasource.listener = self
        self.searchTextfield.delegate = self
    }
    
    fileprivate func cellColor(at index: IndexPath) -> UIColor {
        return index == self.selectedIndex ? Colors.clearLightGreen : Colors.mainLight
    }
    
    fileprivate func performConfirmation() {
        if let selected = self.selectedIndex {
            self.confirmChoosedItemCallback?(self.listDatasource.items[selected.section][selected.row])
        }else{
            self.confirmCreationItemCallback?(self.searchTextfield.text!)
        }
    }
    
    fileprivate func setCallbacks(didChooseItem: SearchableListChoosedCallback? = nil, didCreateItem: SearchableListCreatedCallback? = nil){
        self.confirmChoosedItemCallback = didChooseItem
        self.confirmCreationItemCallback = didCreateItem
    }
    
    fileprivate func calculateNewListDatasourceItems(for newText: String) -> [SearchableItem] {
        switch self.searchMode {
        case .autocompletion(let type): return AutoCompletionController(type).stringsToComplete(string: newText)?.map({SearchableItemM($0)}) ?? []
        case .itemList: return self.originalListItems.filter({$0.shouldResult(for: newText)})
        }
    }
}
