//
//  BorderedButtonFields.swift
//  InternaVet2
//
//  Created by Jorge Luis on 10/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit


protocol PushButtonProtocol: class {
    func pushButtonWasTapped(_ button: PushButtonViewField)
}

@IBDesignable
class PickerViewButtonField: PushButtonViewField, FieldViewContainerProtocol {
    @IBOutlet fileprivate weak var containerField: PickerViewContainer? {
        didSet{
            self.containerField?.delegate = self
        }
    }
    
    var selectedItem: String?
    
    func setItems(_ items: [String]) {
        self.containerField?.datasourceItems = [items]
    }
    
    override var fieldRelativeSize: CGFloat {
        return 1
    }
    
    override func setupViews() {
        super.setupViews()
        self.arrowsView.rightArrow.isHidden = true
    }
    
    override func buttonWasTapped() {
        super.buttonWasTapped()
        guard let container = self.containerField else {return}
        container.changeFieldViewVisibility()
        UIView.animate(withDuration: 0.25) {self.rootView?.layoutIfNeeded()}
        if let scroll = self.scrollSuperview {
            let yVariation: CGFloat = container.fieldIsShowing ? container.bounds.height : 0
            scroll.setContentOffset(scroll.contentOffset.adding(onY: yVariation), animated: true)
        }
    }
    
    func valueWasChanged(_ newValue: Any) {
        if let selected = newValue as? String {
            self.selectedItem = selected
            self.valueLabelText = selected
        }
    }
}

@IBDesignable
class PushButtonViewField: BorderedArrowViewField {
    @IBInspectable var titleLabelText: String = ""{ didSet{ self.dualLabelView.titleLabelText = titleLabelText } }
    @IBInspectable var valueLabelText: String = ""{ didSet{ self.dualLabelView.valueLabelText = valueLabelText } }
    @IBInspectable var placeholderText: String = ""{ didSet{ self.dualLabelView.placeholderText = placeholderText } }
    @IBInspectable var labelSize: CGFloat = 14{ didSet{ self.dualLabelView.labelSize = self.labelSize } }
    @IBInspectable var placeholderColor: UIColor = Colors.lightGreen{ didSet{ self.dualLabelView.placeholderColor = self.labelColor } }
    @IBInspectable var labelColor: UIColor = Colors.darkGreen{ didSet{ self.dualLabelView.labelColor = self.labelColor } }
    
    private weak var dualLabelView: DualLabelView!
    
    weak var delegate: PushButtonProtocol?
    
    override weak var field: UIView! {
        return self.dualLabelView
    }
    override var fieldRelativeSize: CGFloat {
        return 0.9
    }
    
    override func createArrowView() -> DoubleArrowsView! {
        return DoubleArrowsView()
    }
    
    override func setupViews() {
        let dual = DualLabelView()
        self.dualLabelView = dual
        super.setupViews()
        self.arrowsView.isUserInteractionEnabled = false
        self.arrowsView.leftArrow.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.arrowsView.rightArrow.beginTouchAnimation()
        self.dualLabelView.beginTouchAnimation()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.arrowsView.rightArrow.endTouchAnimation()
        self.dualLabelView.endTouchAnimation()
        if let point = touches.first?.location(in: self),
            self.point(inside: point, with: event) {
            self.buttonWasTapped()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.arrowsView.rightArrow.endTouchAnimation()
        self.dualLabelView.endTouchAnimation()
    }
    
    func buttonWasTapped(){
        self.delegate?.pushButtonWasTapped(self)
    }
}
