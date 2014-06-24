//
//  CGEventWrap.h
//  Maxxxro
//
//  Created by Joel on 6/24/14.
//  Copyright (c) 2014 Joel. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef CGEventRef (^bCallback)(CGEventTapProxy, CGEventType, CGEventRef, void*);

CFMachPortRef eventTapCreate(CGEventTapLocation tap, CGEventTapPlacement place, CGEventTapOptions opts, CGEventMask evs, bCallback blk, void *userInfo);
CFMachPortRef eventTapCreate2(CGEventTapLocation tap, CGEventTapPlacement place, CGEventTapOptions opts, CGEventMask evs, bCallback blk, void *userInfo);