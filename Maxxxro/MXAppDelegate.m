//
//  MXAppDelegate.m
//  Maxxxro
//
//  Created by Joel on 9/26/12.
//  Copyright (c) 2012 Joel. All rights reserved.
//

#import "MXAppDelegate.h"

static CGEventRef keyDownCallback(CGEventTapProxy prox, CGEventType type, CGEventRef event, void *refcon) {
    if(8 == CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode)) {
        if(0 == CGEventGetIntegerValueField(event, kCGKeyboardEventAutorepeat))
            [(MXAppDelegate *)refcon startMacro];
        return NULL;
    } else
        return event;
}

static CGEventRef keyUpCallback(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon) {
    if(8 == CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode)) {
        if(0 == CGEventGetIntegerValueField(event, kCGKeyboardEventAutorepeat))
            [(MXAppDelegate *)refcon stopMacro];
        return NULL;
    } else
        return event;
}

@implementation MXAppDelegate

- (void)dealloc
{
    CFRelease(_start);
    CFRelease(_stop);
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _start = CGEventCreateKeyboardEvent(NULL, 7, YES);
    _stop = CGEventCreateKeyboardEvent(NULL, 7, NO);
    
    CFMachPortRef keyDownEventTap = CGEventTapCreate(kCGHIDEventTap, kCGHeadInsertEventTap,  kCGEventTapOptionDefault, CGEventMaskBit(kCGEventKeyDown), &keyDownCallback, self);
    CFRunLoopSourceRef keyDownRunLoopSourceRef = CFMachPortCreateRunLoopSource(NULL, keyDownEventTap, 0);
    CFRelease(keyDownEventTap);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), keyDownRunLoopSourceRef, kCFRunLoopDefaultMode);
    CFRelease(keyDownRunLoopSourceRef);
    
    CFMachPortRef keyUpEventTap = CGEventTapCreate(kCGHIDEventTap, kCGHeadInsertEventTap,  kCGEventTapOptionDefault, CGEventMaskBit(kCGEventKeyUp), &keyUpCallback, self);
    CFRunLoopSourceRef keyUpRunLoopSourceRef = CFMachPortCreateRunLoopSource(NULL, keyUpEventTap, 0);
    CFRelease(keyUpEventTap);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), keyUpRunLoopSourceRef, kCFRunLoopDefaultMode);
    CFRelease(keyUpRunLoopSourceRef);
    
    [_interval bind:@"value"
           toObject:[NSUserDefaultsController sharedUserDefaultsController]
        withKeyPath:@"values.interval"
            options:@{NSValueTransformerBindingOption: [[[MXIntervalTransformer alloc] init] autorelease], NSContinuouslyUpdatesValueBindingOption: @YES}];
    
    [_duration bind:@"value"
           toObject:[NSUserDefaultsController sharedUserDefaultsController]
        withKeyPath:@"values.duration"
            options:@{NSValueTransformerBindingOption: [[[MXDurationTransformer alloc] init] autorelease], NSContinuouslyUpdatesValueBindingOption: @YES}];
}

- (void)startMacro
{
    timer = [NSTimer scheduledTimerWithTimeInterval:[[[NSUserDefaults standardUserDefaults] objectForKey:@"interval"] floatValue] / 1000 target:self selector:@selector(press) userInfo:nil repeats:YES];
}

- (void)stopMacro
{
    [self retain];
    [timer invalidate];
}

- (void)press
{
    CGEventPost(kCGHIDEventTap, _start);
    [NSThread sleepForTimeInterval:[[[NSUserDefaults standardUserDefaults] objectForKey:@"duration"] floatValue] / 1000];
    CGEventPost(kCGHIDEventTap, _stop);
}

@end
