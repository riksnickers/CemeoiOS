//
//  SummaryNewMeetingViewController.h
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 18/12/13.
//  Copyright (c) 2013 Cegeka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SummaryNewMeetingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property NSArray *Contacts;
@property int DateIndex;
@property NSDate *beforeDate;
@property NSTimeInterval Duration;

@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblBeHeld;
@property (weak, nonatomic) IBOutlet UILabel *lblDuration;

- (IBAction)send:(id)sender;
- (void)SendData:(NSDictionary *)data;

@end
