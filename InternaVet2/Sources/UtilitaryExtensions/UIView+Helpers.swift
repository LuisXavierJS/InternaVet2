//
//  UIView+Helpers.swift
//  InternaVet2
//
//  Created by Jorge Luis on 10/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

extension UIView {
    weak var rootView: UIView? {
        var view: UIView? = self
        while view?.superview != nil {
            view = view?.superview
        }
        return view
    }
    
    weak var scrollSuperview: UIScrollView? {
        var view: UIView? = self
        while view?.superview != nil {
            view = view?.superview
            if view is UIScrollView { break }
        }
        return view as? UIScrollView
    }
}
