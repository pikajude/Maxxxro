//
//  ButtonPusher.swift
//  Maxxxro
//
//  Created by Joel on 6/23/14.
//  Copyright (c) 2014 Joel. All rights reserved.
//

import Foundation

class ButtonPusher {
    var delegate: AppDelegate
    var keyCode: Int
    var _start: CGEventRef
    var _stop: CGEventRef
    
    init(delegate: AppDelegate, keyCode: Int) {
        self.delegate = delegate
        self.keyCode = keyCode
        
        self._start = CGEventCreateKeyboardEvent(nil, 7, true).takeRetainedValue()
        self._stop = CGEventCreateKeyboardEvent(nil, 7, false).takeRetainedValue()
        
        let keyDownEventTap = eventTapCreate(CGEventTapLocation(kCGHIDEventTap), CGEventTapPlacement(kCGHeadInsertEventTap), CGEventTapOptions(kCGEventTapOptionDefault), CGEventMask(1 << kCGEventKeyDown), { proxy, type, event, _ in
            if self.keyCode == Int(CGEventGetIntegerValueField(event, CGEventField(kCGKeyboardEventKeycode))) {
                if CGEventGetIntegerValueField(event, CGEventField(kCGKeyboardEventAutorepeat)) == 0 {
                    self.delegate.startMacro()
                }
                return nil
            } else {
                return Unmanaged(_private: event)
            }
        }, nil).takeRetainedValue()
        let keyDownRunLoopSourceRef = CFMachPortCreateRunLoopSource(nil, keyDownEventTap, CFIndex(0))
        CFRelease(keyDownEventTap)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), keyDownRunLoopSourceRef, kCFRunLoopDefaultMode)
        CFRelease(keyDownRunLoopSourceRef)
        
        let keyUpEventTap = eventTapCreate2(CGEventTapLocation(kCGHIDEventTap), CGEventTapPlacement(kCGHeadInsertEventTap), CGEventTapOptions(kCGEventTapOptionDefault), CGEventMask(1 << kCGEventKeyUp), { proxy, type, event, _ in
            if self.keyCode == Int(CGEventGetIntegerValueField(event, CGEventField(kCGKeyboardEventKeycode))) {
                if CGEventGetIntegerValueField(event, CGEventField(kCGKeyboardEventAutorepeat)) == 0 {
                    self.delegate.stopMacro()
                }
                return nil
            } else {
                return Unmanaged(_private: event)
            }
            }, nil).takeRetainedValue()
        let keyUpRunLoopSourceRef = CFMachPortCreateRunLoopSource(nil, keyUpEventTap, CFIndex(0))
        CFRelease(keyUpEventTap)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), keyUpRunLoopSourceRef, kCFRunLoopDefaultMode)
        CFRelease(keyUpRunLoopSourceRef)
    }
    
    @objc func press() {
        CGEventPost(CGEventTapLocation(kCGHIDEventTap), self._start)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(NSUserDefaults.standardUserDefaults().objectForKey("duration").floatValue * 1000000)), dispatch_get_main_queue(), {
            CGEventPost(CGEventTapLocation(kCGHIDEventTap), self._stop)
        })
    }
}