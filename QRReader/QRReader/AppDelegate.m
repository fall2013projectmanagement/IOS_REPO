//
//  AppDelegate.m
//  QRReader
//
//  Created by feifan meng on 10/25/13.
//  Copyright (c) 2013 mobi. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
  
    //open the plist file check the last_login filed is not greater than 1 week then create the singleton
    [self checkIfPlistFileExists];
    return YES;
}

- (void) checkIfPlistFileExists{
    
    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory ,NSUserDomainMask, YES);
    NSString *documentsDirectory = [sysPaths objectAtIndex:0];
    NSString *filePath =  [documentsDirectory stringByAppendingPathComponent:@"login_cred.plist"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        
        NSString *username = [plistDict objectForKey:@"username"];
        NSString *dateString = [plistDict objectForKey:@"last_login"];
        
        NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *lastLoginDate = [formatter dateFromString:dateString];
        
        NSString *currentTimestampStr = [formatter stringFromDate: [NSDate date]];
        NSDate *currentTimestamp = [formatter dateFromString:currentTimestampStr];
        
        if([currentTimestamp timeIntervalSinceDate:lastLoginDate] > 60*60*24*7){
            
            NSLog(@"1 week has passed since the user logged in");
            //This will set the username to nil default
            LoginDataSingleton *myLoginData = [[LoginDataSingleton sharedManager] init];
            NSLog(@"username is nil: %@", myLoginData.username);
        }
        else{
            
            NSLog(@"login still valid. Initializing username as: %@", username);
            
            //Log in is still valid
            LoginDataSingleton *myLoginData = [[LoginDataSingleton sharedManager] init];
            myLoginData.username = username;
            
        }
    }
    else{
        
        //This will set the username to nil default
        LoginDataSingleton *myLoginData = [[LoginDataSingleton sharedManager] init];
        NSLog(@"username is nil: %@", myLoginData.username);
        NSLog(@"login_cred.plist file doesn't exit");
    }
    
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
