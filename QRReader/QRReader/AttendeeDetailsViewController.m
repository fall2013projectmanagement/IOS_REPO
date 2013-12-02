//
//  AttendeeDetailsViewController.m
//  QRReader
//
//  Created by feifan meng on 10/26/13.
//  Copyright (c) 2013 mobi. All rights reserved.
//

#import "AttendeeDetailsViewController.h"

@interface AttendeeDetailsViewController ()

@end

@implementation AttendeeDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSLog(@"user qr key: %@", [self attendeeKey]);
    
    //Send the url request to get the firstname lastname, url
    //Sample Request:
    //http://qraproject.appspot.com/name?id=agxzfnFyYXByb2plY3RyEQsSBFVzZXIYgICAgIDXjAoM
    
    NSString *urlAsString = @"http://qraproject.appspot.com/name?id=";
    urlAsString = [urlAsString stringByAppendingString:[self attendeeKey]];
    
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue
    completionHandler:^(NSURLResponse *response,NSData *data, NSError *error){
        if ([data length] >0 && error == nil){
            
            NSString *result
            = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSLog(@"Result: %@", result);
            
            NSArray *splitResultsImg = [result componentsSeparatedByString:@","];
            NSArray *nameResults = [splitResultsImg[0] componentsSeparatedByString:@" "];
            
            self.firstNameLabel.text = nameResults[0];
            self.lastNameLabel.text = nameResults[1];
            
            NSURL *imgUrl = [NSURL URLWithString:splitResultsImg[1]];
            [self sendImageRequest:imgUrl];
            
        }
        else if ([data length] == 0 && error == nil){
            NSLog(@"Request had no data");
        }
        else if(error != nil){
            NSLog(@"Error retrieving the data");
        }
        else{
            NSLog(@"more errors.");
        }
                           
    }];
}

- (void)sendImageRequest: (NSURL *)imgUrl{
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:imgUrl]; [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue
                           completionHandler:^(NSURLResponse *response,NSData *data, NSError *error){
                               
    if ([data length] >0 && error == nil){
        NSLog(@"Image retrieved.");
        //Set the image as the data
        self.profileImgView.image = [UIImage imageWithData:data];
    }
    else if ([data length] == 0 && error == nil){
        NSLog(@"Img Request had no data");
    }
    else if(error != nil){
        NSLog(@"Error retrieving the Img");
    }
    else{
        NSLog(@"wtf");
    }
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)checkInButton:(id)sender {
    
    //Call The webservice to log the user attendence
    //Sample Request:
    //qraproject.appspot.com/processqr?user_id=agxzfnFyYXByb2plY3RyEQsSBFVzZXIYgICAgIDXjAoM&conf_code=1&timestamp=MM/dd/yyyyHH:mm:ssz
    
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyyHH:mm:ssz"];
    NSString *currentTimestampStr = [formatter stringFromDate: [NSDate date]];
    
    NSLog(@"currentDate: %@", [NSDate date]);

    NSString *urlAsString =
    [NSString
     stringWithFormat:
     @"http://qraproject.appspot.com/processqr?user_id=%@&conf_code=%@&timestamp=%@",self.attendeeKey,
     self.conferenceCode, currentTimestampStr];
    
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSLog(@"checkIn servlet urlAsString: %@", urlAsString);
    NSLog(@"checkIn servlet urlAsString: %@", url);
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue
                           completionHandler:^(NSURLResponse *response,NSData *data, NSError *error){
                               
        BOOL success = false;
        if ([data length] >0 && error == nil){
            //{"checkedIn":"true"}
            
            NSString *validString = @"{\"checkedIn\":\"true\"}";
            
            NSString *resultStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            if([resultStr isEqualToString:validString]){
                success = true;
            }
            else{
                success = false;
                NSLog(@"Request was successful and data was returned, but resultStr didn't match validStr");
            }
            
        }
        else if([data length] == 0 && error == nil){
            NSLog(@"Error checking attendee in. Nothing returned.");
            
        }
        else if(error != nil){
            NSLog(@"Error checking attendee in. Error.");
        }
                               
        if(success){
            UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Attendee checked in." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [success show];

            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else{
            UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to check Attendee In." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [errorView show];
        }
            
    }];
}

- (IBAction)dontCheckInButton:(id)sender {
    
    UIAlertView *canceledView = [[UIAlertView alloc] initWithTitle:@"Cancelling" message:@"Canceled User check in." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [canceledView show];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
