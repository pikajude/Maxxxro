//
//  ButtonPusher.m
//  Maxxxro-S
//
//  Created by Joel on 6/2/14.
//  Copyright (c) 2014 Joel. All rights reserved.
//

#import "ButtonPusher.h"

static CGEventRef keyDownCallback(CGEventTapProxy prox, CGEventType type, CGEventRef event, void *refcon) {
    if(((__bridge ButtonPusher *)refcon).keyCode == CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode)) {
        if(0 == CGEventGetIntegerValueField(event, kCGKeyboardEventAutorepeat))
            [[(__bridge ButtonPusher *)refcon delegate] performSelector:@selector(startMacro)];
        return NULL;
    } else
        return event;
}

static CGEventRef keyUpCallback(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon) {
    if(((__bridge ButtonPusher *)refcon).keyCode == CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode)) {
        if(0 == CGEventGetIntegerValueField(event, kCGKeyboardEventAutorepeat))
            [[(__bridge ButtonPusher *)refcon delegate] performSelector:@selector(stopMacro)];
        return NULL;
    } else
        return event;
}

@implementation ButtonPusher

- (id)initWithDelegate:(id)delegate keyCode:(NSInteger)keyCode
{
    self = [super init];
    
    self.delegate = delegate;
    self.keyCode = keyCode;
    
    _start = CGEventCreateKeyboardEvent(NULL, 7, YES);
    _stop = CGEventCreateKeyboardEvent(NULL, 7, NO);
    
    CFMachPortRef keyDownEventTap = CGEventTapCreate(kCGHIDEventTap, kCGHeadInsertEventTap,  kCGEventTapOptionDefault, CGEventMaskBit(kCGEventKeyDown), &keyDownCallback, (__bridge void *)self);
    CFRunLoopSourceRef keyDownRunLoopSourceRef = CFMachPortCreateRunLoopSource(NULL, keyDownEventTap, 0);
    CFRelease(keyDownEventTap);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), keyDownRunLoopSourceRef, kCFRunLoopDefaultMode);
    CFRelease(keyDownRunLoopSourceRef);
    
    CFMachPortRef keyUpEventTap = CGEventTapCreate(kCGHIDEventTap, kCGHeadInsertEventTap,  kCGEventTapOptionDefault, CGEventMaskBit(kCGEventKeyUp), &keyUpCallback, (__bridge void *)self);
    CFRunLoopSourceRef keyUpRunLoopSourceRef = CFMachPortCreateRunLoopSource(NULL, keyUpEventTap, 0);
    CFRelease(keyUpEventTap);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), keyUpRunLoopSourceRef, kCFRunLoopDefaultMode);
    CFRelease(keyUpRunLoopSourceRef);
    
    return self;
}

- (void)press
{
    CGEventPost(kCGHIDEventTap, _start);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, [[[NSUserDefaults standardUserDefaults] objectForKey:@"duration"] floatValue] * 1000000), dispatch_get_main_queue(), ^{
        CGEventPost(kCGHIDEventTap, _stop);
    });
}

@end
