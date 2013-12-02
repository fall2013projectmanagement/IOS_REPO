//
//  LoginViewController.h
//  QRReader
//
//  Created by feifan meng on 10/26/13.
//  Copyright (c) 2013 mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginDataSingleton.h"

@interface LoginViewController : UITableViewController

- (IBAction)submitLogin:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end
