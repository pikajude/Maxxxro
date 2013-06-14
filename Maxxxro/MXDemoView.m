//
//  MXDemoView.m
//  Maxxxro
//
//  Created by Joel on 6/12/13.
//  Copyright (c) 2013 Joel. All rights reserved.
//

#import "MXDemoView.h"

@implementation MXDemoView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (BOOL)isOpaque
{
    return NO;
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSRect rect = NSMakeRect(dirtyRect.origin.x + 5, dirtyRect.origin.y + 4, dirtyRect.size.width - 10, dirtyRect.size.height - 4);
    NSBezierPath *rounded = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:3.0 yRadius:3.0];
    
    NSGraphicsContext *ctx = [NSGraphicsContext currentContext];
    [ctx saveGraphicsState];
    
    [[NSColor colorWithDeviceRed:138.f/255.f green:178.f/255.f blue:122.f/255.f alpha:1.0f] set];
    [rounded fill];
    
    NSAffineTransform *tr = [NSAffineTransform transform];
    [tr translateXBy:0.0f yBy:-1.0f];
    
    NSBezierPath *path = [tr transformBezierPath:rounded];
    
    NSShadow *shad = [[[NSShadow alloc] init] autorelease];
    [shad setShadowBlurRadius:2.0f];
    [shad setShadowOffset:NSMakeSize(0.0f, -1.0f)];
    [shad set];
    
    [[NSColor colorWithDeviceRed:108.f/255.f green:148.f/255.f blue:92.f/255.f alpha:1.0f] set];
    [path fill];
    
    [ctx restoreGraphicsState];
    
    [ctx saveGraphicsState];
    
    NSBezierPath *player = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect((dirtyRect.size.width / 2) - 14.5, (dirtyRect.size.height / 2) - 14.5, 29, 29)];
    [[NSColor colorWithDeviceRed:223.f/255.f green:87.f/255.f blue:65.f/255.f alpha:1.0f] set];
    [player fill];
    
    if([self isKicking])
        [[NSColor whiteColor] setStroke];
    else
        [[NSColor blackColor] setStroke];
    [player setLineWidth:2.0f];
    [player stroke];
    
    NSBezierPath *ring = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect((dirtyRect.size.width / 2) - 23, (dirtyRect.size.height / 2) - 23, 46, 46)];
    [[NSColor colorWithDeviceWhite:1.0f alpha:0.3f] setStroke];
    [ring setLineWidth:3.0f];
    [ring stroke];
    
    [ctx restoreGraphicsState];
    
    [ctx saveGraphicsState];
    
    NSMutableAttributedString *avatar = [[[NSMutableAttributedString alloc] initWithString:@"1"] autorelease];
    [avatar setAttributes:@{NSFontAttributeName: [NSFont fontWithName:@"Arial Bold" size:19.0f],
                            NSForegroundColorAttributeName: [NSColor whiteColor]}
                    range:NSMakeRange(0, [avatar length])];
    [avatar drawAtPoint:NSMakePoint(dirtyRect.size.width / 2 - 5.5, dirtyRect.size.height / 2 - 11.5)];
    
    [ctx restoreGraphicsState];
}

@end
