//
//  CustomButton.swift
//  InternaVet2
//
//  Created by Jorge Luis on 22/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

@objc protocol SelectionSliderViewDelegateProtocol: class {
    @objc optional func userSelectedItem(atIndex index: Int, slider: SelectionSliderView)
}

@IBDesignable
class SelectionSliderView: DoubleArrowsView, UIScrollViewDelegate {
    @IBInspectable var labelVerticalPadding: CGFloat = 1{ didSet{ self.setupFrames() } }
    @IBInspectable var textColor: UIColor = Colors.lightGreen{ didSet{ self.reloadLabelSettings() } }
    @IBInspectable var fontSize: CGFloat = 14{ didSet{ self.reloadLabelSettings() } }
    @IBInspectable var hiddingColor: UIColor = UIColor.white{ didSet{ self.setupGradientLayer() } }
    @IBInspectable var hiddingLocation: CGFloat = 5{ didSet{ self.setupGradientLayer() } }
    
    fileprivate var scrollPageView: UIScrollView = UIScrollView()
    weak var delegate: SelectionSliderViewDelegateProtocol?
    
    var selectedItemIndex: Int {
        return Int(round(self.scrollPageView.contentOffset.x/self.bounds.width))
    }
    
    var items: [String] = [] { didSet { self.reloadData() } }
    
    func reloadData(){
        self.scrollPageView.subviews.filter({$0 is UILabel}).forEach({$0.removeFromSuperview()})
        self.scrollPageView.setContentOffset(CGPoint.zero, animated: false)
        self.updateArrowsVisibility(forSelectedIndex: 0)
        let nLabels = CGFloat(self.items.count)
        for i in 0..<Int(nLabels) {
            let label = UILabel(frame: self.bounds.with(x: self.bounds.width * CGFloat(i)).insetBy(dx: 15, dy: self.labelVerticalPadding))
            label.tag = i
            label.text = self.items[i]
            label.numberOfLines = 0
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: self.fontSize)
            label.textColor = self.textColor
            self.scrollPageView.addSubview(label)
        }
    }
    
    private func reloadLabelSettings(){
        func setupLabel(label: UILabel){
            label.textColor = self.textColor
            label.font = UIFont.systemFont(ofSize: self.fontSize)
        }
        self.scrollPageView.subviews.filter({$0 is UILabel}).enumerated().forEach({
            setupLabel(label: $0.element as! UILabel)
        })
    }
    
    private func setupScrollView(){
        self.scrollPageView.isPagingEnabled = true
        self.scrollPageView.alwaysBounceHorizontal = true
        self.scrollPageView.alwaysBounceVertical = false
        self.scrollPageView.delegate = self
        self.scrollPageView.showsHorizontalScrollIndicator = false
        self.addSubview(self.scrollPageView)
    }
    
    private func setupGradientLayer(){
        self.layer.sublayers?.filter({$0 is CAGradientLayer}).forEach({$0.removeFromSuperlayer()})
        func gradientLayer(aligned: CGRectAlignment) -> CAGradientLayer {
            let gradient = CAGradientLayer()
            gradient.backgroundColor = UIColor.init(white: 1, alpha: 0).cgColor
            gradient.contentsScale = UIScreen.main.scale
            gradient.locations = [0.0,1.0]
            gradient.startPoint = CGPoint(x: 0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1, y: 0.5)
            var inset: CGFloat = 0
            switch aligned {
                case .right(_):
                    gradient.name = "right"
                    gradient.colors = [gradient.backgroundColor!,self.hiddingColor.cgColor]
                    inset = self.rightArrowLocation
                break
                default:
                    gradient.name = "left"
                    gradient.colors = [self.hiddingColor.cgColor, gradient.backgroundColor!]
                    inset = self.leftArrowLocation
                break
            }
            gradient.frame = CGSize(width: 2 * (self.arrowsSize.width + inset + self.hiddingLocation), height: 0).toRect()
            return gradient
        }
        self.layer.insertSublayer(gradientLayer(aligned: .right(0)), above: self.scrollPageView.layer)
        self.layer.insertSublayer(gradientLayer(aligned: .left(0)), above: self.scrollPageView.layer)
    }
    
    private func setupGradientFrames(){
        self.layer.sublayers?.filter({$0 is CAGradientLayer}).forEach({
            if $0.name == "right"{
                $0.frame = self.bounds.insetBy(dx: 0, dy: self.labelVerticalPadding).with(width: $0.frame.width).aligned([.right(0)], in: self.bounds)
            }else{
                $0.frame = self.bounds.insetBy(dx: 0, dy: self.labelVerticalPadding).with(width: $0.frame.width).aligned([.left(0)], in: self.bounds)
            }
        })
    }
    
    private func setupPaging(){
        self.setupScrollView()
        self.setupGradientLayer()
    }
    
    override func setupViews() {
        self.setupPaging()
        super.setupViews()
        self.updateArrowsVisibility(forSelectedIndex: 0)
    }
    
    override func setupFrames() {
        super.setupFrames()
        self.scrollPageView.frame = self.bounds
        self.scrollPageView.contentSize = self.bounds.size.with(width: CGFloat(self.items.count) * self.bounds.size.width)
        self.setupGradientFrames()
        self.scrollPageView.subviews.filter({$0 is UILabel}).enumerated().forEach({
            $0.element.frame = self.bounds.with(x: self.bounds.width * CGFloat($0.offset)).insetBy(dx: 15, dy: self.labelVerticalPadding)
        })
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.delegate?.userSelectedItem?(atIndex: self.selectedItemIndex, slider: self)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.updateArrowsVisibility(forSelectedIndex: self.selectedItemIndex)
    }
    
    func arrowBeginTouches(arrow: ArrowTouchableView, touches: Set<UITouch>, with event: UIEvent?) {
        let index = arrow == self.rightArrow ? self.selectedItemIndex + 1 : self.selectedItemIndex - 1
        let pos = self.scrollPageView.contentOffset.with(x: self.bounds.width * CGFloat(index))
        self.scrollPageView.setContentOffset(pos, animated: true)        
    }
    
    private func updateArrowsVisibility(forSelectedIndex index: Int){
        self.leftArrow.isUserInteractionEnabled = !(index == 0 || self.items.isEmpty)
        self.leftArrow.alpha =  index == 0 || self.items.isEmpty ? 0.3 : 1
        self.rightArrow.isUserInteractionEnabled = !(index == self.items.count - 1 || self.items.isEmpty)
        self.rightArrow.alpha =  index == self.items.count - 1 || self.items.isEmpty ? 0.3 : 1
    }
    
    override func prepareForInterfaceBuilder() {
        self.items = ["IB Placeholder Text", "IB Placeholder Text 2", "IB Placeholder Text 3"]
    }
}



