//
//  ReusableView.swift
//  TacoPOP
//
//  Created by Jack Davis on 7/25/16.
//  Copyright © 2016 Devslopes. All rights reserved.
//

import UIKit

protocol ReusableView: class {}

extension ReusableView where Self: UIView {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
