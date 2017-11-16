//
//  CreateNewPatient.swift
//  InternaVet2
//
//  Created by Jorge Luis on 01/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class CreateNewPatientViewController: BaseRegisterViewController, PushButtonProtocol, SelectionSliderViewDelegateProtocol, SearchableListDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: CustomFloatTextField!
    @IBOutlet weak var registerTextField: CustomFloatTextField!
    @IBOutlet weak var chipTextField: CustomFloatTextField!
    @IBOutlet weak var weightSelectionText: TextSelectionViewField!
    @IBOutlet weak var hospitalizationSelectionText: TextSelectionViewField!
    @IBOutlet weak var genderSelection: LabeledSelectionViewField!
    @IBOutlet weak var castratedSelection: LabeledSelectionViewField!
    @IBOutlet weak var specieSelection: LabeledSelectionViewField!
    @IBOutlet weak var racePushButton: PushButtonViewField!
    @IBOutlet weak var ownerPushButton: PushButtonViewField!
    @IBOutlet weak var dogHousePickerSelector: PickerViewButtonField!
    @IBOutlet weak var agePickerSelector: PickerViewButtonField!
    
    weak var editingPatient: Patient?
    
    private weak var lastSelectedPushButton: PushButtonViewField?
    private var triedSave: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSelectorsOptions()
        self.setupTextfields()
        self.setupPickerSelectors()
        self.setupDelegates()
    }
    
    fileprivate func setupDelegates() {
        self.racePushButton.delegate = self
        self.ownerPushButton.delegate = self
        self.specieSelection.selection.delegate = self
    }
    
    fileprivate func setupSelectorsOptions(){
        self.weightSelectionText.selection.items = [Words.grams, Words.kilograms]
        self.hospitalizationSelectionText.selection.items = [Words.hour + "s", Words.day + "s"]
        self.genderSelection.selection.items = [Words.male, Words.female]
        self.castratedSelection.selection.items = [Words.no, Words.yes]        
        self.specieSelection.selection.items = [Words.dog, Words.cat]
    }
    
    fileprivate func setupPickerSelectors(){
        let freeDogHousesList: [String] = self.sessionController.currentUser?.dogHouses.filter({$0.patientId == nil}).map({String($0.dogHouserNumber)}) ?? []
        let totalDogHousesToList: [String] = [["--"], freeDogHousesList].flatMap({$0})
        self.dogHousePickerSelector.setItems(totalDogHousesToList)
        
        func getPlural(from: Int, word: String) -> String{
            let begin = String(from) + " "
            let end = from > 1 ? word + "s" : word
            return begin + end
        }
        
        let yearsToList: [String] = Array(1...20).map({ getPlural(from: $0, word: Words.year)})
        let monthsToList: [String] = Array(1...11).map({ getPlural(from: $0, word: Words.month)})
        let totalAgesToList: [String] = [monthsToList, yearsToList].flatMap({$0})
        self.agePickerSelector.setItems(totalAgesToList)
    }
    
    fileprivate func setupTextfields() {
        self.weightSelectionText.textfield.keyboardType = .numbersAndPunctuation
        self.weightSelectionText.textfield.allowsEditingTextAttributes = false
        self.hospitalizationSelectionText.textfield.keyboardType = .numbersAndPunctuation
        self.hospitalizationSelectionText.textfield.allowsEditingTextAttributes = false
    }

    override func saveButtonTapped(_ sender: Any) {
        super.saveButtonTapped(sender)
        self.triedSave = true
    }
    
    override func allFieldsFullfilled() -> Bool{
        return [self.weightSelectionText,
            self.hospitalizationSelectionText,
            self.racePushButton,
            self.ownerPushButton,
            self.dogHousePickerSelector,
            self.agePickerSelector,
            self.nameTextField,
            self.chipTextField,
            self.registerTextField].reduce(true, {
                let fieldIsFullfilled = ($0.1 as? CustomInputFieldProtocol)?.updateFullfilledState() ?? true
                return $0.0 && fieldIsFullfilled
            })
    }

    override func performSave(){
        let newPatient = self.editingPatient ?? Patient()
        newPatient.age = self.agePickerSelector.selectedItem?.stringRepresentation
        newPatient.name = self.nameTextField.text
        newPatient.specie = self.specieSelection.selection.selectedItemTitle
        newPatient.gender = self.genderSelection.selection.selectedItemTitle
        newPatient.chip = self.chipTextField.text
        newPatient.record = self.registerTextField.text
        newPatient.race = self.racePushButton.valueLabelText
        newPatient.dogHouseNumber = self.dogHousePickerSelector.valueLabelText
        if self.editingPatient == nil {
            self.sessionController.currentUser?.patients.append(newPatient)
        }
        self.sessionController.saveContext()
    }
    
    //MARK: Selection view Methods
    
    func selectedItem(atIndex index: Int, slider: SelectionSliderView) {
        switch slider {
        case self.specieSelection.selection: self.didChoose(race: "")
        default:return
        }
    }
    
    
    
    //MARK: Push Button Methods
    
    func pushButtonWasTapped(_ button: PushButtonViewField) {
        if let vc = SearchableListViewController.instantiate() {
            vc.setList(mode: self.getSearchMode(for: button),
                       delegate: self)
            self.navigationController?.pushViewController(vc, animated: true)
            self.lastSelectedPushButton = button
        }
    }
    
    func didConfirmChoosedItem(_ item: SearchableItem) {
        if let lastButton = self.lastSelectedPushButton {
            self.didChooseItem(item, for: lastButton)
        }
    }
    
    func didCreatedItem(_ item: SearchableItem) {
        if let lastButton = self.lastSelectedPushButton {
            self.didCreateItem(item, for: lastButton)
        }
    }
    
    func needsViewControllerToCreateItem(for listViewController: SearchableListViewController) -> RegisterViewController? {        
        if self.lastSelectedPushButton == self.ownerPushButton,
            let controller = CreateNewOwnerViewController.instantiate(){
            return controller
        }
        return nil
    }
    
    fileprivate func getSearchMode(for button: PushButtonViewField) -> SearchMode {
        switch button {
        case self.racePushButton: return .autocompletion(type: self.currentSpecieAutocompletionType())
        default: return .itemList(list: self.sessionController.currentUser?.owners ?? [])
        }
    }
    
    fileprivate func didChooseItem(_ item: SearchableItem, for button: PushButtonViewField) {
        switch button {
        case self.racePushButton:
            self.didChoose(race: item.resultItemTitle())            
        case self.ownerPushButton:
            if let owner = item as? Owner {
                self.didChoose(owner: owner)
            }
        default:return
        }
    }
    
    fileprivate func didCreateItem(_ item: SearchableItem, for button: PushButtonViewField) {
        switch button {
        case self.racePushButton:
            self.didCreate(race: item.resultItemTitle())
        case self.ownerPushButton:
            if let owner = item as? Owner {
                self.didCreate(owner: owner)
            }
        default:return
        }
    }
    
    fileprivate func didChoose(race: String) {
        self.racePushButton.setInputValue(newValue: race)
        if self.triedSave && !race.isEmpty {
            self.racePushButton.updateFullfilledState()
        }
    }
    
    fileprivate func didCreate(race: String) {
        AutoCompletionController(self.currentSpecieAutocompletionType()).insertAssetNameIfPossible(string: race)
        self.didChoose(race: race)
    }
    
    fileprivate func didCreate(owner: Owner) {
        self.didChoose(owner: owner)
    }
    
    fileprivate func didChoose(owner: Owner) {
        self.ownerPushButton.setInputValue(newValue: owner.name ?? "")
    }
    
    private func currentSpecieAutocompletionType() -> AutoCompletionType {
        return AutoCompletionType(rawValue: self.specieSelection.selection.selectedItemTitle) ?? .canisFamiliaris
    }
}

