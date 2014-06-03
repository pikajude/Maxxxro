//
//  DemoView.swift
//  Maxxxro-S
//
//  Created by Joel on 6/2/14.
//  Copyright (c) 2014 Joel. All rights reserved.
//

import Cocoa
import Foundation

let playerColor = NSColor(deviceRed: 0.8745, green: 0.3412, blue: 0.2549, alpha: 1)
let grassColor = NSColor(deviceRed: 0.4235, green: 0.5804, blue: 0.3608, alpha: 1)
let grassHighlight = NSColor(deviceRed: 138/255, green: 178/255, blue: 122/255, alpha: 1)

class DemoView: NSView {
    var hasDrawn: Bool
    var isKicking: Bool
    
    init(frame frameRect: NSRect) {
        self.hasDrawn = false
        self.isKicking = false
        super.init(frame: frameRect)
    }
    
    override func drawRect(dirtyRect: NSRect) {
        let rect = NSRect(x: dirtyRect.origin.x + 5, y: dirtyRect.origin.y + 4, width: dirtyRect.size.width - 10, height: dirtyRect.size.height - 4);
        let rounded = NSBezierPath(roundedRect: rect, xRadius: 3.0, yRadius: 3.0)
        
        let ctx = NSGraphicsContext.currentContext()
        ctx.saveGraphicsState()
        
        grassHighlight.set()
        rounded.fill()
        
        let slide = NSAffineTransform()
        slide.translateXBy(0, yBy: -1)
        
        let path = slide.transformBezierPath(rounded)
        
        let shadow = NSShadow()
        shadow.shadowBlurRadius = 2
        shadow.shadowOffset = NSSize(width: 0, height: -1)
        shadow.set()
        
        grassColor.set()
        path.fill()
        
        ctx.restoreGraphicsState()
        ctx.saveGraphicsState()
        
        let player = NSBezierPath(ovalInRect: NSMakeRect((dirtyRect.size.width / 2) - 14.5, (dirtyRect.size.height / 2) - 14.5, 29, 29))
        playerColor.set()
        player.fill()
        
        if self.isKicking {
            NSColor.whiteColor().setStroke()
        } else {
            NSColor.blackColor().setStroke()
        }
        player.lineWidth = 2
        player.stroke()
        
        let ring = NSBezierPath(ovalInRect: NSMakeRect((dirtyRect.size.width / 2) - 23, (dirtyRect.size.height / 2) - 23, 46, 46))
        NSColor(deviceWhite: 1, alpha: 0.3).setStroke()
        ring.lineWidth = 3
        ring.stroke()
        
        ctx.restoreGraphicsState()
        ctx.saveGraphicsState()
        
        let avatar = NSMutableAttributedString(string: "1")
        avatar.setAttributes(
            [NSFontAttributeName: NSFont(name: "Arial Bold", size: 19),
                NSForegroundColorAttributeName: NSColor.whiteColor()],
            range: NSRange(location: 0, length: avatar.length))
        avatar.drawAtPoint(NSMakePoint(dirtyRect.size.width / 2 - 5.5, dirtyRect.size.height / 2 - 11.5))
        
        ctx.restoreGraphicsState()
    }
}