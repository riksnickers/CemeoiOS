//
//  UnconfirmedTableViewController.m
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 18/01/14.
//  Copyright (c) 2014 Cegeka. All rights reserved.
//

#import "UnconfirmedTableViewController.h"
#import "meetingCell.h"
#import "UserHolder.h"
#import "TokenHolder.h"
#import "IPHolder.h"
#import "meetingCell.h"

@interface UnconfirmedTableViewController ()

@end

@implementation UnconfirmedTableViewController

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

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[UserHolder Propositions]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"meetingCell";
    meetingCell *cell = (meetingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *location = [NSString stringWithFormat:@"%@ - %@",
                          [[[[UserHolder Propositions]objectAtIndex:indexPath.row]objectForKey:@"ProposedRoom"]valueForKey:@"Name"],
                          [[[[[UserHolder Propositions]objectAtIndex:indexPath.row]objectForKey:@"ProposedRoom"]objectForKey:@"LocationID"] valueForKey:@"Name"]];
    [cell.lblLocation setText:location];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SS"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"nl_BE"]];
    

    NSDate *date = [formatter dateFromString:[[[UserHolder Propositions]objectAtIndex:indexPath.row]valueForKey:@"BeginTime"]];
    
    NSString *dateString = [NSDateFormatter localizedStringFromDate:date
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterShortStyle];
     
    
    
    
    [cell.lblTime setText:dateString];

    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}


@end
