//
//  DatePickerContainerView.swift
//  InternaVet2
//
//  Created by Jorge Luis on 08/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

@IBDesignable
class DatePickerContainerView: ContentView {
    private(set) var height: CGFloat = 0
    
    @IBInspectable var dateIsShowing: Bool = false
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!{
        didSet{
            self.height = self.heightConstraint.constant
            self.updateHeightConstraint()
        }
    }
    
    weak var datePicker: UIDatePicker?
    
    var datePickerConstraints: [NSLayoutConstraint] = []
    

    override func setupViews() {
        self.clipsToBounds = true
    }
    
    @discardableResult
    func createDatePickerIfNeeded() -> UIDatePicker? {
        if let dt = self.datePicker { return dt }
        let dtPicker = UIDatePicker()
        self.addSubview(dtPicker)
        self.datePicker = dtPicker
        self.datePicker?.translatesAutoresizingMaskIntoConstraints = false
        self.datePickerConstraints = [NSLayoutConstraint.constraints(withVisualFormat: "V:|[dtPicker(height)]",
                                                                    metrics: ["height" : self.height],
                                                                    views: ["dtPicker" : dtPicker]),
                                     NSLayoutConstraint.constraints(withVisualFormat: "H:|[dtPicker]|",
                                                                    metrics: nil,
                                                                    views: ["dtPicker" : dtPicker])].flatMap({$0})
        NSLayoutConstraint.activate(self.datePickerConstraints)
        
        return dtPicker
    }
    
    func updateHeightConstraint(){
        self.heightConstraint.constant = self.dateIsShowing ? self.height : 0
    }
    
    func showDatePicker() {
        self.createDatePickerIfNeeded()
        self.dateIsShowing = true
        self.updateHeightConstraint()
    }
    
    func hideDatePicker() {
        self.dateIsShowing = false
        self.updateHeightConstraint()
    }
    
    func changeDatePickerVisibility() {
        if self.dateIsShowing {
            self.hideDatePicker()
        }else {
            self.showDatePicker()
        }
    }
    
    override func prepareForInterfaceBuilder() {
        self.backgroundColor = UIColor.green
    }
}
