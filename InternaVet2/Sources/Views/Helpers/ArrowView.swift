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
class ArrowView: UIView{
    var degree: CGFloat = -1
    @IBInspectable var direction: String = ArrowDirection.right.rawValue
    @IBInspectable var lineWidth: CGFloat = 1
    @IBInspectable var lineColor: UIColor = UIColor.black
    
    private var inset: CGFloat = 0
    
    private func arrowDirectionPoint(in rect: CGRect) -> CGPoint {
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
    
    private func defaultArrowPoints(in rect: CGRect) -> (p1: CGPoint, p2: CGPoint) {
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
    
    private func calculateDefaultDegreeOfBiggestPossibleTriangle(in rect: CGRect) -> (defaultDegree: CGFloat, defaultBase: CGFloat)? {
        let arrowDirPoint = self.arrowDirectionPoint(in: rect)
        let defaultPoints = self.defaultArrowPoints(in: rect)
        let dir_p1 = hypot(defaultPoints.p1.x - arrowDirPoint.x, defaultPoints.p1.y - arrowDirPoint.y)
        let dir_p2 = hypot(defaultPoints.p2.x - arrowDirPoint.x, defaultPoints.p2.y - arrowDirPoint.y)
        let p1_p2 = hypot(defaultPoints.p1.x - defaultPoints.p2.x, defaultPoints.p1.y - defaultPoints.p2.y)
        
        if p1_p2 == 0 || dir_p2 == 0 || dir_p1 == 0 { return nil }
        
        let defaultDegree = acos((pow(dir_p1, 2) + pow(dir_p2, 2) - pow(p1_p2, 2)) / (2 * dir_p1 * dir_p2))*180/CGFloat.pi
        return (defaultDegree: defaultDegree, defaultBase: p1_p2)
    }
    
    private func arrowPoints(in rect: CGRect) -> (p1: CGPoint, p2: CGPoint) {
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
    
    
    private func areaForDrawArrow(in rect: CGRect) -> CGRect {
        let dir = ArrowDirection(rawValue: self.direction) ?? .right
        switch dir {
        case .top, .bottom:
            return rect.insetBy(dx: self.lineWidth, dy: 1)
        case .right:
            return rect.insetBy(left: self.lineWidth, right: 0, top: self.lineWidth/2, bottom: self.lineWidth/2) //insetBy(dx: 1, dy: self.lineWidth)
        case .left:
            return rect.insetBy(left: 0, right: self.lineWidth, top: self.lineWidth/2, bottom: self.lineWidth/2) //insetBy(dx: 1, dy: self.lineWidth)
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        let area = self.areaForDrawArrow(in: rect)//rect.insetBy(dx: self.lineWidth, dy: self.lineWidth)
        let directionPoint = self.arrowDirectionPoint(in: area)
        let arrowPoints = self.arrowPoints(in: area)
        let middleLinePoint = CGPoint(x: max(directionPoint.x - lineWidth*2,rect.origin.x), y: directionPoint.y)
        
        let con = UIGraphicsGetCurrentContext()
        
        con?.setLineWidth(1)
        con?.setStrokeColor(self.lineColor.cgColor)
        con?.move(to: directionPoint)
        con?.addLine(to: arrowPoints.p1)
        con?.addLine(to:middleLinePoint)
        con?.move(to: directionPoint)
        con?.addLine(to: arrowPoints.p2)
        con?.addLine(to:middleLinePoint)
        con?.strokePath()
        con?.setLineWidth(0.5)
        con?.setStrokeColor(self.lineColor.withAlphaComponent(0.7).cgColor)
        con?.move(to: middleLinePoint)
        con?.addLine(to: directionPoint.with(x: directionPoint.x + 1))
        con?.strokePath()
        con?.setStrokeColor(UIColor.clear.cgColor)
        con?.setFillColor(self.lineColor.cgColor)
        con?.addEllipse(in: CGSize(width: 1, height: 1).toRect().with(center:directionPoint))
        con?.fillPath()
    }
}
