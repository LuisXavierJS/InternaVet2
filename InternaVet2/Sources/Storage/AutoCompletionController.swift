//
//  AssetNamesStorage.swift
//  InternaVet2
//
//  Created by Jorge Luis on 02/11/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

enum AutoCompletionType: String{
    case canisFamiliaris = "Canis familiaris"
    case felisCatus = "Felis catus"
    case exame = "Exame"
    case procedimento = "Procedimento"
    case medicamento = "Medicamento"
}
class AutoCompletionController: NSObject {
    let assetType: AutoCompletionType
    
    init(_ assetType:AutoCompletionType){
        self.assetType = assetType
    }
    
    func stringsToComplete(string: String) -> [String]?{
        var tipoDeAutocomplete = self.assetType.rawValue
        if let firstChar = string.uppercased().characters.first{
            tipoDeAutocomplete.insert(firstChar, at: tipoDeAutocomplete.startIndex)
            let bundle = Bundle(for: AutoCompletionController.self)
            if let filePath = bundle.path(forResource: tipoDeAutocomplete, ofType: "txt"){
                do{
                    let autoCompleteData = try String(contentsOfFile: filePath)
                    return autoCompleteData.components(separatedBy: ".")
                        .filter({!$0.isEmpty && $0.localizedCaseInsensitiveContains(string)})
                }catch let error as NSError {
                    print("could not get autocomplete of \(tipoDeAutocomplete) for string \(string) because of error: \(error)")
                }
            }
        }
        return nil
    }
    
    class func insertAssetNameIfPossible(string:String, toComplete: AutoCompletionType){
        var tipoDeAutocomplete = toComplete.rawValue
        if let firstChar = string.uppercased().characters.first{
            tipoDeAutocomplete.insert(firstChar, at: tipoDeAutocomplete.startIndex)
            let bundle = Bundle(for: AutoCompletionController.self)
            if let filePath = bundle.path(forResource: tipoDeAutocomplete, ofType: "txt"){
                do{
                    let autoCompleteData = try String(contentsOfFile: filePath)
                    if !autoCompleteData.components(separatedBy: ".").contains(where: {$0.uppercased() == string.uppercased()}){
                        let autoCompleteUpdatedData = autoCompleteData + string + "."
                        try autoCompleteUpdatedData.write(toFile: filePath, atomically: true, encoding: .utf8)
                    }
                }catch let error as NSError {
                    print("could not update autocomplete of \(tipoDeAutocomplete) for string \(string) because of error: \(error)")
                }
            }
        }
    }
}
