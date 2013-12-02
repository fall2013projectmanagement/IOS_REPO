//
//  LoginDataSingleton.h
//  QRReader
//
//  Created by feifan meng on 10/27/13.
//  Copyright (c) 2013 mobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginDataSingleton : NSObject{
    NSString *username;
}

@property(nonatomic, retain) NSString *username;

+ (id)sharedManager;

@end
