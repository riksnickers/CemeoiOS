//
//  UpcomingMeetingsTableViewController.m
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 15/01/14.
//  Copyright (c) 2014 Cegeka. All rights reserved.
//

#import "UpcomingMeetingsTableViewController.h"
#import "meetingCell.h"

@interface UpcomingMeetingsTableViewController ()

@end

@implementation UpcomingMeetingsTableViewController{
    NSArray *Locations;
    NSArray *Times;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    Locations = [[NSArray alloc] initWithObjects:
                 @"Room 3A - Hasselt",
                 @"Room 4D - Leuven",
                 @"Main Meeting Room - Hasselt",
                 nil];
    
    Times = [[NSArray alloc] initWithObjects:
             @"20/08/2014 - 13:00",
             @"22/08/2014 - 15:00",
             @"01/09/2014 - 13:45",
             nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [Locations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"meetingCell";
    meetingCell *cell = (meetingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [cell.lblLocation setText:[Locations objectAtIndex:indexPath.row]];
    [cell.lblTime setText:[Times objectAtIndex:indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

@end
