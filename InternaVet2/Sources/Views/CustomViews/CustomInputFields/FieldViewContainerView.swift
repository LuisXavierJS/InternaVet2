//
//  FieldViewContainerView.swift
//  InternaVet2
//
//  Created by Jorge Luis on 08/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class PickerViewContainer: FieldViewContainerView {
    override func fieldViewInstance() -> UIView {
        return UIPickerView()
    }
    
    override func prepareForInterfaceBuilder() {
        self.backgroundColor = UIColor.green.with(alpha: 0.5)
        let label = UILabel(frame: self.bounds)
        label.text = "UIPickerView"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 25)
        self.addSubview(label)
    }
}

class DatePickerViewContainer: FieldViewContainerView {
    override func fieldViewInstance() -> UIView {
        return UIDatePicker()
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

@IBDesignable
class FieldViewContainerView: ContentView {
    private(set) var height: CGFloat = 0
    
    @IBInspectable var fieldIsShowing: Bool = false
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!{
        didSet{
            self.height = self.heightConstraint.constant
            self.updateHeightConstraint()
        }
    }
    
    weak var fieldView: UIView?
    
    var fieldViewConstraints: [NSLayoutConstraint] = []
    

    override func setupViews() {
        self.clipsToBounds = true
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
        self.fieldViewConstraints = [NSLayoutConstraint.constraints(withVisualFormat: "V:|[fv(height)]",
                                                                    metrics: ["height" : self.height],
                                                                    views: ["fv" : fv]),
                                     NSLayoutConstraint.constraints(withVisualFormat: "H:|[fv]|",
                                                                    metrics: nil,
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
