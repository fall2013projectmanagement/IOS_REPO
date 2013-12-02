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
    myUsername = [self checkIfUserLoggedIn];
    
    if(myUsername != nil){
        self.loggedInAsLabel.text = [[NSString alloc] initWithFormat:@"You are Logged in as: %@",
                                     myUsername];
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
    
    //Logs the user in as someone different
    LoginViewController *myLoginViewController
    = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
    
    [self.navigationController pushViewController:myLoginViewController animated:YES];
    
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
    
    /*
    AttendeeDetailsViewController *attendeeDtlsVC
    = [self.storyboard instantiateViewControllerWithIdentifier:@"attendeeDtlsVC"];
    
    attendeeDtlsVC.conferenceCode = splitResults[0];
    attendeeDtlsVC.attendeeKey = splitResults[1];
    [self.navigationController pushViewController:attendeeDtlsVC animated:YES];
     */
    
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
    }
    else{
        NSLog(@"username is nil, will call the login screen");
    }
    
    return myLoginData.username;
}
@end
