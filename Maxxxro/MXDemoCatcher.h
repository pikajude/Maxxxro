//
//  MXDemoCatcher.h
//  Maxxxro
//
//  Created by Joel on 6/12/13.
//  Copyright (c) 2013 Joel. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MXDemoView.h"

@interface MXDemoCatcher : NSView

@property (assign) IBOutlet MXDemoView *demoView;

- (void)startKick;
- (void)stopKick;

@end
