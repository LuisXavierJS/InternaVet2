//
//  File.swift
//  InternaVet2
//
//  Created by Jorge Luis on 13/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import Foundation
import UIKit.UIColor

fileprivate extension UIColor{
    convenience init(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat){
        self.init(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

struct Colors {
    static let mainLight = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let lightGreen = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
    static let darkGreen = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
}