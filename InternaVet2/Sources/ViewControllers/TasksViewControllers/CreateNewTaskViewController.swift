//
//  CreateNewTaskViewController.swift
//  InternaVet2
//
//  Created by Jorge Luis on 10/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class CreateNewTaskViewController: BaseRegisterViewController, PushButtonProtocol, SelectionSliderViewDelegateProtocol, SearchableListDelegate, EntityServerProtocol {
    @IBOutlet weak var taskTypeSelection: LabeledSelectionViewField!
    @IBOutlet weak var dosageTextfield: TextSelectionViewField!
    @IBOutlet weak var taskNamePushButton: PushButtonViewField!
    @IBOutlet weak var patientPushButton: PushButtonViewField!
    @IBOutlet weak var intervalPickerSelector: PickerViewButtonField!
    @IBOutlet weak var beginHospitalizationDateSelector: DateViewButtonField!
    @IBOutlet weak var endHospitalizationDateSelector: DateViewButtonField!
    @IBOutlet weak var observationsTextView: TextViewButtonField!
    @IBOutlet weak var dosageHeight: NSLayoutConstraint! {
        didSet{
            self.originalDosageHeight = self.dosageHeight.constant
        }
    }
    
    weak var editingTask: Task?
    
    weak var delegate: EntityConsumerProtocol?
    
    fileprivate weak var beginDatePicker: UIDatePicker? {
        return self.beginHospitalizationDateSelector.datePickerContainer?.datepicker
    }
    
    fileprivate weak var endDatePicker: UIDatePicker? {
        return self.endHospitalizationDateSelector.datePickerContainer?.datepicker
    }
    
    private weak var currentPatient: Patient?
    private weak var lastSelectedPushButton: PushButtonViewField?
    private var originalDosageHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDatasources()
        self.setDelegates()
    }
    
    override func allFieldsFullfilled() -> Bool {
        let currentType = self.getCurrentTaskAutocompletionType()
        let dosageIsFullfilled = currentType != .medicamento || (currentType == .medicamento && self.dosageTextfield.updateFullfilledState())
        return [
                self.taskNamePushButton,
                self.patientPushButton,
                self.intervalPickerSelector,
                self.beginHospitalizationDateSelector,
                self.endHospitalizationDateSelector
            ].reduce(true, {
                let fieldIsFullfilled = $0.1?.updateFullfilledState() ?? true
                return $0.0 && fieldIsFullfilled
            }) && dosageIsFullfilled
    }
    
    override func performSave() {
        let task = self.editingTask ?? Task()
        task.name = self.taskNamePushButton.getInputValue()
        task.begin = self.beginDatePicker?.date
        task.end = self.endDatePicker?.date
        task.dosage = self.dosageTextfield.textfield.text
        task.dosageType = self.dosageTextfield.selection.selectedItemTitle
        task.type = self.taskTypeSelection.selection.selectedItemTitle
        task.observations = self.observationsTextView.textViewContainer?.textview?.text
        if self.editingTask == nil {
            task.identifier = UUID().uuidString
            task.patientIdentifier = self.currentPatient?.identifier
            self.currentPatient?.tasks.append(task)
        }
        self.sessionController.saveContext()
        self.delegate?.createdItem(task, for: self)
    }
    
    //MARK: Private methods
    private func setDelegates() {
        self.taskTypeSelection.selection.delegate = self
        self.patientPushButton.delegate = self
        self.taskNamePushButton.delegate = self
    }
    
    private func setDatasources() {
        self.taskTypeSelection.selection.items = ([.medicamento,.procedimento,.exame] as [AutoCompletionType]).map({$0.rawValue})
        self.dosageTextfield.selection.items = [Words.grams, Words.kilograms]
        self.intervalPickerSelector.setItems(Array(1...24).map({return "\($0) hora" + ($0 > 1 ? "s" : "")}))
        self.beginDatePicker?.addTarget(self, action: #selector(self.beginDatePickerValueChanged), for: .valueChanged)
        self.beginDatePicker?.minimumDate = DefaultValues.minimumHospitalizationDate
        self.beginDatePicker?.maximumDate = DefaultValues.maximumHospitalizationDate
        self.endDatePicker?.minimumDate = DefaultValues.minimumHospitalizationDate
        self.endDatePicker?.maximumDate = DefaultValues.maximumHospitalizationDate
    }
    
    private func getCurrentTaskAutocompletionType() -> AutoCompletionType {
        return AutoCompletionType(rawValue: self.taskTypeSelection.selection.selectedItemTitle) ?? .medicamento
    }
    
    private func getSearchMode(for button: PushButtonViewField) -> SearchMode {
        switch button {
        case self.taskNamePushButton: return .autocompletion(type: self.getCurrentTaskAutocompletionType())
        default: return .itemList(list: self.sessionController.currentUser?.patients ?? [])
        }
    }
    
    private func updateDosageHeight() {
        let isMedicine = AutoCompletionType(rawValue: self.taskTypeSelection.selection.selectedItemTitle) == AutoCompletionType.medicamento
        self.dosageHeight.constant = isMedicine ? originalDosageHeight : 0
    }
    
    @objc private func beginDatePickerValueChanged() {
        self.endDatePicker?.minimumDate = self.beginDatePicker?.date
    }
    
    //MAKR: SelectionSliderViewDelegateProtocol
    func selectedItem(atIndex index: Int, slider: SelectionSliderView) {
        switch slider {
        case self.taskTypeSelection.selection:
            self.taskNamePushButton.setInputValue(newValue: "")
            self.updateDosageHeight()
        default:return
        }
    }
    
    //MARK: PushButtonProtocol method
    func pushButtonWasTapped(_ button: PushButtonViewField) {
        if let vc = SearchableListViewController.instantiate() {
            vc.setList(mode: self.getSearchMode(for: button),
                       delegate: self)
            self.navigationController?.pushViewController(vc, animated: true)
            self.lastSelectedPushButton = button
        }
    }

    //MARK: SearchableListDelegate methods
    func didConfirmChoosedItem(_ item: SearchableItem) {
        self.lastSelectedPushButton?.setInputValue(newValue: item.resultItemTitle())
        if let patient = item as? Patient {
            self.currentPatient = patient
        }
    }
    
    func didCreatedItem(_ item: SearchableItem) {
        self.didConfirmChoosedItem(item)
    }
    
    func needsViewControllerToCreateItem(for listViewController: SearchableListViewController) -> RegisterViewController? {
        if self.lastSelectedPushButton == self.patientPushButton {
            return CreateNewPatientViewController.instantiate(withIdentifier: CreateNewPatientViewController.className())
        }
        return nil
    }
}
