//
//  CGContext+Helpers.swift
//  InternaVet2
//
//  Created by Jorge Luis on 02/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

extension CGContext {
    func addLineInPath(for rect: CGRect, alignedIn align: CGRectAlignment) {
        switch align {
        case let .verticallyCentralized(addendum):
            let p = CGPoint(x: 0, y: rect.origin.y + rect.height/2 + addendum)
            self.move(to: p)
            self.addLine(to: p.with(x: rect.maxX))
            break
        case let .horizontallyCentralized(addendum):
            let p = CGPoint(x: rect.origin.x + rect.width/2 + addendum, y: 0)
            self.move(to: p)
            self.addLine(to: p.with(y: rect.maxY))
            break
        case let .top(addendum):
            let p = CGPoint(x: 0, y: addendum)
            self.move(to: p)
            self.addLine(to: p.with(x: rect.maxX))
            break
        case let .bottom(addendum):
            let p = CGPoint(x: 0, y: rect.maxY - addendum)
            self.move(to: p)
            self.addLine(to: p.with(x: rect.maxX))
            break
        case let .left(addendum):
            let p = CGPoint(x: addendum, y: 0)
            self.move(to: p)
            self.addLine(to: p.with(y: rect.maxY))
            break
        case let .right(addendum):
            let p = CGPoint(x: rect.maxX - addendum, y: 0)
            self.move(to: p)
            self.addLine(to: p.with(y: rect.maxY))
            break
        }
    }
}
