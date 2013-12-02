//
//  LoginDataSingleton.m
//  QRReader
//
//  Created by feifan meng on 10/27/13.
//  Copyright (c) 2013 mobi. All rights reserved.
//

#import "LoginDataSingleton.h"

@implementation LoginDataSingleton

+ (id)sharedManager {
    static LoginDataSingleton *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        self.username = nil;
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end
