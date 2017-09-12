//
//  CreateNewPatient.swift
//  InternaVet2
//
//  Created by Jorge Luis on 01/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class CreateNewPatientViewController: UIViewController {
    @IBOutlet weak var nameTextField: CustomFloatTextField!
    @IBOutlet weak var registerTextField: CustomFloatTextField!
    @IBOutlet weak var chipTextField: CustomFloatTextField!
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
    
}
