//
//  MXKeyButtonCell.m
//  Maxxxro
//
//  Created by Joel on 6/13/13.
//  Copyright (c) 2013 Joel. All rights reserved.
//

#define COLOR(x,y,z) [NSColor colorWithDeviceRed:(x)/255.f green:(y)/255.f blue:(z)/255.f alpha:1.f]
#define GRAY(x) COLOR(x,x,x)

#import "MXKeyButtonCell.h"

@implementation MXKeyButtonCell

- (NSInteger)showsStateBy
{
    return NSContentsCellMask;
}

- (void)drawBezelWithFrame:(NSRect)frame inView:(NSView *)controlView
{
    NSArray *borderColors, *buttonColors;
    NSInteger st = ([self isHighlighted] << 1) + [self state];
    switch (st) {
        case 0:
            borderColors = @[GRAY(82.f), GRAY(150.f)];
            buttonColors = @[GRAY(82.f), GRAY(104.f)];
            break;
            
        case 1:
            borderColors = @[COLOR(98.f, 138.f, 82.f), COLOR(188.f, 228.f, 172.f)];
            buttonColors = @[COLOR(98.f, 138.f, 82.f), COLOR(138.f, 178.f, 122.f)];
            break;
            
        case 2:
            borderColors = @[GRAY(104.f), GRAY(104.f)];
            buttonColors = @[GRAY(104.f), GRAY(82.f)];
            break;
            
        case 3:
            borderColors = @[COLOR(138.f, 178.f, 122.f), COLOR(138.f, 178.f, 122.f)];
            buttonColors = @[COLOR(138.f, 178.f, 122.f), COLOR(98.f, 138.f, 82.f)];
            break;
    }
    
    NSGraphicsContext *ctx = [NSGraphicsContext currentContext];
    [ctx saveGraphicsState];
    
    NSRect outerRect = NSMakeRect(frame.origin.x + 6, frame.origin.y + 4, frame.size.width - 12, frame.size.height - 11);
    NSBezierPath *outerPath = [NSBezierPath bezierPathWithRoundedRect:outerRect xRadius:4.f yRadius:4.f];
    
    NSShadow *dropShadow = [[[NSShadow alloc] init] autorelease];
    [dropShadow setShadowBlurRadius:1.5f];
    [dropShadow setShadowColor:[NSColor colorWithDeviceWhite:0.f alpha:0.5f]];
    [dropShadow setShadowOffset:NSMakeSize(0.f, -1.f)];
    [dropShadow set];
    
    [[NSBezierPath bezierPathWithRoundedRect:outerRect xRadius:4.5f yRadius:4.5f] fill];
    
    NSGradient *borderGradient = [[[NSGradient alloc] initWithColors:borderColors] autorelease];
    [borderGradient drawInBezierPath:outerPath angle:-90.f];
    
    NSRect innerRect = NSMakeRect(outerRect.origin.x + 0.5f, outerRect.origin.y + 0.5f, outerRect.size.width - 1, outerRect.size.height - 1);
    NSBezierPath *innerPath = [NSBezierPath bezierPathWithRoundedRect:innerRect xRadius:3.8f yRadius:3.8f];
    NSGradient *innerGradient = [[[NSGradient alloc] initWithColors:buttonColors] autorelease];
    [innerGradient drawInBezierPath:innerPath angle:-90.0f];
    
    [ctx restoreGraphicsState];
}

- (NSRect)drawTitle:(NSAttributedString *)title withFrame:(NSRect)frame inView:(NSView *)controlView
{
    NSMutableAttributedString *foo = [title mutableCopy];
    NSMutableParagraphStyle *m = [[[NSMutableParagraphStyle alloc] init] autorelease];
    [m setAlignment:NSCenterTextAlignment];
    [foo addAttribute:NSParagraphStyleAttributeName value:m range:NSMakeRange(0, [title length])];
    [foo addAttribute:NSForegroundColorAttributeName value:[NSColor whiteColor] range:NSMakeRange(0, [title length])];
    NSShadow *textShadow = [[[NSShadow alloc] init] autorelease];
    [textShadow setShadowBlurRadius:1.f];
    [textShadow setShadowOffset:NSMakeSize(0.f, -1.f)];
    [foo addAttribute:NSShadowAttributeName value:textShadow range:NSMakeRange(0, [title length])];
    frame.origin.y += 0.5f;
    [foo drawInRect:frame];
    return frame;
}

@end
