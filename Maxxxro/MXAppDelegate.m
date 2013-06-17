//
//  MXAppDelegate.m
//  Maxxxro
//
//  Created by Joel on 9/26/12.
//  Copyright (c) 2012 Joel. All rights reserved.
//

#import "MXAppDelegate.h"

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

- (void)applicationWillTerminate:(NSNotification *)notification
{
    [helper killHelper];
}

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
    
    helper.macroKey = keyCode;
}

- (void)launchHelper
{
    helper = [[MXIPCHelper alloc] initWithPath:[[NSBundle mainBundle] pathForResource:@"MaxxxroHelper" ofType:@""]];
    [helper launchHelper:NO];
    if(![helper checkAuth]) {
        [helper killHelper];
        if(![helper launchHelper:YES]) {
            NSLog(@"Not given permission");
            [self freakOut];
            return;
        } else {
            [helper authorize];
            [helper killHelper];
            [helper launchHelper:NO];
            if(![helper checkAuth]) {
                NSLog(@"MakeProcessTrusted failed");
                [self freakOut];
                return;
            }
        }
    }
    
    [helper initialize];
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
    
    [self launchHelper];
    
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
}

- (void)updateInterval:(NSInteger)i
{
    helper.interval = i;
}

- (void)updateDuration:(NSInteger)d
{
    helper.duration = d;
}

- (void)freakOut
{
    [NSApp terminate:nil];
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

@end
