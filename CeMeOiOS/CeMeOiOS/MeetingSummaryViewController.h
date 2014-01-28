//
//  MeetingSummaryViewController.h
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 28/01/14.
//  Copyright (c) 2014 Cegeka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeetingSummaryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *ContactsTable;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblDuration;
@property (weak, nonatomic) IBOutlet UILabel *lblRoom;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress1;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress2;

@property NSDictionary *meeting;

@end
