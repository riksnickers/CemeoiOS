//
//  UnconfirmedSummaryViewController.h
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 20/01/14.
//  Copyright (c) 2014 Cegeka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnconfirmedSummaryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *ContactsTable;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblDuration;
@property (weak, nonatomic) IBOutlet UILabel *lblRoom;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblCity;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;

- (IBAction)sendAnswer:(id)sender;

@property int PropositionIndex;
@property NSDictionary *ChosenProposition;

@end
