//
//  ArrowView.swift
//  InternaVet2
//
//  Created by Jorge Luis on 30/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

enum ArrowDirection: String {
    case top = "top"
    case bottom = "bottom"
    case left = "left"
    case right = "right"
}

@IBDesignable
class ArrowView: ContentView{
    var degree: CGFloat = -1
    @IBInspectable var direction: String = ArrowDirection.right.rawValue
    @IBInspectable var lineWidth: CGFloat = 1
    @IBInspectable var baseLineWidth: CGFloat = 0
    
    @IBInspectable var lineColor: UIColor = UIColor.black
    @IBInspectable var middleLineColor: UIColor =  UIColor.black
    @IBInspectable var baseArrowColor: UIColor = UIColor.gray
    @IBInspectable var mainArrowColor: UIColor = UIColor.lightGray
    
    fileprivate var inset: CGFloat = 0
    
    fileprivate func arrowDirectionPoint(in rect: CGRect) -> CGPoint {
        let dir = ArrowDirection(rawValue: self.direction) ?? .right
        switch dir {
        case .top:
            return CGPoint(x: rect.origin.x + rect.width/2, y: rect.origin.x)
        case .bottom:
            return CGPoint(x: rect.origin.x + rect.width/2, y: rect.maxY)
        case .right:
            return CGPoint(x: rect.maxX, y:  rect.origin.y + rect.height/2)
        case .left:
            return CGPoint(x: rect.origin.x, y: rect.origin.y + rect.height/2)
        }
    }
    
    fileprivate func defaultArrowPoints(in rect: CGRect) -> (p1: CGPoint, p2: CGPoint) {
        let dir = ArrowDirection(rawValue: self.direction) ?? .right
        switch dir {
        case .top:
            return (p1:CGPoint(x: rect.origin.x, y: rect.maxY),p2:CGPoint(x: rect.maxX, y: rect.maxY))
        case .bottom:
            return (p1:CGPoint(x: rect.origin.x, y: rect.origin.y),p2:CGPoint(x: rect.maxX, y: rect.origin.y))
        case .right:
            return (p1:CGPoint(x: rect.origin.x, y: rect.origin.y),p2:CGPoint(x: rect.origin.x, y: rect.maxY))
        case .left:
            return (p1:CGPoint(x: rect.maxX, y: rect.origin.y),p2:CGPoint(x: rect.maxX, y: rect.maxY))
        }
    }
    
    fileprivate func calculateDefaultDegreeOfBiggestPossibleTriangle(in rect: CGRect) -> (defaultDegree: CGFloat, defaultBase: CGFloat)? {
        let arrowDirPoint = self.arrowDirectionPoint(in: rect)
        let defaultPoints = self.defaultArrowPoints(in: rect)
        let dir_p1 = hypot(defaultPoints.p1.x - arrowDirPoint.x, defaultPoints.p1.y - arrowDirPoint.y)
        let dir_p2 = hypot(defaultPoints.p2.x - arrowDirPoint.x, defaultPoints.p2.y - arrowDirPoint.y)
        let p1_p2 = hypot(defaultPoints.p1.x - defaultPoints.p2.x, defaultPoints.p1.y - defaultPoints.p2.y)
        
        if p1_p2 == 0 || dir_p2 == 0 || dir_p1 == 0 { return nil }
        
        let defaultDegree = acos((pow(dir_p1, 2) + pow(dir_p2, 2) - pow(p1_p2, 2)) / (2 * dir_p1 * dir_p2))*180/CGFloat.pi
        return (defaultDegree: defaultDegree, defaultBase: p1_p2)
    }
    
    fileprivate func arrowPoints(in rect: CGRect) -> (p1: CGPoint, p2: CGPoint) {
        if degree > 0, let defaults = self.calculateDefaultDegreeOfBiggestPossibleTriangle(in: rect) {
            let dir = ArrowDirection(rawValue: self.direction) ?? .right
            let defaultDegreeReason = defaults.defaultBase/defaults.defaultDegree
            let desirableBase = degree * defaultDegreeReason
            switch dir{
            case .top,.bottom:
                return self.defaultArrowPoints(in: rect.with(width: desirableBase).aligned(CGRectAlignment.centralized, in: rect))
            case .left, .right:
                return self.defaultArrowPoints(in: rect.with(height: desirableBase).aligned(CGRectAlignment.centralized, in: rect))
            }
        }else {
            return self.defaultArrowPoints(in: rect)
        }
    }
    
    
    fileprivate func areaForDrawArrow(in rect: CGRect) -> CGRect {
        let dir = ArrowDirection(rawValue: self.direction) ?? .right
        switch dir {
        case .top:
            return rect.insetBy(left: self.lineWidth/2, right: self.lineWidth/2, top: 0, bottom: self.lineWidth)
        case .bottom:
            return rect.insetBy(left: self.lineWidth/2, right: self.lineWidth/2, top: self.lineWidth, bottom: 0)
        case .right:
            return rect.insetBy(left: self.lineWidth, right: 0, top: self.lineWidth/2, bottom: self.lineWidth/2)
        case .left:
            return rect.insetBy(left: 0, right: self.lineWidth, top: self.lineWidth/2, bottom: self.lineWidth/2)
        }
    }
    
