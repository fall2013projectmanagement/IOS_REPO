//
//  LoginViewController.m
//  QRReader
//
//  Created by feifan meng on 10/26/13.
//  Copyright (c) 2013 mobi. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitLogin:(id)sender {
    
    //called the backend to gt the results
    //check in status code != 200
    //Sample valid request:
    //http://qraproject.appspot.com/hostlogin?username=fjohnson&password=johnson
    
    NSString *hostloginURL =
    [NSString stringWithFormat:@"http://qraproject.appspot.com/hostlogin?username=%@&password=%@", self.usernameTextField.text,self.passwordTextField.text
     ];
    NSLog(@"hostloginURL: %@", hostloginURL);
    
    NSURL *url = [NSURL URLWithString:hostloginURL];
    
    //Do a http get request to the url if successful go to the scanning screene
    //much simple, one line, wow
    
    NSString *jsonDataString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error: nil];
    
    //Compare with this string
    //not the best solution, but very easy
    NSString *validResultString = @"{\"valid\": \"true\"}";
    NSLog(@"jsonDataString: %@", jsonDataString);
    
    if( [jsonDataString isEqualToString:validResultString]){
        
        //Write the plist file
        [self writeLoginInfoToPlistFile:self.usernameTextField.text];
        
        UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"You can now start scanning QR Codes." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [success show];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else{
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Invalid Login" message:@"Couldn't find Username and Password" delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil];
        [error show];
    }
}

- (void)writeLoginInfoToPlistFile:(NSString *)username{
    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory ,NSUserDomainMask, YES);
    NSString *documentsDirectory = [sysPaths objectAtIndex:0];
    NSString *filePath =  [documentsDirectory stringByAppendingPathComponent:@"login_cred.plist"];
    
    NSLog(@"Login plist File Path: %@", filePath);
    
    NSMutableDictionary *plistDict = plistDict = [[NSMutableDictionary alloc] init]; // needs to be mutable
    
    NSDateFormatter *currentTime = [[NSDateFormatter alloc] init];
    [currentTime setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString =
    [currentTime stringFromDate:[NSDate date]];
    
    NSLog(@"timestamp logged as: %@", dateString);
    
    [plistDict setValue:username forKey:@"username"];
    [plistDict setValue:dateString forKey:@"last_login"];
    
    BOOL didWriteToFile = [plistDict writeToFile:filePath atomically:YES];
    
    if (didWriteToFile) {
        NSLog(@"login Wrote to file.");
        NSLog(@"plist: %@", [plistDict description]);
        
        LoginDataSingleton *myLoginData = [LoginDataSingleton sharedManager];
        myLoginData.username = username;
    } else {
        NSLog(@"Error login failed to write to file");
    }
}
@end
