//
//  MXAppDelegate.m
//  Maxxxro
//
//  Created by Joel on 9/26/12.
//  Copyright (c) 2012 Joel. All rights reserved.
//

#import "MXAppDelegate.h"

static CGEventRef keyDownCallback(CGEventTapProxy prox, CGEventType type, CGEventRef event, void *refcon) {
    if(((MXAppDelegate *)refcon).keyCode == CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode)) {
        if(0 == CGEventGetIntegerValueField(event, kCGKeyboardEventAutorepeat))
            [(MXAppDelegate *)refcon startMacro];
        return NULL;
    } else
        return event;
}

static CGEventRef keyUpCallback(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon) {
    if(((MXAppDelegate *)refcon).keyCode == CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode)) {
        if(0 == CGEventGetIntegerValueField(event, kCGKeyboardEventAutorepeat))
            [(MXAppDelegate *)refcon stopMacro];
        return NULL;
    } else
        return event;
}

void exceptionHandler(int a) {
    for(id app in [[NSWorkspace sharedWorkspace] runningApplications]) {
        if ([[[app executableURL] lastPathComponent] isEqualToString:@"MaxxxroHelper"]) {
            [app forceTerminate];
        }
    }
}

void exceptionHandler2(NSException *e) {
    exceptionHandler(0);
}

@implementation MXAppDelegate

- (IBAction)pickKey:(id)sender
{
    [self updateKeyButtons:[sender tag]];
}

- (void)updateKeyButtons:(NSInteger)keyCode
{
    self.zButton.state = keyCode == 6;
    self.cButton.state = keyCode == 8;
    self.spaceButton.state = keyCode == 49;
    
    [[NSUserDefaults standardUserDefaults] setInteger:keyCode forKey:@"macroKey"];
    self.keyCode = keyCode;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    signal(SIGABRT, &exceptionHandler);
    signal(SIGILL, &exceptionHandler);
    signal(SIGPIPE, &exceptionHandler);
    signal(SIGSEGV, &exceptionHandler);
    signal(SIGFPE, &exceptionHandler);
    signal(SIGBUS, &exceptionHandler);
    NSSetUncaughtExceptionHandler(&exceptionHandler2);
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"interval": @150, @"duration": @100, @"macroKey": @8}];
    
    [self updateKeyButtons:[[[NSUserDefaults standardUserDefaults] objectForKey:@"macroKey"] integerValue]];
    
    MXIntervalTransformer *intTrans = [[[MXIntervalTransformer alloc] init] autorelease];
    MXDurationTransformer *durTrans = [[[MXDurationTransformer alloc] init] autorelease];
    intTrans.delegate = self;
    durTrans.delegate = self;
    
    [_interval bind:@"value"
           toObject:[NSUserDefaultsController sharedUserDefaultsController]
        withKeyPath:@"values.interval"
            options:@{NSValueTransformerBindingOption: intTrans, NSContinuouslyUpdatesValueBindingOption: @NO}];
    
    [_duration bind:@"value"
           toObject:[NSUserDefaultsController sharedUserDefaultsController]
        withKeyPath:@"values.duration"
            options:@{NSValueTransformerBindingOption: durTrans, NSContinuouslyUpdatesValueBindingOption: @NO}];
    
    [self acquirePrivileges];
    [self registerEvents];
}

- (void)acquirePrivileges
{
    NSDictionary *privOptions = @{(id)kAXTrustedCheckOptionPrompt : @YES};
    BOOL accessEnabled = AXIsProcessTrustedWithOptions((CFDictionaryRef)privOptions);
    if(!accessEnabled) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Hi" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Once you have enabled Maxxxro in System Preferences, click OK."];
        [alert beginSheetModalForWindow:self.window completionHandler:^(NSModalResponse code) {
            if(!AXIsProcessTrustedWithOptions((CFDictionaryRef)privOptions)) {
                [NSApp terminate:self];
            }
        }];
    }
}

- (void)registerEvents
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

- (void)updateDuration:(NSInteger)d
{
    NSLog(@"duration: %ld", (long)d);
}

- (void)updateInterval:(NSInteger)i
{
    NSLog(@"interval: %ld", (long)i);
}

- (void)press
{
    CGEventPost(kCGHIDEventTap, _start);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, [[[NSUserDefaults standardUserDefaults] objectForKey:@"interval"] floatValue] * 1000000), dispatch_get_main_queue(), ^{
        CGEventPost(kCGHIDEventTap, _stop);
    });
}

- (void)freakOut
{
    [NSApp terminate:nil];
}

@end
