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
    @IBInspectable var degree: CGFloat = -1
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
    
    override func draw(_ rect: CGRect) {
        
        let area = rect.insetBy(dx: self.lineWidth, dy: self.lineWidth)
        let directionPoint = self.arrowDirectionPoint(in: area)
        let arrowPoints = self.arrowPoints(in: area)
        
        let con = UIGraphicsGetCurrentContext()
        con?.clip(to: rect.insetBy(dx: 1, dy: 1))
        con?.setLineWidth(self.lineWidth)
        con?.setStrokeColor(self.lineColor.cgColor)
        con?.move(to: directionPoint)
        con?.addLine(to: arrowPoints.p1)
        con?.move(to: directionPoint)
        con?.addLine(to: arrowPoints.p2)
        con?.strokePath()        
    }
}
