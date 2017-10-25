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
    
    static func generateRandomColor() -> UIColor {
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
}
