//
//  LabeledSelectionViewField.swift
//  InternaVet2
//
//  Created by Jorge Luis on 03/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit



@IBDesignable
class LabeledSelectionViewField: SelectionArrowViewField {
    @IBInspectable var labelText: String = ""{ didSet{ self.label.text = labelText } }
    @IBInspectable var labelSize: CGFloat = 14{ didSet{ self.label.font = UIFont.systemFont(ofSize: self.labelSize) } }
    @IBInspectable var labelColor: UIColor = Colors.darkGreen{ didSet{ self.label.textColor = self.labelColor } }    
    
    private weak var label: UILabel!
    
    override weak var field: UIView! {
        return self.label
    }
    
    override func setupViews() {
        let lab = UILabel()
        self.label = lab
        super.setupViews()
        self.label.textColor = self.labelColor
        self.label.numberOfLines = 0
        self.label.font = UIFont.systemFont(ofSize: self.labelSize)
    }    

}

@IBDesignable
class TextSelectionViewField: SelectionArrowViewField {
    @IBInspectable var placeholder: String = "" { didSet{ self.textField.placeholder = self.placeholder } }
    @IBInspectable var textColor: UIColor = Colors.darkGreen { didSet{ self.textField.textColor = self.textColor } }
    @IBInspectable var placeholderColor: UIColor = Colors.darkGreen.withAlphaComponent(0.5){ didSet{ self.textField.placeholderColor = self.placeholderColor } }
    @IBInspectable var floatingLabelTextColor: UIColor = Colors.darkGreen{ didSet{ self.textField.floatingLabelTextColor = self.floatingLabelTextColor } }
    @IBInspectable var floatingLabelActiveTextColor: UIColor = Colors.lightGreen{ didSet{ self.textField.floatingLabelActiveTextColor = self.floatingLabelActiveTextColor } }
    
    private weak var textField: CustomFloatTextField!
    
    override weak var field: UIView! {
        return self.textField
    }
    
    override func setupViews() {
        let text = CustomFloatTextField()
        self.textField = text
        super.setupViews()
        self.textField.textAlignment = .center
        self.textField.placeholderColor = self.placeholderColor
        self.textField.floatingLabelTextColor = self.floatingLabelTextColor
        self.textField.floatingLabelActiveTextColor = self.floatingLabelActiveTextColor
        self.textField.textColor = self.textColor        
    }
    
    override func setupFrames() {
        super.setupFrames()
        self.textField.frame = self.textField.frame.insetBy(dx: 0, dy: 5)
    }
}

protocol PushButtonProtocol: class {
    func pushButtonWasTapped(_ button: PushButtonViewField)
}

@IBDesignable
class PickerViewButtonField: PushButtonViewField, FieldViewContainerProtocol {
    @IBOutlet fileprivate weak var containerField: PickerViewContainer?
    
    var selectedItem: String?
    
    func setItems(_ items: [String]) {
        self.containerField?.datasourceItems = [items]
    }
    
    override var fieldRelativeSize: CGFloat {
        return 1
    }
    
