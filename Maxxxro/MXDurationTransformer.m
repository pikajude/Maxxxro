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
    return [NSString stringWithFormat:@"Kicks last %ldms", [value integerValue]];
}

@end
