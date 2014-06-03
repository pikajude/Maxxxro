//
//  ButtonPusher.h
//  Maxxxro-S
//
//  Created by Joel on 6/2/14.
//  Copyright (c) 2014 Joel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ApplicationServices/ApplicationServices.h>

@interface ButtonPusher : NSObject {
    CGEventRef _start;
    CGEventRef _stop;
}

@property (assign) id delegate;
@property (assign) NSInteger keyCode;

- (id)initWithDelegate:(id)delegate keyCode:(NSInteger)keyCode;
- (void)press;

@end
