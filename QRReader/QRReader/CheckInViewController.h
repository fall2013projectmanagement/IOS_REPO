//
//  CheckInViewController.h
//  QRReader
//
//  Created by feifan meng on 12/1/13.
//  Copyright (c) 2013 mobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckInViewController : UIViewController

@property(nonatomic, strong) NSString *conferenceCode;
@property(nonatomic, strong) NSString *attendeeKey;

@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

- (IBAction)checkInBtn:(id)sender;
- (IBAction)cancelBtn:(id)sender;

@end
