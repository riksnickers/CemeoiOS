//
//  UpcomingViewController.h
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 14/12/13.
//  Copyright (c) 2013 Cegeka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpcomingViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *UpComingTable;

@property (nonatomic, strong) NSArray *Locations;
@property (nonatomic, strong) NSArray *Times;

@end
