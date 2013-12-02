//
//  ViewController.h
//  QRReader
//
//  Created by feifan meng on 10/25/13.
//  Copyright (c) 2013 mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "AttendeeDetailsViewController.h"
#import "ZBarSDK.h"
#import "LoginDataSingleton.h"
#import "CheckInViewController.h"

@interface ViewController : UIViewController <ZBarReaderDelegate>

- (IBAction)startScanBtn:(id)sender;
- (IBAction)loginButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *loggedInAsLabel;

@end
