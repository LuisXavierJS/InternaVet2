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

fileprivate enum SearchMode {
    case autocompletion(type: AutoCompletionType)
    case itemList
}

class SearchableListViewController: BaseListViewController, UITextFieldDelegate, UITableViewDelegate {
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var listTableView: UITableView!
    
    @IBOutlet weak var textfieldHeightConstraint: NSLayoutConstraint!
    
    private(set) var originalListItems: [SearchableItem] = []
    lazy var listDatasource: JSGenericTableController<SearchResultCell> = JSGenericTableController<SearchResultCell>(tableView: self.listTableView)
    
    private(set) var selectedIndex: IndexPath?
   
    private(set) var confirmChoosedItemCallback: SearchableListChoosedCallback?
    private(set) var confirmCreationItemCallback: SearchableListCreatedCallback?
    
    private var searchMode: SearchMode = .itemList
    
    //MARK: Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegates()
    }
    
    //MARK: IBActions
    
    @IBAction func confirmButtonTapped() {
        self.dismiss(animated: true, completion: { [weak self] in
            self?.performConfirmation()
        })
    }
    
    @IBAction func backButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Public methods
    
    func setList(items: [SearchableItem], didChooseItem: SearchableListChoosedCallback? = nil, didCreateItem: SearchableListCreatedCallback? = nil) {
        self.searchMode = .itemList
        self.searchTextfield.text = ""
        self.originalListItems = items
        self.listDatasource.items = [items]
        self.setCallbacks()
    }
    
    func setAutocompletion(_ type: AutoCompletionType, didChooseItem: SearchableListChoosedCallback? = nil, didCreateItem: SearchableListCreatedCallback? = nil) {
        self.searchMode = .autocompletion(type: type)
        self.searchTextfield.text = ""
        self.originalListItems = []
        self.listDatasource.items = [[]]
        self.setCallbacks()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [self.selectedIndex,indexPath].flatMap({$0}), with: .automatic)
        self.selectedIndex = indexPath
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = self.cellColor(at: indexPath)
    }

    //MARK: Fileprivate methods
    
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