    override func setupViews() {
        super.setupViews()
        self.containerField?.delegate = self
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
            self.titleLabelText = selected
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

@IBDesignable
class DualLabelView: ContentView {
    @IBInspectable var titleLabelText: String = ""{ didSet{ self.firsLabel.text = titleLabelText } }
    @IBInspectable var labelSize: CGFloat = 14 {
        didSet {
            self.firsLabel.font = UIFont.systemFont(ofSize: self.labelSize)
            self.secondLabel.font = UIFont.systemFont(ofSize: self.labelSize)
        }
    }
    @IBInspectable var labelColor: UIColor = Colors.darkGreen{
        didSet {
            self.firsLabel.textColor = self.labelColor
            self.updateValueLabelColors()
        }
    }
    @IBInspectable var valueLabelText: String = ""{ didSet{ self.secondLabel.text = valueLabelText;self.updateValueLabelColors() } }
    @IBInspectable var placeholderText: String = ""{ didSet{ self.secondLabel.text = placeholderText;self.updateValueLabelColors() } }
    @IBInspectable var placeholderColor: UIColor = Colors.lightGreen{ didSet{ self.updateValueLabelColors() } }
    
    weak var firsLabel: UILabel!
    weak var secondLabel: UILabel!
    
    private var _firstLabelColor: UIColor = Colors.darkGreen
    private var _secondLabelColor: UIColor = Colors.lightGreen
    
    override func setupViews() {
        func createAndSetupLabel() -> UILabel {
            let label = UILabel()
            label.textColor = self.labelColor
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: self.labelSize)
            label.backgroundColor = UIColor.clear
            self.addSubview(label)
            return label
        }
        self.firsLabel = createAndSetupLabel()
        self.firsLabel.textAlignment = .left
        self.secondLabel = createAndSetupLabel()
        self.secondLabel.textAlignment = .right
        self.updateValueLabelColors()
    }
    
    override func setupFrames() {
        self.firsLabel.frame = self.bounds
        self.secondLabel.frame = self.bounds
    }
    
    func beginTouchAnimation(){
        self._firstLabelColor = self.firsLabel.textColor
        self._secondLabelColor = self.secondLabel.textColor
        self.firsLabel.textColor = self.firsLabel.textColor.withBrightness(75/255)
        self.secondLabel.textColor = self.secondLabel.textColor.withBrightness(75/255)
    }
    
    func endTouchAnimation(){
        self.firsLabel.textColor = self._firstLabelColor
        self.secondLabel.textColor = self._secondLabelColor
    }
    
    func updateValueLabelColors() {
        self.secondLabel.text = self.valueLabelText.isEmpty ? self.placeholderText : self.valueLabelText
        self.secondLabel.textColor = self.secondLabel.text == self.placeholderText ? self.placeholderColor : self.labelColor
    }
}

//abstract class!
class SelectionArrowViewField: BorderedArrowViewField, SelectionSliderViewDelegateProtocol {
    @IBInspectable var selLabelVerticalPadding: CGFloat = 1{ didSet{ self.selectionView.labelVerticalPadding = self.selLabelVerticalPadding } }
    @IBInspectable var selTextColor: UIColor = Colors.lightGreen{ didSet{ self.selectionView.textColor = self.selTextColor } }
    @IBInspectable var selFontSize: CGFloat = 12.5{ didSet{ self.selectionView.fontSize = self.selFontSize } }
    @IBInspectable var selHiddingColor: UIColor = UIColor.white{ didSet{ self.selectionView.hiddingColor = self.selHiddingColor } }
    @IBInspectable var selHiddingLocation: CGFloat = -10{ didSet{ self.selectionView.hiddingLocation = self.selHiddingLocation } }
    
    var selectionOptions: [String] {
        set {
            self.selectionView.items = newValue
        }
        get {
            return self.selectionView.items
        }
    }
    
    weak var selectionView: SelectionSliderView! {
        return self.arrowsView as! SelectionSliderView
    }
    
    override func createArrowView() -> DoubleArrowsView! {
        return SelectionSliderView()
    }
    
    override func setupViews() {
        super.setupViews()
        self.selectionView.labelVerticalPadding = self.selLabelVerticalPadding
        self.selectionView.textColor = self.selTextColor
        self.selectionView.fontSize = self.selFontSize
        self.selectionView.hiddingColor = self.selHiddingColor
        self.selectionView.hiddingLocation = self.selHiddingLocation
        self.selectionView.delegate = self
        self.selectionView.items = ["Canis Familiaris", "Felis Catus"]
    }
    
}

//abstract class!
class BorderedArrowViewField: BorderedView {
    @IBInspectable var fieldIndent: CGFloat = 15{ didSet{ self.setupFrames() } }
    @IBInspectable var spaceBetween: CGFloat = 10{ didSet{ self.setupFrames() } }
    @IBInspectable var selRightMargin: CGFloat = 5{ didSet{ self.setupFrames() } }
    
    weak var field: UIView!{
        assertionFailure("MUST IMPLEMENT A FIELD ON SUBCLASS!")
        return nil
    }
    var fieldRelativeSize: CGFloat {
        return 0.5
    }
    weak var arrowsView: DoubleArrowsView!
    
    func createArrowView() -> DoubleArrowsView! {
        assertionFailure("MUST IMPLEMENT A FIELD ON SUBCLASS!")
        return nil
    }
    
    override func setupViews() {
        super.setupViews()
        let arrowView = self.createArrowView()!
        self.addSubview(arrowView)
        self.arrowsView = arrowView
        self.addSubview(self.field)
    }
    
    override func setupFrames() {
        super.setupFrames()
        self.field.frame = self.bounds.insetBy(dx: 0, dy: self.lineWidth)
            .with(width: self.bounds.width*self.fieldRelativeSize - self.fieldIndent/2 - self.spaceBetween/2 - self.selRightMargin/2)
            .aligned([.left(self.fieldIndent)], in: self.bounds)
        
        self.arrowsView.frame = self.bounds
            .insetBy(dx: 0, dy: self.lineWidth)
            .with(width: self.bounds.width*(1 - self.fieldRelativeSize) - self.fieldIndent/2 - self.spaceBetween/2 - self.selRightMargin/2)
            .aligned([.right(-self.selRightMargin)], in: self.bounds)
    }
    
    override func prepareForInterfaceBuilder() {
        self.arrowsView.prepareForInterfaceBuilder()
    }
}
