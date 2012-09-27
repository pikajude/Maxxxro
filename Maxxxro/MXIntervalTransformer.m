//
//  MXIntervalTransformer.m
//  Maxxxro
//
//  Created by Joel on 9/26/12.
//  Copyright (c) 2012 Joel. All rights reserved.
//

#import "MXIntervalTransformer.h"

@implementation MXIntervalTransformer

- (id)transformedValue:(id)value
{
    return [NSString stringWithFormat:@"%ld ms between kicks", [value integerValue]];
}

@end
