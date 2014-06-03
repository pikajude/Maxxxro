//
//  DemoCatcher.swift
//  Maxxxro-S
//
//  Created by Joel on 6/2/14.
//  Copyright (c) 2014 Joel. All rights reserved.
//

import Cocoa
import Foundation

class DemoCatcher: NSView {
    @IBOutlet var demoView: DemoView
    
    func acceptsFirstResponder() -> Bool {
        return true;
    }
    
    override func flagsChanged(theEvent: NSEvent!)  {
        self.handleKeyEvent(theEvent)
    }
    
    func startKick() {
        self.demoView.isKicking = true
        self.demoView.needsDisplay = true
    }
    
    func stopKick() {
        self.demoView.isKicking = false
        self.demoView.needsDisplay = true
    }
    
    override func keyDown(theEvent: NSEvent!) {
        if !theEvent.ARepeat {
            self.handleKeyEvent(theEvent)
        }
    }
    
    override func keyUp(theEvent: NSEvent!) {
        if !theEvent.ARepeat {
            self.handleKeyEvent(theEvent)
        }
    }
    
    func handleKeyEvent(theEvent: NSEvent) {
        switch theEvent.keyCode {
        case 7, 49:
            if theEvent.type == NSEventType.KeyDown {
                self.startKick()
            } else {
                self.stopKick()
            }
            
        case 54, 55:
            if theEvent.modifierFlags & NSEventModifierFlags.CommandKeyMask {
                self.startKick()
            } else {
                self.stopKick()
            }
        
        case 56, 60:
            if theEvent.modifierFlags & NSEventModifierFlags.ShiftKeyMask {
                self.startKick()
            } else {
                self.stopKick()
            }
            
        default: return ()
        }
    }
}