//
//  CreateNewTaskViewController.swift
//  InternaVet2
//
//  Created by Jorge Luis on 10/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class CreateNewTaskViewController: BaseRegisterViewController, PushButtonProtocol, SelectionSliderViewDelegateProtocol, SearchableListDelegate {
    @IBOutlet weak var taskTypeSelection: LabeledSelectionViewField!
    @IBOutlet weak var dosageTextfield: CustomFloatTextField!
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
    
    private weak var currentPatient: Patient?
    private weak var lastSelectedPushButton: PushButtonViewField?
    private var originalDosageHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegates()
    }
    
    
    //MARK: Private methods
    private func setDelegates() {
        self.taskTypeSelection.selection.delegate = self
        self.patientPushButton.delegate = self
        self.taskNamePushButton.delegate = self
    }
    
    private func setDatasources() {
        
    }
    
    private func getCurrentTaskAutocompletionType() -> AutoCompletionType {
        return .exame
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
            return CreateNewPatientViewController.instantiate()
        }
        return nil
    }
}
