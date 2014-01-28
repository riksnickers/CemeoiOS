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
#import "MeetingSummaryViewController.h"

@interface UpcomingMeetingsTableViewController ()

@end

@implementation UpcomingMeetingsTableViewController{
    UIAlertView *waitAlert;
    NSDictionary *mSelf,*room,*meeting;
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
    [self getPropos];
    
    [self.refreshControl addTarget:self action:@selector(getPropos) forControlEvents:UIControlEventValueChanged];
    
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
    return [[UserHolder Meetings] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"meetingCell";
    meetingCell *cell = (meetingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    meeting = [[[UserHolder Meetings] objectAtIndex:indexPath.row]objectForKey:@"Meeting"];
    mSelf = [[[UserHolder Meetings] objectAtIndex:indexPath.row]objectForKey:@"Self"];
    room = [mSelf objectForKey:@"Room"];
    
    NSString *location = [NSString stringWithFormat:@"%@ - %@",
                          [room valueForKey:@"Name"],
                          [[room objectForKey:@"LocationID"]objectForKey:@"Name"]];
    [cell.lblLocation setText:location];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SS"];
    
    NSDate *date = [formatter dateFromString:[meeting valueForKey:@"BeginTime"]];
    
    NSString *dateString = [NSDateFormatter localizedStringFromDate:date
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterShortStyle];
    
    NSTimeInterval check = [date timeIntervalSinceNow];
    if(check < 86400){
        [cell setBackgroundColor:[UIColor colorWithRed:255/255.0f green:200/255.0f blue:198/255.0f alpha:1.0f]];
    }
    
    [cell.lblTime setText:dateString];
    
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
    waitAlert = [[UIAlertView alloc] initWithTitle:@"Refreshing data"
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
        
        //set the badge count
        int badgeCount = [[[UserHolder Propositions] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Answer = 0)"]]count];
        
        if(badgeCount != 0){
            [[[[[self tabBarController] tabBar] items] objectAtIndex:1] setBadgeValue:[NSString stringWithFormat:@"%d", badgeCount]];
        }else{
            [[[[[self tabBarController] tabBar] items] objectAtIndex:1] setBadgeValue:nil];
        }

        
        [self getMeetings];
        
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

-(void)getMeetings{
    if(waitAlert == nil){
        waitAlert = [[UIAlertView alloc] initWithTitle:@"Refreshing data"
                                               message:nil
                                              delegate:nil
                                     cancelButtonTitle:nil
                                     otherButtonTitles:nil];
        UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125, 50, 30, 30)];
        loading.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [waitAlert addSubview:loading];
        [loading startAnimating];
        [waitAlert show];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"bearer %@", [[TokenHolder Token] valueForKey:@"access_token"]] forHTTPHeaderField:@"Authorization"];
    
    [manager GET:[IPHolder IPWithPath:@"/api/Meeting/All"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //save propositions un userholder
        [UserHolder setMeetings:[responseObject mutableCopy]];
        
        [self.tableView reloadData];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [self.refreshControl endRefreshing];
        [waitAlert dismissWithClickedButtonIndex:0 animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.refreshControl endRefreshing];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Something went wrong"
                                                       message: @"Could not get meetings"
                                                      delegate: self
                                             cancelButtonTitle:@"Ok"
                                             otherButtonTitles:nil];
        
        [waitAlert dismissWithClickedButtonIndex:0 animated:YES];
        [alert show];
    }];
    

}

- (IBAction)Logout:(id)sender {
    [self performSegueWithIdentifier:@"ToLogin" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"toFullMeeting"])
    {
        MeetingSummaryViewController *ms = [segue destinationViewController];
        
        NSIndexPath *myIndexPath = [self.tableView
                                    indexPathForSelectedRow];
        
        ms.meeting = [[UserHolder Meetings] objectAtIndex:myIndexPath.row];
    }
}

-(void)scheduleNotificationWithDate:(NSDate *)meetingDate{
    UILocalNotification *localNotif = [[UILocalNotification alloc]init];
    
    NSTimeInterval diff = [meetingDate timeIntervalSinceNow];
    
    if(diff > 3600){
        localNotif.fireDate = [meetingDate dateByAddingTimeInterval:-3600];
        localNotif.alertBody = @"You have a meeting in one hour";
        localNotif.soundName = UILocalNotificationDefaultSoundName;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}
@end
