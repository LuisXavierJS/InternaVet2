//
//  SearchableListViewController.swift
//  InternaVet2
//
//  Created by Jorge Luis on 08/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

protocol SearchableListDelegate: class {
    func didConfirmChoosedItem(_ item: SearchableItem) -> Void
    func didCreatedItem(_ item: SearchableItem) -> Void
    func needsViewControllerToCreateItem(for listViewController: SearchableListViewController) -> RegisterViewController?
}

typealias SearchableListChoosedCallback = ((_ item: SearchableItem) -> Void)
typealias SearchableListCreatedCallback = ((_ itemName: String) -> Void)

enum SearchMode {
    case autocompletion(type: AutoCompletionType)
    case itemList(list: [SearchableItem])
}

class SearchableListViewController: BaseListViewController, UITextFieldDelegate, UITableViewDelegate, EntityConsumerProtocol {
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var listTableView: UITableView!
    
    @IBOutlet weak var textfieldHeightConstraint: NSLayoutConstraint!
    
    private(set) var originalListItems: [SearchableItem] = []
    var listDatasource: JSGenericTableController<SearchResultCell>!
    
    private(set) var selectedIndex: IndexPath?
    
    private var searchMode: SearchMode = .itemList(list: [])
    
    weak var delegate: SearchableListDelegate?
    
    //MARK: Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDatasources()
        self.setDelegates()
        self.setCreateButton()
    }
    
    //MARK: IBActions
    
    func createButtonTaped() {
        if let controller = self.delegate?.needsViewControllerToCreateItem(for: self) {
            controller.delegate = self
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func confirmButtonTapped() {
        self.navigationController?.popViewController(animated: true)
        self.performConfirmation()
    }
    
    @IBAction func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Public methods
    
    func setList(mode: SearchMode, delegate: SearchableListDelegate) {
        self.searchMode = mode
        self.delegate = delegate
        self.searchTextfield?.text = ""
        switch self.searchMode {
        case .autocompletion(_):
            self.originalListItems = []
            self.listDatasource?.items = [[]]
        case .itemList(let list):
            self.originalListItems = list
            self.listDatasource?.items = [list]
        }
    }
    
    //MARK: UITextFieldDelegate Methods
    
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
    
    //MARL: UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let oldSelected = self.selectedIndex
        self.selectedIndex = indexPath
        tableView.reloadRows(at: [self.selectedIndex,oldSelected].flatMap({$0}), with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = self.cellColor(at: indexPath)
    }
    
    //MARK: Entity Consumer Protocol methods
    
    func createdItem(_ item: StorageItem, for: EntityServerProtocol) {
        self.delegate?.didCreatedItem(item as! SearchableItem)
        if let root = self.delegate as? UIViewController {
            self.navigationController?.popToViewController(root, animated: true)
        }else {
            self.navigationController?.popViewController(animated: true)
        }
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
    
    fileprivate func setCreateButton() {
        switch self.searchMode {
        case .itemList(_):
            let button = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(self.createButtonTaped))
            self.navigationItem.rightBarButtonItems?.append(button)
        default:return
        }
    }
    
    fileprivate func cellColor(at index: IndexPath) -> UIColor {
        return index == self.selectedIndex ? Colors.clearLightGreen : Colors.mainLight
    }
    
    fileprivate func performConfirmation() {
        if let selected = self.selectedIndex {
            self.delegate?.didConfirmChoosedItem(self.listDatasource.items[selected.section][selected.row])
        }else{
            switch self.searchMode {
            case .autocompletion(let type):
                AutoCompletionController(type).insertAssetNameIfPossible(string: self.searchTextfield.text!)                
            default:break
            }
            self.delegate?.didCreatedItem(SearchableItemM(self.searchTextfield.text!))
        }
    }
    
    fileprivate func calculateNewListDatasourceItems(for newText: String) -> [SearchableItem] {
        switch self.searchMode {
        case .autocompletion(let type): return AutoCompletionController(type).stringsToComplete(string: newText)?.map({SearchableItemM($0)}) ?? []
        case .itemList: return self.originalListItems.filter({$0.shouldResult(for: newText)})
        }
    }
    
}
