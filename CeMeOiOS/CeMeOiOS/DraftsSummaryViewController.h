//
//  DraftsSummaryViewController.h
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 30/01/14.
//  Copyright (c) 2014 Cegeka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DraftsSummaryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblDuration;
@property (weak, nonatomic) IBOutlet UILabel *lblHeld;
- (IBAction)Send:(id)sender;

@property NSMutableDictionary *Draft;
@property NSInteger draftIndex;

@end
