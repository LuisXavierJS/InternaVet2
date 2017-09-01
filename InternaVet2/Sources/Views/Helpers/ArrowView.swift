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
    @IBInspectable var degree: CGFloat = 60
    @IBInspectable var direction: String = ArrowDirection.right.rawValue
    @IBInspectable var lineWidth: CGFloat = 1
    @IBInspectable var lineColor: UIColor = UIColor.black
    
    private func arrowDirectionPoint(in rect: CGRect) -> CGPoint {
        let dir = ArrowDirection(rawValue: self.direction) ?? .right
        switch dir {
        case .top:
            return CGPoint(x: rect.width/2, y: 0)
        case .bottom:
            return CGPoint(x: rect.width/2, y: rect.height)
        case .right:
            return CGPoint(x: rect.width, y: rect.height/2)
        case .left:
            return CGPoint(x: 0, y: rect.height/2)
        }
    }
    
    private func mockArrowPoints(in rect: CGRect) -> (p1: CGPoint, p2: CGPoint) {
        let dir = ArrowDirection(rawValue: self.direction) ?? .right
        switch dir {
        case .top:
            return (p1:CGPoint(x: 0, y: rect.height),p2:CGPoint(x: rect.width, y: rect.height))
        case .bottom:
            return (p1:CGPoint(x: 0, y: 0),p2:CGPoint(x: rect.width, y: 0))
        case .right:
            return (p1:CGPoint(x: 0, y: 0),p2:CGPoint(x: 0, y: rect.width))
        case .left:
            return (p1:CGPoint(x: rect.width, y: 0),p2:CGPoint(x: rect.width, y: rect.height))
        }
    }
    
    private func calculateMockDegreeOfBiggestPossibleTriangle(in rect: CGRect) -> CGFloat {
        let arrowDirPoint = self.arrowDirectionPoint(in: rect)
        let mockPoints = self.mockArrowPoints(in: rect)
        let dir_p1 = hypot(mockPoints.p1.x - arrowDirPoint.x, mockPoints.p1.y - arrowDirPoint.y)
        let dir_p2 = hypot(mockPoints.p2.x - arrowDirPoint.x, mockPoints.p2.y - arrowDirPoint.y)
        let p1_p2 = hypot(mockPoints.p1.x - mockPoints.p2.x, mockPoints.p1.y - mockPoints.p2.y)
        
        if p1_p2 == 0 || dir_p2 == 0 || dir_p1 == 0 { return 0 }
        
        return acos((pow(dir_p1, 2) + pow(dir_p2, 2) - pow(p1_p2, 2)) / (2 * dir_p1 * dir_p2))*180/CGFloat.pi
    }
    
    override func draw(_ rect: CGRect) {
        print(self.bounds == rect)
    
    }
}
