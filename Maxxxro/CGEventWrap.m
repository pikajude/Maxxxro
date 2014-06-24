//
//  CGEventWrap.m
//  Maxxxro
//
//  Created by Joel on 6/24/14.
//  Copyright (c) 2014 Joel. All rights reserved.
//

#import "CGEventWrap.h"

static bCallback ctx = NULL;
static bCallback ctx2 = NULL;

static CGEventRef callback(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon) {
    return ctx(proxy, type, event, refcon);
}

static CGEventRef callback2(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon) {
    return ctx2(proxy, type, event, refcon);
}

CFMachPortRef eventTapCreate(CGEventTapLocation tap, CGEventTapPlacement place, CGEventTapOptions opts, CGEventMask evs, bCallback blk, void *userInfo) {
    ctx = blk;
    CFMachPortRef ref = CGEventTapCreate(tap, place, opts, evs, &callback, userInfo);
    return ref;
}

CFMachPortRef eventTapCreate2(CGEventTapLocation tap, CGEventTapPlacement place, CGEventTapOptions opts, CGEventMask evs, bCallback blk, void *userInfo) {
    ctx2 = blk;
    CFMachPortRef ref = CGEventTapCreate(tap, place, opts, evs, &callback2, userInfo);
    return ref;
}