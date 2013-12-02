//
//  ViewController.m
//  QRReader
//
//  Created by feifan meng on 10/25/13.
//  Copyright (c) 2013 mobi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController{
    NSString *myUsername;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"back from login");
    myUsername = [self checkIfUserLoggedIn];
    
    if(myUsername != nil){
        self.loggedInAsLabel.text = [[NSString alloc] initWithFormat:@"You are Logged in as: %@",myUsername];
    }
    else{
        self.loggedInAsLabel.text = @"You are not logged in.";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startScanBtn:(id)sender {
    
    //If the user is not logged in then go to the log in view
    if(myUsername == nil){
        LoginViewController *myLoginViewController
        = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        
        [self.navigationController pushViewController:myLoginViewController animated:YES];
    }
    else{
        //Start the Scanning Screen
        ZBarReaderViewController *codeReader = [ZBarReaderViewController new];
        codeReader.readerDelegate=self;
        codeReader.supportedOrientationsMask = ZBarOrientationMaskAll;
        
        ZBarImageScanner *scanner = codeReader.scanner;
        [scanner setSymbology: ZBAR_I25 config: ZBAR_CFG_ENABLE to: 0];
        
        [self presentViewController:codeReader animated:YES completion:nil];
    }
    
}

- (IBAction)loginButton:(id)sender {
    NSString *logBtnText =[[self.loginBtnText titleLabel] text];
    //NSLog(@"text: %@", [[self.loginBtnText titleLabel] text]);
    //Logs the user in as someone different
    if([logBtnText isEqual: @"Login"]){
        LoginViewController *myLoginViewController
        = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        
        [self.navigationController pushViewController:myLoginViewController animated:YES];
    }else{
        NSLog(@"user logout");
        //Call the logUserOut function to log the user out
        [self logUserOut];
        [self.loginBtnText setTitle:@"Login" forState:UIControlStateNormal];
    }
}

- (void)logUserOut{
    //delete login_cred.plist
    //set the LoginDataSingleton to null
    LoginDataSingleton *myLoginData = [LoginDataSingleton sharedManager];
    
    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory ,NSUserDomainMask, YES);
    NSString *documentsDirectory = [sysPaths objectAtIndex:0];
    NSString *filePath =  [documentsDirectory stringByAppendingPathComponent:@"login_cred.plist"];
    
    NSError *error;
    if(![[NSFileManager defaultManager] removeItemAtPath:filePath error:&error])
    {
        NSLog(@"Couldn't delete the plist file");
        UIAlertView *loggedOutView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to logout." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [loggedOutView show];
        [self.navigationController popToRootViewControllerAnimated:YES];

    }else{
        NSLog(@"plist file deleted");
        UIAlertView *loggedOutView = [[UIAlertView alloc] initWithTitle:@"Logged out" message:@"You have been logged out." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [loggedOutView show];
        [self.navigationController popToRootViewControllerAnimated:YES];
        myLoginData.username = nil;
        myUsername = nil;
        self.loggedInAsLabel.text = @"You are not logged in.";
        [self.loginBtnText setTitle:@"Login" forState:UIControlStateNormal];
    }
    
}
- (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // just grab the first barcode
        break;
    
    // showing the result on textview
    //resultTextView.text = symbol.data;
    NSLog(@"QR Code Data: %@", symbol.data);
    
    NSArray *splitResults = [symbol.data componentsSeparatedByString:@","];
    
    [reader dismissViewControllerAnimated:YES completion:nil];
    
    CheckInViewController *checkInVc = [self.storyboard instantiateViewControllerWithIdentifier:@"checkInVC"];
    
    checkInVc.conferenceCode =splitResults[0];
    checkInVc.attendeeKey = splitResults[1];
    [self.navigationController pushViewController:checkInVc animated:YES];
}


- (NSString *) checkIfUserLoggedIn{
    
    //Check something on the device
    LoginDataSingleton *myLoginData = [LoginDataSingleton sharedManager];
    if (myLoginData.username != nil) {
        NSLog(@"ViewController username: %@", myLoginData.username);
        [self.loginBtnText setTitle:@"Logout" forState:UIControlStateNormal];
    }
    else{
        NSLog(@"username is nil, will call the login screen");
        [self.loginBtnText setTitle:@"Login" forState:UIControlStateNormal];
    }
    
    return myLoginData.username;
}
@end
