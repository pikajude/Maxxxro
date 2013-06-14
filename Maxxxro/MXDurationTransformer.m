//
//  MXDurationTransformer.m
//  Maxxxro
//
//  Created by Joel on 9/26/12.
//  Copyright (c) 2012 Joel. All rights reserved.
//

#import "MXDurationTransformer.h"

@implementation MXDurationTransformer

- (id)transformedValue:(id)value
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Kicks last %ldms", [value integerValue]]];
    NSShadow *textShadow = [[[NSShadow alloc] init] autorelease];
    [textShadow setShadowBlurRadius:1.f];
    [textShadow setShadowOffset:NSMakeSize(0.f, -1.f)];
    [str addAttribute:NSShadowAttributeName value:textShadow range:NSMakeRange(0, [str length])];
    return str;
}

@end
