//
//  FieldViewContainerView.swift
//  InternaVet2
//
//  Created by Jorge Luis on 08/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class PickerViewContainer: FieldViewContainerView, UIPickerViewDelegate, UIPickerViewDataSource {
    var datasourceItems: [[String]] = [[]] {
        didSet{
            (self.fieldView as? UIPickerView)?.reloadAllComponents()
        }
    }
    
    override func fieldViewInstance() -> UIView {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.reloadAllComponents()
        return picker
    }
    
    override func prepareForInterfaceBuilder() {
        self.backgroundColor = UIColor.green.with(alpha: 0.5)
        let label = UILabel(frame: self.bounds)
        label.text = "UIPickerView"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 25)
        self.addSubview(label)
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

class TextViewContainer: FieldViewContainerView, UITextViewDelegate {
    override func fieldViewInstance() -> UIView {
        let textView = UITextView()
        textView.layer.cornerRadius = 3
        textView.layer.borderWidth = 0.4
        textView.layer.borderColor = Colors.darkGreen.cgColor
        textView.delegate = self
        return textView
    }
    
    override func prepareForInterfaceBuilder() {
        self.backgroundColor = UIColor.green.with(alpha: 0.5)
        let label = UILabel(frame: self.bounds)
        label.text = "UITextField"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 25)
        self.addSubview(label)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.delegate?.valueWasChanged(textView.text)
    }
    
    override func setupViews() {
        super.setupViews()
        self.verticalDistance = 5
        self.horizontalDistance = 5
    }
    
    override func heightConstraintWasSetted() {
        super.heightConstraintWasSetted()        
        self.createFieldViewIfNeeded()
    }
}

class DatePickerViewContainer: FieldViewContainerView {
    override func fieldViewInstance() -> UIView {
        let datePicker =  UIDatePicker()
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: .valueChanged)
        return datePicker
    }
    
    func datePickerValueChanged(_ sender: UIDatePicker){
        print(sender.date)
        self.delegate?.valueWasChanged(sender.date)
    }

    override func prepareForInterfaceBuilder() {
        self.backgroundColor = UIColor.green.with(alpha: 0.5)
        let label = UILabel(frame: self.bounds)
        label.text = "UIDatePicker"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 25)
        self.addSubview(label)
    }
}


protocol FieldViewContainerProtocol: class {
    func valueWasChanged(_ newValue: StringRepresentable )
}

//abstract class
@IBDesignable
class FieldViewContainerView: ContentView {
    private(set) var height: CGFloat = 0
    
    @IBInspectable var fieldIsShowing: Bool = false
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!{
        didSet{
            self.heightConstraintWasSetted()
        }
    }
    
    var verticalDistance: CGFloat = 0
    var horizontalDistance: CGFloat = 0
    
    weak var fieldView: UIView?
    
    weak var delegate: FieldViewContainerProtocol?
    
    var fieldViewConstraints: [NSLayoutConstraint] = []

    override func setupViews() {
        self.clipsToBounds = true
    }
    
    func heightConstraintWasSetted(){
        self.height = self.heightConstraint.constant
        self.updateHeightConstraint()
    }
    
    func fieldViewInstance() -> UIView {
        assertionFailure("MUST BE IMPLEMENTED BY SUBCLASS")
        return UIView()
    }
    
    @discardableResult
    func createFieldViewIfNeeded() -> UIView? {
        if let fv = self.fieldView { return fv }
        let fv = self.fieldViewInstance()
        self.addSubview(fv)
        self.fieldView = fv
        self.fieldView?.translatesAutoresizingMaskIntoConstraints = false
        self.fieldViewConstraints = [NSLayoutConstraint.constraints(withVisualFormat: "V:|-(top)-[fv(height)]",
                                                                    metrics: ["height" : self.height - (self.verticalDistance * 2), "top": self.verticalDistance],
                                                                    views: ["fv" : fv]),
                                     NSLayoutConstraint.constraints(withVisualFormat: "H:|-(left)-[fv]-(right)-|",
                                                                    metrics: ["left":self.horizontalDistance, "right":self.horizontalDistance],
                                                                    views: ["fv" : fv])].flatMap({$0})
        NSLayoutConstraint.activate(self.fieldViewConstraints)
        
        return fv
    }
    
    func updateHeightConstraint(){
        self.heightConstraint.constant = self.fieldIsShowing ? self.height : 0
    }
    
    func showFieldView() {
        self.createFieldViewIfNeeded()
        self.fieldIsShowing = true
        self.updateHeightConstraint()
    }
    
    func hideFieldView() {
        self.fieldIsShowing = false
        self.updateHeightConstraint()
    }
    
    func changeFieldViewVisibility() {
        if self.fieldIsShowing {
            self.hideFieldView()
        }else {
            self.showFieldView()
        }
    }
}
