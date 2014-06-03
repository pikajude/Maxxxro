//
//  DurationTransformer.swift
//  Maxxxro-S
//
//  Created by Joel on 6/2/14.
//  Copyright (c) 2014 Joel. All rights reserved.
//

import Cocoa
import Foundation

class DurationTransformer: NSValueTransformer {
    var delegate: AppDelegate
    
    init(delegate: AppDelegate) {
        self.delegate = delegate;
        super.init()
    }
    
    override func transformedValue(value: AnyObject!) -> AnyObject! {
        let str = NSMutableAttributedString(string: "Kicks last \(value.integerValue)ms")
        let textShadow = NSShadow()
        textShadow.shadowBlurRadius = 1
        textShadow.shadowOffset = NSMakeSize(0, -1)
        str.addAttribute(
            NSShadowAttributeName,
            value: textShadow,
            range: NSMakeRange(0, str.length))
        self.delegate.updateDuration(value.integerValue)
        return str
    }
}