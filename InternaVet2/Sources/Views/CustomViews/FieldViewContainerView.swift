//
//  FieldViewContainerView.swift
//  InternaVet2
//
//  Created by Jorge Luis on 08/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

protocol FieldViewContainerProtocol: class {
    func valueWasChanged(_ newValue: StringRepresentable )
}

class CustomInputField: ContentView {
    @IBOutlet weak var heightConstraint: NSLayoutConstraint? {
        didSet{
            self.originalHeight = heightConstraint?.constant ?? self.frame.height
        }
    }
    
    private var originalHeight: CGFloat = 0
    
    weak var delegate: FieldViewContainerProtocol?
    
    var isShowing: Bool {
        return (self.heightConstraint?.constant ?? self.frame.height) > 0
    }
    
    func changeFieldViewVisibility() {
        self.heightConstraint?.constant = self.isShowing ? 0 : self.originalHeight
    }
}

class PickerViewContainer: CustomInputField, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var pickerview: UIPickerView? {
        didSet {
            self.pickerview?.delegate = self
        }
    }
    
    var datasourceItems: [[String]] = [[]] {
        didSet{
            self.pickerview?.reloadAllComponents()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.datasourceItems.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.datasourceItems[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.datasourceItems[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.delegate?.valueWasChanged(self.datasourceItems[component][row])
    }
}

class TextViewContainer: CustomInputField, UITextViewDelegate {
    @IBOutlet weak var textview: UITextView? {
        didSet{
            self.textview?.delegate = self
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.delegate?.valueWasChanged(textView.text)
    }
}

class DatePickerViewContainer: CustomInputField {
    @IBOutlet weak var datepicker: UIDatePicker? {
        didSet{
            self.datepicker?.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: .valueChanged)
        }
    }
    
    func datePickerValueChanged(_ sender: UIDatePicker){
        print(sender.date)
        self.delegate?.valueWasChanged(sender.date)
    }
}
