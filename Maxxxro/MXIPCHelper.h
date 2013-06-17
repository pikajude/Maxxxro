//
//  MXIPCHelper.h
//  Maxxxro
//
//  Created by Joel on 6/14/13.
//  Copyright (c) 2013 Joel. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MXIPCHelper : NSObject {
    const char *path, *popenPath;
    FILE *handle;
}

@property (nonatomic, assign) NSInteger interval;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) NSInteger macroKey;

- (MXIPCHelper *)initWithPath:(NSString *)path;

- (BOOL)launchHelper:(BOOL)asAdmin;
- (BOOL)checkAuth;
- (BOOL)authorize;
- (void)killHelper;
- (void)initialize;

@end
