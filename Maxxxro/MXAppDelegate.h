//
//  MXAppDelegate.h
//  Maxxxro
//
//  Created by Joel on 9/26/12.
//  Copyright (c) 2012 Joel. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ApplicationServices/ApplicationServices.h>
#import "MXIntervalTransformer.h"
#import "MXDurationTransformer.h"

@interface MXAppDelegate : NSObject <NSApplicationDelegate> {
    CGEventRef _start;
    CGEventRef _stop;
    NSTimer *timer;
}

@property (assign) IBOutlet NSWindow *window;

@property (assign) IBOutlet NSTextField *interval;
@property (assign) IBOutlet NSTextField *duration;

@property (assign) IBOutlet NSButton *cButton;
@property (assign) IBOutlet NSButton *zButton;
@property (assign) IBOutlet NSButton *spaceButton;

@property (assign) NSInteger keyCode;

- (IBAction)pickKey:(id)sender;

- (void)updateKeyButtons:(NSInteger)keyCode;

- (void)startMacro;
- (void)stopMacro;

- (void)press;

@end
