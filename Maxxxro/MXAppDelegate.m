//
//  MXAppDelegate.m
//  Maxxxro
//
//  Created by Joel on 9/26/12.
//  Copyright (c) 2012 Joel. All rights reserved.
//

#import "MXAppDelegate.h"

static CGEventRef keyDownCallback(CGEventTapProxy prox, CGEventType type, CGEventRef event, void *refcon) {
    if([[[(MXAppDelegate *)refcon butt] selectedItem] tag] == CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode)) {
        if(0 == CGEventGetIntegerValueField(event, kCGKeyboardEventAutorepeat))
            [(MXAppDelegate *)refcon startMacro];
        return NULL;
    } else
        return event;
}

static CGEventRef keyUpCallback(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon) {
    if([[[(MXAppDelegate *)refcon butt] selectedItem] tag] == CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode)) {
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
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"interval": @150, @"duration": @100, @"button": @8}];
    
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
    timer = [NSTimer scheduledTimerWithTimeInterval:([[[NSUserDefaults standardUserDefaults] objectForKey:@"interval"] floatValue] + [[[NSUserDefaults standardUserDefaults] objectForKey:@"duration"] floatValue]) / 1000 target:self selector:@selector(press) userInfo:nil repeats:YES];
    [timer fire];
}

- (void)stopMacro
{
    if(timer == nil) return;
    [self retain];
    [timer invalidate];
    timer = nil;
}

- (void)press
{
    CGEventPost(kCGHIDEventTap, _start);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, [[[NSUserDefaults standardUserDefaults] objectForKey:@"interval"] floatValue] * 1000000), dispatch_get_main_queue(), ^{
        CGEventPost(kCGHIDEventTap, _stop);
    });
}

@end
