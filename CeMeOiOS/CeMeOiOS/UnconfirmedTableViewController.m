//
//  UnconfirmedTableViewController.m
//  CeMeOiOS
//
//  Created by Jeffrey Smets on 18/01/14.
//  Copyright (c) 2014 Cegeka. All rights reserved.
//

#import "UnconfirmedTableViewController.h"
#import "UnconfirmedSummaryViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "meetingCell.h"
#import "UserHolder.h"
#import "TokenHolder.h"
#import "IPHolder.h"
#import "meetingCell.h"

@interface UnconfirmedTableViewController ()

@end

@implementation UnconfirmedTableViewController{
    NSDictionary *proposition;
    NSArray *confirmed;
    NSArray *unconfirmed;
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
    
    //set refresh action
    [self.refreshControl addTarget:self action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return @"Unconfirmed by you";
    }else{
        return @"Confirmed by you";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return [unconfirmed count];
    }else{
        return [confirmed count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"meetingCell";
    meetingCell *cell = (meetingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //if unconfirmed proposition needs to be in first table section
    if(indexPath.section == 0){
        proposition = [[unconfirmed objectAtIndex:indexPath.row]objectForKey:@"Proposition"];
    }else{
        proposition = [[confirmed objectAtIndex:indexPath.row]objectForKey:@"Proposition"];
    }
    
    NSString *location = [NSString stringWithFormat:@"%@ - %@",
                          [[proposition objectForKey:@"ProposedRoom"]valueForKey:@"Name"],
                          [[[proposition objectForKey:@"ProposedRoom"]objectForKey:@"LocationID"]valueForKey:@"Name"]];
    [cell.lblLocation setText:location];
    
    //filter convert the timestring to nsdate
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SS"];
    
    NSDate *date = [formatter dateFromString:[proposition valueForKey:@"BeginTime"]];
    
    NSString *dateString = [NSDateFormatter localizedStringFromDate:date
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterShortStyle];
    
    [cell.lblTime setText:dateString];

    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"toUnconfirmedSummary"])
    {
        UnconfirmedSummaryViewController *vc = [segue destinationViewController];
        
       NSIndexPath *myIndexPath = [self.tableView
                                    indexPathForSelectedRow];
        
        if(myIndexPath.section == 0){
            vc.ChosenProposition = [unconfirmed objectAtIndex:myIndexPath.row];
        }else{
            vc.ChosenProposition = [confirmed objectAtIndex:myIndexPath.row];
        }
    }
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
        
        //filter confirmed and unconfirmed propositions
        confirmed = [[UserHolder Propositions] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(not Answer = 0)"]];
        unconfirmed = [[UserHolder Propositions] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Answer = 0)"]];
        
        [self.tableView reloadData];
        
        //set the badge count
        NSUInteger badgeCount = [[[UserHolder Propositions] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Answer = 0)"]]count];
        
        if(badgeCount != 0){
            [[[[[self tabBarController] tabBar] items] objectAtIndex:1] setBadgeValue:[NSString stringWithFormat:@"%lu", badgeCount]];
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

-(void)refresh{
    [self getPropos];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //filter confirmed and unconfirmed propositions
    confirmed = [[UserHolder Propositions] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(not Answer = 0)"]];
    unconfirmed = [[UserHolder Propositions] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Answer = 0)"]];
    
    [self.tableView reloadData];
}


@end
