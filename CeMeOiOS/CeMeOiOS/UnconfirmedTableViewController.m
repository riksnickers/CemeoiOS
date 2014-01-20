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
    [self.refreshControl addTarget:self action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];

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
    
    proposition = [[[UserHolder Propositions]objectAtIndex:indexPath.row]objectForKey:@"Proposition"];
    
    NSString *location = [NSString stringWithFormat:@"%@ - %@",
                          [[proposition objectForKey:@"ProposedRoom"]valueForKey:@"Name"],
                          [[[proposition objectForKey:@"ProposedRoom"]objectForKey:@"LocationID"]valueForKey:@"Name"]];
    [cell.lblLocation setText:location];
    
    
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
        
        vc.PropositionIndex = [myIndexPath row];
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
        [waitAlert dismissWithClickedButtonIndex:0 animated:YES];
        [self.tableView reloadData];
        [[[[[self tabBarController] tabBar] items]
          objectAtIndex:1] setBadgeValue:[NSString stringWithFormat:@"%ld", (unsigned long)[[UserHolder Propositions]count]]];
        [self.refreshControl endRefreshing];
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


@end