    fileprivate func getMiddleLine(in rect: CGRect, for directionPoint: CGPoint) -> CGPoint {
        let dir = ArrowDirection(rawValue: self.direction) ?? .right
        switch dir {
        case .top:
            return CGPoint(x: directionPoint.x, y: max(directionPoint.y + lineWidth*2,rect.origin.y))
        case .bottom:
            return CGPoint(x: directionPoint.x, y: max(directionPoint.y - lineWidth*2,rect.origin.y))
        case .right:
            return CGPoint(x: max(directionPoint.x - lineWidth*2,rect.origin.x), y: directionPoint.y)
        case .left:
            return CGPoint(x: max(directionPoint.x + lineWidth*2,rect.origin.x), y: directionPoint.y)
        }
    }
    
    fileprivate func getHalfMiddleBaselinePoint(for points: (middle: CGPoint, direction: CGPoint)) -> CGPoint {
        let halfWidth = self.baseLineWidth > 0 ? self.baseLineWidth : self.lineWidth
        let dir = ArrowDirection(rawValue: self.direction) ?? .right
        switch dir {
        case .top:
            return CGPoint(x: points.direction.x, y: points.middle.y - halfWidth)
        case .bottom:
            return CGPoint(x: points.direction.x, y: points.middle.y + halfWidth)
        case .right:
            return CGPoint(x: points.middle.x + halfWidth, y: points.direction.y)
        case .left:
            return CGPoint(x: points.middle.x - halfWidth, y: points.direction.y)
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        let area = self.areaForDrawArrow(in: rect)
        let directionPoint = self.arrowDirectionPoint(in: area)
        let arrowPoints = self.arrowPoints(in: area)
        let middleLinePoint =  self.getMiddleLine(in: rect, for: directionPoint)
        
        let con = UIGraphicsGetCurrentContext()
        
        con?.move(to: directionPoint)
        con?.addLine(to: arrowPoints.p1)
        con?.addLine(to:middleLinePoint)
        con?.move(to: directionPoint)
        con?.addLine(to: arrowPoints.p2)
        con?.addLine(to:middleLinePoint)
        
        if let path = con?.path{
            con?.setFillColor(self.mainArrowColor.cgColor)
            con?.fillPath()
            
            let halfMiddlePoint =  self.getHalfMiddleBaselinePoint(for:(middle:middleLinePoint,direction:directionPoint))
            con?.move(to:halfMiddlePoint)
            con?.addLine(to: arrowPoints.p1)
            con?.addLine(to: middleLinePoint)
            con?.addLine(to: arrowPoints.p2)
            con?.addLine(to: halfMiddlePoint)
            con?.setFillColor(self.baseArrowColor.cgColor)
            con?.fillPath()
            
            con?.addPath(path)
            con?.setLineWidth(1)
            con?.setStrokeColor(self.lineColor.cgColor)
            con?.strokePath()
        }
        
        con?.move(to: middleLinePoint)
        con?.addLine(to: directionPoint.with(x: directionPoint.x + 0.5))
        
        con?.setLineWidth(0.5)
        con?.setStrokeColor(self.middleLineColor.cgColor)
        con?.strokePath()
        
        con?.setStrokeColor(UIColor.clear.cgColor)
        con?.setFillColor(self.lineColor.cgColor)
        con?.addEllipse(in: CGSize(width: 1, height: 1).toRect().with(center:directionPoint))
        con?.fillPath()
    }
    
    convenience init(_ direction: ArrowDirection, frame: CGRect = CGRect.zero) {
        self.init(frame: frame)
        self.direction = direction.rawValue
    }
    
}

@objc protocol ArrowTouchableDelegateProtocol: class {
    @objc optional func arrowBeginTouches(arrow: ArrowTouchableView, touches: Set<UITouch>, with event: UIEvent?)
    @objc optional func arrowEndedTouches(arrow: ArrowTouchableView, touches: Set<UITouch>, with event: UIEvent?)
}

class ArrowTouchableView: ArrowView {    
    private var _lineColor: UIColor = UIColor.black
    private var _middleLineColor: UIColor =  UIColor.black
    private var _baseArrowColor: UIColor = UIColor.gray
    private var _mainArrowColor: UIColor = UIColor.lightGray
    
    weak var delegate: ArrowTouchableDelegateProtocol?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.arrowBeginTouches?(arrow: self, touches: touches, with: event)
        
        self._lineColor = self.lineColor
        self._baseArrowColor = self.baseArrowColor
        self._mainArrowColor = self.mainArrowColor
        self._middleLineColor = self.middleLineColor
        
        self.lineColor = self.lineColor.withBrightness(75/255)
        self.middleLineColor = self.middleLineColor.withBrightness(75/255)
        self.mainArrowColor = self.mainArrowColor.withBrightness(75/255)
        self.baseArrowColor = self.baseArrowColor.withBrightness(75/255)
        
        UIView.transition(with: self, duration: 0.15, options: .transitionCrossDissolve, animations: {
            self.setNeedsDisplay()
        }, completion: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.arrowEndedTouches?(arrow: self, touches: touches, with: event)
        self.lineColor = self._lineColor
        self.middleLineColor = self._middleLineColor
        self.mainArrowColor = self._mainArrowColor
        self.baseArrowColor = self._baseArrowColor
        UIView.transition(with: self, duration: 0.15, options: .transitionCrossDissolve, animations: {
            self.setNeedsDisplay()
        }, completion: nil)
    }
}
