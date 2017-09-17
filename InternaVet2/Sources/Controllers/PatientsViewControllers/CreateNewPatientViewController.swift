//
//  CreateNewPatient.swift
//  InternaVet2
//
//  Created by Jorge Luis on 01/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class CreateNewPatientViewController: UIViewController {
    @IBOutlet weak var nameTextField: BorderedTextFieldView!
    @IBOutlet weak var registerTextField: BorderedTextFieldView!
    @IBOutlet weak var chipTextField: BorderedTextFieldView!
    @IBOutlet weak var weightSelectionText: TextSelectionViewField!
    @IBOutlet weak var hospitalizationSelectionText: TextSelectionViewField!
    @IBOutlet weak var genderSelection: LabeledSelectionViewField!
    @IBOutlet weak var castratedSelection: LabeledSelectionViewField!
    @IBOutlet weak var diedSelection: LabeledSelectionViewField!
    @IBOutlet weak var specieSelection: LabeledSelectionViewField!
    @IBOutlet weak var racePushButton: PushButtonViewField!
    @IBOutlet weak var ownerPushButton: PushButtonViewField!
    @IBOutlet weak var dogHousePickerSelector: PickerViewButtonField!
    @IBOutlet weak var agePickerSelector: PickerViewButtonField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSelectorsOptions()
        self.setupTextfields()
        self.setupPickerSelectors()
    }
    
    func setupSelectorsOptions(){
        self.weightSelectionText.selectionOptions = [Words.grams, Words.kilograms]
        self.hospitalizationSelectionText.selectionOptions = [Words.hour.plural, Words.day.plural]
        self.genderSelection.selectionOptions = [Words.male, Words.female]
        self.castratedSelection.selectionOptions = [Words.no, Words.yes]
        self.diedSelection.selectionOptions = [Words.no, Words.yes]
        self.specieSelection.selectionOptions = [Words.dog, Words.cat]
    }
    
    func setupPickerSelectors(){
        let freeDogHousesList: [String] = SessionController.currentUser?.dogHouses.filter({$0.patientId == nil}).map({String($0.dogHouserNumber)}) ?? []
        let totalDogHousesToList: [String] = [["--"], freeDogHousesList].flatMap({$0})
        self.dogHousePickerSelector.setItems(totalDogHousesToList)
        
        let yearsToList: [String] = Array(1...11).map({ self.getPlural(from: $0, word: Words.year)})
        let monthsToList: [String] = Array(1...11).map({self.getPlural(from: $0, word: Words.month)})
        let totalAgesToList: [String] = [monthsToList, yearsToList].flatMap({$0})
        self.agePickerSelector.setItems(totalAgesToList)
    }

    func getPlural(from: Int, word: String) -> String{
        let begin = String(from) + " "
        let end = from > 1 ? word.plural : word
        return begin + end
    }
    
    func setupTextfields() {
        self.weightSelectionText.textField.keyboardType = .numbersAndPunctuation
        self.weightSelectionText.textField.allowsEditingTextAttributes = false
        self.hospitalizationSelectionText.textField.keyboardType = .numbersAndPunctuation
        self.hospitalizationSelectionText.textField.allowsEditingTextAttributes = false
    }

    func allFieldsFullfilled() -> Bool{
        return true
//            self.weightSelectionText.getFullfilled() &&
//            self.hospitalizationSelectionText.getFullfilled() &&
//            self.genderSelection.getFullfilled() &&
//            self.diedSelection.getFullfilled() &&
//            self.specieSelection.getFullfilled() &&
//            self.castratedSelection.getFullfilled() &&
//            self.racePushButton.getFullfilled() &&
//            self.ownerPushButton.getFullfilled() &&
//            self.dogHousePickerSelector.getFullfilled() &&
//            self.agePickerSelector.getFullfilled() &&
//            self.nameTextField.getFullfilled() &&
//            self.chipTextField.getFullfilled() &&
//            self.registerTextField.getFullfilled()
    }

    func performSave(){
        if self.allFieldsFullfilled() {
            let newPatient = Patient()
            newPatient.age = self.agePickerSelector.selectedItem?.stringRepresentation
            newPatient.name = self.nameTextField.textField.text
            newPatient.specie = self.specieSelection.selectionView.selectedItemTitle
            newPatient.gender = self.genderSelection.selectionView.selectedItemTitle
            SessionController.currentUser?.addIfPossibleAndSavePatient(newPatient)
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        self.performSave()
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
