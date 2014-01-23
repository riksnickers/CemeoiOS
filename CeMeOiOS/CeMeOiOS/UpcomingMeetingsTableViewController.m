//
//  UpcomingMeetingsTableViewController.m
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 15/01/14.
//  Copyright (c) 2014 Cegeka. All rights reserved.
//

#import "UpcomingMeetingsTableViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "meetingCell.h"
#import "UserHolder.h"
#import "TokenHolder.h"
#import "IPHolder.h"

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
    
    //set the badge count
    int badgeCount = [[[UserHolder Propositions] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Answer = 0)"]]count];
    
    if(badgeCount != 0){
        [[[[[self tabBarController] tabBar] items] objectAtIndex:1] setBadgeValue:[NSString stringWithFormat:@"%d", badgeCount]];
    }else{
        [[[[[self tabBarController] tabBar] items] objectAtIndex:1] setBadgeValue:nil];
    }
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

- (IBAction)unwindToUpcoming:(UIStoryboardSegue *)unwindSegue
{
    [self getPropos];
}

-(void)getPropos{
    UIAlertView *waitAlert = [[UIAlertView alloc] initWithTitle:@"Getting propositions"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil];
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125, 50, 30, 30)];
    loading.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [waitAlert addSubview:loading];
    [loading startAnimating];
    [waitAlert show];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"bearer %@", [[TokenHolder Token] valueForKey:@"access_token"]] forHTTPHeaderField:@"Authorization"];
    
    [manager GET:[IPHolder IPWithPath:@"/api/Proposition/All"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //save propositions un userholder
        [UserHolder setPropositions:[responseObject mutableCopy]];
        
        [self.tableView reloadData];
        
        //set the badge count
        int badgeCount = [[[UserHolder Propositions] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Answer = 0)"]]count];
        
        if(badgeCount != 0){
            [[[[[self tabBarController] tabBar] items] objectAtIndex:1] setBadgeValue:[NSString stringWithFormat:@"%d", badgeCount]];
        }else{
            [[[[[self tabBarController] tabBar] items] objectAtIndex:1] setBadgeValue:nil];
        }
        
        [self.refreshControl endRefreshing];
        [waitAlert dismissWithClickedButtonIndex:0 animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.refreshControl endRefreshing];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Something went wrong"
                                                       message: @"Could not get meeting propositions"
                                                      delegate: self
                                             cancelButtonTitle:@"Ok"
                                             otherButtonTitles:nil];
        
        [waitAlert dismissWithClickedButtonIndex:0 animated:YES];
        [alert show];
    }];
    
}

- (IBAction)Logout:(id)sender {
    [UserHolder SetUserData:nil];
    [TokenHolder setToken:nil];
    [self performSegueWithIdentifier:@"ToLogin" sender:self];
}
@end
