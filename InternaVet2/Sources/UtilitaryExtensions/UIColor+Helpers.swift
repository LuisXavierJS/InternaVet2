//
//  File.swift
//  InternaVet2
//
//  Created by Jorge Luis on 02/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

extension UIColor {
    func rgbaComponents() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red : CGFloat = 0
        var green : CGFloat = 0
        var blue : CGFloat = 0
        var alpha : CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red: red, green: green, blue: blue, alpha:alpha)
    }
    
    func withBrightness(_ bright: CGFloat) -> UIColor{
        let c = self.rgbaComponents()
        return UIColor(red: c.red + bright, green: c.green + bright, blue: c.blue + bright, alpha: c.alpha)
    }
    
    func with(red: CGFloat) -> UIColor {
        let c = self.rgbaComponents()
        return UIColor(red: red, green: c.green, blue: c.blue, alpha: c.alpha)
    }
    
    func with(green: CGFloat) -> UIColor {
        let c = self.rgbaComponents()
        return UIColor(red: c.red, green: green, blue: c.blue, alpha: c.alpha)
    }
    
    func with(blue: CGFloat) -> UIColor {
        let c = self.rgbaComponents()
        return UIColor(red: c.red, green: c.green, blue: blue, alpha: c.alpha)
    }
    
    func with(alpha: CGFloat) -> UIColor {
        let c = self.rgbaComponents()
        return UIColor(red: c.red, green: c.green, blue: c.blue, alpha: alpha)
    }
}
