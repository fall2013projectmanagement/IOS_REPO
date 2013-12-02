//
//  AttendeeDetailsViewController.h
//  QRReader
//
//  Created by feifan meng on 10/26/13.
//  Copyright (c) 2013 mobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttendeeDetailsViewController : UITableViewController

@property(nonatomic, strong) NSString *conferenceCode;
@property(nonatomic, strong) NSString *attendeeKey;

@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *profileImgView;

- (IBAction)checkInButton:(id)sender;
- (IBAction)dontCheckInButton:(id)sender;

@end
