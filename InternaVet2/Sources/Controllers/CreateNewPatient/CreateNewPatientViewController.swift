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
        
    }
    
    func setupSelectorsOptions(){
        self.weightSelectionText.selectionOptions = ["Gramas", "Quilogramas"]
        self.hospitalizationSelectionText.selectionOptions = ["Horas", "Dias"]
        self.genderSelection.selectionOptions = ["Macho", "Fêmea"]
        self.castratedSelection.selectionOptions = ["Não", "Sim"]
        self.diedSelection.selectionOptions = ["Não", "Sim"]
        self.specieSelection.selectionOptions = ["Canis Familiaris", "Felis Catus"]
    }
    
    func setupPickerSelectors(){
        let freeDogHousesList: [String] = SessionController.currentUser?.dogHouses.filter({$0.patientId == nil}).map({String($0.dogHouserNumber)}) ?? []
        let totalDogHousesToList: [String] = [["--"], freeDogHousesList].flatMap({$0})
        self.dogHousePickerSelector.setItems(totalDogHousesToList)
        
        let monthsToList: [String] = Array(1...11).map({String($0) + ($0 > 1 ? " meses" : " mês")})
        let yearsToList: [String] = Array(1...30).map({String($0) + ($0 > 1 ? " anos" : " ano")})
        let totalAgesToList: [String] = [monthsToList, yearsToList].flatMap({$0})
        self.agePickerSelector.setItems(totalAgesToList)
    }
    
}
