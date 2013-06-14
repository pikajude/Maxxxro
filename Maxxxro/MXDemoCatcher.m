//
//  MXDemoCatcher.m
//  Maxxxro
//
//  Created by Joel on 6/12/13.
//  Copyright (c) 2013 Joel. All rights reserved.
//

#import "MXDemoCatcher.h"

@implementation MXDemoCatcher

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
}

- (void)flagsChanged:(NSEvent *)theEvent
{
    [self handleKeyEvent:theEvent];
}

- (void)keyDown:(NSEvent *)theEvent
{
    if(![theEvent isARepeat]) {
        [self handleKeyEvent:theEvent];
    }
}

- (void)keyUp:(NSEvent *)theEvent
{
    if(![theEvent isARepeat]) {
        [self handleKeyEvent:theEvent];
    }
}

- (void)handleKeyEvent:(NSEvent *)theEvent
{
    switch ([theEvent keyCode]) {
        case 7:
        case 49:
            if([theEvent type] == NSKeyDown)
                [self startKick];
            else
                [self stopKick];
            break;
            
        case 54:
        case 55:
            if([theEvent modifierFlags] & NSCommandKeyMask)
                [self startKick];
            else
                [self stopKick];
            break;
            
        case 56:
        case 60:
            if([theEvent modifierFlags] & NSShiftKeyMask)
                [self startKick];
            else
                [self stopKick];
            break;
            
        default:
            break;
    }
}

- (void)startKick
{
    [[self demoView] setIsKicking:YES];
    [[self demoView] setNeedsDisplay:YES];
}

- (void)stopKick
{
    [[self demoView] setIsKicking:NO];
    [[self demoView] setNeedsDisplay:YES];
}

@end