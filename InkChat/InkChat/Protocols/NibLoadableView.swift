//
//  NibLoadableView.swift
//  TacoPOP
//
//  Created by Jack Davis on 7/25/16.
//  Copyright © 2016 Devslopes. All rights reserved.
//

import UIKit

protocol NibLoadableView: class {}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
}
