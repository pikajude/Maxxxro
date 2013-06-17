//
//  MXIPCHelper.m
//  Maxxxro
//
//  Created by Joel on 6/14/13.
//  Copyright (c) 2013 Joel. All rights reserved.
//

#import "MXIPCHelper.h"

@implementation MXIPCHelper

- (MXIPCHelper *)initWithPath:(NSString *)p
{
    self = [super init];
    path = [p UTF8String];
    popenPath = [[NSString stringWithFormat:@"\"%@\"", p] UTF8String];
    return self;
}

- (BOOL)launchHelper:(BOOL)asAdmin
{
    if(asAdmin) {
        AuthorizationRef authorizationRef;
        OSStatus stat;
        stat = AuthorizationCreate(NULL, kAuthorizationEmptyEnvironment,
                                     kAuthorizationFlagDefaults, &authorizationRef);
        if(stat != errAuthorizationSuccess)
            return NO;
        
        AuthorizationItem right    = {kAuthorizationRightExecute, 0, NULL, 0};
        AuthorizationRights rights = {1, &right};
        AuthorizationFlags flags   = kAuthorizationFlagDefaults           |
                                     kAuthorizationFlagInteractionAllowed |
                                     kAuthorizationFlagPreAuthorize       |
                                     kAuthorizationFlagExtendRights;
        stat = AuthorizationCopyRights(authorizationRef, &rights, kAuthorizationEmptyEnvironment, flags, NULL);
        if(stat != errAuthorizationSuccess)
            return NO;
        
        AuthorizationExecuteWithPrivileges(authorizationRef, path, kAuthorizationFlagDefaults, NULL, &handle);
        setbuf(handle, NULL);
        return YES;
    } else {
        handle = popen(popenPath, "r+");
        setbuf(handle, NULL);
        return YES;
    }
}

- (BOOL)checkAuth
{
    assert(handle);
    fputc('?', handle);
    int authed = fgetc(handle);
    NSLog(@"%d\n", authed);
    return (BOOL)authed;
}

- (BOOL)authorize
{
    assert(handle);
    fputc('a', handle);
    fputc((int)strlen(path), handle);
    fwrite(path, strlen(path), 1, handle);
    int worked = fgetc(handle);
    return worked == kAXErrorSuccess;
}

- (void)initialize
{
    assert(handle);
    NSLog(@"initializing");
    self.interval = [[[NSUserDefaults standardUserDefaults] objectForKey:@"interval"] integerValue];
    self.duration = [[[NSUserDefaults standardUserDefaults] objectForKey:@"duration"] integerValue];
    self.macroKey = [[[NSUserDefaults standardUserDefaults] objectForKey:@"macroKey"] integerValue];
    fputc('!', handle);
}

- (NSInteger)duration
{
    assert(false);
}

- (NSInteger)interval
{
    assert(false);
}

- (NSInteger)macroKey
{
    assert(false);
}

- (void)setInterval:(NSInteger)i
{
    assert(handle);
    fputc('i', handle);
    fputc((int)i, handle);
}

- (void)setDuration:(NSInteger)d
{
    assert(handle);
    fputc('d', handle);
    fputc((int)d, handle);
}

- (void)setMacroKey:(NSInteger)key
{
    assert(handle);
    fputc('m', handle);
    fputc((int)key, handle);
}

- (void)killHelper
{
    if(!handle) return;
    fputc('k', handle);
    pclose(handle);
    handle = NULL;
}

@end
