//
//  MXKeyButton.m
//  Maxxxro
//
//  Created by Joel on 6/13/13.
//  Copyright (c) 2013 Joel. All rights reserved.
//

#import "MXKeyButton.h"

@implementation MXKeyButton

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}

- (void)resetCursorRects
{
    NSRect b = [self bounds];
    b.size.width -= 12;
    b.origin.x += 6;
    b.origin.y += 3;
    b.size.height -= 10;
    NSCursor *cursor = [NSCursor pointingHandCursor];
    [self addCursorRect:b cursor:cursor];
}

@end
