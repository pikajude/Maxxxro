//
//  main.c
//  MaxxxroHelper
//
//  Created by Joel on 6/14/13.
//  Copyright (c) 2013 Joel. All rights reserved.
//

#include <ApplicationServices/ApplicationServices.h>
#include <CoreServices/CoreServices.h>
#include <Security/Security.h>
#include <stdio.h>
#include <pthread.h>

static int macroKey = -1;
static int previousMacroKey = -1;
static int interval = -1;
static int duration = -1;
static CGEventRef _start;
static CGEventRef _stop;

static void startMacro(void);
static pthread_t t;

static CGEventRef keyDownCallback(CGEventTapProxy prox, CGEventType type, CGEventRef event, void *refcon) {
    if(macroKey == CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode)) {
        if(0 == CGEventGetIntegerValueField(event, kCGKeyboardEventAutorepeat)) {
            previousMacroKey = macroKey;
            CGEventRef *data = calloc(4, sizeof(CGEventRef));
            data[0] = (CGEventRef)interval;
            data[1] = (CGEventRef)duration;
            data[2] = _start;
            data[3] = _stop;
            pthread_create(&t, NULL, (void *(*)(void *))&startMacro, NULL);
        }
        return NULL;
    } else
        return event;
}

static CGEventRef keyUpCallback(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon) {
    if(previousMacroKey == CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode)) {
        if(0 == CGEventGetIntegerValueField(event, kCGKeyboardEventAutorepeat)) {
            pthread_cancel(t);
            CGEventPost(kCGHIDEventTap, _stop);
        }
        return NULL;
    } else
        return event;
}

static void startMacro(void) {
    if(interval == -1) return;
    do {
        CGEventPost(kCGHIDEventTap, _start);
        usleep(duration * 1000);
        CGEventPost(kCGHIDEventTap, _stop);
        usleep(interval * 1000);
    } while(true);
}

static void runSetup(void) {
    _start = CGEventCreateKeyboardEvent(NULL, 7, true);
    _stop = CGEventCreateKeyboardEvent(NULL, 7, false);
    
    CFMachPortRef keyDownEventTap = CGEventTapCreate(kCGHIDEventTap, kCGHeadInsertEventTap,  kCGEventTapOptionDefault, CGEventMaskBit(kCGEventKeyDown), &keyDownCallback, NULL);
    CFRunLoopSourceRef keyDownRunLoopSourceRef = CFMachPortCreateRunLoopSource(NULL, keyDownEventTap, 0);
    CFRelease(keyDownEventTap);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), keyDownRunLoopSourceRef, kCFRunLoopDefaultMode);
    CFRelease(keyDownRunLoopSourceRef);
    
    CFMachPortRef keyUpEventTap = CGEventTapCreate(kCGHIDEventTap, kCGHeadInsertEventTap,  kCGEventTapOptionDefault, CGEventMaskBit(kCGEventKeyUp), &keyUpCallback, NULL);
    CFRunLoopSourceRef keyUpRunLoopSourceRef = CFMachPortCreateRunLoopSource(NULL, keyUpEventTap, 0);
    CFRelease(keyUpEventTap);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), keyUpRunLoopSourceRef, kCFRunLoopDefaultMode);
    CFRelease(keyUpRunLoopSourceRef);
    
    CFRunLoopRun();
}

const char *getString(FILE *h) {
    int len = fgetc(h);
    char *str = calloc(1, sizeof(char) * (len+1));
    fgets(str, len + 1, h);
    return str;
}

int main(int argc, const char * argv[])
{
    setbuf(stdout, NULL);
    char c;
    while((c = fgetc(stdin)) != EOF) {
        switch (c) {
            case '?': {
                bool isAuthed = AXAPIEnabled() || AXIsProcessTrusted();
                fputc(isAuthed, stdout);
                fprintf(stderr, "return from ?\n");
                break;
            }
                
            case 'a': {
                const char *path = getString(stdin);
                CFStringRef r = CFStringCreateWithCString(kCFAllocatorDefault, path, CFStringGetSystemEncoding());
                AXError a = AXMakeProcessTrusted(r);
                fputc(a, stdout);
                CFRelease(r);
                break;
            }
                
            case 'k': {
                exit(0);
                break;
            }
                
            case 'm': {
                macroKey = fgetc(stdin);
                break;
            }
                
            case 'i': {
                interval = fgetc(stdin);
                break;
            }
                
            case 'd': {
                duration = fgetc(stdin);
                break;
            }
                
            case '!': {
                pthread_t _;
                pthread_create(&_, NULL, (void *(*)(void *))&runSetup, NULL); // macro key set up by now
                break;
            }
        }
    }
}