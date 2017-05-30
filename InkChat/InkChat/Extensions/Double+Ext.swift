//
//  Double+Ext.swift
//  InkChat
//
//  Created by iOS Dev Log on 2017/5/30.
//  Copyright © 2017年 iOSDevLog. All rights reserved.
//

import Foundation

extension Double {
    func format(f:String) ->String {
        return NSString(format:"%\(f)f" as NSString,self) as String
    }
}
