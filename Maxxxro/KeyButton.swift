//
//  KeyButton.swift
//  Maxxxro-S
//
//  Created by Joel on 6/2/14.
//  Copyright (c) 2014 Joel. All rights reserved.
//

import Cocoa
import Foundation

class KeyButton: NSButton {
    init(coder: NSCoder!) {
        super.init(coder: coder)
    }
    
    override func resetCursorRects() {
        var b = self.bounds
        b.size.width -= 12
        b.origin.x += 6
        b.origin.y += 3
        b.size.height -= 10
        self.addCursorRect(b, cursor: NSCursor.pointingHandCursor())
    }
}