//
//  KeyButtonCell.swift
//  Maxxxro-S
//
//  Created by Joel on 6/2/14.
//  Copyright (c) 2014 Joel. All rights reserved.
//

import Cocoa
import Foundation

func gray(c: CGFloat) -> NSColor {
    return NSColor(deviceWhite: c/255, alpha: 1)
}

func color(a: CGFloat, b: CGFloat, c: CGFloat) -> NSColor {
    return NSColor(deviceRed: a/255, green: b/255, blue: c/255, alpha: 1)
}

class KeyButtonCell: NSButtonCell {
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        self.showsStateBy = NSCellStyleMask.ContentsCellMask
    }
    
    override func drawBezelWithFrame(frame: NSRect, inView controlView: NSView!) {
        var borderColors = []
        var buttonColors = []
        
        if self.highlighted {
            if self.state === NSOffState {
                borderColors = [gray(104), gray(104)]
                buttonColors = [gray(104), gray(82)]
            } else {
                borderColors = [color(138, 178, 122), color(138, 178, 122)]
                buttonColors = [color(138, 178, 122), color(98, 138, 82)]
            }
        } else {
            if self.state === NSOffState {
                borderColors = [gray(82), gray(150)]
                buttonColors = [gray(82), gray(104)]
            } else {
                borderColors = [color(98, 138, 82), color(188, 228, 172)]
                buttonColors = [color(98, 138, 82), color(138, 178, 122)]
            }
        }
        
        let ctx = NSGraphicsContext.currentContext()
        ctx.saveGraphicsState()
        
        let outerRect = NSMakeRect(frame.origin.x + 6, frame.origin.y + 4, frame.size.width - 12, frame.size.height - 11)
        let outerPath = NSBezierPath(roundedRect: outerRect, xRadius: 4, yRadius: 4)
        
        let dropShadow = NSShadow()
        dropShadow.shadowBlurRadius = 1.5
        dropShadow.shadowColor = NSColor(deviceWhite: 0, alpha: 0.5)
        dropShadow.shadowOffset = NSSize(width: 0, height: -1)
        dropShadow.set()
        
        NSBezierPath(roundedRect: outerRect, xRadius: 4.5, yRadius: 4.5).fill()
        
        let borderGradient = NSGradient(colors: borderColors)
        borderGradient.drawInBezierPath(outerPath, angle: -90)
        
        let innerRect = NSMakeRect(outerRect.origin.x + 0.5, outerRect.origin.y + 0.5, outerRect.size.width - 1, outerRect.size.height - 1)
        let innerPath = NSBezierPath(roundedRect: innerRect, xRadius: 3.8, yRadius: 3.8)
        let innerGradient = NSGradient(colors: buttonColors)
        innerGradient.drawInBezierPath(innerPath, angle: -90)
        
        ctx.restoreGraphicsState()
    }
    
    override func drawTitle(title: NSAttributedString!, withFrame frame: NSRect, inView controlView: NSView!) -> NSRect {
        let foo = title.mutableCopy() as NSMutableAttributedString
        let m = NSMutableParagraphStyle()
        m.alignment = NSTextAlignment.CenterTextAlignment
        foo.addAttribute(NSParagraphStyleAttributeName, value: m, range: NSMakeRange(0, title.length))
        foo.addAttribute(NSForegroundColorAttributeName, value: NSColor.whiteColor(), range: NSMakeRange(0, title.length))
        let textShadow = NSShadow()
        textShadow.shadowBlurRadius = 1
        textShadow.shadowOffset = NSMakeSize(0, -1)
        foo.addAttribute(NSShadowAttributeName, value: textShadow, range: NSMakeRange(0, title.length))
        var newFrame = NSRect(origin: CGPoint(x: frame.origin.x, y: frame.origin.y + 0.5), size: frame.size)
        foo.drawInRect(newFrame)
        return newFrame
    }
}