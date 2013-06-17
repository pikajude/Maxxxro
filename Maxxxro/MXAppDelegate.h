//
//  MXAppDelegate.h
//  Maxxxro
//
//  Created by Joel on 9/26/12.
//  Copyright (c) 2012 Joel. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ApplicationServices/ApplicationServices.h>
#import <ServiceManagement/ServiceManagement.h>
#import <Security/Security.h>
#import "MXIntervalTransformer.h"
#import "MXDurationTransformer.h"
#import "MXIPCHelper.h"

@interface MXAppDelegate : NSObject <NSApplicationDelegate> {
    NSTimer *timer;
    MXIPCHelper *helper;
}

@property (assign) IBOutlet NSWindow *window;

@property (assign) IBOutlet NSTextField *interval;
@property (assign) IBOutlet NSTextField *duration;

@property (assign) IBOutlet NSButton *cButton;
@property (assign) IBOutlet NSButton *zButton;
@property (assign) IBOutlet NSButton *spaceButton;

@property (assign) NSInteger keyCode;

- (IBAction)pickKey:(id)sender;

- (void)updateInterval:(NSInteger)i;
- (void)updateDuration:(NSInteger)d;

- (void)updateKeyButtons:(NSInteger)keyCode;
- (void)freakOut;

- (void)startMacro;
- (void)stopMacro;

@end
