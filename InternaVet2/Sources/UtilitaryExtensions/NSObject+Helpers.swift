//
//  NSObject+Helpers.swift
//  InternaVet2
//
//  Created by Jorge Luis on 24/10/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit


extension NSObject {
    public class func className() -> String {
        let moduleClassName = NSStringFromClass(self.classForCoder())
        let className = moduleClassName.components(separatedBy: ".").last!
        return className
    }
    
    func findNext(type: AnyClass) -> Any{
        var resp = self as! UIResponder
        while !resp.isKind(of: type.self) && resp.next != nil {
            resp = resp.next!
        }
        return resp
    }
}
