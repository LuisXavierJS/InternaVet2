//
//  UITableViewCell+Helpers.swift
//  InternaVet2
//
//  Created by Jorge Luis on 24/10/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

extension UITableViewCell{
    public weak var tableView: UITableView? {
        var view: UIView? = self
        repeat {
            view = view?.superview
            if let table = view as? UITableView { return table }
        } while view?.superview != nil
        return view as? UITableView
    }
}
