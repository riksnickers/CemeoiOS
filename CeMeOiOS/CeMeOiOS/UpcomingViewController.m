//
//  UpcomingViewController.m
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 14/12/13.
//  Copyright (c) 2013 Cegeka. All rights reserved.
//

#import "UpcomingViewController.h"
#import "meetingCell.h"

@interface UpcomingViewController ()

@end

@implementation UpcomingViewController
@synthesize Locations;
@synthesize Times;
@synthesize UpComingTable;

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
    
    //local values for now, online implementation in next sprint
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.Locations count];
}

/*! using a custom meeting cell to populate the table
 contains meeting location and date 
 (tap action yet to be implemented)
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellId = @"meetingCell";
    
    meetingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if(cell == nil){
        cell = [[meetingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
    }
    
    cell.lblLocation.text = [Locations objectAtIndex:[indexPath row]];
    cell.lblTime.text = [Times objectAtIndex:[indexPath row]];
    return cell;
}

/*!
 Action to return from SummaryViewController back to here after meeting has been send
 */
- (IBAction)unwindToUpcoming:(UIStoryboardSegue *)unwindSegue
{
}

@end
