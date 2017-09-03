//
//  CustomButton.swift
//  InternaVet2
//
//  Created by Jorge Luis on 22/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

@IBDesignable
class SelectionSliderView: DoubleArrowsView, UIScrollViewDelegate {
    @IBInspectable var lineColor: UIColor = Colors.lightGreen
    @IBInspectable var lineWidth: CGFloat = 1
    @IBInspectable var textColor: UIColor = Colors.lightGreen{ didSet{ self.reloadLabelSettings() } }
    @IBInspectable var fontSize: CGFloat = 14{ didSet{ self.reloadLabelSettings() } }
    @IBInspectable var hiddingColor: UIColor = UIColor.white{ didSet{ self.setupGradientLayer() } }
    @IBInspectable var hiddingLocation: CGFloat = 5{ didSet{ self.setupGradientLayer() } }
    
    fileprivate var scrollPageView: UIScrollView = UIScrollView()
    
    var selectedItemIndex: Int {
        return Int(round(self.scrollPageView.contentOffset.x/self.bounds.width))
    }
    
    var items: [String] = [] { didSet { self.reloadData() } }
    
    func reloadData(){
        self.scrollPageView.subviews.filter({$0 is UILabel}).forEach({$0.removeFromSuperview()})
        self.scrollPageView.setContentOffset(CGPoint.zero, animated: false)
        let nLabels = CGFloat(self.items.count)
        self.scrollPageView.contentSize = self.bounds.size.with(width: nLabels * self.bounds.size.width)
        for i in 0..<Int(nLabels) {
            let label = UILabel(frame: self.bounds.with(x: self.bounds.width * CGFloat(i)).insetBy(dx: 15, dy: self.lineWidth))
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
        self.scrollPageView.subviews.filter({$0 is UILabel}).forEach({setupLabel(label: $0 as! UILabel)})
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
                    gradient.colors = [gradient.backgroundColor!,self.hiddingColor.cgColor]
                    inset = self.rightArrowLocation
                break
                default:
                    gradient.colors = [self.hiddingColor.cgColor, gradient.backgroundColor!]
                    inset = self.leftArrowLocation
                break
            }
            gradient.frame = self.bounds
                .insetBy(dx: 0, dy: self.lineWidth)
                .with(width: 2 * (self.arrowsSize.width + inset + self.hiddingLocation))
                .aligned([aligned], in: self.bounds)
            return gradient
        }
        self.layer.insertSublayer(gradientLayer(aligned: .right(0)), above: self.scrollPageView.layer)
        self.layer.insertSublayer(gradientLayer(aligned: .left(0)), above: self.scrollPageView.layer)
    }
    
    private func setupPaging(){
        self.setupScrollView()
        self.setupGradientLayer()
    }
    
    override func setupViews() {
        self.setupPaging()
        super.setupViews()
    }
    
    override func setupFrames() {
        super.setupFrames()
        self.scrollPageView.frame = self.bounds
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    override func draw(_ rect: CGRect) {
        let con = UIGraphicsGetCurrentContext()
        con?.setLineWidth(self.lineWidth)
        con?.setStrokeColor(self.lineColor.cgColor)
        con?.addLineInPath(for: rect, alignedIn: .top(0))
        con?.addLineInPath(for: rect, alignedIn: .bottom(0))
        con?.strokePath()
    }
    
    override func prepareForInterfaceBuilder() {
        let label = UILabel(frame: self.bounds.insetBy(dx: 15, dy: self.lineWidth))
        label.font = UIFont.systemFont(ofSize: self.fontSize)
        label.textColor = self.textColor
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Placeholder Text"
        self.addSubview(label)
    }
}


@IBDesignable
class DoubleArrowsView: ContentView {
    @IBInspectable var leftArrowLocation: CGFloat = 5{ didSet{ self.setupArrowsFrames() } }
    @IBInspectable var rightArrowLocation: CGFloat = 5{ didSet{ self.setupArrowsFrames() } }
    @IBInspectable var leftArrowAlpha: CGFloat = 1{ didSet{ self.setArrowsDisplay() } }
    @IBInspectable var rightArrowAlpha: CGFloat = 1{ didSet{ self.setArrowsDisplay() } }
    @IBInspectable var arrowsMainColor: UIColor = Colors.darkGreen{ didSet{ self.setArrowsDisplay() } }
    @IBInspectable var arrowsBaseColor: UIColor = Colors.lightGreen{ didSet{ self.setArrowsDisplay() } }
    @IBInspectable var arrowsWidth: CGFloat = 4{ didSet{ self.setArrowsDisplay() } }
    @IBInspectable var arrowsSize: CGSize = CGSize(width: 20, height: 25){ didSet{ self.setArrowsDisplay() } }
    
    fileprivate(set) var leftArrow: ArrowTouchableView = ArrowTouchableView(ArrowDirection.left)
    fileprivate(set) var rightArrow: ArrowTouchableView = ArrowTouchableView(ArrowDirection.right)
    
    private func setArrowsDisplay() {
        self.setupArrowsLayout()
        self.setupArrowsFrames()
        self.leftArrow.setNeedsDisplay()
        self.rightArrow.setNeedsDisplay()
    }
    
    private func setupArrow(arrow: ArrowView, withAlpha alpha: CGFloat) {
        arrow.mainArrowColor = self.arrowsMainColor.withAlphaComponent(alpha)
        arrow.baseArrowColor = self.arrowsBaseColor.withAlphaComponent(alpha)
        arrow.middleLineColor = UIColor.clear
        arrow.lineColor = UIColor.clear
        arrow.lineWidth = self.arrowsWidth
        arrow.backgroundColor = UIColor.clear
    }
    
    private func setupArrowsFrames(){
        self.leftArrow.frame = self.arrowsSize.toRect().aligned([.verticallyCentralized(0),.left(self.leftArrowLocation)], in: self.bounds)
        self.rightArrow.frame = self.arrowsSize.toRect().aligned([.verticallyCentralized(0),.right(-self.rightArrowLocation)], in: self.bounds)
    }
    
    private func setupArrowsLayout(){
        self.setupArrow(arrow: self.leftArrow, withAlpha: self.leftArrowAlpha)
        self.setupArrow(arrow: self.rightArrow, withAlpha: self.rightArrowAlpha)
    }
    
    override func setupViews() {
        self.setupArrowsLayout()
        self.addSubview(self.leftArrow)
        self.addSubview(self.rightArrow)
    }
    
    override func setupFrames() {
        self.setupArrowsFrames()
    }
}

