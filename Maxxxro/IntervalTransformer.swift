//
//  IntervalTransformer.swift
//  Maxxxro-S
//
//  Created by Joel on 6/2/14.
//  Copyright (c) 2014 Joel. All rights reserved.
//

import Cocoa
import Foundation

class IntervalTransformer: NSValueTransformer {
    var delegate: AppDelegate
    
    init(delegate: AppDelegate) {
        self.delegate = delegate
        super.init()
    }
    
    override func transformedValue(value: AnyObject!) -> AnyObject! {
        let str = NSMutableAttributedString(string: "\(value.integerValue) ms between kicks")
        let shadow = NSShadow()
        shadow.shadowBlurRadius = 1
        shadow.shadowOffset = NSMakeSize(0, -1)
        str.addAttribute(NSShadowAttributeName, value: shadow, range: NSMakeRange(0, str.length))
        delegate.updateInterval(value.integerValue)
        return str
    }
}